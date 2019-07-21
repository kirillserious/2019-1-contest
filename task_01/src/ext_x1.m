% Находит крайние точки множества X_1
%
% Inputs
%   G    (m, 2) -- необяз. -- матрица G, как в условии
%   g    (m, 1) -- необяз. -- вектор g, как в условии
% Returns
%   exts    (k, 2) -- крайние точки множества X_1
function exts = ext_x1 (G, g)
    % Если параметры не заданы, берем глобальные переменные
    global gMat gVec;
    if nargin < 2    
        G = gMat;
        g = gVec;
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
                if set_x1(x, 0.001, G, g)
                    % Проверим, не повторяется ли точка
                    flag = 0;
                    for k = 1:size(exts, 1)
                        if max(x == exts(k, :)')
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

