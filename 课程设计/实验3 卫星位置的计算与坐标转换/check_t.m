function corrTime = check_t(time)
%
% 检查指定历元与参考历元之间是否出现跨周现象，如果存在跨周现象，需要根据ICD文件指定的方式进行校正
% 注意：周内秒计数每周日0点0分置0
%
% corrTime = check_t(time);
%
%   输入:
%       time        - 校正前与参考历元的时间差，单位为秒
%
%   输出:
%       corrTime    - 校正后与参考历元的时间差，单位为妙

half_week = 302400;     % 秒

corrTime = time;

if time > half_week
    corrTime = time - 2*half_week;
elseif time < -half_week
    corrTime = time + 2*half_week;
end
