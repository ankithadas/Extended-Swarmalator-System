clear
clc
close all;

Opt = odeset('Events',@eventFunction);
global k;
t0 = 0;
tEnd = 10;
y0 = [0,0];
m = 5;
k = 40;

cr = 2*sqrt(k*m);
c = cr - 5;

figure(1)
while t0 < tEnd
    funHandle = @(t,y) rhs(t,y,c,m);
    [time,pos] = ode45(funHandle,[t0,tEnd],y0,Opt);
    plot(time,pos);
    t0 = time(end);
    y0 = pos(end,:);
    c = c + 0.05;
end
