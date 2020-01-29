% Attempting to simplify the model

clear;
clc;
close all;

reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init,2);
clear ans

% Constants of simulation 
N = 100;
J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;
timeSteps = 200;
stepSize = 1;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);

y00 = rand((dim+1)*N,1);
y00(dim*N + 1:end) = 2*pi*y00(dim*N + 1:end);
% Solve the system for 200 time steps 

[~,y_full] = ode45(@swarmalator_matrixform, [0:stepSize:timeSteps*stepSize], y00, options, dim, N, zeros(1,N), K, J, gamma1, gamma2);
y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);

% Show final state 
minx = min(min(y_full(:,1:N)));
maxx = max(max(y_full(:,1:N)));
miny = min(min(y_full(:,N+1:2*N)));
maxy = max(max(y_full(:,N+1:2*N)));

figure(1);
colormap('hsv');
scatter(y_full(end,1:N),y_full(end,N+1:2*N),[],y_full(end,2*N+1:end)),colorbar;
caxis([0 2*pi]);
xlim([minx maxx]);
ylim([miny maxy]);
daspect([1 1 1]); 
%%
index = phaseSeparation(y_full(end,:));
figure(3)
gscatter(y_full(end,1:N),y_full(end,N+1:2*N),index,'bgmk');
[C,P] = centroidCal(y_full(end,:),index);
hold on
plot(C(:,1),C(:,2),'kx');

%%
k = 1;
clusterNums = [];
while any(k == index)
    clusterNums = [clusterNums;[sum(index == k),k]];
    k = k + 1;
end
vars = ones(N,1);
clusterNums = sortrows(clusterNums,'descend');
for i = 1:2
    num = clusterNums(i,2);
    vars(index == num) = 0;
end
%%
% Solve the system again
y00 = y_full(end,:);
[~,y_new] = ode45(@swarmalator_matrixform, [0:stepSize:2*timeSteps*stepSize], y00, options, dim, N, zeros(1,N), K, J, gamma1, gamma2);
y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);
%%
f = figure(4);
colormap('hsv');
ax = axes;
ax.XLim = [minx maxx];
ax.YLim = [miny maxy];
ax.NextPlot = 'add';
plot1 = scatter(y_new(1,1:N),y_new(1,N+1:2*N),[],y_new(1,2*N+1:end));
caxis([0 2*pi]);
daspect([1 1 1]);
colorbar;
for i=2:timeSteps+1
    plot1.XData = y_new(i,1:N);
    plot1.YData = y_new(i,N+1:2*N);
    plot1.CData = y_new(i,2*N + 1:end);
    %drawnow update
    pause(0.05);
    %waitforbuttonpress;
    % file2 = sprintf('J_1.2\\fig_%05i.png',i);
    % saveas(f,file2);
end