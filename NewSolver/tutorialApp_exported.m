classdef tutorialApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        UIAxes                matlab.ui.control.UIAxes
        AmplitudeSliderLabel  matlab.ui.control.Label
        AmplitudeSlider       matlab.ui.control.Slider
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: AmplitudeSlider
        function AmplitudeSliderValueChanged(app, event)
            value = app.AmplitudeSlider.Value;
            plot(app.UIAxes, value*peaks)
            app.UIAxes.YLim = [-1000 1000];
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'UI Figure';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            app.UIAxes.Position = [171 149 300 185];

            % Create AmplitudeSliderLabel
            app.AmplitudeSliderLabel = uilabel(app.UIFigure);
            app.AmplitudeSliderLabel.HorizontalAlignment = 'right';
            app.AmplitudeSliderLabel.Position = [189 94 59 22];
            app.AmplitudeSliderLabel.Text = 'Amplitude';

            % Create AmplitudeSlider
            app.AmplitudeSlider = uislider(app.UIFigure);
            app.AmplitudeSlider.ValueChangedFcn = createCallbackFcn(app, @AmplitudeSliderValueChanged, true);
            app.AmplitudeSlider.Position = [269 103 150 3];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = tutorialApp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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