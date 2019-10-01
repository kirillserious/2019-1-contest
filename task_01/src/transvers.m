% Условие трансверсальности на правом конце
function transvers()
    global MostOptimalLine MostOptimalPsi;
        
    % Рисуем начальное множество 
    global r p;
    figure('Name', 'Условие трансверсальности');
    drawingRho(@(dir)startRho(dir, r, p), 40, 'g');
    % Рисуем конечное множество
    hold on;
    exts = finishExt();
    drawingRho(@(dir)finishRho(dir, exts), 40, 'r');
    
    % Рисуем целевое множество
   global SpecifyIsOptimalExist;
            if SpecifyIsOptimalExist
                x1 = min(p(1) - r, min(MostOptimalLine(:,1)));
                x2 = max(p(1) + r, max(MostOptimalLine(:,1)));
                y1 = min(p(2) - r, min(MostOptimalLine(:,2)));
                y2 = max(p(2) + r, max(MostOptimalLine(:,2)));
                
                exts = finishExt();
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
                
                drawFinishSet(x1 + 5, y1 + 5);
            end
        
    
    
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
    if finishSet([point(1); point(2) + eps])
        p2 = quiver(point(1), point(2), normal(1), normal(2));
    else
        p2 = quiver(point(1), point(2), -normal(1), -normal(2));
    end
    % Вывод результата
    angle = psi(1)*normal(1) + psi(2)*normal(2);
    title(strcat('\delta = ', num2str(angle)));
    axis([point(1)-2, point(1)+2, point(2)-2, point(2)+2]);
    grid on;
    legend([mostOptimalPlot, p1, p2], {'Оптимальная траектория', '-\psi(t_1)', 'n'});
end

function res = fcn(t, x, eps)
    if finishSet([x(1) + eps; x(2) + t])
        res = 1;
    else
        res = -1;
    end
end