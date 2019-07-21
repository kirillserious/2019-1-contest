% Опорная функция начального множества
function [value, point] = startRho(dir, radius, x0)
    global r p;
    if nargin < 3
        radius = r;
        x0 = p;
    end
        
    value = dir(1)*x0(1) + dir(2)*x0(2) + radius*sqrt(dir(1)^2 + dir(2)^2);
    point = [x0(1) + radius*dir(1); x0(2) + radius*dir(2)];
end

