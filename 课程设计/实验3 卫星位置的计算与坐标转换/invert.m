function result = invert(data)
% �������bit�������ֵ��ת�� 0 ��� 1 and 1 ��� 0.
%
%result = invert(data)

dataLength = length(data);
temp(1:dataLength) = '1';

invertMask = bin2dec(char(temp));

result = dec2bin(bitxor(bin2dec(data), invertMask), dataLength);