% An attempt for three cluster state

clear;
clc;

% Setting random numbers for consistent results
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


% Same cluster size 
n1 = N/2;
n2 = N/2;

pos1 = pointsInC(0,0,1,n1);
pos2 = pointsInC(5,0,1,n2);

phase1 = zeros(n1,1);
phase2 = pi*ones(n1,1);

y00 = [[pos1;pos2],[phase1;phase2]];
y00  = reshape(y00,1,[]);
%% run the system until it settles down

timeSteps = 200;
stepSize = 1;

% Solve ODE
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);
y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);

index = phaseSeparation(y_full(end,:));
[centroid,pos] = centroidCal(y_full(end,:),index);

minx = min(min(y_full(:,1:N)));
maxx = max(max(y_full(:,1:N)));
miny = min(min(y_full(:,N+1:2*N)));
maxy = max(max(y_full(:,N+1:2*N)));

%%
figure
colormap('hsv');
scatter(y_full(end,1:N),y_full(end,N+1:2*N),[],y_full(end,2*N+1:end),'.'),colorbar;
caxis([0 2*pi]);
xlim([minx maxx]);
ylim([miny maxy]);
daspect([1 1 1]); 
hold on;
plot(centroid(:,1),centroid(:,2),'kx');

%%
% Calculate mid point
mid = mean(centroid);
y_steady = reshape(y_full(end,:),[],3);

% new points
n = 1;
pos = pointsInC(mid(1),mid(2),0.4,n);
midPhase = mean(y_steady(:,3));
y_mid = [pos,repmat(midPhase,n,1)];
y_steady = [y_steady;y_mid];
N_dy = N + n;
y_steady = reshape(y_steady,1,[]);

%%
% Solve the new system
[~,y_dy] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize*150],y_steady, options, dim,N_dy,zeros(1,N_dy),K,J,gamma1,gamma2);

%%
y_dy(:,dim*N_dy + 1:end) = mod(y_dy(:,dim*N_dy + 1:end),2*pi);
minx = min(min(y_dy(:,1:N_dy)));
maxx = max(max(y_dy(:,1:N_dy)));
miny = min(min(y_dy(:,N_dy+1:2*N_dy)));
maxy = max(max(y_dy(:,N_dy+1:2*N_dy)));
%%
%f = figure('visible','off');
% figure
% for i = 1:timeSteps*2+1
%     colormap('hsv');
%     scatter(y_dy(i,1:N_dy),y_dy(i,N_dy+1:2*N_dy),[],y_dy(i,2*N_dy+1:end)),colorbar;
%     caxis([0 2*pi]);
%     xlim([minx maxx]);
%     ylim([miny maxy]);
%     daspect([1 1 1]); 
%     %pause(0.01)
% %     file1 = sprintf('threeClusterStable\\fig_%05i.png',i);
% %     saveas(f,file1);
% end
figure
colormap(hsv(256));
ax = axes;
ax.XLim = [minx-0.5 maxx+0.5];
ax.YLim = [miny-0.5 maxy+0.5];
ax.NextPlot = 'add';
plot1 = scatter(y_dy(1,1:N_dy),y_dy(1,N_dy+1:2*N_dy),[],y_dy(1,2*N_dy+1:end),'filled');
caxis([0 2*pi]);
daspect([1 1 1]);
obj = colorbar;
obj.TickLabelInterpreter = 'latex';
obj.XTickLabel = {'$0$','$\frac{\pi}{4}$','$\frac{\pi}{2}$','$\frac{3\pi}{4}$','$\pi$','$\frac{5\pi}{4}$','$\frac{3\pi}{2}$','$\frac{7\pi}{4}$','$2\pi$'};
obj.XTick = 0:pi/4:2*pi;
obj.FontSize = 13;
box on;
xlabel('x');
ylabel('y');
for i=1000:20:timeSteps*50+1
    plot1.XData = y_dy(i,1:N_dy);
    plot1.YData = y_dy(i,N_dy+1:2*N_dy);
    plot1.CData = y_dy(i,2*N_dy + 1:end);
    %drawnow update
    pause(0.05);
    hold on
    %waitforbuttonpress;
    % file2 = sprintf('J_1.2\\fig_%05i.png',i);
    % saveas(f,file2);
end
 
%save('threeClusterStable\\matlabVar.mat');
%%
Jacob = jacobianMatrix(y_dy(end,:),N_dy,K,gamma1,gamma2);
eig(Jacob)

%%
figure
plot(1:length(y_dy(300:end,end)),y_dy(300:end,end));