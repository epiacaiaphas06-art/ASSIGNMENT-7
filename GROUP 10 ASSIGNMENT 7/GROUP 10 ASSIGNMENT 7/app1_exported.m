classdef app1_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        UITable          matlab.ui.control.Table
        SOLVEButton      matlab.ui.control.Button
        EditField5       matlab.ui.control.EditField
        EditField5Label  matlab.ui.control.Label
        EditField4       matlab.ui.control.EditField
        EditField4Label  matlab.ui.control.Label
        EditField3       matlab.ui.control.EditField
        EditField3Label  matlab.ui.control.Label
        EditField2       matlab.ui.control.EditField
        EditField2Label  matlab.ui.control.Label
        EditField        matlab.ui.control.EditField
        EditFieldLabel   matlab.ui.control.Label
        DropDown         matlab.ui.control.DropDown
        DropDownLabel    matlab.ui.control.Label
        GROUP_6NUMERICALMETHODSSOLVERLabel  matlab.ui.control.Label
        UIAxes           matlab.ui.control.UIAxes
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SOLVEButton
        function SOLVEButtonPushed(app, event)
           f_root = @(x) x.^3 - 4.*x - 9;
           df_root = @(x) 3.*x.^2 - 4;
           g_fixed = @(x) (4.*x + 8).^(1/3);
           f_ode = @(x,y) 0.8.*x + 1.2.*y;
         
           a = str2double(string(app.EditField.Value));
           b = str2double(string(app.EditField2.Value));
           x0 = str2double(string(app.EditField3.Value));
           h = str2double(string(app.EditField4.Value));
           x_end = str2double(string(app.EditField5.Value));
            tol = 1e-4; yo = 0.5;
             method = app.DropDown.Value;
            
            cla(app.UIAxes);
            data = []; 
              
            switch method
                case 'Bisection'
                    c = (a+b)/2; 
                    data = [];
                    for iter = 1:20
                        fc = f_root(c);
                        data = [data; iter, a, b, c, fc];
                        if abs(fc)<tol, break;
                        end
                        if f_root(a)*fc<0, b = c;
                        else, a = c;
                        end
                        c = (a+b)/2;
                    end
                    app.UITable.Data = array2table(data);
                    plot(app.UIAxes,data(:,1),data(:,4),'-o')
                case 'NRM'
                    x = x0;
                    data = [];
                    for iter = 1:20
                        x1 = x - f_root(x)/df_root(x);
                        data = [data; iter, x, x1, f_root(x1)]
                        if abs(x1-x)<tol, break;
                        end;
                        x = x1;
                    end
                    data = double(data);
                    app.UITable.Data = array2table(data);
                    plot(app.UIAxes,double(data(:,1)), double(data(:,3)), '-o')
                 

                case 'Secant'
                    x0s = a; x1s = b; data = [];
                    for iter = 1:20
                        x2 = x1s - f_root(x1s)*(x1s-x0s)/(f_root(x1s)-f_root(x0s));
                        data =[data; iter, x0s, x1s, x2, f_root(x2)];
                        if abs(x2-x1s)<tol, break;
                        end;
                        x0s = x1s; x1s = x2;
                    end
                   app.UITable.Data = array2table(data);
                   plot(app.UIAxes, data(:,1), data(:,4), '-o');
                     
                case 'Fixed Point iteration'
                    x = x0; data = [];
                    for iter = 1:20
                       x1 = g_fixed(x);
                       data = [data; iter, x, x1, f_root(x1)];
                       if abs(x1-x)<tol, break;
                       end
                       x = x1;
                    end
                     app.UITable.Data = array2table(data);
                     plot(app.UIAxes, data(:,1), data(:,3), '-o');
                    
                case 'Euler'
                    y0 = 0.5;
                    x = 0:h:x_end;
                    y = zeros(size(x));
                    y(1) = y0; 
                    for i = 1:length(x)-1
                        y(i+1)= y(i) + h*f_ode(x(i),y(i));
                    end
                    data = [x(:), y(:)];
                     app.UITable.Data = array2table(data);
                    plot(app.UIAxes,x,y,'-o');
                    
                case 'RK4'
                    y0 = 0.5;
                    x = 0:h:x_end;
                    y = zeros(size(x)); y(1) = y0; data = [];
                    for i = 1:length(x)-1
                        k1 = f_ode(x(i),y(i));
                        k2 = f_ode(x(i)+h/2, y(i)+h*k1/2);
                        k3 = f_ode(x(i)+h/2,y(i)+h*k2/2);
                        k4 = f_ode(x(i)+h,y(i)+h*k3);
                        y(i+1) = y(i)+h*(k1+2*k2+2*k3+k4)/6;
                    end
                     data = [x(:), y(:)];
                     app.UITable.Data = array2table(data);
                    plot(app.UIAxes, x, y,'-o');
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [341 33 300 185];

            % Create GROUP_6NUMERICALMETHODSSOLVERLabel
            app.GROUP_6NUMERICALMETHODSSOLVERLabel = uilabel(app.UIFigure);
            app.GROUP_6NUMERICALMETHODSSOLVERLabel.FontSize = 18;
            app.GROUP_6NUMERICALMETHODSSOLVERLabel.FontWeight = 'bold';
            app.GROUP_6NUMERICALMETHODSSOLVERLabel.FontColor = [0.7176 0.2745 1];
            app.GROUP_6NUMERICALMETHODSSOLVERLabel.Position = [177 431 389 23];
            app.GROUP_6NUMERICALMETHODSSOLVERLabel.Text = 'GROUP_6-NUMERICAL METHODS SOLVER:';

            % Create DropDownLabel
            app.DropDownLabel = uilabel(app.UIFigure);
            app.DropDownLabel.HorizontalAlignment = 'right';
            app.DropDownLabel.Position = [231 376 65 22];
            app.DropDownLabel.Text = 'Drop Down';

            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            app.DropDown.Items = {'Bisection', 'NRM', 'Secant', 'Fixed Point iteration', 'Euler', 'RK4'};
            app.DropDown.Position = [311 376 100 22];
            app.DropDown.Value = 'NRM';

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.UIFigure);
            app.EditFieldLabel.HorizontalAlignment = 'right';
            app.EditFieldLabel.Position = [242 349 55 22];
            app.EditFieldLabel.Text = 'Edit Field';

            % Create EditField
            app.EditField = uieditfield(app.UIFigure, 'text');
            app.EditField.Position = [311 349 100 22];
            app.EditField.Value = '2';

            % Create EditField2Label
            app.EditField2Label = uilabel(app.UIFigure);
            app.EditField2Label.HorizontalAlignment = 'right';
            app.EditField2Label.Position = [234 328 62 22];
            app.EditField2Label.Text = 'Edit Field2';

            % Create EditField2
            app.EditField2 = uieditfield(app.UIFigure, 'text');
            app.EditField2.Position = [311 328 100 22];
            app.EditField2.Value = '3';

            % Create EditField3Label
            app.EditField3Label = uilabel(app.UIFigure);
            app.EditField3Label.HorizontalAlignment = 'right';
            app.EditField3Label.Position = [234 307 62 22];
            app.EditField3Label.Text = 'Edit Field3';

            % Create EditField3
            app.EditField3 = uieditfield(app.UIFigure, 'text');
            app.EditField3.Position = [311 307 100 22];
            app.EditField3.Value = '2.5';

            % Create EditField4Label
            app.EditField4Label = uilabel(app.UIFigure);
            app.EditField4Label.HorizontalAlignment = 'right';
            app.EditField4Label.Position = [234 286 62 22];
            app.EditField4Label.Text = 'Edit Field4';

            % Create EditField4
            app.EditField4 = uieditfield(app.UIFigure, 'text');
            app.EditField4.Position = [311 286 100 22];
            app.EditField4.Value = '0.25';

            % Create EditField5Label
            app.EditField5Label = uilabel(app.UIFigure);
            app.EditField5Label.HorizontalAlignment = 'right';
            app.EditField5Label.Position = [234 265 62 22];
            app.EditField5Label.Text = 'Edit Field5';

            % Create EditField5
            app.EditField5 = uieditfield(app.UIFigure, 'text');
            app.EditField5.Position = [311 265 100 22];
            app.EditField5.Value = '1';

            % Create SOLVEButton
            app.SOLVEButton = uibutton(app.UIFigure, 'push');
            app.SOLVEButton.ButtonPushedFcn = createCallbackFcn(app, @SOLVEButtonPushed, true);
            app.SOLVEButton.Position = [273 230 100 22];
            app.SOLVEButton.Text = 'SOLVE';

            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITable.RowName = {};
            app.UITable.Position = [26 33 302 185];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = app1_exported

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