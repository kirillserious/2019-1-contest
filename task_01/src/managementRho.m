% Опорная функция множества ограничения
function [value, point] = managementRho (dir, a, b, c)
    x11 = sqrt(b / (a + c));
    x12 = - x11;
    x20 = a*b/(a + c);
    if dir(2) <= 0 && dir(1)^2/(4*a*dir(2)^2) <= x20
        value = dir(1)^2 / (2*a*dir(2)) + dir(1)^2 / (4*a*dir(2));
        point = [dir(1)/(2*a*dir(2)); dir(1)^2/(4*a*dir(2)^2)];
    else if dir(2) <= 0 && dir(1)^2/(4*a*dir(2)^2) > x20 && dir(1) < 0
        value = x12 * dir(1) + x20 * dir(2);
        point = [x12; x20];
    else if dir(2) <= 0 && dir(1)^2/(4*a*dir(2)^2) > x20 && dir(1) > 0
        value = x11 * dir(1) + x20 * dir(2);
        point = [x11; x20];
    else if dir(2) >= 0 && b - dir(1)^2/(4*c*dir(2)^2) >= x20
        value = dir(1)^2/(2*c*dir(2)) + (dir(1)^2/(4*c*dir(2)^2))*dir(2);
        point = [dir(1)/(2*c*dir(2)); dir(1)^2/(4*c*dir(2)^2)];
    else if dir(2) >= 0 && b - dir(1)^2/(4*c*dir(2)^2) < x20 && dir(1) < 0
        value = x12*dir(1) + x20*dir(2);
        point = [x12; x20];
   else %dir(2) >= 0 && b - dir(1)^2/(4*c*dir(2)^2) < x20 && dir(1) > 0
        value = x11*dir(1) + x20*dir(2);
        point = [x11; x20];       
    end
    end
    end
    end
    end
end