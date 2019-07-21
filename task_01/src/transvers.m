% Условие трансверсальности на правом конце
function transvers()
        global MostOptimalLine MostOptimalPsi;
        
    % Рисуем начальное множество 
    global r p;
    figure('Name', 'Условие трансверсальности');
    drawingRho(@(dir)startRho(dir, r, p), 40, 'g');
    % Рисуем конечное множество
    hold on;
    exts = ext_x1();
    drawingRho(@(dir)finishRho(dir, exts), 40, 'r');
    % Рисуем оптимальное управление
    hold on;
    mostOptimalPlot = plot(MostOptimalLine(:, 1), MostOptimalLine(:,2), 'm');
    % Рисуем стрелку с пси
    point = MostOptimalLine(end, :)';
    psi   = MostOptimalPsi(end, :)';
    psi = -psi / norm(psi);
    p1 = quiver(point(1), point(2), psi(1), psi(2));
    % Рисуем нормаль
    eps = 0.01;
    options = optimset('TolX', 0.01 * eps);
    t = fzero(@(t) fcn(t, point,  eps), [-1; 1], options);
    normal = [t; -eps];
    normal = normal / norm(normal);
    if set_x1([point(1); point(2) + eps])
        p2 = quiver(point(1), point(2), normal(1), normal(2));
    else
        p2 = quiver(point(1), point(2), -normal(1), -normal(2));
    end
    % Вывод результата
    angle = psi(1)*normal(1) + psi(2)*normal(2);
    title(strcat('\delta = ', num2str(angle)));
    axis equal;
    legend([mostOptimalPlot, p1, p2], {'Оптимальная траектория', '-\psi(t_1)', 'n'});
end

function res = fcn(t, x, eps)
    if set_x1([x(1) + eps; x(2) + t])
        res = 1;
    else
        res = -1;
    end
end