function word = checkPhase(word, D30Star)
% 根据上一个字的最后一个bit，对后续30个bit进行数据恢复
%word = checkPhase(word, D30Star)
%
%   输入:
%       word        - 30bit的数组，取值为 '0' 或 '1' 
%       D30Star     - 上个字的最后一个bit值(char类型).
%
%   输出:
%       word        - 恢复后的30bit数组 

if D30Star == '1'
    % 根据ICD文件，当值为1时，bit值进行翻转
    word(1:24) = invert(word(1:24));
end
