clear;
clc;
close all;

reset(RandStream.getGlobalStream,1);
%rand_init = 76599;

% Constants
N = 400;
K = -0.5;
J = 0.8;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;

timeSteps = 100;
stepSize = 1;
% Initial conditions
y00 = rand((dim+1)*N,1);
y00(dim*N + 1:end) = 2*pi*y00(dim*N + 1:end);
options = odeset('RelTol',1e-6,'AbsTol',1e-6);

% Solve system for some 
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);
y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);

y00 = y_full(end,:);
clear y_full
% Show end state
figure(1);
colormap('hsv');
scatter(y00(1:N),y00(N+1:2*N),[],y00(2*N+1:end),'o'),colorbar;
caxis([0 2*pi]);
% xlim([minx maxx]);
% ylim([miny maxy]);
daspect([1 1 1]); 
%%

index = phaseSeparation(y00);
figure(2)
gscatter(y00(1:N),y00(N+1:2*N),index,'bgmk');
[C,P] = centroidCal(y00,index);
hold on
plot(C(:,1),C(:,2),'kx');

%%
% Group the Clusters together so that it is easy to track the system
k = 1;
y_stable = [];
y00 = reshape(y00,[],3);
clusterNums = [];
while any(k == index)
    clusterNums = [clusterNums;sum(index == k)];
    y_cluster = y00(index == k,:);
    y_stable = [y_stable;y_cluster];
    y_cluster = [];
    k = k + 1;
end
clear y_cluster
y_stable = reshape(y_stable,1,[]);

%%
% Solve the system again to look into the dynamics
tic
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y_stable, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);

minx = min(min(y_full(:,1:N)));
maxx = max(max(y_full(:,1:N)));
miny = min(min(y_full(:,N+1:2*N)));
maxy = max(max(y_full(:,N+1:2*N)));
toc
%%
i = 1;
y_new = y_full;
%y_new = reshape(y_full, timeSteps+1,[],3);
for n = 1:numel(clusterNums)
    avgPhase = mean(y_stable(2*N+i:2*N + i + clusterNums(n) - 1));
    if n == 3
        y_new(:,2*N + i:2*N + i + clusterNums(n) - 1) = 0;
    else
        y_new(:,2*N + i:2*N + i + clusterNums(n) - 1) = y_new(:,2*N + i:2*N + i + clusterNums(n) - 1) - avgPhase;
    end
        i = i + clusterNums(n);
end

%%    

f = figure(3);
cmin = min(y_new(:,2*N+1:end),[],'all');
cmax = max(y_new(:,2*N+1:end),[],'all');
for i=1:timeSteps+1
    colormap(jet(256));
    scatter(y_new(i,1:N),y_new(i,N+1:2*N),[],y_new(i,2*N+1:end),'filled'),colorbar;
    caxis([-0.15 0.15]);
    xlim([minx maxx]);
    ylim([miny maxy]);
    box on;
    xlabel('x');
    ylabel('y');
    daspect([1 1 1]); 
    %pause(0.05) 
    if i == 100
        waitforbuttonpress;
    end
    %file2 = sprintf('PhaseVar\\ori_%05i.png',i);
    %saveas(f,file2);
end
%%
save('PhaseVariationsInClusters.mat');