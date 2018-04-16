function intNumber = twosComp2dec(binaryNumber)
% 将由'0'、'1'构成的数组，转换成对应的整数 
%
%intNumber = twosComp2dec(binaryNumber)

%--- 检查输入是否字符串 -----------------------------------------
if ~isstr(binaryNumber)
    error('Input must be a string.')
end

%--- 将二进制形式转换为10进制 -------------------------
intNumber = bin2dec(binaryNumber);

%--- 负数求补 ------------------
if binaryNumber(1) == '1'
    intNumber = intNumber - 2^size(binaryNumber, 2);
end
