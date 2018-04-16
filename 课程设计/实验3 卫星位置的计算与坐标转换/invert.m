function result = invert(data)
% 将输入的bit数组进行值翻转， 0 变成 1 and 1 变成 0.
%
%result = invert(data)

dataLength = length(data);
temp(1:dataLength) = '1';

invertMask = bin2dec(char(temp));

result = dec2bin(bitxor(bin2dec(data), invertMask), dataLength);