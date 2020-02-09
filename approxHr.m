% This file tries to approximate the average distance between the clusters for N = 100 case

clear 
clc
close all

reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init, 2);

% Constants
N = 100;
J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;
timeSteps = 300;
stepSize = 1;
options = odeset('RelTol',1e-6,'AbsTol',1e-6);

pos1 = pointsInC(0,0,1,N/2);  
pos2 = pointsInC(10,0,1,N/2);

phase1 = zeros(N/2,1);
phase2 = pi*ones(N/2,1);

y00 = reshape([[pos1;pos2],[phase1;phase2]],1,[]);
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);
index = phaseSeparation(y_full(end,:));

[C,pos] = centroidCal(y_full(end,:),index);

figure
gscatter(y_full(end,1:N),y_full(end,N+1:2*N),index,'bgmk');
hold on 
plot(C(:,1),C(:,2),'kx');
daspect([1 1 1]);
dis = norm(diff(C));
%% Distance with time 
htime = [];
for i = 1:timeSteps+1
    Cloop = centroidCal(y_full(i,:),index);
    dis = norm(diff(Cloop));
    pos = reshape(y_full(i,1:2*N),[],2);
    disAvg = mean2(pdist2(pos(1:N/2,:),pos(N/2+1,:)));
    htime = [htime;[dis,disAvg]];
end
figure;
semilogy(1:size(y_full,1),htime(:,1),1:size(y_full,1),htime(:,2));
ylim([4.5 10]);
legend(["Centroid distance","Avg Distance"]);
grid on;

%%

phase = y_full(end,2*N + 1:end);
pos = reshape(y_full(end,1:2*N),[],2);
clust1 = pos(1:N/2,:);
clust2 = pos(N/2+1:end,:);

%%

c0clust1 = clust1 - C(1,:);
c0clust2 = clust2 - C(2,:);

%%
%plot(c0clust2(:,1),c0clust2(:,2),'.');

%%
hdist = [];
for d = 0:0.01:6
    sep = c0clust2 + [d,0];
    distan = mean2(pdist2(c0clust1,sep));
    hdist = [hdist;[d,distan]];
end
figure
plot(hdist(:,1),hdist(:,2));
set(get(gca, 'XLabel'), 'String', 'Center distance');
set(get(gca, 'YLabel'), 'String', 'Average distance between the swarmalators');
grid on