classdef app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure         matlab.ui.Figure
        Panel            matlab.ui.container.Panel
        AtPanel          matlab.ui.container.Panel
        a11EditField     matlab.ui.control.EditField
        a12EditField     matlab.ui.control.EditField
        a22EditField     matlab.ui.control.EditField
        a21EditField     matlab.ui.control.EditField
        BtPanel          matlab.ui.container.Panel
        b11EditField     matlab.ui.control.EditField
        b12EditField     matlab.ui.control.EditField
        b22EditField     matlab.ui.control.EditField
        b21EditField     matlab.ui.control.EditField
        X0Panel          matlab.ui.container.Panel
        rEditFieldLabel  matlab.ui.control.Label
        rEditField       matlab.ui.control.NumericEditField
        x0Panel          matlab.ui.container.Panel
        p2EditField      matlab.ui.control.NumericEditField
        p1EditField      matlab.ui.control.NumericEditField
        X1Panel          matlab.ui.container.Panel
        G1EditField      matlab.ui.control.NumericEditField
        G2EditField      matlab.ui.control.NumericEditField
        gEditField       matlab.ui.control.NumericEditField
        addGButton       matlab.ui.control.Button
        refreshGButton   matlab.ui.control.Button
        PPanel           matlab.ui.container.Panel
        aEditFieldLabel  matlab.ui.control.Label
        aEditField       matlab.ui.control.NumericEditField
        bEditFieldLabel  matlab.ui.control.Label
        bEditField       matlab.ui.control.NumericEditField
        cEditFieldLabel  matlab.ui.control.Label
        cEditField       matlab.ui.control.NumericEditField
        changeButton     matlab.ui.control.Button
        Button_6         matlab.ui.control.Button
        Button_2         matlab.ui.control.Button
        Button_3         matlab.ui.control.Button
        Button_4         matlab.ui.control.Button
        Button_5         matlab.ui.control.Button
    end

    methods (Access = private)

        % Button pushed function: changeButton
        function changeButtonPushed(app, event)
                global a b c r p ...
                    a11Str a12Str a21Str a22Str ...
                    b11Str b12Str b21Str b22Str;
                utilsSetSettings();
                a = app.aEditField.Value;
                b = app.bEditField.Value;
                c = app.cEditField.Value;
                r = app.rEditField.Value;
                p = [app.p1EditField.Value, app.p2EditField.Value];
                a11Str = app.a11EditField.Value;
                a12Str = app.a12EditField.Value;
                a21Str = app.a21EditField.Value;
                a22Str = app.a22EditField.Value;
                b11Str = app.b11EditField.Value;
                b12Str = app.b12EditField.Value;
                b21Str = app.b21EditField.Value;
                b22Str = app.b22EditField.Value;
                utilsSetABSymb();
                app.Button_5.Enable = 'off';
        end
        
        function defaultButtonPushed(app, event)
           utilsSetStandartValues();
           utilsSetABSymb();
           global a b c r p ...
               a11Str a12Str a21Str a22Str ...
               b11Str b12Str b21Str b22Str;

           app.a11EditField.Value = a11Str;
           app.a12EditField.Value = a12Str;
           app.a21EditField.Value = a21Str;
           app.a22EditField.Value = a22Str;
           app.b11EditField.Value = b11Str;
           app.b12EditField.Value = b12Str;
           app.b22EditField.Value = b22Str;
           app.b21EditField.Value = b21Str;
           app.rEditField.Value = r;
           app.p2EditField.Value = p(2);
           app.p1EditField.Value = p(1);
           app.aEditField.Value = a;
           app.bEditField.Value = b;
           app.cEditField.Value = c;
           app.Button_5.Enable = 'off';
        end
        function specifyButtonPushed(app, event)
            specify();
            app.Button_5.Enable = 'on';
        end 
        function outputButtonPushed(app, event)
            output();
        end
        function addGButtonPushed(app, event)
            global gMat gVec;
            utilsSetSettings();
            gMat = [gMat; [app.G1EditField.Value, app.G2EditField.Value]];
            gVec = [gVec; app.gEditField.Value];
            app.Button_5.Enable = 'off';         
        end
        function refreshGButtonPushed(app, event)
            global gMat gVec;
            utilsSetSettings();
            gMat = [];
            gVec = [];
            app.Button_5.Enable = 'off';  
        end
        function transversButtonPushed(app, event)
            transvers();
        end
        function checkIntersectButtonPushed(app, event)
            isIntersect();
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
                global a; 
                global b;
                global c;
                global r;
                global p;
                global a11Str;
                global a12Str;
                global a21Str;
                global a22Str;
                global b11Str;
                global b12Str;
                global b21Str;
                global b22Str;
            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 678 496];
            app.UIFigure.Name = 'Практикум 1';

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.Title = 'Начальные настройки';
            app.Panel.Position = [322 12 348 475];

            % Create AtPanel
            app.AtPanel = uipanel(app.Panel);
            app.AtPanel.Title = 'Матрица A(t)';
            app.AtPanel.Position = [11 329 158 112];

            % Create a11EditField
            app.a11EditField = uieditfield(app.AtPanel, 'text');
            app.a11EditField.Position = [7 48 66 22];
            app.a11EditField.Value = a11Str;

            % Create a12EditField
            app.a12EditField = uieditfield(app.AtPanel, 'text');
            app.a12EditField.Position = [88 48 66 22];
            app.a12EditField.Value = a12Str;

            % Create a21EditField
            app.a21EditField = uieditfield(app.AtPanel, 'text');
            app.a21EditField.Position = [7 9 66 22];
            app.a21EditField.Value = a21Str;
            
            % Create a22EditField
            app.a22EditField = uieditfield(app.AtPanel, 'text');
            app.a22EditField.Position = [88 9 66 22];
            app.a22EditField.Value = a22Str;
            
            % Create BtPanel
            app.BtPanel = uipanel(app.Panel);
            app.BtPanel.Title = 'Матрица B(t)';
            app.BtPanel.Position = [179 329 158 112];

            % Create b11EditField
            app.b11EditField = uieditfield(app.BtPanel, 'text');
            app.b11EditField.Position = [7 48 66 22];
            app.b11EditField.Value = b11Str;
            
            % Create b12EditField
            app.b12EditField = uieditfield(app.BtPanel, 'text');
            app.b12EditField.Position = [88 48 66 22];
            app.b12EditField.Value = b12Str;

            % Create b22EditField
            app.b22EditField = uieditfield(app.BtPanel, 'text');
            app.b22EditField.Position = [88 9 66 22];
            app.b22EditField.Value = b22Str;

            % Create b21EditField
            app.b21EditField = uieditfield(app.BtPanel, 'text');
            app.b21EditField.Position = [7 9 66 22];
            app.b21EditField.Value = b21Str;

            % Create X0Panel
            app.X0Panel = uipanel(app.Panel);
            app.X0Panel.Title = 'Множество X0';
            app.X0Panel.Position = [179 154 158 157];

            % Create rEditFieldLabel
            app.rEditFieldLabel = uilabel(app.X0Panel);
            app.rEditFieldLabel.HorizontalAlignment = 'right';
            app.rEditFieldLabel.Position = [11 107 25 22];
            app.rEditFieldLabel.Text = 'r';

            % Create rEditField
            app.rEditField = uieditfield(app.X0Panel, 'numeric');
            app.rEditField.Position = [51 107 100 22];
            app.rEditField.Value = r;

            % Create x0Panel
            app.x0Panel = uipanel(app.X0Panel);
            app.x0Panel.Title = 'x0';
            app.x0Panel.Position = [8 6 142 92];

            % Create p2EditField
            app.p2EditField = uieditfield(app.x0Panel, 'numeric');
            app.p2EditField.Position = [21 9 100 22];
            app.p2EditField.Value = p(2);

            % Create p1EditField
            app.p1EditField = uieditfield(app.x0Panel, 'numeric');
            app.p1EditField.Position = [21 38 100 22];
            app.p1EditField.Value = p(1);

            % Create X1Panel
            app.X1Panel = uipanel(app.Panel);
            app.X1Panel.Title = 'Множество X1';
            app.X1Panel.Position = [11 11 158 168];

            % Create G1EditField
            app.G1EditField = uieditfield(app.X1Panel, 'numeric');
            app.G1EditField.Position = [9 114 57 22];

            % Create G2EditField
            app.G2EditField = uieditfield(app.X1Panel, 'numeric');
            app.G2EditField.Position = [81 114 57 22];

            % Create gEditField
            app.gEditField = uieditfield(app.X1Panel, 'numeric');
            app.gEditField.Position = [9 78 57 22];

            % Create addGButton
            app.addGButton = uibutton(app.X1Panel, 'push');
            app.addGButton.Position = [29 38 100 22];
            app.addGButton.Text = 'Добавить';
            app.addGButton.ButtonPushedFcn = createCallbackFcn(app, @addGButtonPushed, true);
            

            % Create refreshGButton
            app.refreshGButton = uibutton(app.X1Panel, 'push');
            app.refreshGButton.Position = [29 10 100 22];
            app.refreshGButton.Text = 'Сбросить';
            app.refreshGButton.ButtonPushedFcn = createCallbackFcn(app, @refreshGButtonPushed, true);
            

            % Create PPanel
            app.PPanel = uipanel(app.Panel);
            app.PPanel.Title = 'Множество P';
            app.PPanel.Position = [11 190 158 121];

            % Create aEditFieldLabel
            app.aEditFieldLabel = uilabel(app.PPanel);
            app.aEditFieldLabel.HorizontalAlignment = 'right';
            app.aEditFieldLabel.Position = [15 71 25 22];
            app.aEditFieldLabel.Text = 'a';

            % Create aEditField
            app.aEditField = uieditfield(app.PPanel, 'numeric');
            app.aEditField.Position = [55 71 100 22];
            app.aEditField.Value = a;

            % Create bEditFieldLabel
            app.bEditFieldLabel = uilabel(app.PPanel);
            app.bEditFieldLabel.HorizontalAlignment = 'right';
            app.bEditFieldLabel.Position = [14 40 25 22];
            app.bEditFieldLabel.Text = 'b';
            
            % Create bEditField
            app.bEditField = uieditfield(app.PPanel, 'numeric');
            app.bEditField.Position = [54 40 100 22];
            app.bEditField.Value = b;

            % Create cEditFieldLabel
            app.cEditFieldLabel = uilabel(app.PPanel);
            app.cEditFieldLabel.HorizontalAlignment = 'right';
            app.cEditFieldLabel.Position = [14 8 25 22];
            app.cEditFieldLabel.Text = 'c';

            % Create cEditField
            app.cEditField = uieditfield(app.PPanel, 'numeric');
            app.cEditField.Position = [54 8 100 22];
            app.cEditField.Value = c;

            % Create changeButton
            app.changeButton = uibutton(app.Panel, 'push');
            app.changeButton.ButtonPushedFcn = createCallbackFcn(app, @changeButtonPushed, true);
            app.changeButton.Position = [214 49 100 22];
            app.changeButton.Text = 'Изменить';

            % Create Button_6
            app.Button_6 = uibutton(app.Panel, 'push');
            app.Button_6.Position = [214 21 100 22];
            app.Button_6.Text = 'К стандартным';
            app.Button_6.ButtonPushedFcn = createCallbackFcn(app, @defaultButtonPushed, true);
            
            % Create Button_2
            app.Button_2 = uibutton(app.UIFigure, 'push');
            app.Button_2.Position = [12 273 300 22];
            app.Button_2.Text = 'Погрешность УТ';
            app.Button_2.ButtonPushedFcn = createCallbackFcn(app, @transversButtonPushed, true);
            

            % Create Button_3
            app.Button_3 = uibutton(app.UIFigure, 'push');
            app.Button_3.Position = [12 242 300 22];
            app.Button_3.Text = 'Проверить пересечение множеств';
            app.Button_3.ButtonPushedFcn = createCallbackFcn(app, @checkIntersectButtonPushed, true);

            % Create Button_4
            app.Button_4 = uibutton(app.UIFigure, 'push');
            app.Button_4.Position = [12 210 300 22];
            app.Button_4.Text = 'Уточнить результат';
            app.Button_4.ButtonPushedFcn = createCallbackFcn(app, @specifyButtonPushed, true);
            

            % Create Button_5
            app.Button_5 = uibutton(app.UIFigure, 'push');
            app.Button_5.Position = [12 181 300 22];
            app.Button_5.Text = 'Вывод результата';
            app.Button_5.ButtonPushedFcn = createCallbackFcn(app, @outputButtonPushed, true);
            app.Button_5.Enable = 'off';
        end
    end

    methods (Access = public)

        % Construct app
        function app = app
            % Положим везде стандартные значения
            utilsSetStandartValues();
            utilsSetABSymb();
            
            % Create and configure components
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