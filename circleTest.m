% Test if a circular arrangment of swarmalators is stable. 

%%%%% Conlcusion: It is in an unstable equilibrium position where the distance between the clusters exponentially increases until the clusters are seperate. The instability increases with more number of particles both in the center and outside.


clear;
clc;
close all;


J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;
stepSize = 1;
timeSteps = 100;
reset(RandStream.getGlobalStream,1);
n = 8;
r = 1;
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
[~,y_full] = ode113(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00, options, dim,N,zeros(1,N),K,J,gamma1,gamma2);

minx = min(min(y_full(:,1:N)));
maxx = max(max(y_full(:,1:N)));
miny = min(min(y_full(:,N+1:2*N)));
maxy = max(max(y_full(:,N+1:2*N)));
d = zeros(timeSteps+1,1);
figure
for i=1:timeSteps+1
    colormap('hsv');
    scatter(y_full(i,1:N),y_full(i,N+1:2*N),[],y_full(i,2*N+1:end)),colorbar;
    caxis([0 2*pi]);
    xlim([minx maxx]);
    ylim([miny maxy]);
    daspect([1 1 1]); 
    % hold on
    index = phaseSeperation(y_full(i,:));
    [C,~] = centroidCal(y_full(i,:),index);
    dis = norm(diff(C));
    d(i) = dis;
    % plot(C(:,1),C(:,2),'kx');
    pause(0.01) 
    % hold off
    % drawnow
    %waitforbuttonpress;
%      file2 = sprintf('videos\\swarmalator_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g\\fig_%05i.png',distro,N,K,J,gamma1,gamma2,i);
%     saveas(f,file2);
end


index = phaseSeperation(y_full(end,:));
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
