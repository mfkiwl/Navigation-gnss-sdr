function [satPositions, satClkCorr] = satpos(transmitTime, eph) 
% ���������������ݣ�����������ָ����Ԫ�����ǵع�����
%[satPositions, satClkCorr] = satpos(transmitTime,eph);
%
%   ����:
%       transmitTime  - ָ����Ԫ�����������ӵ����������ʱ�䣬��λΪ��
%       eph           - ��Ӧ�����ڵ���������

%
%   ���:
%       satPositions  - GPS�������� (�ع�����ϵ [X; Y; Z;])
%       satClkCorr    - У�����������


%% Initialize constants ===================================================

% GPS ����

gpsPi          = 3.1415926535898;  % Pi        
Omegae_dot     = 7.2921151467e-5;  % ������ת���ٶ� [rad/s]
GM             = 3.986005e14;      % ������������ [m^3/s^2]
F              = -4.442807633e-10; % �����ЧӦ����ϵ��, [sec/(meter)^(1/2)]
                                   % F = -2*sqrt(GM)/c^2
                                   % mu -- �����ճ�����c-����

  
%% ������У�����Ա��������λ�ü��� --------------------------------

    %--- �������Ӳ�����ο���Ԫ��ʱ��� ---------------------------------------------
    dt = check_t(transmitTime - eph.t_oc);

    %--- ����������У��ֵ ---------------------------------------
    % ����GPS��ICD�ļ���L1Ƶ����Ҫ���Ӳ�����ϼ�T_GD��
    % L2Ƶ�������Ӳ�����ϼ���fL1/fL2��^2*T_GD
    % �˴�������L1Ƶ��
    
    satClkCorr = (eph.a_f2 * dt + eph.a_f1) * dt + ...
                         eph.a_f0 - ...
                         eph.T_GD;

    %--- �����źŷ���ʱ�̵�GPSʱ��
    time = transmitTime - satClkCorr;

%% ����λ�ý��� ----------------------------------------------

    %1. �ָ��볤��
    a   = eph.sqrtA * eph.sqrtA;

    % ���������������ο���Ԫ��ʱ���
    tk  = check_t(time - eph.t_oe);

    %2. ��ʼ��ƽ�����ٶ�
    n0  = sqrt(GM / a^3);
    
    % ƽ�����ٶ�����
    n   = n0 + eph.deltan;

    %3. ����ƽ�����
    M   = eph.M_0 + n * tk;
    % ����Ϊ0��360��֮��
    M   = rem(M + 2*gpsPi, 2*gpsPi);

    %4. ��ʼ��ƫ�����
    E   = M;

    %--- ������10�ε���������õ�ƫ�����E ----------------------------
    for ii = 1:10
        E_old   = E;
        E       = M + eph.e * sin(E);
        dE      = rem(E - E_old, 2*gpsPi);

        if abs(dE) < 1.e-12
            % ���������˳�ѭ��
            break;
        end
    end

    % ������ 0��360��֮��
    E   = rem(E + 2*gpsPi, 2*gpsPi);

    %5. ����������
    nu   = atan2(sqrt(1 - eph.e^2) * sin(E), cos(E)-eph.e);

    %6. ����������ǣ����ص�Ǿ� + �����ǣ�
    phi = nu + eph.omega;
    % ������ 0 �� 360��֮��
    phi = rem(phi, 2*gpsPi);

    %7. ͨ����гϵ���������������
    u = phi + ...
        eph.C_uc * cos(2*phi) + ...
        eph.C_us * sin(2*phi);
    % ͨ����гϵ�����������
    r = a * (1 - eph.e*cos(E)) + ...
        eph.C_rc * cos(2*phi) + ...
        eph.C_rs * sin(2*phi);
    % ͨ����гϵ���������������
    i = eph.i_0 + eph.iDot * tk + ...
        eph.C_ic * cos(2*phi) + ...
        eph.C_is * sin(2*phi);

    %8. ������ྭ�������Լ�������ת������
    Omega = eph.omega_0 + (eph.omegaDot - Omegae_dot)*tk - ...
            Omegae_dot * eph.t_oe;
    % ������0��360֮��
    Omega = rem(Omega + 2*gpsPi, 2*gpsPi);

    %9. ---ͨ����ת����ʵ�ֹ�����꣨r��u�����չ�����ϵ��ת�� ------------------------------------
    satPositions(1) = cos(u)*r * cos(Omega) - sin(u)*r * cos(i)*sin(Omega);
    satPositions(2) = cos(u)*r * sin(Omega) + sin(u)*r * cos(i)*cos(Omega);
    satPositions(3) = sin(u)*r * sin(i);


    %% 10. �����������Ӳ� --------------------
    % ���������ЧӦ����ֵ������ICD�ļ�����
    dtr = F * eph.e * eph.sqrtA * sin(E);

    % ������������GPSԭ��ʱ֮����Ӳ�������
    satClkCorr = (eph.a_f2 * dt + eph.a_f1) * dt + ...
                         eph.a_f0 - ...
                         eph.T_GD + dtr;
                     
    %���Ӳ���HOW�е������ӽ�ϣ����Եõ����յ�GPSԭ��ʱ����������ʱ��α������
