% Уточняет результат
% Inputs:
%    figureMode    string = 'default'
%                           'new_figure' -- в новом окне
%    traectoryMode string = 'default'
%                           'draw_all' -- рисует не дошедшие до целевого
%                                         множества траектории
%    finishMode    string = 'default'
%                           'strict'   -- рисует целевое множество,
%                           используя опорную функцию
function specify (figureMode, traectoryMode, finishMode)
    % Стандартные значения
    if nargin < 1
        figureMode = 'default';
    end
    if nargin < 2
        traectoryMode = 'default';
    end
    if nargin < 3
        finishMode = 'default';
    end
    
    
    % Разбираемся с фигурами
    global SpecifyIsFirstUsage SpecifyFigure;
    
    isNewFigure = 0;
    if SpecifyIsFirstUsage
        SpecifyFigure = figure('Name', 'Траектории');
        SpecifyIsFirstUsage = 0;
        isNewFigure = 1;
    else
        if ~isvalid(SpecifyFigure) || strcmp(figureMode, 'new_figure')
            SpecifyFigure = figure('Name', 'Траектории');
            isNewFigure = 1;
        end
    end
    figure(SpecifyFigure);
    hold on;
    
    % Если рисуем в старом окне, то закрасим бывшую оптимальную траеторию
    % синим
    global SpecifyIsOptimalExist MostOptimalLine;
    if SpecifyIsOptimalExist && ~isNewFigure
        plot(MostOptimalLine(:,1), MostOptimalLine(:,2), 'b');
    end


    global aMat bMat;
    global r p;
    global gMat gVec;
    
    if isNewFigure
        drawingRho(@(dir)startRho(dir, r, p), 40, 'g');
    end
    
    % Переменные для множества управлений
    global a b c;

    % Промежуток времени
    global startT MaxDeltaT;
    tspan = [startT, startT + MaxDeltaT];

    % Разбиение psi по единичной окружности
    global SplitNumber PsiPlace Delta ;
    angleVec = linspace(PsiPlace - Delta, PsiPlace + Delta, SplitNumber+1);
    psi0Mat  = [transpose(cos(angleVec)), transpose(sin(angleVec))];
    
    % Удаление из разбиения уже проверенных начальных значений
    global SpecifiedStartPsis;
    setdiff(psi0Mat, SpecifiedStartPsis, 'rows');
    SpecifiedStartPsis = [SpecifiedStartPsis; psi0Mat];
    
    % Если не осталось ни одного psi0
    if (size(psi0Mat, 1) == 0) && (~isNewFigure)
        return
    end
        
    if (size(psi0Mat, 1) == 0) && (isNewFigure)
        %! Добавить обработку этого случая
        return
    end
    

    
    optimalTime = startT + MaxDeltaT;
    optimalManagement = 0;
    optimalTimeManagement = 0;
    optimalLine = 0;
    optimalTimeLine = 0;
    optimalPsi = 0;
    optimalIndex = -1;
    
    for i = 1:SplitNumber
        % Условие транверсальности на левом конце
        [~, optimalX0] = startRho(transpose(psi0Mat(i, :)), r, p);
        % Решение для psi
        [timeManagement, psiMat] = ode45(@(t, psi)psiOdeFun(t, psi), ...
            tspan, transpose(psi0Mat(i, :)));
        % Условие максимума
        [n, ~] = size(timeManagement);
        management = zeros(n, 2);
        for j = 1:n
            psi = transpose(psiMat(j, :));
            ksi = transpose(bMat(startT)) * psi; 
            [~, management(j, :)] = managementRho(ksi, a, b, c);
        end
        
        options = odeset('Events', @odeEventFcn, 'RelTol', 2.22045e-14);
        [timeLine, lineMat, ~, ~, ~] = ode45(@(t, x)xOdeFun(management, timeManagement, t, x), tspan, optimalX0, options); 
        
        % Траектория дошла до множества
        if timeLine(end) < startT + MaxDeltaT
            plot(lineMat(:, 1), lineMat(:, 2), 'b');
            if timeLine(end) < optimalTime
                optimalTime = timeLine(end);
                optimalManagement = management;
                optimalTimeManagement = timeManagement;
                optimalLine = lineMat;
                optimalTimeLine = timeLine;
                optimalPsi = psiMat;
                optimalIndex = i;
            end
        % Траектория не дошла до множества    
        else
            if strcmp(traectoryMode, 'draw_all')
                plot(lineMat(:,1), lineMat(:,2), 'k');
            end
        end
    end
    
    
    global MostOptimalTime MostOptimalManagement ...
        MostOptimalTimeManagement MostOptimalTimeLine ...
        MostOptimalPsi;
    
    % Найденная на этой итерации оптимальная траектория оказалось
    % самой оптимальной
    if (optimalIndex > 0) && (MostOptimalTime > optimalTime)
        PsiPlace = PsiPlace - Delta + (optimalIndex-1) * (2*Delta/SplitNumber);        
        MostOptimalTime = optimalTime;
        MostOptimalManagement = optimalManagement;
        MostOptimalTimeManagement = optimalTimeManagement;
        MostOptimalLine = optimalLine;
        MostOptimalTimeLine = optimalTimeLine;
        MostOptimalPsi = optimalPsi;
        SpecifyIsOptimalExist = 1;
        plot(optimalLine(:, 1), optimalLine(:,2), 'm');
    end
    
    % Оптимальная траектория существует
    if SpecifyIsOptimalExist
        plot(MostOptimalLine(:, 1), MostOptimalLine(:,2), 'm');
        title(['Конечное время ' num2str(optimalTime)]);
    else
        title('Оптимальная траектория не найдена');
    end
    
        
    % Если рисуем в новом окне, то рисуем целевое множество
    if isNewFigure
        if strcmp(finishMode, 'strict')
            exts = finishExt();
            drawingRho(@(dir)finishRho(dir, exts), 40, 'r');
        else
            exts = finishExt();
            if SpecifyIsOptimalExist
                x1 = min(p(1) - r, min(MostOptimalLine(:,1)));
                x2 = max(p(1) + r, max(MostOptimalLine(:,1)));
                y1 = min(p(2) - r, min(MostOptimalLine(:,2)));
                y2 = max(p(2) + r, max(MostOptimalLine(:,2)));
                
                if ~isempty(exts)
                    x1 = min(x1, min(exts(:,1)));
                    x2 = max(x2, max(exts(:,1)));
                    y1 = min(y1, min(exts(:,2)));
                    y2 = max(y2, max(exts(:,2)));
                end
                    
                delta = max(x2 - x1, y2 - y1);
                drawFinishSet(x1 - delta/2, y1 - delta/2, ...
                    x1 + 3*delta/2, y1 + 3*delta/2);
                axis([x1 - delta/4, x1 + 5*delta/4, ...
                    y1 - delta/4, y1 + 5*delta/4]);
            else
                x1 = abs(p(1) - r);
                y1 = abs(p(2) - r);
                if ~isempty(exts)
                    x1 = max(x1, max(abs(exts(:,1))));
                    y1 = max(y1, max(abs(exts(:,2))));
                end
                
                drawFinishSet(x1 + 5, y1 + 5);
                axis([-x1-4, x1+4, -y1-4, y1+4]);
            end
        end
    end
    
    % Дополнительные параметры графика
    grid on;
    startPlt    = fill(nan, nan, 'g');
    finishPlt   = fill(nan, nan, 'r');
    failurePlt  = plot(nan, nan, 'k');
    ordinaryPlt = plot(nan, nan, 'b');
    optimalPlt  = plot(nan, nan, 'm');
    
    if strcmp(traectoryMode, 'draw_all')
        legend([startPlt, finishPlt, failurePlt, ordinaryPlt optimalPlt], ... 
            'Начальное множество', 'Целевое множество', ...
            'Неудачные траектории', 'Удачные траектории', ...
            'Оптимальная траектория');
    else
        legend([startPlt, finishPlt, ordinaryPlt optimalPlt], ... 
            'Начальное множество', 'Целевое множество', ...
            'Удачные траектории', 'Оптимальная траектория');
    end

    
    function dxdt = xOdeFun (managementMat, tVec, t, x)
        tVec = abs(tVec - t);
        ind = find(tVec == max(tVec));
        dxdt = aMat(t) * x + bMat(t) * transpose(managementMat(ind, :));
    end

    function dxdt = psiOdeFun (t, psi)
        dxdt = transpose(aMat(t)) * psi;
    end

    function [value, terminal, direction] = odeEventFcn (t, x)
        if (max(gMat * x + gVec) < 0.001)
            value = 0;
        else
            value = 1;
        end
        terminal = 1;
        direction = 0;
    end
end
% -8.7
