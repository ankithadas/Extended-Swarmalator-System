clear;
clc;

dy=zeros(3*100,1);
J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
phi = rand(100,1);
PHIdiff = phi'- phi;
w = zeros(1,100);
dim = 2;
N = 100;
pts = rand(100,2);

Y = 1./internal.stats.pdistmex(pts','euc',[]);
invDis = zeros(N,N);
invDis(tril(true(N),-1)) = Y;
invDis = invDis + invDis';
invDis = invDis + eye(N);
%%
upper = sparse(triu(PHIdiff,1));
tic

inCalc = invDis.*(gamma1*sin(upper) + gamma2*sin(2*upper));
dy(dim*N + 1:(dim+1)*N) = w' + (K/N)*sum(inCalc - inCalc',2);
toc
a = dy;
dy=zeros(3*100,1);
tic 
dy(dim*N + 1:(dim+1)*N) = w' + (K/N)*sum(invDis.*(gamma1*sin(PHIdiff) + gamma2*sin(2*PHIdiff)),2);
toc