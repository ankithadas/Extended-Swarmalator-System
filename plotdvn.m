clear;
clc;
% utter failure

d1 = load('K_-0.4.mat');
d2 = load('K_-0.5.mat');
d3 = load('K_-0.6.mat');


j = d1.d(:,2);
r = 1./(1-j);

%%
figure;
semilogy(j,d1.d(:,1),'bx',j,d2.d(:,1),'go',j,d3.d(:,1),'r^','MarkerSize',10);
hold on
semilogy(j,r,'-k')
legend('K = -0.4','K = -0.5','K = -0.6','Theoretical','location','northwest');
ylabel('Log(r)');
xlabel('J');
grid on;

figure;
plot(j,d1.d(:,1),'bx',j,d2.d(:,1),'go',j,d3.d(:,1),'r^','MarkerSize',10);
hold on
plot(j,r,'-k')
legend('K = -0.4','K = -0.5','K = -0.6','Theoretical','location','northwest');
ylabel('r');
xlabel('J');
grid on;