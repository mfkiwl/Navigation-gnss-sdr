
%
% 并行频率捕获

% ***** 参数初始化 *****
fs=11.999e6;	% 采样频率
ts=1/fs;	       % 单位采样时间
num=fs/1000;	% 1毫秒数据点个数
nn=[0:num-1];	       % 采样数据点向量
fc0=3.563e6;	% 载波频率（中频频率）
svnum = 1;           % 待搜索的卫星号

% ***** 读取中频采样信号文件 *****
load signal.mat
x=double(data');    

% ***** 外循环，按0.5码片间隔生成不同码相位的测距码信号 *****
code=zeros（2046，num)     %%初始化测距码信号矩阵
cacode=GetCACode（svnnum,1023)
for m=1:2046
   for n=1:num
     %根据码相位从CACode中查找测距码值
     index = floor((m-1)*0.5 + (n-1)*ts*1023e.6 )    %计算码相位，码相位总体偏移值（码片）+ 测距码内码片偏移（码片）
     index = mod(index,1023)                                     %循环取余，得到code（m,n）所对应的测距码内码片偏移量
     
     %填入相应单元
     code(m,n)=cacode(index)
  end
end
code=double(code);


% *****   生成测距码与输入中频信号之间的乘积信号 *******
y = ones(2046,1);
yx=y*x;                          %%    复制2046个中频输入信号
xcarrier = yx.*code;     %%    生成2046个码相位对应的乘积信号
result=zeros（2046,length(x))  %%初始化幅值矩阵

% ***** 对于每个码相位乘积信号，执行并行频率捕获 *****
for i=1:2046
    IQ = fft(xcarrier(i));    %%对乘积信号进行傅里叶变换，将时域转换到频域   
  
    result(i,:)=abs(IQ);      %%计算每个频率分量的幅值（即I^2+Q^2)
end

%****   提取最大幅值及其对应的频率和码相位维坐标
[peak codephase]=max(max(result));
[peak frequency]=max(max(result'));

%*****  绘图  ******

samplesPerChip = floor(length(code)/1023);
sampleLength = length(x);

figure(1)
x_axis=1:2046;
y_axis=(0:sampleLength-1)*fs/sampleLength;
s=surf(x_axis, y_axis, result);
set(s,'EdgeColor','none','Facecolor','interp');
axis([min(x_axis) max(x_axis) min(y_axis) max(y_axis) min(min(result)) max(max(result))]);
caxis([0 max(max(result))]);
xlabel('码相位 [chips]');
ylabel('频率 [MHz]');
zlabel('相关幅值');
text=sprintf('SVN %i',svnum);
title(text);
