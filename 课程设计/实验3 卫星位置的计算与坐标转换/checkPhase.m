function word = checkPhase(word, D30Star)
% ������һ���ֵ����һ��bit���Ժ���30��bit�������ݻָ�
%word = checkPhase(word, D30Star)
%
%   ����:
%       word        - 30bit�����飬ȡֵΪ '0' �� '1' 
%       D30Star     - �ϸ��ֵ����һ��bitֵ(char����).
%
%   ���:
%       word        - �ָ����30bit���� 

if D30Star == '1'
    % ����ICD�ļ�����ֵΪ1ʱ��bitֵ���з�ת
    word(1:24) = invert(word(1:24));
end
