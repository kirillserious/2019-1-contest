%  Множество X_1
%  Arguments:
%    x     [1, 2]
%    G     [m, 2]
%    g     [m, 1]
function result = set_x1 (x, eps)
    global G g;
    if nargin < 2
        eps = 0.001;
    end
    result = G * x + g <= eps;
end

