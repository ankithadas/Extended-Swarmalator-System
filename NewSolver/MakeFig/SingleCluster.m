clear
clc

fileName = 'gamma1_-1_gamma2_0_N_100_K_-0.5_J_0.8.mat';
ti = 'Single cluster';

fig = makeFig(fileName,ti);

fig.Visible = 'On';

fileName2 = 'gamma1_0.67_gamma2_-0.33_N_400_K_-0.5_J_0.8.mat';
ti = 'Two Clusters with rogues';

fig2 = makeFig(fileName2,ti);
fig2.Visible = 'On';

fileName3 = 'gamma1_0.67_gamma2_-0.33_N_100_K_-0.5_J_0.8.mat';
ti = 'Two Clusters with rogues';

fig3 = makeFig(fileName3,ti);
fig3.Visible = 'On';