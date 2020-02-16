
figure
colormap(hsv(256));
c = 200;
scatter(y_dy(end-c,1:N_dy),y_dy(end-c,N_dy+1:2*N_dy),...
    [],y_dy(end-c,2*N_dy+1:end),'filled');
caxis([0 2*pi]);
daspect([1 1 1]);
xlabel('x');
ylabel('y');
box on
obj = colorbar;
obj.TickLabelInterpreter = 'latex';
obj.XTickLabel = {'$0$','$\frac{\pi}{4}$','$\frac{\pi}{2}$','$\frac{3\pi}{4}$','$\pi$','$\frac{5\pi}{4}$','$\frac{3\pi}{2}$','$\frac{7\pi}{4}$','$2\pi$'};
obj.XTick = 0:pi/4:2*pi;
obj.FontSize = 13;