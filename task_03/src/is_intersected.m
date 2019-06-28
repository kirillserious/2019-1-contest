% Определяет пересекаются ли отрезки AB и CD
function is = is_intersected (a, b, c, d)
    is = intersect_1(a(1), b(1), c(1), d(1)) && ...
        intersect_1(a(2), b(2), c(2), d(2)) && ...
        area(a, b, c) * area(a, b, d) <= 0 && ...
        area(c, d, a) * area(c, d, b) <= 0;
end

function result = area(a, b, c)
    result = (b(1) - a(1)) * (c(2) - a(2)) - (b(2) - a(2)) * (c(1) - a(1));
end

function result = intersect_1(a, b, c, d)
    if a > b
        tmp = a;
        a = b;
        b = tmp;
    end
    if c > d
        tmp = c;
        c = d;
        d = tmp;
    end
    result = (max(a, c) <= min(b, d));
end
