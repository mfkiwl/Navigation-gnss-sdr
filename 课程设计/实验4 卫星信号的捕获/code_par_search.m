
% ��������λ����
% ���Ǻ�Ϊ svnum
% ��������λ��Ƶ��

% ***** ������ʼ�� *****
fs=11.999e6;	% ����Ƶ��
ts=1/fs;	       % ��λ����ʱ��
num=fs/1000;	       % 1�������ݵ����
nn=[0:n-1];	       % �������ݵ�����
fc0=3.563e6;	% �ز�Ƶ�ʣ���ƵƵ�ʣ�
svnum = 1;           % �����������Ǻ�

% ***** ��ȡ��Ƶ�����ź��ļ� *****
load signal.mat
x=double(data');    

% ***** ���ɱ��ز�����ź� *****
code=zeros��1��num)     %%��ʼ��������źž���
cacode=GetCACode��svnnum,1023)
for n=1:num
     %��������λ��CACode�в��Ҳ����ֵ
     index = floor((m-1)*0.5 + (n-1)*ts*1023e.6 )    % ��������λ
     index = mod(index,1023)                                     % ������������Ƭƫ����
     
     %������Ӧ��Ԫ
     code(1,n)=cacode(index)
  end
code=double(code)

% ***** �Բ����������Ҷ�任������ȡ�乲��
codefreq = conj(fft(code))

% ****** Ƶ��άѭ�� *****
for i=1:41
  %��ȡ��ǰƵ��
  fc(i) = fc0 + 0.0005e6*(i-21);
  
  %���ɱ����ز���ͬ����������ź�
  expfreq=exp(j*2*pi*fc(i)*ts*nn);
  sine= imag(expfreq);		% generate local sine
  cosine= real(expfreq);	% generate local cosine
 
  % ���ɱ����ز��������źŵ�I֧·��Q֧·�˻��ź�
  I = sine.*x;              
  Q = cosine.*x;           
  
  % �Գ˻��ź�������Ҷ�任����ʱ��ת��Ƶ��
  IQfreq = fft(I+j*Q);     
  convcodeIQ = IQfreq .* codefreq;  % ��Ƶ���������źŹ���Ƶ�����˷�
  result(i,:) = abs(ifft(convcodeIQ)).^2;   % ������Ҷ��任��ʱ��
  end
  
  %%������ǲ�ͬƵ���µ�����λ����оݣ�I^2+Q^2)
[peak codephase]=max(max(result));
[peak frequency]=max(max(result'));

frequency = fc(frequency)

%***** ��ͼ   *****
codephaseChips = round(1023 - (codephase/11999)*1023)
gold_rate = 1.023e6;			% Gold code clock rate in Hz
ts=1/fs;
tc=1/gold_rate;
b=[1:n];
c=ceil((ts*b)/tc);

figure(1)
x_axis=c;
y_axis=fc/1e6;
s=surf(x_axis,y_axis,result);
set(s,'EdgeColor','none','Facecolor','interp');
axis([min(x_axis) max(x_axis) min(y_axis) max(y_axis) min(min(result)) max(max(result))]);
caxis([0 max(max(result))]);
xlabel('����λ [chips]');
ylabel('Ƶ�� [MHz]');
zlabel('��������С');
text=sprintf('���Ǻ� %i',svnum);
title(text);