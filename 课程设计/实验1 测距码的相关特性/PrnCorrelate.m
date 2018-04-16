
PRN1=GetCACode(2,1023);
PRN2=GetCACode(10,1023);
PRN3=GetCACode(15,1023);

tempPRN = zeros(1,1023);
%*********************************************
%  ����ؼ��㣬����λ����Ϊ1����Ԫ

correlatePRN1_1 = zeros(1,1023);
for m=1:1023
    for n = 1:1023
        index = mod(m+n-1,1023);
        if index==0 
            index =1023
        end
                
        tempPRN(n) = PRN1(index);
    end
        
    tempPRN=tempPRN.*PRN1;
    correlatePRN1_1(m)=sum(tempPRN);    
end



%*********************************************
%  ����ؼ��㣬����λ����Ϊ1����Ԫ
correlatePRN1_2 = zeros(1,1023);
for m=1:1023
    for n = 1:1023
        index = mod(m+n-1,1023);
        if index==0 
            index =1023
        end
                
        tempPRN(n) = PRN2(index);
    end
        
    tempPRN=tempPRN.*PRN1;
    correlatePRN1_2(m)=sum(tempPRN);    
end

correlatePRN1_3 = zeros(1,1023);
for m=1:1023
    for n = 1:1023
        index = mod(m+n-1,1023);
        if index==0 
            index =1023
        end
                
        tempPRN(n) = PRN3(index);
    end
        
    tempPRN=tempPRN.*PRN1;
    correlatePRN1_3(m)=sum(tempPRN);    
end

%********************************************
% ��ͼ
plot(subplot(3,1,1),correlatePRN1_1);
xlim([-10,1033]);
ylim([-100,1030]);
title('��2��������ؼ�����');
xlabel('����λ(1-1023)');
plot(subplot(3,1,2),correlatePRN1_2);
xlim([-10,1033]);
ylim([-100,1030]);
ylim([-100,1030]);
title('��2���Ǻ͵�10���ǵĻ���ؼ�����');
xlabel('����λ(1-1023)');
plot(subplot(3,1,3),correlatePRN1_3);
xlim([-10,1033]);
ylim([-100,1030]);
title('��2���Ǻ͵�15���ǵĻ���ؼ�����');



