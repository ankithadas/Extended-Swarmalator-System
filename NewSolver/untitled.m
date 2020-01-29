function untitled
FigH = figure('position',[360 500 500 500]);
axes('XLim', [0 4*pi], 'units','pixels', ...
     'position',[100 100 300 300], 'NextPlot', 'add');
x     = linspace(0, 4*pi, 400);
y     = sin(x);
LineH = plot(x,y);
TextH = uicontrol('style','text','position',[220 50 40 15]);
SliderH = uicontrol('style','slider','position',[100 20 300 20],'min', 0, 'max', 4*pi);
addlistener(SliderH, 'Value', 'PostSet', @callbackfn);
movegui(FigH, 'center')
    function callbackfn(source, eventdata)
    num          = get(eventdata.AffectedObject, 'Value');
    LineH.YData  = sin(num * x);
    TextH.String = num2str(num);
    end
  end