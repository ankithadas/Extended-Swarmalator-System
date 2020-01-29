function solvePlot
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
    options = odeset('RelTol',1e-6,'AbsTol',1e-6,'OutputFcn',@odePlotter);
    tic
    fig = figure(1);
    ax = axes;
    ax.XLim = [-5 5];
    ax.YLim = [-5 5];
    daspect([1 1 1]);
    box on
    tStart = 0;
    tEnd = timeSteps;
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

    odePlotter([],[],'done');
    toc

    function status = odePlotter(~,y,flag,varargin)
        persistent TARGET_FIGURE TARGET_AXES
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
                                pause(0.01);
                                %drawnow limitrate;
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
                set(SliderH,'Value',gamma1);
                addlistener(SliderH, 'Value', 'PostSet', @callbackfn);
                ud.figStart = 1;
            end
            %gamma1 = get(SliderH,'Value');
            %set(SilderH,'Value',gamma1);
            TextH.String = num2str(gamma1);
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
            TextH.String = num2str(gamma1);
            set(gcf,'UserData',ud);
        end
    end
% Update code so the axis limits don't get smaller while plotting
end


% if ud data already exists, then deal with that case appropriately 
% add names for the slider, fix slider position, add more sliders for other variables, and make the code a bit more readable 
% Check if drawnow statements are needed and update code accordingly
% Get rid of all variables in persist function except figure and axis handles 