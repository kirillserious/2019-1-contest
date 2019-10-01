% Режим интенсивного торможения

function [is, uMat, xMat, timeVec, value] = intensive(T, L, S, eps, alpha, k1, k2, N, modeStr)
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
    
    % Работаем с разбиением по t1 и t2
        % Шаг разбиения
        step = T / N;
        for t1 = step:step:T-2*step
            for t2 = t1+step:step:T-step
                % Найдём psi10 и psi20
                AMat = [exp((k1+1).*t1), 1;
                        exp((k1+1).*t2), 1];
                fVec = [alpha/2; 0];
                resVec = AMat \ fVec;
                A = resVec(1);
                B = resVec(2);
                
                t3 = t2 + 1/(k2+1)*log(((k2+1)/(2*B*(k1+1)))+1);
                
                if A+B < alpha/2 || A > 0 || t3 < t2 || t3 > T
                    continue;
                end
                % Найдём x11 и x21
                x11   = 1 / (k1 + 1) .* ...
                        (-A/(k1+1) + A/(k1+1) .* cosh((k1+1).*t1) + ...
                        (B - alpha/2)    .* (t1- 1/(k1+1)*(1 - exp(-(k1+1).*t1))));
                x21   = 1 / (k1 + 1) .* ...
                        (A           .* sinh((k1+1).*t1) + ...
                        (B - alpha/2)    .* (1 - exp(-(k1+1).*t1)));
                % Найдём x12 и x22
                x12 = x11 + x21 / (k1 + 1) .* (1 - exp((k1+1).*(t1-t2)));
                x22 = x21.*exp((k1+1).*(t1-t2));
                % Найдем x13 и x23
                x13 = x12 + x22 / (k2+1) .* (1 - exp((k2+1)*(t2-T)));
                x23 = x22 * exp((k2+1)*(t2 - T));
                % Найдем x1T и x2T
                x2T = x23*exp((k2+1)*(t3-T)) + ...
                    1/(k2+1)*(((k1+1)/(k2+1)*B + alpha/2)*(1 - exp((k2+1)*(t3-T))) - ...
                    (k1+1)/(k2+1)*B/2*(exp((k2+1)*(T-t2)) - exp((k2+1)*(2*t3-T-t2))));
                x1T = x13 + x23/(k2+1)*(1 - exp((k2+1)*(t3-T))) + ...
                    1/(k2+1)*(((k1+1)/(k2+1)*B + alpha/2)*(T-t3-1/(k2+1)*(1 - exp((k2+1)*(t3-T)))) - ...
                    (k1+1)/(k2+1)*B/2/(k2+1)*(exp((k2+1)*(T-t2)) -2*exp((k2+1)*(t3-t2)) + exp((k2+1)*(2*t3-T-t2))));
                
                % Проверим на реализуемость
                if abs(x1T - L) < 0.001 && x2T >= S - eps - 0.001 && x2T <= S + eps + 0.001                    
                    is = 1;
                    ttt = 0:step:t1;
                    u1Vec = A*exp((k1+1)*ttt) + B - alpha/2;
                    u2Vec = k1 * ones(1, numel(ttt));
                    x1Vec   = 1 / (k1 + 1) .* ...
                            (-A/(k1+1) + A/(k1+1)           .* cosh((k1+1).*ttt) + ...
                            (B - alpha/2)    .* (ttt - 1/(k1+1)*(1 - exp(-(k1+1).*ttt))));
                    x2Vec   = 1 / (k1 + 1) .* ...
                            (A           .* sinh((k1+1).*ttt) + ...
                            (B - alpha/2)    .* (1 - exp(-(k1+1).*ttt)));
                    allT = ttt;
                    ttt = t1:step:t2;
                    u1Vec = [u1Vec, 0*ones(1, numel(ttt))];
                    u2Vec = [u2Vec, k1*ones(1, numel(ttt))];
                    x1Vec = [x1Vec, x11 + x21 / (k1 + 1) .* (1 - exp((k1+1).*(t1-ttt)))];
                    x2Vec = [x2Vec, x21.*exp((k1+1).*(t1-ttt))];
                    allT = [allT, ttt];
                    ttt = t2:step:t3;
                    u1Vec = [u1Vec, 0*ones(1, numel(ttt))];
                    u2Vec = [u2Vec, k2*ones(1, numel(ttt))];
                    x1Vec = [x1Vec, x12 + x22 / (k2+1) .* (1 - exp((k2+1)*(t2-ttt)))];
                    x2Vec = [x2Vec, x22 * exp((k2+1)*(t2 - ttt))];
                    allT = [allT, ttt];
                    ttt = t3:step:T;
                    u1Vec = [u1Vec, (k1+1)/(k2+1)*B*(1 - exp((k2+1)*(ttt-t2))) + alpha/2];
                    u2Vec = [u2Vec, k2*ones(1, numel(ttt))];
                    x1Vec = [x1Vec, ...
                            x13 + x23/(k2+1)*(1 - exp((k2+1)*(t3-ttt))) + ...
                            1/(k2+1)*(((k1+1)/(k2+1)*B + alpha/2)*(ttt-t3-1/(k2+1)*(1 - exp((k2+1)*(t3-ttt)))) - ...
                            (k1+1)/(k2+1)*B/2/(k2+1)*(exp((k2+1)*(ttt-t2)) -2*exp((k2+1)*(t3-t2)) + exp((k2+1)*(2*t3-ttt-t2))))];
                    x2Vec = [x2Vec, ...
                            x23.*exp((k2+1).*(t3-ttt)) + ...
                            1./(k2+1).*(((k1+1)./(k2+1)*B + alpha/2)*(1 - exp((k2+1)*(t3-ttt))) - ...
                            (k1+1)/(k2+1)*B/2*(exp((k2+1)*(ttt-t2)) - exp((k2+1)*(2*t3-ttt-t2))))];
                    allT = [allT, ttt];
                    if strcmp(modeStr, 'draw')
                        plot(x1Vec, x2Vec, 'g');
                    end
                    % Проверим на наилучшесть
                    curValue = trapz(allT, u1Vec.^2 + alpha.*abs(u1Vec));
                    if curValue < value
                        uMat = [u1Vec', u2Vec'];
                        xMat = [x1Vec', x2Vec'];
                        timeVec = allT;
                        value = curValue;
                    end
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