% Опорная функция начального множества
function [value, point] = startRho(dir, r, x0)
    value = dir(1)*x0(1) + dir(2)*x0(2) + r*sqrt(dir(1)^2 + dir(2)^2);
    point = [x0(1) + r*dir(1); x0(2) + r*dir(2)];
end

