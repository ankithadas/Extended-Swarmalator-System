% nohup nice -15 matlab -nodisplay < file.m > log.txt 2> err.txt &                 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Solves the full Kuramoto system and determines the drift of the mean phase
%% 
%%

clear;
clc;

%% Set up the matlabpool
% num_cores = 4; % How many CPU cores to use (set to 1 to disable parallelism, set to 0 to use matlab's default)
% 
% if isempty(gcp('nocreate'))
%     poolobj = gcp('nocreate');
%     delete(poolobj);
% end
% 
% % Now open the pool
% if num_cores == 0
%     parpool;
% elseif num_cores ~= 1
%     parpool('local',num_cores);
% end

%% Set the random seed (so we get reproducible results)
reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init,2);  %% Discouraged syntax for randn 
clear rand_init
%% Native frequencies 

N = 100;

SWITCH_GAP = 8;
% No gap: uniformly deterministic
if(SWITCH_GAP == 0)
    a = 1;
    i_vec = cumsum(ones(1,N));
    argument = 2*(i_vec-(N+1)/2)/(N-1);
    omega = argument.^a;
end
% No gap: uniformly random
if(SWITCH_GAP == 1)
    omega = -1 + 2*rand(1,N);
    omega = sort(omega);
end
% No gap: normally distributed
if(SWITCH_GAP == 2)
    sigma_omega = sqrt(0.1);
    omega = sigma_omega*randn(1,N);
    omega = sort(omega);
end
% No gap: normally equiprobable distributed
if(SWITCH_GAP == 3)
    distro = 'Gaussian';
    dN = 1/(N+1);
    i_vec = dN:dN:1-dN;
    sigma_omega = sqrt(0.02);
    omega = icdf('Normal',i_vec,0,sigma_omega);
    fprintf('Gaussian distribution used\n');
end
% No gap: Bimodal distribution
if(SWITCH_GAP == 4)
    sigma2 = 0.5;
    sig4 = 1/(4*sigma2);
    normi = 0.5*exp(sig4)*pi*(besseli(-0.25,sig4)+besseli(0.25,sig4));
    %V = x.^4/4-x.^2/2;
    %rho = exp(-2*V/sigma2)/normi;

    omega = rand_generator(...
                 @(x) exp(-2*(x.^4/4-x.^2/2)/sigma2)/normi,...
                 -10,10,100000,'slow');
    omega = sort(omega);
end
% Bimodal distribution: 2 Gaussians
if(SWITCH_GAP == 5)
    sigma2 = sqrt(0.1);
    omega1 = sigma2*randn(1,N)-0.5;
    omega2 = sigma2*randn(1,N)+0.5;
    rand_k = rand(1,N);
    r1 = find(rand_k<0.5);
    r2 = find(rand_k>=0.5);
    omega = zeros(1,N);
    omega(r1) = omega1(r1);
    omega(r2) = omega2(r2);
    omega = sort(omega);
end
% Bimodal distribution: 2 Gaussians equiprobable
if(SWITCH_GAP == 6)
    sigma2 = sqrt(0.1);
    Lo = 0.75;
    %Lo = 1.0;
    %Lo = 0.5;
    cdf_bimodal = @(x) ...
                 ((1+erf((Lo+x)/(sqrt(2)*sigma2))+erfc((Lo-x)/(sqrt(2)*sigma2)))/4);
    u0 = cumsum(ones(1,N))/N;
    omg = zeros(1,N);
    omega = fsolve(@(om)(cdf_bimodal(om)-u0),omg);
    omega = sort(omega);
end
% 4 frequencies
if(SWITCH_GAP == 7)
    omega(1:N/4) = -1;
    omega(N/4+1:N/2) = -1/3;
    omega(N/2+1:3*N/4) = 1/3;
    omega(3*N/4+1:N) = 1;
end
% identical
if(SWITCH_GAP == 8)
    distro = 'identical';
    omega = zeros(1,N);
    fprintf('Identically distributed oscillators\n');
end

%% Loop over coupling strengths K
tic
options = odeset('RelTol',1e-6,'AbsTol',1e-6,'Stats','on');
dim = 2;
na = 100;
%na = 10000;
dts = 1;

na_trans = 5000;
time = dts*(1:1:na);

K = -0.5;
J = 0.8;
gamma1 = 2/3;
gamma2 = -1/3;

y00 = rand((dim+1)*N,1);

y00(dim*N + 1:end) = 2*pi*y00(dim*N + 1:end);

[~,y_full] = ode45(@swarmalator_matrixform, [0:dts:na*dts], y00, options, dim, N, omega, K, J, gamma1, gamma2); % replaced T with ~
%y_full(:,dim*N + 1:end) = mod(y_full(:,dim*N + 1:end),2*pi);
ch = toc
%%
% minx = min(min(y_full(:,1:N)));
% maxx = max(max(y_full(:,1:N)));
% miny = min(min(y_full(:,N+1:2*N)));
% maxy = max(max(y_full(:,N+1:2*N)));
% i=501;
% figure(1)
% for i=1:na+1
%     
%     colormap('hsv');
%     scatter(y_full(i,1:N),y_full(i,N+1:2*N),[],y_full(i,2*N+1:end))
%     caxis([0 2*pi]);
%     xlim([minx maxx]);
%     ylim([miny maxy]);
%     daspect([1 1 1]);  
%     w=waitforbuttonpress;
% end

%%
% 
% file1 = sprintf('swarmalator_%s_N_%i_K_%g_J_%g_g1_%.2g_g2_%.2g.mat',distro,N,K,J,gamma1,gamma2);
% 
% save(file1);

%
% dir = sprintf('videos\\swarmalator_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g',distro,N,K,J,gamma1,gamma2);
% 
% status = system(['mkdir ',dir]);

minx = min(y_full(:,1:N),[],'all');
maxx = max(y_full(:,1:N),[],'all');
miny = min(y_full(:,N+1:2*N),[],'all');
maxy = max(y_full(:,N+1:2*N),[],'all');
%f = figure('visible','off');
figure(2);
colormap(hsv(256));
ax = axes;
ax.XLim = [minx-0.5 maxx+0.5];
ax.YLim = [miny-0.5 maxy+0.5];
ax.NextPlot = 'add';
plot1 = scatter(y_full(1,1:N),y_full(1,N+1:2*N),[],y_full(1,2*N+1:end),'filled');
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
for i=2:na+1
    plot1.XData = y_full(i,1:N);
    plot1.YData = y_full(i,N+1:2*N);
    plot1.CData = y_full(i,2*N + 1:end);
    %drawnow update
    pause(0.05);
    %waitforbuttonpress;
    % file2 = sprintf('J_1.2\\fig_%05i.png',i);
    % saveas(f,file2);
end
 

% %%
% figure(3)
% hobj = histogram(y_full(end,2*N+1:end),50);
% bins = [];
% edges = linspace(min(y_full(end,2*N+1:end)), max(y_full(end,2*N+1:end)), 15);
% for i = 1:numel(edges)-1
%     if i == 1
%         data = find(y_full(end,2*N+1:end) >= edges(i) & y_full(end,2*N+1:end) <= edges(i+1));
%     else
%         data = find(y_full(end,2*N+1:end) > edges(i) & y_full(end,2*N+1:end) <= edges(i+1));
%     end
%     if ~isempty(data)
%         bins = [bins ;[ mean(y_full(end,2*N + data)),numel(data),min(y_full(end,2*N + data)),max(y_full(end,2*N + data))]];
%     end
% end
% bins = sortrows(bins,1,'ascend');
% diffMeans = diff(bins(:,1));
% for i = 1:length(diffMeans)
%     if diffMeans(i) < 0.15
%         % Correct the new mean of the phase 
%         bins(i,1) = (bins(i,1)*bins(i,2) + bins(i+1,1)*bins(i+1,2))/(bins(i,2) + bins(i+1,2));
%         % Change the number of particles in the bin
%         bins(i,2) = bins(i,2) + bins(i+1,2);
%         % Change the min and max of bins
%         bins(i,3) = min(bins(i:i+1,3));  %% Is this necessary ?
%         bins(i,4) = max(bins(i:i+1,4));
%         bins(i+1,1) = nan;
%     end
% end
% bins(any(isnan(bins),2),:) = [];
% bins = sortrows(bins,2,'descend');
% clusterPhDiff = abs(bins(1,1) - bins(2,1));
% fprintf('%f is the phase difference of the clusters\n',clusterPhDiff);
% fprintf('%d is the abs diff with pi =  %.4f\n', abs(pi - clusterPhDiff),pi);
% indexPh = zeros(1,length(y_full(end,2*N+1:end)));
% for i = 1:size(bins,1)
%     ind = find(y_full(end,2*N+1:end) >= bins(i,3) & y_full(end,2*N+1:end) <= bins(i,4));
%     indexPh(ind) = i;
% end
% figure(4)
% plot(y_full(end,2*N+1:end),1:N,'kx');
% hold on 

%%
[index,bins] = phaseSeparation(y_full(end,:));
figure(3)
gscatter(y_full(end,1:N),y_full(end,N+1:2*N),index,'bgmk');
[C,P] = centroidCal(y_full(end,:),index);
hold on
plot(C(:,1),C(:,2),'kx');


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%
% %setenv('PATH', [getenv('PATH') '/Users/lachlans/build:/Users/lachlans/bin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/opt/X11/bin']);
% %file3 = sprintf('swarmalator_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g.mp4',distro,N,K,J,gamma1,gamma2);
% %status = system(['cp videos/convert2video.sh ',dir]);
% %status = system(['cd ',dir,' && ./convert2video.sh && mv video.mp4 ',file3,' && cp ',file3,' ../',file3,' && cd ..']);
% % status = system('./convert2video.sh');
% % status = system(['mv video.mp4 ',file3]);
% % status = system(['cp ',file3,' ../',file3]);
% % status = system('cd ..');
% %% Stable state: Average all trasient state phase

% y_stable = y_full(end,:);

% figure(5)
% colormap('hsv');
% scatter(y_stable(1:N),y_stable(N+1:2*N),[],y_stable(2*N+1:end)),colorbar;
% caxis([0 2*pi]);
% xlim([minx maxx]);
% ylim([miny maxy]);
% daspect([1 1 1]);

% phase_index1 = find((abs(y_stable(2*N+1:end) - bins(1,1)) <= 0.1));
% phase_index2 = find((abs(y_stable(2*N+1:end)-bins(2,1)) <= 0.1));
% phase_rogue = setdiff(1:N,[phase_index1,phase_index2]);
% avgPhase = (bins(1,1)*bins(1,2) + bins(2,1)*bins(2,2))/sum(bins(1:2,2));
% ph = y_stable(2*N + 1:end);
% %avgPhase = mean(ph(phase_rogue));

% y_stable(2*N + phase_rogue) = avgPhase;

% %y_stable(2*N+1:end) = avgPhase;

% figure(6)
% colormap('hsv');
% scatter(y_stable(1:N),y_stable(N+1:2*N),[],y_stable(2*N+1:end)),colorbar;
% caxis([0 2*pi]);
% xlim([minx maxx]);
% ylim([miny maxy]);
% daspect([1 1 1]);

% %%
% [T,y_Stablefull] = ode45(@swarmalator_matrixform, [0:dts:100], y_stable, options, dim, N, omega, K, J, gamma1, gamma2);


% %%
% figure(7)

% for i=1:numel(T)
%     colormap('hsv');
%     scatter(y_Stablefull(i,1:N),y_Stablefull(i,N+1:2*N),[],y_Stablefull(i,2*N+1:end)),colorbar;
%     caxis([0 2*pi]);
%     %xlim([-2.5 4]);
%     %ylim([-1 2]);
%     axis tight
%     daspect([1 1 1]); 
%     pause(0.01) 
%     %waitforbuttonpress;
%     %file2 = sprintf('videos\\swarmalator_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g\\fig_%05i.png',distro,N,K,J,gamma1,gamma2,i);
%     %saveas(f,file2);
% end
% hold on
% %%
% % file1 = sprintf('swarmalatorStable_%s_N_%i_K_%g_J_%g_g1_%g_g2_%g.mat',distro,N,K,J,gamma1,gamma2);
% % save(file1);

% %% calculates avergve distance between swarmalators
% [avgSwarmDistance, stdSwarm] = averageDistance(y_Stablefull(end,[phase_index2, N + phase_index2]),numel(phase_index2));
% fprintf('The average distance between the swarmalators is %d and std = %d\n', avgSwarmDistance, stdSwarm);

% %%


%% Find phase variation with time 
figure;
ax = axes;
for i = 1:N
    plot(1:(na + 1),y_full(:,2*N + i));
    xlim([1,inf]);
    %ylim([0 2*pi]);
    hold on
end
ax.TickLabelInterpreter = 'latex';
ax.YTickLabel = {'$0$','$\frac{\pi}{2}$','$\pi$','$\frac{3\pi}{2}$','$2\pi$','$\frac{5\pi}{2}$'};
ax.YTick = 0:pi/2:5*pi/2;
ax.FontSize = 12;
xlabel('Time');
ylabel('Phase \theta_i');
phDiff = diff(bins(:,1))
absDiff = abs(pi - phDiff)
addData = zeros(size(bins));
for i = 500:na+1
    [index,bins] = phaseSeparation(y_full(i,:));
    addData = addData + bins;
end
addData = addData/(length(500:na+1));

