
% 串行捕获技术 
%

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

% *****   频率维度串行搜索  *****
result = zeros(41, 2046);   	% 初始化结果矩阵
fc = zeros(41,1);						% 41个频率值向量

% *****   频率串行搜索算法 *****
% 按照500Hz间距,10KHz频率带宽进行捕获
for i=1:41
   % 生成本地参考载波信号
  fc(i) = fc0 + 5e2*(i-21);		% 中心频点 + 500*n频率偏移
  % 生成I支路和Q支路信号
  expfreq=exp(1i*2*pi*fc(i)*ts*nn);	%利用复变函数中复数与三角函数之间的关系，获得cos和sin两路正交信号
  sine= imag(expfreq);			% 生成本地正弦信号
  cosine= real(expfreq);			% 生成本地余弦信号 
  
  %分别在I支路和Q支路上做相关计算积分
  I = (y*sine).*xcarrier;       		% 生成2046个码相位对应的I支路信号
  Q = (y*cosine).*xcarrier;   		% 生成2046个码相位对应的Q支路信号
  
  %在fc(i)本地参考频率下，2046个码相位分别做1ms的累积相关计算，得到相关性判据I^2+Q^2
  result(i,:)=sum(I').^2+sum(Q').^2;    
end
% 上述循环输出为41*2046个搜索单元的相关性判据矩阵
% 其中幅值出现显著峰值的位置，为该信号频率和码相位对应的单元位置
% 如果幅值未出现显著峰值，则输入信号中不包含该卫星信号

%取最大峰值和相应的码相位维坐标（1-2046）和频率维坐标（1-41）
[peak codephase]=max(max(result));
[peak frequency]=max(max(result'));

%取真实频率值
frequency = fc(frequency);

%****** 绘图  *****
figure(1)
x_axis=1:2046;
y_axis=fc/1e6;
s=surf(x_axis,y_axis,result);
set(s,'EdgeColor','none','Facecolor','interp');
axis([min(x_axis) max(x_axis) min(y_axis) max(y_axis) min(min(result)) max(max(result))]);
caxis([0 max(max(result))]);
xlabel('码相位 [chips]');
ylabel('频率 [MHz]');
zlabel('相关性幅值');
text=sprintf('SVN %i',svnum);
title(text);
