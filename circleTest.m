% Test if a circular arrangment of swarmalators is stable. 

%%%%% Conlcusion: It is in an unstable equilibrium position where the distance between the clusters exponentially increases until the clusters are seperate. The instability increases with more number of particles both in the center and outside.


clear;
clc;
close all;


J = -0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;
stepSize = 1;
timeSteps = 500;
reset(RandStream.getGlobalStream,1);
n = 6;
r = 0.5;
theta = linspace(0, 2*pi,n+1);
theta(end) = [];
x = r*cos(theta)';
y = r*sin(theta)';
phase = pi*ones(size(x));
pos = [x,y,phase];

% particle in the center with phase 0 
pos(end+1,:) = 0;

% add n particles to the center
% cen = pointsInC(0,0,0.005,5);
% cen(:,3) = 0;
% pos = [pos;cen];
y00 = reshape(pos,1,[]);

% Solve the system
options = odeset('RelTol',1e-6,'AbsTol',1e-6);
N = size(pos,1);
[~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);

minx = min(min(y_full(:,1:N)));
maxx = max(max(y_full(:,1:N)));
miny = min(min(y_full(:,N+1:2*N)));
maxy = max(max(y_full(:,N+1:2*N)));
d = zeros(timeSteps+1,1);
figure
colormap('hsv');
ax = axes;
ax.XLim = [minx maxx];
ax.YLim = [miny maxy];
ax.NextPlot = 'add';
plot1 = scatter(y_full(1,1:N),y_full(1,N+1:2*N),[],y_full(1,2*N+1:end));
colorbar;
caxis([0 2*pi]);
daspect([1 1 1]); 
for i=2:timeSteps+1
    plot1.XData = y_full(i,1:N);
    plot1.YData = y_full(i,N+1:2*N);
    plot1.CData = y_full(i,2*N + 1:end);
    % hold on
    index = phaseSeparation(y_full(i,:));
    [C,~] = centroidCal(y_full(i,:),index);
    dis = norm(diff(C));
    d(i) = dis;
    % plot(C(:,1),C(:,2),'kx');
    pause(0.02) 
    % hold off
    % drawnow
    %waitforbuttonpress;
%      file2 = sprintf('videos\\swarmalator_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g\\fig_%05i.png',distro,N,K,J,gamma1,gamma2,i);
%     saveas(f,file2);
end


index = phaseSeparation(y_full(end,:));
[C,pos] = centroidCal(y_full(end,:),index);
dis = norm(diff(C));
fprintf('The distance between the clusters is %.5f\n',dis);

figure
gscatter(y_full(end,1:N),y_full(end,N+1:2*N),index,'bgmk');
hold on 
plot(C(:,1),C(:,2),'kx');
daspect([1 1 1]);
%%
figure
yyaxis left
semilogy(1:length(d),d);
ylim([min(d),max(d)+ 10e2]);
ylabel('Log Distance');
yyaxis right
plot(1:length(d),d);
title('Distance vs time');
xlabel('Time');
ylabel('Distance')
grid on

%%
figure 
colormap('hsv');
scatter(y00(1:N),y00(N+1:2*N),[],y00(2*N+1:end),'filled');
box on;
obj = colorbar;
obj.TickLabelInterpreter = 'latex';
obj.XTickLabel = {'$0$','$\frac{\pi}{4}$','$\frac{\pi}{2}$','$\frac{3\pi}{4}$','$\pi$','$\frac{5\pi}{4}$','$\frac{3\pi}{2}$','$\frac{7\pi}{4}$','$2\pi$'};
obj.XTick = 0:pi/4:2*pi;
obj.FontSize = 13;
caxis([0 2*pi]);
daspect([1 1 1]); 
xlim([-1 1]);
ylim([-1 1]);
xlabel('x');
ylabel('y');

%% Change in radius 
dist = zeros(1,timeSteps+1);
for i = 1:timeSteps+1
    pos = reshape(y_full(i,:),[],3);
    pos(end,:) = [];
    dist(i) = mean(vecnorm(pos(:,1:2),2,2));
end
figure 
plot(1:timeSteps+1,dist,'LineWidth',1.5);
axis tight
grid on;
xlabel('Time');
ylabel('Average radius of circular arrangment');