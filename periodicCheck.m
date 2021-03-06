clear;
clc;
close all
reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init,2);  %% Discouraged syntax for randn 
clear rand_init

N = 100;
tic
options = odeset('RelTol',1e-6,'AbsTol',1e-6);

dim = 2;

na = 1000;
%na = 10000;
dts = 0.1;

K = -0.5;
J = 0.8;
gamma1 = 2/3;
gamma2 = -1/3;

y00 = rand((dim+1)*N,1);

y00(dim*N + 1:end) = 2*pi*y00(dim*N + 1:end);

[~,y_full] = ode45(@swarmalator_matrixform, [0:dts:2*na], y00, options, dim, N, zeros(1,N), K, J, gamma1, gamma2);
y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);
toc
%% The while loop of the code needs fixing 
index = phaseSeparation(y_full(end,:));
k = 1;
clusterNums = [];
y00 = reshape(y_full(end,:),[],3);
y_stable = [];
while any(k == index)
    clusterNums = [clusterNums;[sum(index == k),k]];
    y_cluster = y00(index == k,:);
    y_stable = [y_stable;y_cluster];
    y_cluster = [];
    k = k + 1;
end
clear y_cluster
%clusterNums = sortrows(clusterNums,1,'descend');
y_stable = reshape(y_stable,1,[]);

%% Solve the system for 1000 timeSteps
tic
[~,y_full] = ode45(@swarmalator_matrixform, [0:dts:na], y_stable, options, dim, N, zeros(1,N), K, J, gamma1, gamma2);
toc
%%
save('perodicCyclesData.mat');
%%
minx = min(min(y_full(:,1:N)));
maxx = max(max(y_full(:,1:N)));
miny = min(min(y_full(:,N+1:2*N)));
maxy = max(max(y_full(:,N+1:2*N)));
y_reshaped = reshape(y_full,size(y_full,1),[],3);

y_data = y_reshaped(1:end,end-5:end,1:2);
color = 'rgbcmk';

for i = 1:6
    data = squeeze(y_data(:,i,1:2));
    figure
    plot(data(:,1),data(:,2),color(i));
    %title(sprintf('Particle motion %d',i));
    xlabel('x');
    ylabel('y');
    daspect([1 1 1 ]);
    %hold on
    %axis([minx maxx miny maxy]);
end
%legend('1','2','3','4','5','6');
