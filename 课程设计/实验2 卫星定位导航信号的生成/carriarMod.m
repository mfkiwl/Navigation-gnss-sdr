%**********************************************************************%
%���룺
%       PRN��    �������
%       Q��      ��������
%       Fin��    �ز�Ƶ��
%       LEN��    ����볤��
%�����
%       gpsdata�����ɵ�GPS�������ݣ�ʱ�䲽��Ϊ1/Q����Ƭ��ȣ���1/(Q*1.023e6)��
%**********************************************************************%
function    gpsdata = carriarMod(codes,Fin,Q,LEN)

%********************************************************
%  1  --  ������ԪֵΪ1�����ز���˲����ޱ仯��ʵ��0����λ
% -1  --  ������ԪֵΪ0�����ز���˲��η�ת��ʵ��180����λ
%*********************************************************

fs = 1.023*1.e6;                    % CA������
fc = Fin*Q;                         % �ز�����Ƶ��

delta_ts = 1/fs;                    % CA��ʱ�䲽��
delta_tc = 1/fc;                    % �ز�ʱ�䲽��

% ���ݸöβ������������ʱ������õ����ز���������
signalnum = floor(length(codes)*delta_ts/delta_tc);

n=0;                                % ʱ�������
Index_Code = 0;                     % ��Ԫָʾ��

gpsdata = zeros(1,signalnum);       % ���ƺ��ź��������

%   �Ե��ƺ�������н��в���
while(n < signalnum)                    %
    n=n+1;
   
    Index_Code = floor(n*delta_tc/delta_ts);
    
    gpsdata(n)=codes(Index_Code+1);
end
% ��ʱgpsdata��codes�������ز�����Ľ��

%*********************************************************************
%   �źŵ���   s(t)=exp(j*2*pi*omega*t)=cos(2*pi*f*t)+j*sin(2*pi*f*t)
%   I�ࣺ    cos��2*pi*f*t��
%   Q�ࣺ    sin��2*pi*f*t��
%   һ����Ԫ�Ŀ�ȣ�
figure
plot(subplot(2,1,1),gpsdata);

% BPSK�ز���λ���ƣ�exp(j*2*pi*Fin*(0:n-1)*delta_tc)Ϊ�ز�����������
gpsdata=gpsdata.*cos(2*pi*Fin*(0:n-1)*delta_tc);

plot(subplot(2,1,2),real(gpsdata));

