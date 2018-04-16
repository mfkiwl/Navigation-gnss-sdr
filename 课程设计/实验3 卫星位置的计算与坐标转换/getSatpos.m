%从文件中读取一帧导航电文
%第一个bit为上一个字的最后1位，用于后续字节原始数据的恢复和校验，因此共有1501个bit

load('navBitsBin3.mat','navBitsBin3');
load('navBitsBin6.mat','navBitsBin6');
load('navBitsBin15.mat','navBitsBin15');
load('navBitsBin22.mat','navBitsBin22');

% ---------   第3颗星的位置  -----------------------
% 导航电文解析
[eph3, TOW3] =  ephemeris(navBitsBin3(2:1501)', navBitsBin3(1));
% 设置当前历元
transmitTime = TOW3;
% 计算码相位测量历元的卫星地固坐标 
 [satPositions3, satClkCorr3] = satpos(transmitTime,eph3);
 
% ---------   第6颗星的位置  -----------------------
% 导航电文解析
[eph6, TOW6] =  ephemeris(navBitsBin6(2:1501)', navBitsBin6(1));
% 码相位测量所在历元
transmitTime = TOW6;
% 计算码相位测量历元的卫星地固坐标 
 [satPositions6, satClkCorr6] = satpos(transmitTime,eph6);
 
% ---------   第15颗星的位置  -----------------------
% 导航电文解析
[eph15, TOW15] =  ephemeris(navBitsBin15(2:1501)', navBitsBin15(1));
% 码相位测量所在历元
transmitTime = TOW15;
% 计算码相位测量历元的卫星地固坐标 
 [satPositions15, satClkCorr15] = satpos(transmitTime,eph15);

 
% ---------   第22颗星的位置  -----------------------
% 导航电文解析
[eph22, TOW22] =  ephemeris(navBitsBin22(2:2201)', navBitsBin22(1));
% 码相位测量所在历元
transmitTime = TOW22;
% 计算码相位测量历元的卫星地固坐标 
 [satPositions22, satClkCorr22] = satpos(transmitTime,eph22);

