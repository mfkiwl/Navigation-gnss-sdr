function corrTime = check_t(time)
%
% ���ָ����Ԫ��ο���Ԫ֮���Ƿ���ֿ�������������ڿ���������Ҫ����ICD�ļ�ָ���ķ�ʽ����У��
% ע�⣺���������ÿ����0��0����0
%
% corrTime = check_t(time);
%
%   ����:
%       time        - У��ǰ��ο���Ԫ��ʱ����λΪ��
%
%   ���:
%       corrTime    - У������ο���Ԫ��ʱ����λΪ��

half_week = 302400;     % ��

corrTime = time;

if time > half_week
    corrTime = time - 2*half_week;
elseif time < -half_week
    corrTime = time + 2*half_week;
end
