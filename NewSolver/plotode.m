function status = plotode(~,y,flag,varargin)
    persistent TARGET_FIGURE TARGET_AXES N
    status = 0;
    m = size(y,2);
    if nargin < 3 || isempty(flag)
        flag = '';
    elseif isstring(flag) && isscalar(flag)
        flag = char(flag);
    end
    switch(flag)
    case ''
        ud = get(TARGET_FIGURE,'UserData');
        minx = min(y(1:N,:),[],'all');
        maxx = max(y(1:N,:),[],'all');
        miny = min(y(N+1:2*N,:),[],'all');
        maxy = max(y(N+1:2*N,:),[],'all');
        if ud.axesData(1,1) > minx
            ud.axesData(1,1) = minx;
        end
        if ud.axesData(1,2) < maxx
            ud.axesData(1,2) = maxx;
        end
        if ud.axesData(2,1) > miny
            ud.axesData(2,1) = miny;
        end
        if ud.axesData(2,2) < maxy
            ud.axesData(2,2) = maxy;
        end
%         set(TARGET_AXES,'XLim',ud.axesData(1,:));
%         set(TARGET_AXES,'YLim',ud.axesData(2,:));
        %TARGET_AXES.XLimMode = 'manual';
        %TARGET_AXES.YLimMode = 'manual';
        TARGET_AXES.XLim = ud.axesData(1,:);
        TARGET_AXES.YLim = ud.axesData(2,:);
        %TARGET_AXES.NextPlot = 'add';
        set(TARGET_FIGURE,'UserData',ud);
        %gammaVar = get(SliderH,'Value');
        %TextH.String = num2str(gammaVar);
        if ud.stop == 1
            status = 1;
        end
        if m~= 1
            for k = 1:m
                ud.ScatterPoints.XData = y(1:N,k);
                ud.ScatterPoints.YData = y(N+1:2*N,k);
                ud.ScatterPoints.CData = mod(y(2*N+1:end,k),2*pi);
                drawnow limitrate
            end
        else
            ud.ScatterPoints.XData = y(1:N,1);
            ud.ScatterPoints.YData = y(N+1:2*N,1);
            ud.ScatterPoints.CData = mod(y(2*N+1:end,1),2*pi);
            drawnow limitrate
        end
        
    case 'init'
        appData = varargin{end};
        TARGET_FIGURE = appData.UIFigure;
        TARGET_AXES = appData.UIAxes;
        ud = get(TARGET_FIGURE,'UserData');
        TARGET_AXES.Colormap = hsv;
        N = length(y(:,1))/3;
        if ~isfield(ud,'ScatterPoints')
            ud.ScatterPoints = scatter(TARGET_AXES,y(1:N,1),y(N+1:2*N,1),[],y(2*N+1:end,1));
            colorbar(TARGET_AXES)
        else
            ud.ScatterPoints.XData = y(1:N,1);
            ud.ScatterPoints.YData = y(N+1:2*N,1);
            ud.ScatterPoints.CData = mod(y(2*N+1:end,1),2*pi);
        end
        if ~isfield(ud,'figStart')
            set(TARGET_AXES,'DataAspectRatio',[1 1 1]);
            set(TARGET_FIGURE,'Colormap',hsv);
            set(TARGET_AXES,'CLim',[0 2*pi]);
            set(TARGET_AXES,'Box','on');
            colorbar(TARGET_AXES);
            ud.figStart = 1;
            %appData.gamma1Slider.Value = appData.gamma1;
        end
        if ~isfield(ud,'axesData')
            ud.axesData = zeros(2,2);
        end
        ud.stop = 0;
        set(TARGET_FIGURE,'UserData',ud);
        drawnow update
          
    case 'done'
        
    end
end