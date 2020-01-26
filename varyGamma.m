% This script varies gamma1 and gamma2 values and sees how the simulation changes

clear;
clc;

% Setting random numbers for consistent results
reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init, 2);

load('DataFiles\\swarmalator_identical_N_100_K_-0.5_J_0.8_g1_0.67_g2_-0.33.mat');
clear ans

% Redfine variables for code readability
N = 100;
J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;