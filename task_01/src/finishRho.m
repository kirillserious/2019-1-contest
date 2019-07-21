function [value, point] = finishRho(l, exts, eps)
    if nargin < 5
        eps = 0.001;
    end
    
    if size(exts, 1) == 0
        value = nan;
        point = nan;
        return
    end
    [value, index] = max(exts(:, 1) .* l(1) + exts(:, 2) .* l(2));
    if set_x1(exts(index, :)' + eps*l)
        value = nan;
        point = nan;
    else
        point = exts(index, :)';
    end
end