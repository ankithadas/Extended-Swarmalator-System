
clear;
clc;
close all;

%% Native Frequencies 

global N;
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
%% Constants

options = odeset('RelTol',1e-6,'AbsTol',1e-6);
dim = 2;
na = 100;
%na = 10000;
dts = 1;

na_trans = 5000;
time = dts*(1:1:na);

K = -0.5;
J = 0.8;
gamma1 = 0.67;
gamma2 = -0.33;

bodies = Swarmalator(1,N);
%%

positions = num2cell(rand(2,N),1);
[bodies.position] = positions{:};
velocity = num2cell(rand(2,N),1);
[bodies.velocity] = velocity{:};
phase = num2cell(omega);
[bodies.phase] = phase{:};