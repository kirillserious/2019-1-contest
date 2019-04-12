function specify()
    global aMat bMat;
    % Рисуем начальное множество 
    global r p;
    figure('Name', 'Траектории');
    drawingRho(@(dir)startRho(dir, r, p), 40, 'g');
    % Рисуем конечное множество
    global gMat gVec;
    hold on;
    drawingRho(finishRhoFunc(gMat, gVec), 40, 'r');
    
    % Переменные для множества управлений
    global a b c;

    % Промежуток времени
    global startT MaxDeltaT;
    tspan = [startT, startT + MaxDeltaT];

    % Разбиение единичной окружности
    global SplitNumber PsiPlace Delta;
    angleVec = linspace(PsiPlace - Delta, PsiPlace + Delta, SplitNumber+1);
    psi0Mat  = [transpose(cos(angleVec)), transpose(sin(angleVec))];

    hold on;
    optimalTime = startT + MaxDeltaT;
    optimalManagement = 0;
    optimalTimeManagement = 0;
    optimalLine = 0;
    optimalTimeLine = 0;
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
            % ksi = B.T * psi 
            ksi = transpose(bMat(startT)) * psi; 
            [~, management(j, :)] = managementRho(ksi, a, b, c);
        end
        
        options = odeset('Events', @odeEventFcn);
        [timeLine, lineMat, ~, ~, ~] = ode45(@(t, x)xOdeFun(management, timeManagement, t, x), tspan, optimalX0, options); 
    
        if timeLine(end) < startT + MaxDeltaT
            ordinaryPlot = plot(lineMat(:, 1), lineMat(:, 2), 'b');
            if timeLine(end) < optimalTime
                optimalTime = timeLine(end);
                optimalManagement = management;
                optimalTimeManagement = timeManagement;
                optimalLine = lineMat;
                optimalTimeLine = timeLine;
                optimalIndex = i;
            end
        end
    end
    
    
    global MostOptimalTime MostOptimalManagement ...
        MostOptimalTimeManagement MostOptimalLine MostOptimalTimeLine;
    
    if (optimalIndex > 0)
        PsiPlace = PsiPlace - Delta + (optimalIndex-1) * (2*Delta/SplitNumber);
        Delta = Delta / SplitNumber;
        MostOptimalTime = optimalTime;
        MostOptimalManagement = optimalManagement;
        MostOptimalTimeManagement = optimalTimeManagement;
        MostOptimalLine = optimalLine;
        MostOptimalTimeLine = optimalTimeLine;
        optimalPlot = plot(optimalLine(:, 1), optimalLine(:,2), 'm');
        title(['Конечное время ' num2str(optimalTime)]);
    end
    
    axis([-20 20 -20 20]);
    legend([ordinaryPlot optimalPlot], 'Удачные траектории', 'Оптимальная траектория');

    function dxdt = xOdeFun (managementMat, tVec, t, x)
        tVec = abs(tVec - t);
        ind = find(tVec == max(tVec));
        dxdt = aMat(t) * x + bMat(t) * transpose(managementMat(ind, :));
    end

    function dxdt = psiOdeFun (t, psi)
        dxdt = transpose(aMat(t)) * psi;
    end

    function [value, terminal, direction] = odeEventFcn (t, x)
        if (max(gMat * x + gVec) < 0)
            value = 0;
        else
            value = 1;
        end
        terminal = 1;
        direction = 0;
    end
end

