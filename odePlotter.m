function status = odePlotter(~,y,flag,varargin)
    persistent TARGET_FIGURE TARGET_AXES N axesData
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
            minx = min(y(1:N,:),[],'all');
            maxx = max(y(1:N,:),[],'all');
            miny = min(y(N+1:2*N,:),[],'all');
            maxy = max(y(N+1:2*N,:),[],'all');

            if axesData(1,1) > minx
                axesData(1,1) = minx;
            end
            if axesData(1,2) < maxx
                axesData(1,2) = maxx;
            end
            if axesData(2,1) > miny
                axesData(2,1) = miny;
            end
            if axesData(2,2) < maxy
                axesData(2,2) = maxy;
            end
            set(TARGET_AXES,'XLim',axesData(1,:));
            set(TARGET_AXES,'YLim',axesData(2,:));
            try
                if m~= 1
                    for k = 1:m
                        ud = get(TARGET_FIGURE,'UserData');
                        ud.ScatterPoints.XData = y(1:N,k);
                        ud.ScatterPoints.YData = y(N+1:2*N,k);
                        ud.ScatterPoints.CData = mod(y(2*N+1:end,k),2*pi);
                        %pause(0.005);
                        drawnow update
                    end
                else
                    ud = get(TARGET_FIGURE,'UserData');
                    ud.ScatterPoints.XData = y(1:N,1);
                    ud.ScatterPoints.YData = y(N+1:2*N,1);
                    ud.ScatterPoints.CData = mod(y(2*N+1:end,1),2*pi);
                    % currentXLim = get(TARGET_AXES,'XLim');
                    % currentYLim = get(TARGET_AXES,'YLim');
                    drawnow update
                    % for faster updating
                    % drawnow limirate
                end
            catch ME 
                error(message('ErrorUpdatingWindow',ME.message));                
            end
        end

    case 'init'
        f = figure(gcf);
        TARGET_FIGURE = f;
        TARGET_AXES = gca;
        N = length(y)/3;
        ud = get(f,'UserData');
        colormap('hsv');
        
        if ~ishold || ~isfield(ud,'ScatterPoints') || ~isfield(ud,'ColorBar')
            ud.ScatterPoints = scatter(y(1:N,1),y(N+1:2*N,1),[],y(2*N+1:end,1));
            %colorbar;
        end
        set(TARGET_AXES,'DataAspectRatio',[1 1 1]);
        set(TARGET_FIGURE,'Colormap',hsv);
        set(TARGET_AXES,'CLim',[0 2*pi]);
        set(TARGET_AXES,'Box','on');
        axesData = zeros(2,2);
        % This second of the code may be unnecessary 
        % axesData(1,:) = get(TARGET_AXES,'XLim');
        % axesData(2,:) = get(TARGET_AXES,'YLim');
        %%%%%%%%%%%%%% end
        colorbar;
        set(f,'UserData',ud);
        drawnow update
    case 'done'
        if ~isempty(y)
            scatter(y(1:N,1),y(N+1:2*N,1),[],y(2*N+1:end,1));
        end
    end
end