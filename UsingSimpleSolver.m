clear
clc
close all

reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init,2);
clear rand_init

N = 100;

options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dim = 2;
timeSteps = 300;
stepSize = 1;
K = -0.5;
J = 0.8;
gamma1 = 2/3;
gamma2 = -1/3;

% Initial conditions
y00 = rand((dim+1)*N,1);
y00(dim*N + 1:end) = 2*pi*y00(dim*N + 1:end);
[~,y_full] = ode45(@swarmalator_matrixform, [0:stepSize:timeSteps*stepSize], y00, options, dim, N, zeros(1,N), K, J, gamma1, gamma2);
y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);

%% Final time plot 
minx = min(y_full(:,1:N),[],'all');
maxx = max(y_full(:,1:N),[],'all');
miny = min(y_full(:,N+1:2*N),[],'all');
maxy = max(y_full(:,N+1:2*N),[],'all');
figure(1);
colormap('hsv');
ax = axes;
ax.XLim = [minx maxx ];
ax.YLim = [miny maxy];
ax.NextPlot = 'add';
scatter(y_full(end,1:N), y_full(end,N + 1:dim*N),[],y_full(end,dim*N+1:end));
caxis([0 2*pi]);
daspect([1 1 1]);
colorbar;
title(sprintf('State of the system after T = %d time steps', timeSteps*stepSize));
set(get(gca, 'XLabel'), 'String', 'x');
set(get(gca, 'YLabel'), 'String', 'y');


%%
index = phaseSeparation(y_full(end,:));
