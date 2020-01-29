% This script varies gamma1 and gamma2 values and sees how the simulation changes

clear;
clc;
close all;

% Setting random numbers for consistent results
reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init, 2);

load('DataFiles\\swarmalator_identical_N_100_K_-0.5_J_0.8_g1_0.67_g2_-0.33.mat','y_full','options');
clear ans

% Redefine variables for code readability
N = 100;
J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;
timeSteps = 100;
stepSize = 1;
y00 = y_full(end,:);
clear y_full

n = 5;
xp = linspace(0,1,n)';
xm = linspace(-1,0,n)';
y1 = 1 - xp;
y2 = flipud(xp) - 1;
y3 = -1 - flipud(xm);
y4 = 1 + xm;
points = unique([[xp,y1];[flipud(xp),y2];[flipud(xm),y3];[xm,y4]],'stable','row');

% l = [false ;(points(2:end,1) == points(1:end-1,1) & points(2:end,2) == points(1:end-1,2))];
% points = points(~l,:);
% points(end,:) = [];
figure
plot(points(:,1),points(:,2));

%Loop through gamma1 gamma2 pairs 

for i = 1:size(points,1)
    gamma1 = points(i,1);
    gamma2 = points(i,2);

    % Solve the new system for 100 timeSteps 
    [~,y_full] = ode45(@swarmalator_matrixform, [0:stepSize:timeSteps*stepSize], y00, options, dim, N, zeros(1,N), K, J, gamma1, gamma2);
    y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);

    minx = min(min(y_full(:,1:N)));
    maxx = max(max(y_full(:,1:N)));
    miny = min(min(y_full(:,N+1:2*N)));
    maxy = max(max(y_full(:,N+1:2*N)));
    
    f = figure(1);
    file1 = sprintf('g1_%d_g2_%d',gamma1,gamma2);
    v = VideoWriter(file1,'Motion JPEG AVI');
    v.Quality = 80;
    v.FrameRate = 15;
    open(v);
    for k=1:timeSteps+1
        colormap('hsv');
        scatter(y_full(k,1:N),y_full(k,N+1:2*N),[],y_full(k,2*N+1:end)),colorbar;
        caxis([0 2*pi]);
        xlim([minx maxx]);
        ylim([miny maxy]);
        daspect([1 1 1]); 
        writeVideo(v,getframe(gcf));
        pause(0.05) 
        %waitforbuttonpress;
        %file2 = sprintf('videos\\swarmalator_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g\\fig_%05i.png',distro,N,K,J,gamma1,gamma2,i);
        %saveas(f,file2);
    end
    close(v)
    close(f)
end