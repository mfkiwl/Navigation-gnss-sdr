
% 并行码相位捕获
% 卫星号为 svnum
% 返回码相位和频率

% ***** 参数初始化 *****
fs=11.999e6;	% 采样频率
ts=1/fs;	       % 单位采样时间
num=fs/1000;	       % 1毫秒数据点个数
nn=[0:n-1];	       % 采样数据点向量
fc0=3.563e6;	% 载波频率（中频频率）
svnum = 1;           % 待搜索的卫星号

% ***** 读取中频采样信号文件 *****
load signal.mat
x=double(data');    

% ***** 生成本地测距码信号 *****
code=zeros（1，num)     %%初始化测距码信号矩阵
cacode=GetCACode（svnnum,1023)
for n=1:num
     %根据码相位从CACode中查找测距码值
     index = floor((m-1)*0.5 + (n-1)*ts*1023e.6 )    % 计算码相位
     index = mod(index,1023)                                     % 计算测距码内码片偏移量
     
     %填入相应单元
     code(1,n)=cacode(index)
  end
code=double(code)

% ***** 对测距码做傅里叶变换，并求取其共轭
codefreq = conj(fft(code))

% ****** 频率维循环 *****
for i=1:41
  %获取当前频率
  fc(i) = fc0 + 0.0005e6*(i-21);
  
  %生成本地载波的同相和正交相信号
  expfreq=exp(j*2*pi*fc(i)*ts*nn);
  sine= imag(expfreq);		% generate local sine
  cosine= real(expfreq);	% generate local cosine
 
  % 生成本地载波与输入信号的I支路和Q支路乘积信号
  I = sine.*x;              
  Q = cosine.*x;           
  
  % 对乘积信号做傅里叶变换，从时域转到频域
  IQfreq = fft(I+j*Q);     
  convcodeIQ = IQfreq .* codefreq;  % 在频域与测距码信号共轭频谱做乘法
  result(i,:) = abs(ifft(convcodeIQ)).^2;   % 做傅里叶逆变换至时域
  end
  
  %%输出的是不同频率下的码相位相关判据（I^2+Q^2)
[peak codephase]=max(max(result));
[peak frequency]=max(max(result'));

frequency = fc(frequency)

%***** 绘图   *****
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
xlabel('码相位 [chips]');
ylabel('频率 [MHz]');
zlabel('相关输出大小');
text=sprintf('卫星号 %i',svnum);
title(text);