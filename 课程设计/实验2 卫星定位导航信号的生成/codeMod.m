
%***************************************************************
% codeMOd��  ���������ĵ��Ƶ�����루��Ƶ�룩�ϣ��γ��µ�������
% ���룺
%           PRN��    C/A��������
%           frame��  �������ģ�ȡֵΪ����1��һ֡Ϊ1500bit���������г���Ϊ1500����������
%  �����
%           code��   ���ƺ�������У�����Ӧ��Ϊlen(frame)*20*1023
%*********************************************************************

function codes = codeMod(PRN,LEN,frame)

CAcode = GetCACode(PRN,LEN);
Q=1;                                %������
codelen = length(frame)*20*LEN*Q;
CAcodeSample = zeros(1,codelen);
frameSample = zeros(1,codelen);
code   = zeros(1,codelen);

for n=1:codelen
    p_index=floor((n-1)/(20*LEN*Q))+1;    %������ָʾ��
    q_index = mod(n,LEN*Q);               %CA��ָʾ��
    if q_index==0
        q_index=LEN*Q;
    end
    q_index=floor((q_index-1)/Q)+1;    
    CAcodeSample(n)=CAcode(q_index);
    frameSample(n)=frame(p_index);
    code(n)=CAcodeSample(n)*frameSample(n);
end
%*******************************************************
% % ��ͼ
% plot(subplot(3,1,1),frameSample);
% title('��������');
% ylim([-2,+2]);
% xlim([1550,1650]);
% 
% plot(subplot(3,1,2),CAcodeSample);
% title('����루��Ƶ�룩');
% ylim([-2,+2]);
% xlim([1550,1650]);
% 
% plot(subplot(3,1,3),code);
% title('����ƽ��');
% ylim([-2,+2]);
% xlim([1550,1650]);

codes=code;
end

