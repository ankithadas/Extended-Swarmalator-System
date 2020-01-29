function status = odePlotter2(~,y,flag,varargin)
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
        % Check if TARGET_FIGURE and TARGET_AXES is there
        if isempty(TARGET_FIGURE) || isempty(TARGET_AXES)
            error(message('odePlotter not called with Init'));
        elseif ishghandle(TARGET_FIGURE) && ishghandle(TARGET_AXES)
            try
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
                set(TARGET_AXES,'XLim',ud.axesData(1,:));
                set(TARGET_AXES,'YLim',ud.axesData(2,:));
                
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
                        %pause(0.005);
                        %etime(clock,ud.time)
                        if etime(clock,ud.time) < 0.005
                            %pause(0.01);
                            drawnow limitrate;
                        else
                            ud.time = clock;
                            set(TARGET_FIGURE,'UserData',ud);
                        end
                        drawnow limitrate
                    end
                else
                    %etime(clock,ud.time)
                    if etime(clock,ud.time) < 0.005
                        %pause(0.01);
                        drawnow limitrate;
                    else
                        ud.time = clock;
                        set(TARGET_FIGURE,'UserData',ud);
                    end
                    ud.ScatterPoints.XData = y(1:N,1);
                    ud.ScatterPoints.YData = y(N+1:2*N,1);
                    ud.ScatterPoints.CData = mod(y(2*N+1:end,1),2*pi);
                    drawnow limitrate
                end
            catch ME 
                error(message('ErrorUpdatingWindow',ME.message));               
 
            end
        end
    case 'init'
        f = figure(gcf);
        TARGET_FIGURE = f;
        TARGET_AXES = gca;
        ud = get(f,'UserData');
        colormap('hsv');
        N = length(y(:,1))/3;
        if ~isfield(ud,'ScatterPoints')
            ud.ScatterPoints = scatter(y(1:N,1),y(N+1:2*N,1),[],y(2*N+1:end,1));
            %colorbar;
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
            colorbar;
            TextH = uicontrol('style','text','position',[220 50 40 15]);
            SliderH = uicontrol('style','slider','position',[100 20 300 20],'min',  0, 'max', 2);
            set(SliderH,'Value',ud.gamma1);
            addlistener(SliderH, 'Value', 'PostSet', @callbackfn);
            ud.figStart = 1;
        end
        %gamma1 = get(SliderH,'Value');
        %set(SilderH,'Value',gamma1);
        TextH.String = num2str(ud.gamma1);
        ud.time = clock;
        ud.stop = 0;
        if ~isfield(ud,'axesData')
            ud.axesData = zeros(2,2);
        end
        set(f,'UserData',ud);
        drawnow update
    case 'done'
        if ~isempty(y)
            scatter(y(1:N,1),y(N+1:2*N,1),[],y(2*N+1:end,1));
        end
    end
    function callbackfn(~,eventData)
        ud = get(gcf,'UserData');
        ud.stop = 1;
        ud.gamma1 = get(eventData.AffectedObject,'Value');
        TextH.String = num2str(ud.gamma1);
        set(gcf,'UserData',ud);
    end
end
