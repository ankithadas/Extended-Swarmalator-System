clear
clc
close all;
reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init,2);
N = 300;
J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;
stepSize = 1;
timeSteps = 300;
y00 = rand((dim+1)*N,1);
y00(dim*N + 1:end) = 2*pi*y00(dim*N + 1:end);
%%
options = odeset('RelTol',1e-6,'AbsTol',1e-6,'OutputFcn',@odePlotter);
tic
fig = figure(1);
ax = axes;
ax.XLim = [-5 5];
ax.YLim = [-5 5];
daspect([1 1 1]);
box on
[~,y_full] = ode45(@swarmalator_matrixform, [0 timeSteps*stepSize],y00,     options, dim, N, zeros(1,N), K, J, gamma1, gamma2);
odeplot([],[],'done');
toc