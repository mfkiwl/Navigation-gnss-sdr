%���ļ��ж�ȡһ֡��������
%��һ��bitΪ��һ���ֵ����1λ�����ں����ֽ�ԭʼ���ݵĻָ���У�飬��˹���1501��bit

load('navBitsBin3.mat','navBitsBin3');
load('navBitsBin6.mat','navBitsBin6');
load('navBitsBin15.mat','navBitsBin15');
load('navBitsBin22.mat','navBitsBin22');

% ---------   ��3���ǵ�λ��  -----------------------
% �������Ľ���
[eph3, TOW3] =  ephemeris(navBitsBin3(2:1501)', navBitsBin3(1));
% ���õ�ǰ��Ԫ
transmitTime = TOW3;
% ��������λ������Ԫ�����ǵع����� 
 [satPositions3, satClkCorr3] = satpos(transmitTime,eph3);
 
% ---------   ��6���ǵ�λ��  -----------------------
% �������Ľ���
[eph6, TOW6] =  ephemeris(navBitsBin6(2:1501)', navBitsBin6(1));
% ����λ����������Ԫ
transmitTime = TOW6;
% ��������λ������Ԫ�����ǵع����� 
 [satPositions6, satClkCorr6] = satpos(transmitTime,eph6);
 
% ---------   ��15���ǵ�λ��  -----------------------
% �������Ľ���
[eph15, TOW15] =  ephemeris(navBitsBin15(2:1501)', navBitsBin15(1));
% ����λ����������Ԫ
transmitTime = TOW15;
% ��������λ������Ԫ�����ǵع����� 
 [satPositions15, satClkCorr15] = satpos(transmitTime,eph15);

 
% ---------   ��22���ǵ�λ��  -----------------------
% �������Ľ���
[eph22, TOW22] =  ephemeris(navBitsBin22(2:2201)', navBitsBin22(1));
% ����λ����������Ԫ
transmitTime = TOW22;
% ��������λ������Ԫ�����ǵع����� 
 [satPositions22, satClkCorr22] = satpos(transmitTime,eph22);

