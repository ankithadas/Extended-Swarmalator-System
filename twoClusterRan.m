%{
Objective: Generate 2 clusters at a fixed dis apart with some radius and with phase Pi apart. Find the intercluster dis as N varies.

Additional Objective: Add rogues in the middle and see if they settle to a position. Also check if stable 3 cluster is possible. 
%}

clear;
clc;


reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init, 2);



% Constants
N = 200;   % Can be varied  % Currently must be even
d = zeros(2,N/2);
timeSteps = 200;
stepSize = 1;
%iN = [6,10,20,50,60,70,80,90,100,120,150,180,200,250,300,350,400,450,500,550,600,650,700,750,800];
% iN = [100];
%%
dirc = ['FinalStatesR\\N_',num2str(N),'T_',num2str(timeSteps),'\\'];
status = system(['mkdir ',dirc]);
%%
parfor i = 2:N/2
    options = odeset('RelTol',1e-6,'AbsTol',1e-6);
    K = -0.5;
    J = 0.8;
    gamma1 = 2/3;
    gamma2 = -1/3;
    dim = 2;
    % Generate random points in a circle with center (a,b) of radius r
    %%%%

    % Possibly get input from user for N, centers, and number of bodies in each cluster
    n1 = i;          %% Change this if it can be any number 
    n2 = N-i;

    pos1 = pointsInC(0,0,1,n1);  
    pos2 = pointsInC(7,0,1,n2);

    phase1 = zeros(n1,1);
    phase2 = pi*ones(n2,1);

    pos = [[pos1;pos2],[phase1;phase2]];

    % % checking 
    % pos = [pos1;pos2];
    % figure 
    % plot(pos(:,1),pos(:,2),'.');
    % daspect([1 1 1]); 
    % % Test passed
    

    y00 = reshape(pos,1,[]); 

    
    

    % Solve ODE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [~,y_full] = ode45(@swarmalator_matrixform,[0:stepSize:timeSteps*stepSize],y00,options, dim,N,zeros(1,N),K,J,gamma1,gamma2);
    %y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);

    minx = min(min(y_full(:,1:N)));
    maxx = max(max(y_full(:,1:N)));
    miny = min(min(y_full(:,N+1:2*N)));
    maxy = max(max(y_full(:,N+1:2*N)));
    %f = figure('visible','off');
    %figure(2);
    %%

    % for i=1:timeSteps+1
    %     colormap('hsv');
    %     scatter(y_full(i,1:N),y_full(i,N+1:2*N),[],y_full(i,2*N+1:end),'.'),colorbar;
    %     caxis([0 2*pi]);
    %     xlim([minx maxx]);
    %     ylim([miny maxy]);
    %     daspect([1 1 1]); 
    %     pause(0.01) 
    %     %waitforbuttonpress;
    % %      file2 = sprintf    ('videos\\swarmalator_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g\\fig_%05i.png',distro,N,K,J,gamma1, gamma2,i);
    % %     saveas(f,file2);
    % end

    %%
    % file1 = sprintf('twoClusterN_%i_K_%g_J_%g_g1_%.2g_g2_%.2g.mat',N,K,J,gamma1,gamma2);
    % save(file1,'y_full','N');
    index = phaseSeparation(y_full(end,:));
    [C,pos] = centroidCal(y_full(end,:),index);

    % figure
    % gscatter(y_full(end,1:N),y_full(end,N+1:2*N),index,'bgmk');
    % hold on 
    % plot(C(:,1),C(:,2),'kx');
    % daspect([1 1 1]);
    
    dis = norm(diff(C));

    fprintf('The distance between the clusters is %.5f\n',dis);
    d(:,i) = [dis;n1];
    
    %%
    file2 = sprintf('FinalStatesR\\N_%iT_%i\\twoClusterRan_n1_%i_n2_%i.png',N,timeSteps,n1,n2);
    f = figure('visible','off');
    colormap('hsv');
    scatter(y_full(end,1:N),y_full(end,N+1:2*N),[],y_full(end,2*N+1:end),'.'),colorbar;
    caxis([0 2*pi]);
    xlim([minx maxx]);
    ylim([miny maxy]);
    daspect([1 1 1]); 
    hold on;
    plot(C(:,1),C(:,2),'kx');
    saveas(f,file2);
end

%%
save(sprintf('FinalStatesR\\N_%iT_%i\\d.mat',N,timeSteps),'d');

%%
d(:,~all(d)) = [];
figure 
plot(2:N/2,d(1,1:N/2-1),'s--');
%xlim([5,800]);
ylim([min(d(1,:)) max(d(1,:))]);
text = sprintf("Distance between the clusters Vs N =%i:T=%i",N,timeSteps);
title(text);
xlabel("Number of swarmalators");
ylabel("Distance between clusters");
saveas(gcf,strcat(dirc,'DistVSN.png'));
saveas(gcf,strcat(dirc,'DistVSN'),'epsc');
%%

csvwrite(strcat(dirc,'distanceArray.txt'),d);
%%
save(strcat(dirc,'twoClusterSim.mat'));

