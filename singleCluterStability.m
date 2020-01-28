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
timeSteps = 100;
% Make a single cluster 
pos = pointsInC(0,0,1,N);

% Set phase to 0
pos(:,3) = 0;

y00 = reshape(pos,1,[]);
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
[~,y_full] = ode113(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);

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

% gamma1 = gamma1 + 0.2;
% gamma2 = gamma2 - 0.5;
J = 0.1;
K = -1;
y_stable = y_full(end,:);
%y_stable(2*N + 20) = 6;
figure;
colormap('hsv');
scatter(y_stable(1:N),y_stable(N+1:2*N),[],y_stable(2*N+1:end)),colorbar;
caxis([0 2*pi]);
xlim([minx maxx]);
ylim([miny maxy]);
daspect([1 1 1]); 
[T,y_new] = ode113(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y_stable, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);

minx = min(min(y_new(:,1:N)));
maxx = max(max(y_new(:,1:N)));
miny = min(min(y_new(:,N+1:2*N)));
maxy = max(max(y_new(:,N+1:2*N)));

figure(2);
for i=1:length(T)
    colormap('hsv');
    scatter(y_new(i,1:N),y_new(i,N+1:2*N),[],y_new(i,2*N+1:end)),colorbar;
    caxis([0 2*pi]);
    xlim([minx maxx]);
    ylim([miny maxy]);
    daspect([1 1 1]); 
    pause(0.05) 
    %waitforbuttonpress;
%      file2 = sprintf('videos\\swarmalator_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g\\fig_%05i.png',distro,N,K,J,gamma1,gamma2,i);
%     saveas(f,file2);
end