%**********************************************************************%
%输入：
%       PRN：    测距码编号
%       Q：      采样因子
%       Fin：    载波频率
%       LEN：    测距码长度
%输出：
%       gpsdata：生成的GPS仿真数据，时间步长为1/Q个码片宽度，即1/(Q*1.023e6)秒
%**********************************************************************%
function    gpsdata = carriarMod(codes,Fin,Q,LEN)

%********************************************************
%  1  --  代表码元值为1，与载波相乘波形无变化，实现0度相位
% -1  --  代表码元值为0，与载波相乘波形翻转，实现180度相位
%*********************************************************

fs = 1.023*1.e6;                    % CA码速率
fc = Fin*Q;                         % 载波采样频率

delta_ts = 1/fs;                    % CA码时间步长
delta_tc = 1/fc;                    % 载波时间步长

% 根据该段测距码序列所用时长计算得到的载波采样长度
signalnum = floor(length(codes)*delta_ts/delta_tc);

n=0;                                % 时间计数器
Index_Code = 0;                     % 码元指示器

gpsdata = zeros(1,signalnum);       % 调制后信号输出序列

%   对调制后的码序列进行采样
while(n < signalnum)                    %
    n=n+1;
   
    Index_Code = floor(n*delta_tc/delta_ts);
    
    gpsdata(n)=codes(Index_Code+1);
end
% 此时gpsdata是codes码序列重采样后的结果

%*********************************************************************
%   信号调制   s(t)=exp(j*2*pi*omega*t)=cos(2*pi*f*t)+j*sin(2*pi*f*t)
%   I相：    cos（2*pi*f*t）
%   Q相：    sin（2*pi*f*t）
%   一个码元的宽度：
figure
plot(subplot(2,1,1),gpsdata);

% BPSK载波相位调制，exp(j*2*pi*Fin*(0:n-1)*delta_tc)为载波采样码序列
gpsdata=gpsdata.*cos(2*pi*Fin*(0:n-1)*delta_tc);

plot(subplot(2,1,2),real(gpsdata));

