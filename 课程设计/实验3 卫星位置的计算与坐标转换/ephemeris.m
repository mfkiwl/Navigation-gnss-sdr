function [eph, TOW] = ephemeris(bits, D30Star)
% 从给定的bit流中，解析出星历和TOW信息，暂不考虑子帧的先后顺序
% 另外，函数未做奇偶校验，认为输入的bit流没有误码
%
%[eph, TOW] = ephemeris(bits, D30Star)
%   输入:
%       bits        - 导航电文比特流，1500个bit，bit取值为'0'或 '1'.
%       D30Star     - 前一个字的最后一个bit，按照ICD文件用于为后续30bit恢复原始数据，取值为'0' or '1'.
%   Outputs:
%       TOW         - 字节流中第一个子帧（子帧编号不一定为1）的周内秒计数
%       eph         - 卫星的星历数据


%% Check if there is enough data ==========================================
if length(bits) < 1500
    error('The parameter BITS must contain 1500 bits!');
end

%% Check if the parameters are strings ====================================
if ~ischar(bits)
    error('The parameter BITS must be a character array!');
end

if ~ischar(D30Star)
    error('The parameter D30Star must be a char!');
end

% Pi used in the GPS coordinate system
gpsPi = 3.1415926535898; 

%% Decode all 5 sub-frames ================================================
for i = 1:5

    %--- 截取一个子帧的300bit数据  ---------------------------------------
    subframe = bits(300*(i-1)+1 : 300*i);

    %--- 根据ICD文件，利用D30Str恢复原始数据 ----------------
    for j = 1:10
        [subframe(30*(j-1)+1 : 30*j)] = ...
            checkPhase(subframe(30*(j-1)+1 : 30*j), D30Star);
        
        D30Star = subframe(30*j);
    end

    %--- 提取子帧ID（1-5） ------------------------------------------
    subframeID = bin2dec(subframe(50:52));

    %--- 根据子帧ID，提取导航电文 ----------------------
    switch subframeID
        case 1  %--- It is subframe 1 -------------------------------------
            % 包含GPS周计数WN（自GPS时起点至本周的周数模1024） ，钟差、频偏、钟漂等参数
            eph.weekNumber  = bin2dec(subframe(61:70)) + 1024;
            eph.accuracy    = bin2dec(subframe(73:76));
            eph.health      = bin2dec(subframe(77:82));
            eph.T_GD        = twosComp2dec(subframe(197:204)) * 2^(-31);
            eph.IODC        = bin2dec([subframe(83:84) subframe(197:204)]);
            eph.t_oc        = bin2dec(subframe(219:234)) * 2^4;
            eph.a_f2        = twosComp2dec(subframe(241:248)) * 2^(-55);
            eph.a_f1        = twosComp2dec(subframe(249:264)) * 2^(-43);
            eph.a_f0        = twosComp2dec(subframe(271:292)) * 2^(-31);

        case 2  %--- It is subframe 2 -------------------------------------
            % 包含卫星星历数据
            eph.IODE_sf2    = bin2dec(subframe(61:68));
            eph.C_rs        = twosComp2dec(subframe(69: 84)) * 2^(-5);
            eph.deltan      = ...
                twosComp2dec(subframe(91:106)) * 2^(-43) * gpsPi;
            eph.M_0         = ...
                twosComp2dec([subframe(107:114) subframe(121:144)]) ...
                * 2^(-31) * gpsPi;
            eph.C_uc        = twosComp2dec(subframe(151:166)) * 2^(-29);
            eph.e           = ...
                bin2dec([subframe(167:174) subframe(181:204)]) ...
                * 2^(-33);
            eph.C_us        = twosComp2dec(subframe(211:226)) * 2^(-29);
            eph.sqrtA       = ...
                bin2dec([subframe(227:234) subframe(241:264)]) ...
                * 2^(-19);
            eph.t_oe        = bin2dec(subframe(271:286)) * 2^4;

        case 3  %--- It is subframe 3 -------------------------------------
            % 包含第二部分的卫星星历数据
            eph.C_ic        = twosComp2dec(subframe(61:76)) * 2^(-29);
            eph.omega_0     = ...
                twosComp2dec([subframe(77:84) subframe(91:114)]) ...
                * 2^(-31) * gpsPi;
            eph.C_is        = twosComp2dec(subframe(121:136)) * 2^(-29);
            eph.i_0         = ...
                twosComp2dec([subframe(137:144) subframe(151:174)]) ...
                * 2^(-31) * gpsPi;
            eph.C_rc        = twosComp2dec(subframe(181:196)) * 2^(-5);
            eph.omega       = ...
                twosComp2dec([subframe(197:204) subframe(211:234)]) ...
                * 2^(-31) * gpsPi;
            eph.omegaDot    = twosComp2dec(subframe(241:264)) * 2^(-43) * gpsPi;
            eph.IODE_sf3    = bin2dec(subframe(271:278));
            eph.iDot        = twosComp2dec(subframe(279:292)) * 2^(-43) * gpsPi;

        case 4  %--- It is subframe 4 -------------------------------------
            % 卫星历书、电离层修正参数、UTC校准参数等
            % 暂时用不到，不做解码

        case 5  %--- It is subframe 5 -------------------------------------
            % 卫星历书等 (PRN: 1-24).
            % 暂时用不到，不做解码

    end 

end 

%% 计算数据流中第一个子帧的周内秒计数 (TOW) ====
%  提取子帧周内秒计数同时，根据卫星钟差校正参数对其进行校正.
%  根据ICD文件，TOW表示的是下一个子帧的开始时间

%  周内秒计数时间步长为1.5，TOW截断了后两位，即4*1.5=6秒
%  当前子帧为数据流中最后一个子帧，其标识的是下一个子帧的开始时间
%  由于一帧的传输时间为30秒，所以周内秒计数减30秒即为数据流中第一个子帧的开始时间（信号发射时间）
TOW = bin2dec(subframe(31:47)) * 6 - 30;
