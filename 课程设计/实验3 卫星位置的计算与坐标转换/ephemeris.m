function [eph, TOW] = ephemeris(bits, D30Star)
% �Ӹ�����bit���У�������������TOW��Ϣ���ݲ�������֡���Ⱥ�˳��
% ���⣬����δ����żУ�飬��Ϊ�����bit��û������
%
%[eph, TOW] = ephemeris(bits, D30Star)
%   ����:
%       bits        - �������ı�������1500��bit��bitȡֵΪ'0'�� '1'.
%       D30Star     - ǰһ���ֵ����һ��bit������ICD�ļ�����Ϊ����30bit�ָ�ԭʼ���ݣ�ȡֵΪ'0' or '1'.
%   Outputs:
%       TOW         - �ֽ����е�һ����֡����֡��Ų�һ��Ϊ1�������������
%       eph         - ���ǵ���������


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

    %--- ��ȡһ����֡��300bit����  ---------------------------------------
    subframe = bits(300*(i-1)+1 : 300*i);

    %--- ����ICD�ļ�������D30Str�ָ�ԭʼ���� ----------------
    for j = 1:10
        [subframe(30*(j-1)+1 : 30*j)] = ...
            checkPhase(subframe(30*(j-1)+1 : 30*j), D30Star);
        
        D30Star = subframe(30*j);
    end

    %--- ��ȡ��֡ID��1-5�� ------------------------------------------
    subframeID = bin2dec(subframe(50:52));

    %--- ������֡ID����ȡ�������� ----------------------
    switch subframeID
        case 1  %--- It is subframe 1 -------------------------------------
            % ����GPS�ܼ���WN����GPSʱ��������ܵ�����ģ1024�� ���ӲƵƫ����Ư�Ȳ���
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
            % ����������������
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
            % �����ڶ����ֵ�������������
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
            % �������顢���������������UTCУ׼������
            % ��ʱ�ò�������������

        case 5  %--- It is subframe 5 -------------------------------------
            % ��������� (PRN: 1-24).
            % ��ʱ�ò�������������

    end 

end 

%% �����������е�һ����֡����������� (TOW) ====
%  ��ȡ��֡���������ͬʱ�����������Ӳ�У�������������У��.
%  ����ICD�ļ���TOW��ʾ������һ����֡�Ŀ�ʼʱ��

%  ���������ʱ�䲽��Ϊ1.5��TOW�ض��˺���λ����4*1.5=6��
%  ��ǰ��֡Ϊ�����������һ����֡�����ʶ������һ����֡�Ŀ�ʼʱ��
%  ����һ֡�Ĵ���ʱ��Ϊ30�룬���������������30�뼴Ϊ�������е�һ����֡�Ŀ�ʼʱ�䣨�źŷ���ʱ�䣩
TOW = bin2dec(subframe(31:47)) * 6 - 30;
