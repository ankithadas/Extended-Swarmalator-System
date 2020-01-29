classdef solverApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        UIAxes             matlab.ui.control.UIAxes
        SwitchLabel        matlab.ui.control.Label
        Switch             matlab.ui.control.Switch
        gamma1SliderLabel  matlab.ui.control.Label
        gamma1Slider       matlab.ui.control.Slider
    end

    
    properties (Access = public)
        N = 100;    % Description
        J = 0.8;
        K = -0.5;
        gamma1 = 2/3;
        gamma2 = -1/3;
        dim = 2;
        stepSize = 1;
        timeSteps = 1000;
        y00 = [];
        options = odeset('RelTol',1e-6,'AbsTol',1e-6,'OutputFcn',@plotode); %% Need to change the function name
        tStart = 0;
        tEnd = 1000;
        
    end
    
    methods (Static)
        
        function dy = swarSims(~,y,dim,N,w,K,J,gamma1,gamma2,varargin)
            dy=zeros((dim+1)*N,1);
            v = zeros(N,dim);
            
            
            pts = reshape(y(1:dim*N),N,dim);
            PTS = permute(repmat(pts,1,1,N),[3 1 2]);
            PTSdiff = PTS - permute(PTS, [2 1 3]);
            
            
            Y = 1./internal.stats.pdistmex(pts','euc',[]);
            invDis = zeros(N,N);
            invDis(tril(true(N),-1)) = Y;
            invDis = invDis + invDis';
            invDis = invDis + eye(N);
            
            
            phi = y(dim*N + 1:end);
            PHIdiff = phi' - phi;
            
            A_pos = (1 + J*cos(PHIdiff)) - invDis.^2;
            dy(dim*N + 1:(dim+1)*N) = w' + (K/N)*sum(invDis.*(gamma1*sin(PHIdiff) + gamma2*sin(2*PHIdiff)),2);
            v_pos = v + (1/N)*reshape(sum(A_pos.*PTSdiff,2),N,dim);
            dy(1:dim*N) = reshape(v_pos,dim*N,1);
        end 
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            reset(RandStream.getGlobalStream,1);
            rand_init = 76599;
            var = randn(rand_init,2);
            clear var
            
            app.y00 = rand((app.dim+1)*app.N,1);
            app.y00(app.dim*app.N + 1:end) = 2*pi*app.y00(app.dim*app.N + 1:end);
            app.UIAxes.Box = 'on';
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            value = app.Switch.Value;  
%             disp(value);
%             if strcmp(value,'On')
%                 disp('Run this code');
%             end
            if strcmp(value,'On')
                while app.tStart < app.tEnd
                    [T,y_full] = ode45(@swarmalator_matrixform, [app.tStart:app.stepSize/5:app.tEnd],...
                    app.y00,app.options, app.dim, app.N, zeros(1,app.N), app.K, app.J, app.gamma1, app.gamma2,app);
                    app.tStart = T(end);
                    app.y00 = y_full(end,:);
                    if length(T) > 4
                        app.options = odeset(app.options,'InitialStep',T(end) - T(end-4),'MaxStep',T(end)-T(1));
                    end
                end
            end
        end

        % Value changed function: gamma1Slider
        function gamma1SliderValueChanged(app, event)
            value = app.gamma1Slider.Value;
            app.gamma1 = value;
            ud = get(app.UIFigure,'UserData');
            ud.stop = 1;
            ud.gamma1 = value;
            set(app.UIFigure,'UserData',ud);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 867 451];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [314 37 540 379];

            % Create SwitchLabel
            app.SwitchLabel = uilabel(app.UIFigure);
            app.SwitchLabel.HorizontalAlignment = 'center';
            app.SwitchLabel.Position = [121 359 41 22];
            app.SwitchLabel.Text = 'Switch';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'slider');
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.Position = [118 396 45 20];

            % Create gamma1SliderLabel
            app.gamma1SliderLabel = uilabel(app.UIFigure);
            app.gamma1SliderLabel.HorizontalAlignment = 'right';
            app.gamma1SliderLabel.Position = [28 325 52 22];
            app.gamma1SliderLabel.Text = 'gamma1';

            % Create gamma1Slider
            app.gamma1Slider = uislider(app.UIFigure);
            app.gamma1Slider.Limits = [0 2];
            app.gamma1Slider.ValueChangedFcn = createCallbackFcn(app, @gamma1SliderValueChanged, true);
            app.gamma1Slider.Position = [101 334 150 3];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = solverApp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end