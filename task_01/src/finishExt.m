% Находит крайние точки целевого множества
%
% Inputs
%   G    (m, 2) = gMat -- матрица G, как в условии
%   g    (m, 1) = gVec -- вектор g, как в условии
% Returns
%   exts    (k, 2) -- крайние точки множества X_1
function exts = finishExt (G, g, eps)
    % Если параметры не заданы, берем глобальные переменные
    global gMat gVec;
    if nargin < 2    
        G = gMat;
        g = gVec;
    end
    if nargin < 3
        eps = 0.0001;
    end
    
    exts = [];
    m = size(G, 1);    
    for i = 1 : m-1
        for j = i+1 : m
            % Проверим на непересечение
            normal_i = transpose(G(i, :));
            normal_j = transpose(G(j, :));
            normal_i = normal_i ./ norm(normal_i);
            normal_j = normal_j ./ norm(normal_j);
            if (max(normal_i ~= normal_j)) && (max(normal_i ~= -normal_j))
                A =  [G(i, :); G(j, :)];
                b = -[g(i, 1); g(j, 1)];
                x = A \ b;
                if finishSet(x, eps, G, g)
                    % Проверим, не повторяется ли точка
                    flag = 0;
                    for k = 1:size(exts, 1)
                        if min(x == exts(k, :)')
                            flag = 1;
                        end
                    end
                    % Добавим точку в множество
                    if ~flag
                        exts = [exts; x'];
                    end
                end
            end
        end
    end
end

