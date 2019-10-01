%
% Режимы акселерации и отсутствия торможения
%
function [is, uMat, xMat, timeVec, value] = acceleration(T, L, S, eps, alpha, k1, k2, N, modeStr)
    % Закинем стандартные начала
    is = 0;
    uMat = [];
    xMat = [];
    timeVec = 0:0.01:T;
    value = inf;
    
    if nargin < 9
        modeStr = 'default';
    end
    
    % Нарисуем начальное и конечное множества
    if strcmp(modeStr, 'draw')
        figure;
        plot(0, 0, '*r');
        hold on, grid on;
        plot([L, L], [S-eps, S+eps], 'r');
        title('Траектории');
        xlabel('x_1');
        ylabel('x_2');
        goodPlt = plot(NaN, NaN, 'g');
        bestPlt = plot(NaN, NaN, 'b');
        legend([goodPlt, bestPlt], 'Удачные траектории', 'Лучшая траектория');
    end
    
    % Работаем с разбиением по xi
        % Шаг разбиения
        step = 2*eps / N;
        % Матрица для решения СЛАУ
        AMat = 1/(k1+1) .* ...
            [ (cosh((k1+1)*T) - 1)/(k1+1), T - 1/(k1+1)*(1 - exp(-(k1+1)*T)) ; ...
              sinh((k1+1)*T),              1 - exp(-(k1+1)*T)];
        for xi = S-eps : step : S+eps
            % Решим СЛАУ относительно A и (B - alpha/2)
            fVec = [L; xi];
            resVec = AMat \ fVec;
            A = resVec(1);
            B = resVec(2) + alpha/2;
            
            % Проверим режим на реализуемость
            if A + B >= alpha/2 ...
                    && (A > 0 ...                                      % Режим акселерации
                    || (A < 0 && 1/(k1 + 1)*log((alpha/2 - B)/A) > T)) % Режим отсутствия торможения
                is = 1;
                u1Vec = A .* exp((k1+1).*timeVec) + B - alpha/2;
                u2Vec = k1 .* ones(1, numel(timeVec));
                x1Vec   = 1 / (k1 + 1) .* ...
                        (-A./(k1+1) + A./(k1+1).* cosh((k1+1).*timeVec) + ...
                        (B - alpha/2)    .* (timeVec - 1/(k1+1)*(1 - exp(-(k1+1).*timeVec))));
                x2Vec   = 1 / (k1 + 1) .* ...
                        (A           .* sinh((k1+1).*timeVec) + ...
                        (B - alpha/2)    .* (1 - exp(-(k1+1).*timeVec)));
                % Нарисуем траекторию
                if strcmp(modeStr, 'draw')
                    plot(x1Vec, x2Vec, 'g');
                end
                
                % Проверим на наилучшесть
                curValue = trapz(timeVec, u1Vec.^2 + alpha.*abs(u1Vec));
                if curValue < value
                    uMat = [u1Vec', u2Vec'];
                    xMat = [x1Vec', x2Vec'];
                    value = curValue;
                end
            end
        end
        
    % Нарисуем остальное
    if is && strcmp(modeStr, 'draw')
        % Рисуем оптимальную траекторию
        plot(xMat(:,1), xMat(:, 2), 'b');
        title('Траектории');
        xlabel('x_1');
        ylabel('x_2');
        goodPlt = plot(NaN, NaN, 'g');
        bestPlt = plot(NaN, NaN, 'b');
        legend([goodPlt, bestPlt], 'Удачные траектории', 'Лучшая траектория');
        % Рисуем оптимальное управление
        figure;
        plot(timeVec, uMat(:, 1));
        xlabel('t');
        ylabel('u_1');
        figure;
        plot(timeVec, uMat(:, 2));
        xlabel('t');
        ylabel('u_2');
    end

end