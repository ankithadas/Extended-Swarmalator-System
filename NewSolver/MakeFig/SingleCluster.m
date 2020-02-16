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

fileName4 = 'gamma1_-1_gamma2_0.71_N_100_K_-0.5_J_0.8.mat';
ti = 'Active Single Cluster';

fig4 = makeFig(fileName4,ti);
fig4.Visible = 'On';

fileName5 = 'gamma1_0.67_gamma2_-0.5_N_100_K_-0.5_J_0.8.mat';
ti = '';

fig5 = makeFig(fileName5,ti);
fig5.Visible = 'On';