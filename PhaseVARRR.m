clear;
clc;
close all;

N = 300;
K = -0.5;
J = 0.8;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;

timeSteps = 1000;
n1 = N/2;
n2 = N/2;
pos1 = pointsInC(0,0,1,n1);
pos2 = pointsInC(7,0,1,n2);
phase1 = rand(n1,1)*10^(-1);
phase2 = pi*ones(n2,1);
stepSize = 1;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);

pos = [[pos1;pos2],[phase1;phase2]];
y00 = reshape(pos,1,[]);
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);

%%
figure;
colormap(hsv(256));
scatter(y_full(end,1:N/2),y_full(end,N+1:N + N/2),[],y_full(end,2*N+1:2*N + N/2),'filled');
colorbar;
caxis([-inf inf]);
box on;
daspect([1 1 1]); 