function [value, point] = finishRho(l, exts, eps)
    if nargin < 3
        eps = 0.001;
    end
    
    if size(exts, 1) == 0
        value = nan;
        point = nan;
        return
    end
    [value, index] = max(exts(:, 1) .* l(1) + exts(:, 2) .* l(2));
    if finishSet(exts(index, :)' + eps*l, eps)
        value = nan;
        point = nan;
    else
        point = exts(index, :)';
    end
end