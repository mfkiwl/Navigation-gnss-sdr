function intNumber = twosComp2dec(binaryNumber)
% ����'0'��'1'���ɵ����飬ת���ɶ�Ӧ������ 
%
%intNumber = twosComp2dec(binaryNumber)

%--- ��������Ƿ��ַ��� -----------------------------------------
if ~isstr(binaryNumber)
    error('Input must be a string.')
end

%--- ����������ʽת��Ϊ10���� -------------------------
intNumber = bin2dec(binaryNumber);

%--- ������ ------------------
if binaryNumber(1) == '1'
    intNumber = intNumber - 2^size(binaryNumber, 2);
end
