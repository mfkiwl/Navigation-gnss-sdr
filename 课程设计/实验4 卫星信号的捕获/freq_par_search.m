
%
% ����Ƶ�ʲ���

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
result=zeros��2046,length(x))  %%��ʼ����ֵ����

% ***** ����ÿ������λ�˻��źţ�ִ�в���Ƶ�ʲ��� *****
for i=1:2046
    IQ = fft(xcarrier(i));    %%�Գ˻��źŽ��и���Ҷ�任����ʱ��ת����Ƶ��   
  
    result(i,:)=abs(IQ);      %%����ÿ��Ƶ�ʷ����ķ�ֵ����I^2+Q^2)
end

%****   ��ȡ����ֵ�����Ӧ��Ƶ�ʺ�����λά����
[peak codephase]=max(max(result));
[peak frequency]=max(max(result'));

%*****  ��ͼ  ******

samplesPerChip = floor(length(code)/1023);
sampleLength = length(x);

figure(1)
x_axis=1:2046;
y_axis=(0:sampleLength-1)*fs/sampleLength;
s=surf(x_axis, y_axis, result);
set(s,'EdgeColor','none','Facecolor','interp');
axis([min(x_axis) max(x_axis) min(y_axis) max(y_axis) min(min(result)) max(max(result))]);
caxis([0 max(max(result))]);
xlabel('����λ [chips]');
ylabel('Ƶ�� [MHz]');
zlabel('��ط�ֵ');
text=sprintf('SVN %i',svnum);
title(text);
