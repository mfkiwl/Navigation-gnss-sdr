
%***************************************************************
% codeMOd：  将导航电文调制到测距码（扩频码）上，形成新的码序列
% 输入：
%           PRN：    C/A码测距码编号
%           frame：  导航电文，取值为正负1（一帧为1500bit，输入序列长度为1500的整数倍）
%  输出：
%           code：   调制后的码序列，长度应当为len(frame)*20*1023
%*********************************************************************

function codes = codeMod(PRN,LEN,frame)

CAcode = GetCACode(PRN,LEN);
Q=1;                                %采样率
codelen = length(frame)*20*LEN*Q;
CAcodeSample = zeros(1,codelen);
frameSample = zeros(1,codelen);
code   = zeros(1,codelen);

for n=1:codelen
    p_index=floor((n-1)/(20*LEN*Q))+1;    %电文码指示器
    q_index = mod(n,LEN*Q);               %CA码指示器
    if q_index==0
        q_index=LEN*Q;
    end
    q_index=floor((q_index-1)/Q)+1;    
    CAcodeSample(n)=CAcode(q_index);
    frameSample(n)=frame(p_index);
    code(n)=CAcodeSample(n)*frameSample(n);
end
%*******************************************************
% % 制图
% plot(subplot(3,1,1),frameSample);
% title('导航电文');
% ylim([-2,+2]);
% xlim([1550,1650]);
% 
% plot(subplot(3,1,2),CAcodeSample);
% title('测距码（扩频码）');
% ylim([-2,+2]);
% xlim([1550,1650]);
% 
% plot(subplot(3,1,3),code);
% title('码调制结果');
% ylim([-2,+2]);
% xlim([1550,1650]);

codes=code;
end

