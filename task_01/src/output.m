% Выводит оптимальное управление и траектории

function output()
    global MostOptimalTime MostOptimalManagement ...
        MostOptimalTimeManagement MostOptimalLine MostOptimalTimeLine ...
        startT;
    hFigure = figure('Name', 'Оптимальное управление');
    
    xObj = subplot(2, 1, 1);
    yObj = subplot(2, 1, 2);
    
    plot(xObj, MostOptimalTimeManagement, MostOptimalManagement(:, 1));
    xlabel(xObj, 't');
    ylabel(xObj, 'u_1');
    xlim(xObj, [startT, MostOptimalTime]);
    title(xObj, ['Конечное время ' num2str(MostOptimalTime)]);
    plot(yObj, MostOptimalTimeManagement, MostOptimalManagement(:, 2));
    xlabel(yObj, 't');
    ylabel(yObj, 'u_2');
    xlim(yObj, [startT, MostOptimalTime]);
    
    hFigure = figure('Name', 'Оптимальная траектория');
    xObj = subplot(2, 1, 1);
    yObj = subplot(2, 1, 2);
    plot(xObj, MostOptimalTimeLine, MostOptimalLine(:, 1));
    xlabel(xObj, 't');
    ylabel(xObj, 'x_1');
    xlim(xObj, [startT, MostOptimalTime]);
    title(xObj, ['Конечное время ' num2str(MostOptimalTime)]);
    plot(yObj, MostOptimalTimeLine, MostOptimalLine(:, 2));
    xlabel(yObj, 't');
    ylabel(yObj, 'x_2');
    xlim(yObj, [startT, MostOptimalTime]);
end

