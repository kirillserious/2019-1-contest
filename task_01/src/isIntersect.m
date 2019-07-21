%   Проверяет пересекаются ли начальное и целевое множества
function is = isIntersect()
    is = 0;

    exts = ext_x1();
    for i = 1:size(exts, 1)
        if startSet(exts(i,:)')
            is = 1;
        end
    end
    
    global r p;
    for i = linspace(0, 2*pi, 20)
        dir = [sin(i); cos(i)];
        point = r * dir + p; 
        if finishSet(point)
            is = 1;
        end
    end
    
    if is
        msgbox('Множества пересекаются');
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