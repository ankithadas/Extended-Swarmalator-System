% Something is wrong with this code. Nothing is happening when changing gamma1 and gamma2 values. Need to check why this is happening. 
clear;
clc;
close all;
reset(RandStream.getGlobalStream,1);

% Constants
N = 100;
J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;
stepSize = 1;
timeSteps = 200;
% Make a single cluster 
pos = pointsInC(0,0,1,N);

% Set phase to 0
pos(:,3) = 0;
%%
y00 = reshape(pos,1,[]);
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);
%%
minx = min(min(y_full(:,1:N)));
maxx = max(max(y_full(:,1:N)));
miny = min(min(y_full(:,N+1:2*N)));
maxy = max(max(y_full(:,N+1:2*N)));

figure
colormap('hsv');
scatter(y_full(end,1:N),y_full(end,N+1:2*N),[],y_full(end,2*N+1:end)),colorbar;
caxis([0 2*pi]);
xlim([minx maxx]);
ylim([miny maxy]);
daspect([1 1 1]);
%%
gamma1 = gamma1-0.005;
gamma2 = gamma2-0.005;
% J = 0.1;
% K = -1;
y_stable = y_full(end,:);
y_stable(2*N+1:end) = randn(N,1)*10e-3;
%y_stable(2*N + 20) = 6;
figure;
colormap('hsv');
scatter(y_stable(1:N),y_stable(N+1:2*N),[],y_stable(2*N+1:end)),colorbar;
%caxis([0 2*pi]);
xlim([minx maxx]);
ylim([miny maxy]);
daspect([1 1 1]); 
%%
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
[T,y_new] = ode45(@swarmalator_matrixform,[0:stepSize :20*timeSteps*stepSize],y_stable, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);

%%

figure;
colormap('hsv');
scatter(y_new(end,1:N),y_new(end,N+1:2*N),[],y_new(end,2*N+1:end)),colorbar;
%caxis([0 2*pi]);
% xlim([minx maxx]);
% ylim([miny maxy]);
daspect([1 1 1]); 
%%
figure(2);
for i = 1:100
    initalPhase = y_stable(2*N+i);
    transientPhase = y_new(:,2*N+i);
    phaseChange = abs(transientPhase-initalPhase);
    semilogy(1:length(transientPhase),phaseChange);
    title('\phi_0 - \phi_t vs Time');
    set(get(gca, 'XLabel'), 'String', 'Time');
    set(get(gca, 'YLabel'), 'String', 'Log \phi_0 - \phi_t');
    %axis tight 
    grid on;
    hold on
end