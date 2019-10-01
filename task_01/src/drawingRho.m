%  Рисует ограниченное множество по опорной функции
%  Arguments:
%      rho    @(dir)->[value, point] -- опорная функция множества
%      N      scalar                 -- число точек аппроксимации
%      color  string = 'r'           -- цвет рисунка
%  Returns:
%      filledPlt    plot             -- график закрашенной области
function filledPlt = drawingRho(rho, N, color)
    if nargin < 3
        color = 'r';
    end
    N = N + 1;
    pointVec = zeros(N, 2);
    angle = linspace(0, 2* pi, N);
    direction = [transpose(cos(angle)), transpose(sin(angle))];
    for i = 1 : N
        [~, pointVec(i,:)] = rho(direction(i,:));
    end
    % Рисовало пентаграмами точки аппроксимации
     plot(pointVec(:, 1), pointVec(:, 2), strcat(color, 'p'));
     hold on;
    maxVal = norm(max(pointVec));
    pointVec(isnan(pointVec)) = direction(isnan(pointVec)) .* maxVal;
    filledPlt = fill([pointVec(:, 1); pointVec(1, 1)], [pointVec(:, 2); pointVec(1, 2)], color);
end

