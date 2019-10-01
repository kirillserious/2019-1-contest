%   Проверяет пересекаются ли начальное и целевое множества
function is = isIntersect()
    is = 0;

    exts = finishExt();
    for i = 1:size(exts, 1)
        if startSet(exts(i,:)')
            is = 1;
        end
    end
    
    global r p;
    
    for i = linspace(0, 2*pi, 20)
        dir = [sin(i); cos(i)];
        
        
        point = r .* dir + p';
        
        if finishSet(point)
            is = 1;
        end
    end
    
    if is
        figure('Name', 'Пересечение множеств');
        i = linspace(0, 2*pi, 40);
        i = [sin(i'), cos(i')];
        i = [r .* i(:,1) + p(1), r .* i(:, 2) + p(2)];
        plot(i(:, 1), i(:, 2), 'g');
        hold on;
        drawFinishSet(p(1) - r - 5, p(2) - r - 5, p(1) + r + 5, ... 
                p(2) + r + 5, 'as_line');
        axis([p(1) - r - 4, p(1) + r + 4, p(2) - r - 4, ... 
                p(2) + r + 4]);
        grid on;
        legend('Граница начального множества', 'Граница целевого множества');
        title('Множества пересекаются');
    else
        msgbox('Множества не пересекаются');
    end
end

function is = startSet(x)
    global r p;
    
    if (x(1) - p(1))^2 + (x(2) - p(2))^2 <= r
        is = 1;
    else
        is = 0;
    end
end

function is = finishSet(x)
    global gMat gVec;
    
    is = (gMat * x + gVec <= 0);
end