function f = makeFig(fileName,ti)
%MAKEFIG Summary of this function goes here
%   Detailed explanation goes here
    load(fileName,'data');
    N = data.N;
    x = data.yData(1:N);
    y = data.yData(N+1:2*N);
    c = data.yData(2*N+1:end);

    f = figure('Visible','off');
    colormap(hsv(256));
    scatter(x,y,[],c,'filled');
    title(ti);
    box on
    caxis([0 2*pi]);
    daspect([1 1 1]);
    xlabel('x');
    ylabel('y');

%obj = colorbar('XTickLabel',{'0','\pi/4','\pi/2','3\pi/4','\pi','5\pi/4','3\pi/2','7\pi/4','2\pi'},'XTick',0:pi/4:2*pi);
    obj = colorbar;
    obj.TickLabelInterpreter = 'latex';
    obj.XTickLabel = {'$0$','$\frac{\pi}{4}$','$\frac{\pi}{2}$','$\frac{3\pi}{4}$','$\pi$','$\frac{5\pi}{4}$','$\frac{3\pi}{2}$','$\frac{7\pi}{4}$','$2\pi$'};
    obj.XTick = 0:pi/4:2*pi;
    obj.FontSize = 13;
end

