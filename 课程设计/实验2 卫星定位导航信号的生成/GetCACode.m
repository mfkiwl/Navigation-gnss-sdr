%******************************************************
%输入：
%    PRN: 伪距码编号，1-32
%    LEN：测距码长度，C/A码为1023
%输出：
%    PRN对应的C/A码
%*******************************************************


function CACode = GetCACode(PRN,LEN)
format long g;
X=[1 1 1 1 1 0 1 1 0 0; 
   1 1 1 1 0 1 1 0 0 0; 
   1 1 1 0 1 1 0 0 0 0; 
   1 1 0 1 1 0 0 0 0 0; 
   0 0 1 0 0 1 0 1 1 0; 
   0 1 0 0 1 0 1 1 0 0; 
   0 1 1 0 0 1 0 1 1 0; 
   1 1 0 0 1 0 1 1 0 0; 
   1 0 0 1 0 1 1 0 0 0; 
   1 1 0 1 1 1 0 1 0 0; 
   1 0 1 1 1 0 1 0 0 0; 
   1 1 1 0 1 0 0 0 0 0; 
   1 1 0 1 0 0 0 0 0 0; 
   1 0 1 0 0 0 0 0 0 0; 
   0 1 0 0 0 0 0 0 0 0; 
   1 0 0 0 0 0 0 0 0 0; 
   1 0 0 0 1 0 0 1 1 0; 
   0 0 0 1 0 0 1 1 0 0; 
   0 0 1 0 0 1 1 0 0 0; 
   0 1 0 0 1 1 0 0 0 0; 
   1 0 0 1 1 0 0 0 0 0; 
   0 0 1 1 0 0 0 0 0 0; 
   0 0 1 1 0 0 1 1 1 0; 
   1 0 0 1 1 1 0 0 0 0; 
   0 0 1 1 1 0 0 0 0 0; 
   0 1 1 1 0 0 0 0 0 0; 
   1 1 1 0 0 0 0 0 0 0; 
   1 1 0 0 0 0 0 0 0 0; 
   0 0 0 1 0 1 0 1 1 0; 
   0 0 1 0 1 0 1 1 0 0; 
   0 1 0 1 0 1 1 0 0 0; 
   1 0 1 0 1 1 0 0 0 0];

%local CA code generating
%               [1 2 3 4 5 6 7 8 9 10];

InitialPhase_G1=[1 1 1 1 1 1 1 1 1 1];
Coef_G1        =[0 0 1 0 0 0 0 0 0 1];
InitialPhase_G2=X(PRN,:);
Coef_G2        =[0 1 1 0 0 1 0 1 1 1];
N=LEN;
NUM=10; 
CA_code_save=zeros(1,N);
for i=1:N
    G1_in =mod(sum(InitialPhase_G1.*Coef_G1),2);
    G1_out=InitialPhase_G1(NUM);
    G2_in =mod(sum(InitialPhase_G2.*Coef_G2),2);
    G2_out=InitialPhase_G2(NUM);
    G_out =G1_out+G2_out;
    CA_code_save(i)=mod(G_out,2);
    InitialPhase_G1(2:NUM)=InitialPhase_G1(1:NUM-1);
    InitialPhase_G1(1)=G1_in;
    InitialPhase_G2(2:NUM)=InitialPhase_G2(1:NUM-1);
    InitialPhase_G2(1)=G2_in;
end
CACode = 2*CA_code_save-1;
