clear
clc
close all;
reset(RandStream.getGlobalStream,1);
rand_init = 76599;
randn(rand_init,2);
N = 100;
J = 0.8;
K = -0.5;
gamma1 = 2/3;
gamma2 = -1/3;
dim = 2;
stepSize = 1;
timeSteps =1000;
y00 = rand((dim+1)*N,1);
y00(dim*N + 1:end) = 2*pi*y00(dim*N + 1:end);
%%
options = odeset('RelTol',1e-6,'AbsTol',1e-6,'OutputFcn',@odePlotter2);
tic
fig = figure(1);
ax = axes;
ax.XLim = [-5 5];
ax.YLim = [-5 5];
daspect([1 1 1]);
box on
tStart = 0;
tEnd = timeSteps;
ud = get(fig,'UserData');
ud.gamma1 = gamma1;
ud.gamma2 = gamma2;
set(fig,'UserData',ud);
while tStart < tEnd
    [T,y_full] = ode45(@swarmalator_matrixform, [tStart:stepSize/5:tEnd], y00,options, dim, N, zeros(1,N), K, J, gamma1, gamma2);
    tStart = T(end);
    data = get(fig,'UserData');
    gamma1 = data.gamma1;
    y00 = y_full(end,:);
    if length(T) > 4
        options = odeset(options,'InitialStep',T(end) - T(end-4),'MaxStep',T(end)-T(1));
    end
end
odePlotter2([],[],'done');
toc

% maybe add more inputs using varargin