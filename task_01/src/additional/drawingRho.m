% Рисует множество по опорной функции
function drawingRho(rho, N, color)
    N = N + 1;
    pointVec = zeros(N, 2);
    angle = linspace(0, 2* pi, N);
    direction = [transpose(cos(angle)), transpose(sin(angle))];
    for i = 1 : N
        [~, pointVec(i,:)] = rho(direction(i,:));
    end 
    plot(pointVec(:, 1), pointVec(:, 2), strcat(color, 'p'));
    hold on;
    maxVal = norm(max(pointVec));
    pointVec(isnan(pointVec)) = direction(isnan(pointVec)) .* maxVal;
    
    grid on;
    if nargin < 3
        fill([pointVec(:, 1); pointVec(1, 1)], [pointVec(:, 2); pointVec(1, 2)], 'r');
    else
        fill([pointVec(:, 1); pointVec(1, 1)], [pointVec(:, 2); pointVec(1, 2)], color);
    end
    hold off;
    
end