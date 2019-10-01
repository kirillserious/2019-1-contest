%  Проверяет, попала ли точка в целевое множество
%  Arguments:
%    x     [1, 2]          -- проверяемая точка
%    eps   scalar  = 0.001 -- погрешность проверки
%    G     [m, 2]  = gMat  -- матрица G, как в задании
%    g     [m, 1]  = gVec  -- вектор g, как в задании
%  Returns:
%    is    scalar  -- 1 принадлежит, 0 не принадлежит 
function is = finishSet (x, eps, G, g)
    % Если не матрицы не заданы, берем из глобальных переменных
    global gMat gVec;
    if nargin < 4
        G = gMat;
        g = gVec;
    end
    % Значение eps по умолчанию
    if nargin < 2
        eps = 0.001;
    end
    % Результат
    is = (max(G * x + g) <= eps);
end