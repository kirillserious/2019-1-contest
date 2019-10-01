% Режим слабого торможения при alpha = 0 для первого ограничения на
% управление
%

function [is, uMat, xMat, timeVec, value] = weakZeroSecond(T, L, S, eps, k1, k2, N, modeStr)
    % Закинем стандартные начала
    is = 0;
    uMat = [];
    xMat = [];
    timeVec = 0:0.01:T;
    value = inf;
    
    if nargin < 8
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
        goodPlt = plot(NaN, NaN, 'b');
        bestPlt = plot(NaN, NaN, 'g');
        legend([goodPlt, bestPlt], 'Удачные траектории', 'Лучшая траектория');
    end
    
    % Работаем с разбиением по xi и по t1
    xiStep = 2 * eps / N;
    tStep  = T  / N;
    for xi = S-eps : xiStep : S+eps
        for t1 = tStep : tStep : T-tStep
            % Найдём x11 и x21
            x21 = xi / (exp((k2+1).*(t1 - T)));
            x11 = L - x21.*(1 - exp((k2+1).*(t1 - T)))./(k2+1);
            if x11 < 0 || x21 < 0
                continue;
            end
            % Найдем A и B
            AMat = 1/(k1+1) .* ...
            [ (cosh((k1+1)*t1) - 1)/(k1+1), t1 - 1/(k1+1)*(1 - exp(-(k1+1)*t1)) ; ...
              sinh((k1+1)*t1),              1 - exp(-(k1+1)*t1)];
            fVec = [x11; x21];
            resVec = AMat \ fVec;
            A = resVec(1);
            B = resVec(2);
            
            % Проверим на реализуемость
            t2 = log(-B / A) / (k1+1);
            if A < 0 && (A + B) > 0 && t2 < T && ...
                        abs((A*exp((k1+1)*t1) + B)) < 0.001
                is = 1;
                timeVecBefore = 0:tStep:t1;
                timeVecAfter  = t1:tStep:T;
                psi2VecBefore = A .* exp((k1+1).*timeVecBefore) + B;
                u1Vec = [psi2VecBefore, zeros(1, numel(timeVecAfter))];
                u2Vec = k1 .* ones(1, numel(u1Vec));
                x1Vec   = 1 / (k1 + 1) .* ...
                        (-A./(k1+1) + A./(k1+1).* cosh((k1+1).*timeVecBefore) + ...
                        B    .* (timeVecBefore - 1/(k1+1)*(1 - exp(-(k1+1).*timeVecBefore))));
                x2Vec   = 1 / (k1 + 1) .* ...
                        (A           .* sinh((k1+1).*timeVecBefore) + ...
                        B    .* (1 - exp(-(k1+1).*timeVecBefore)));
                x1Vec = [x1Vec, x11 + x21 / (k2 + 1) .* (1 - exp((k2+1).*(t1-timeVecAfter)))];
                x2Vec = [x2Vec, x21.*exp((k2+1).*(t1-timeVecAfter))];    
                % Нарисуем
                if strcmp(modeStr, 'draw')
                    plot(x1Vec, x2Vec, 'b');
                end
                % Проверим на наилучшесть
                curValue = trapz([timeVecBefore, timeVecAfter], u1Vec.^2);
                if curValue < value
                    uMat = [u1Vec', u2Vec'];
                    xMat = [x1Vec', x2Vec'];
                    timeVec = [timeVecBefore, timeVecAfter];
                    value = curValue;
                end
            end
        end
    end

    % Нарисуем остальное
    if is && strcmp(modeStr, 'draw')
        % Рисуем оптимальную траекторию
        plot(xMat(:,1), xMat(:, 2), 'g');
        title('Траектории');
        xlabel('x_1');
        ylabel('x_2');
        goodPlt = plot(NaN, NaN, 'b');
        bestPlt = plot(NaN, NaN, 'g');
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

