function [satPositions, satClkCorr] = satpos(transmitTime, eph) 
% 根据卫星星历数据，计算龄期内指定历元的卫星地固坐标
%[satPositions, satClkCorr] = satpos(transmitTime,eph);
%
%   输入:
%       transmitTime  - 指定历元，采用卫星钟的周内秒计数时间，单位为秒
%       eph           - 相应龄期内的星历数据

%
%   输出:
%       satPositions  - GPS卫星坐标 (地固坐标系 [X; Y; Z;])
%       satClkCorr    - 校正后的卫星钟


%% Initialize constants ===================================================

% GPS 常数

gpsPi          = 3.1415926535898;  % Pi        
Omegae_dot     = 7.2921151467e-5;  % 地球自转角速度 [rad/s]
GM             = 3.986005e14;      % 地球引力常数 [m^3/s^2]
F              = -4.442807633e-10; % 相对论效应改正系数, [sec/(meter)^(1/2)]
                                   % F = -2*sqrt(GM)/c^2
                                   % mu -- 开普勒常数，c-光速

  
%% 卫星钟校正，以便进行卫星位置计算 --------------------------------

    %--- 计算与钟差参数参考历元的时间差 ---------------------------------------------
    dt = check_t(transmitTime - eph.t_oc);

    %--- 计算卫星钟校正值 ---------------------------------------
    % 根据GPS的ICD文件，L1频点需要在钟差基础上减T_GD，
    % L2频点需在钟差基础上减（fL1/fL2）^2*T_GD
    % 此处仅考虑L1频点
    
    satClkCorr = (eph.a_f2 * dt + eph.a_f1) * dt + ...
                         eph.a_f0 - ...
                         eph.T_GD;

    %--- 计算信号发射时刻的GPS时间
    time = transmitTime - satClkCorr;

%% 卫星位置解算 ----------------------------------------------

    %1. 恢复半长轴
    a   = eph.sqrtA * eph.sqrtA;

    % 计算与星历参数参考历元的时间差
    tk  = check_t(time - eph.t_oe);

    %2. 初始化平均角速度
    n0  = sqrt(GM / a^3);
    
    % 平均角速度修正
    n   = n0 + eph.deltan;

    %3. 计算平近点角
    M   = eph.M_0 + n * tk;
    % 调整为0到360度之间
    M   = rem(M + 2*gpsPi, 2*gpsPi);

    %4. 初始化偏近点角
    E   = M;

    %--- 不少于10次迭代，计算得到偏近点角E ----------------------------
    for ii = 1:10
        E_old   = E;
        E       = M + eph.e * sin(E);
        dE      = rem(E - E_old, 2*gpsPi);

        if abs(dE) < 1.e-12
            % 收敛即可退出循环
            break;
        end
    end

    % 调整到 0到360度之间
    E   = rem(E + 2*gpsPi, 2*gpsPi);

    %5. 计算真近点角
    nu   = atan2(sqrt(1 - eph.e^2) * sin(E), cos(E)-eph.e);

    %6. 计算升交距角（近地点角距 + 真近点角）
    phi = nu + eph.omega;
    % 调整至 0 到 360度之间
    phi = rem(phi, 2*gpsPi);

    %7. 通过球谐系数修正真近点角误差
    u = phi + ...
        eph.C_uc * cos(2*phi) + ...
        eph.C_us * sin(2*phi);
    % 通过球谐系数修正向径误差
    r = a * (1 - eph.e*cos(E)) + ...
        eph.C_rc * cos(2*phi) + ...
        eph.C_rs * sin(2*phi);
    % 通过球谐系数修正轨道倾角误差
    i = eph.i_0 + eph.iDot * tk + ...
        eph.C_ic * cos(2*phi) + ...
        eph.C_is * sin(2*phi);

    %8. 升交点赤经修正，以及地球自转的修正
    Omega = eph.omega_0 + (eph.omegaDot - Omegae_dot)*tk - ...
            Omegae_dot * eph.t_oe;
    % 调整到0到360之间
    Omega = rem(Omega + 2*gpsPi, 2*gpsPi);

    %9. ---通过旋转矩阵，实现轨道坐标（r，u）到空固坐标系的转换 ------------------------------------
    satPositions(1) = cos(u)*r * cos(Omega) - sin(u)*r * cos(i)*sin(Omega);
    satPositions(2) = cos(u)*r * sin(Omega) + sin(u)*r * cos(i)*cos(Omega);
    satPositions(3) = sin(u)*r * sin(i);


    %% 10. 计算卫星钟钟差 --------------------
    % 计算相对论效应修正值，按照ICD文件计算
    dtr = F * eph.e * eph.sqrtA * sin(E);

    % 计算卫星钟与GPS原子时之间的钟差修正数
    satClkCorr = (eph.a_f2 * dt + eph.a_f1) * dt + ...
                         eph.a_f0 - ...
                         eph.T_GD + dtr;
                     
    %该钟差与HOW中的卫星钟结合，可以得到最终的GPS原子时，可用于授时和伪距修正
