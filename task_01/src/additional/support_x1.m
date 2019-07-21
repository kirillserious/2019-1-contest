function rho = support_x1(l, eps)
    global exts G g;
    if nargin < 5
        eps = 0.001;
    end
    
    [value, index] = max(exts * l);
    if set_x1(exts(index, :)' + eps*l, G, g)
        rho = nan;
    else
        rho = value;
    end
end

