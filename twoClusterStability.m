
clear;
clc;

reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init, 2);

N = 100;   % Can be varied  % Currently must be even

J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;

% gamma1 = gamma1+0.1;
% gamma2 = gamma2-0.1;

dim = 2;
n1 = N/2;           %% Change this if it can be any number
n2 = N/2;
pos1 = pointsInC(0,0,1,n1);  
pos2 = pointsInC(7,0,1,n2);
phase1 = zeros(n1,1);
phase2 = pi*ones(n2,1);
pos = [[pos1;pos2],[phase1;phase2]];
% % checking 
% pos = [pos1;pos2];
% figure 
% plot(pos(:,1),pos(:,2),'.');
% daspect([1 1 1]); 
% % Test passed
y00 = reshape(pos,1,[]); 
timeSteps = 500;
stepSize = 1;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
% Solve ODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:5*timeSteps*stepSize],y00,options, dim,N,zeros(1,N),K,J,gamma1,gamma2);
%y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);
%%
y00 = y_full(end,:);
y00(2*N+1:end) = y00(2*N+1:end) + (2*rand(1,N)-1)*10^(-8);
gamma1 = gamma1-0.09;
gamma2 = gamma2+0.09;
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:2*timeSteps*stepSize],y00,options, dim,N,zeros(1,N),K,J,gamma1,gamma2);
%%
Jmat = jacobianMatrix(y_full(end,:),N,K,gamma1,gamma2);
eig(Jmat)
gamma1+ 2*gamma2

figure;
colormap('hsv');
scatter(y_full(end,1:N),y_full(end,N+1:2*N),[],y_full(end,2*N+1:end)),colorbar;
caxis([0 2*pi]);
% xlim([minx maxx]);
% ylim([miny maxy]);
daspect([1 1 1]);