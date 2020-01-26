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

index = phaseSeperation(y_full(end,:));
[centroid,pos] = centroidCal(y_full(end,:),index);

% minx = min(min(y_full(:,1:N)));
% maxx = max(max(y_full(:,1:N)));
% miny = min(min(y_full(:,N+1:2*N)));
% maxy = max(max(y_full(:,N+1:2*N)));

%%
% figure
% colormap('hsv');
% scatter(y_full(end,1:N),y_full(end,N+1:2*N),[],y_full(end,2*N+1:end),'.'),colorbar;
% caxis([0 2*pi]);
% xlim([minx maxx]);
% ylim([miny maxy]);
% daspect([1 1 1]); 
% hold on;
% plot(centroid(:,1),centroid(:,2),'kx');

%%
% Calculate mid point
mid = mean(centroid);
y_steady = reshape(y_full(end,:),[],3);

% new points
bodiesMiddle = 10:1:30;
for i = 1:length(bodiesMiddle)
    n = bodiesMiddle(i);
    pos = pointsInC(mid(1),mid(2),0.4,n);
    midPhase = mean(y_steady(:,3));
    y_mid = [pos,repmat(midPhase,n,1)];
    y_sim = [y_steady;y_mid];
    N_dy = N + n;
    y_sim = reshape(y_sim,1,[]);

    %%
    % Solve the new system
    timeSteps = 1000;
    [~,y_dy] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y_sim,    options, dim,N_dy,zeros(1,N_dy),K,J,gamma1,gamma2);

    %%
    y_dy(:,dim*N_dy + 1:end) = mod(y_dy(:,dim*N_dy + 1:end),2*pi);
    minx = min(min(y_dy(:,1:N_dy)));
    maxx = max(max(y_dy(:,1:N_dy)));
    miny = min(min(y_dy(:,N_dy+1:2*N_dy)));
    maxy = max(max(y_dy(:,N_dy+1:2*N_dy)));

    % Making files 
    system(sprintf(' mkdir -p threeClusterSims/n_%i',n));
    f = figure('visible','off');
    %figure
    for j = 1:timeSteps+1
        colormap('hsv');
        scatter(y_dy(j,1:N_dy),y_dy(j,N_dy+1:2*N_dy),[],y_dy(j,2*N_dy+1:end)),colorbar;
        caxis([0 2*pi]);
        xlim([minx maxx]);
        ylim([miny maxy]);
        daspect([1 1 1]); 
        pause(0.01)
        file1 = sprintf('threeClusterSims/n_%i/fig_%5i.png',n,j);
        saveas(f,file1);
    end
    save(sprintf('threeClusterSims/n_%i/matlabVar.mat',n));
end

