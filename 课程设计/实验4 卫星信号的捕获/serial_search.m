
% ���в����� 
%

% ***** ������ʼ�� *****
fs=11.999e6;	% ����Ƶ��
ts=1/fs;	       % ��λ����ʱ��
num=fs/1000;	% 1�������ݵ����
nn=[0:num-1];	       % �������ݵ�����
fc0=3.563e6;	% �ز�Ƶ�ʣ���ƵƵ�ʣ�
svnum = 1;           % �����������Ǻ�

% ***** ��ȡ��Ƶ�����ź��ļ� *****
load signal.mat
x=double(data');    

% ***** ��ѭ������0.5��Ƭ������ɲ�ͬ����λ�Ĳ�����ź� *****
code=zeros��2046��num)     %%��ʼ��������źž���
cacode=GetCACode��svnnum,1023)
for m=1:2046
   for n=1:num
     %��������λ��CACode�в��Ҳ����ֵ
     index = floor((m-1)*0.5 + (n-1)*ts*1023e.6 )    %��������λ������λ����ƫ��ֵ����Ƭ��+ ���������Ƭƫ�ƣ���Ƭ��
     index = mod(index,1023)                                     %ѭ��ȡ�࣬�õ�code��m,n������Ӧ�Ĳ��������Ƭƫ����
     
     %������Ӧ��Ԫ
     code(m,n)=cacode(index)
  end
end
code=double(code);


% *****   ���ɲ������������Ƶ�ź�֮��ĳ˻��ź� *******
y = ones(2046,1);
yx=y*x;                          %%    ����2046����Ƶ�����ź�
xcarrier = yx.*code;     %%    ����2046������λ��Ӧ�ĳ˻��ź�

% *****   Ƶ��ά�ȴ�������  *****
result = zeros(41, 2046);   	% ��ʼ���������
fc = zeros(41,1);						% 41��Ƶ��ֵ����

% *****   Ƶ�ʴ��������㷨 *****
% ����500Hz���,10KHzƵ�ʴ�����в���
for i=1:41
   % ���ɱ��زο��ز��ź�
  fc(i) = fc0 + 5e2*(i-21);		% ����Ƶ�� + 500*nƵ��ƫ��
  % ����I֧·��Q֧·�ź�
  expfreq=exp(1i*2*pi*fc(i)*ts*nn);	%���ø��亯���и��������Ǻ���֮��Ĺ�ϵ�����cos��sin��·�����ź�
  sine= imag(expfreq);			% ���ɱ��������ź�
  cosine= real(expfreq);			% ���ɱ��������ź� 
  
  %�ֱ���I֧·��Q֧·������ؼ������
  I = (y*sine).*xcarrier;       		% ����2046������λ��Ӧ��I֧·�ź�
  Q = (y*cosine).*xcarrier;   		% ����2046������λ��Ӧ��Q֧·�ź�
  
  %��fc(i)���زο�Ƶ���£�2046������λ�ֱ���1ms���ۻ���ؼ��㣬�õ�������о�I^2+Q^2
  result(i,:)=sum(I').^2+sum(Q').^2;    
end
% ����ѭ�����Ϊ41*2046��������Ԫ��������оݾ���
% ���з�ֵ����������ֵ��λ�ã�Ϊ���ź�Ƶ�ʺ�����λ��Ӧ�ĵ�Ԫλ��
% �����ֵδ����������ֵ���������ź��в������������ź�

%ȡ����ֵ����Ӧ������λά���꣨1-2046����Ƶ��ά���꣨1-41��
[peak codephase]=max(max(result));
[peak frequency]=max(max(result'));

%ȡ��ʵƵ��ֵ
frequency = fc(frequency);

%****** ��ͼ  *****
figure(1)
x_axis=1:2046;
y_axis=fc/1e6;
s=surf(x_axis,y_axis,result);
set(s,'EdgeColor','none','Facecolor','interp');
axis([min(x_axis) max(x_axis) min(y_axis) max(y_axis) min(min(result)) max(max(result))]);
caxis([0 max(max(result))]);
xlabel('����λ [chips]');
ylabel('Ƶ�� [MHz]');
zlabel('����Է�ֵ');
text=sprintf('SVN %i',svnum);
title(text);
