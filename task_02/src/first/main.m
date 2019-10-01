function main(T, L, S, eps, alpha, k1, k2, N, modeStr)
    if nargin < 9
        modeStr = 'default';
    end

    plot(0, 0, '*g');
    hold on;
    plot([L; L], [S - eps; S + eps], 'r');
    grid on;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                              %
    %  Режимы акселерации и отсутствия торможения  %
    %                                              %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Разобьём отрезок [S-eps, S+eps] на N точек \xi_i, i = 1,N
    xiVec = linspace(S-eps, S+eps, N);
    
    % Для каждой точки \xi_i
        % Матрица для поиска A и B как решение СЛАУ на разбиении целевого
        % множества
        AMat = 1/(k1+1) .* ...
            [ cosh((k1+1)*T), T - 1/(k1+1)*(1 - exp(-(k1+1)*T)) ; ...
              sinh((k1+1)*T), 1 - exp(-(k1+1)*T)];
        for i = 1:N
            % Решим СЛАУ для поиска A и B
            fVec = [L; xiVec(i)]; % Правая часть СЛАУ
            resVec = AMat \ fVec; % Решение СЛАУ
            A = resVec(1);
            B = resVec(2) + 1/2;
            
            if A >= 0 && B > alpha/2
            % Выполняется режим акселерации
                if strcmp(modeStr, 'acc') || strcmp(modeStr, 'acc and non')
                    [uMat, timeVec, value] = acceleration ...
                            (A, B, T, alpha, k1, 'draw', 'b');
                else
                    [uMat, timeVec, value] = acceleration ...
                            (A, B, T, alpha, k1);
                end
            else
                if A < 0 && B > alpha/2 && 1/(k1 + 1)*log((alpha/2 - B)/A) > T
                % Выполняется режим отсутствия торможения
                    if strcmp(modeStr, 'non') || strcmp(modeStr, 'acc and non')
                        [uMat, timeVec, value] = acceleration ...
                                (A, B, T, alpha, k1, 'draw', 'm');
                    else
                        [uMat, timeVec, value] = acceleration ...
                                (A, B, T, alpha, k1);
                    end
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                            %
        %  Режим слабого торможения  %
        %                            %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        weakFcn = @(eta, xi) eta .* (L + xi/(k1+1)) - xi .* exp((k1+1).*T)/(k1+1) ...
                - xi*exp((k1+1).*T) * (2.*eta.*eta.*log(eta) - eta.*eta - 2.*eta + 1) ...
                ./ ((eta-1).*(eta-1));
        for i = 1:N
            curWeakFcn = @(t1) weakFcn(exp((k1+1)*t1), xiVec(i));
            
            firstT1 = fzero(curWeakFcn, 0.01);
            secondT1 = fzero(curWeakFcn, T);
            
            
            if ~isnan(firstT1) && firstT1 > 0 && firstT1 < T
                if strcmp(modeStr, 'weak')
                    weak(firstT1, xiVec(i), T, L, alpha, k1, 'draw', 'b');
                end
            end
            if ~isnan(secondT1) && secondT1 > 0 && secondT1 < T
                if strcmp(modeStr, 'weak')
                    weak(secondT1, xiVec(i), T, L, alpha, k1, 'draw', 'b');
                end
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                             %
        %  Режим сильного торможения  %
        %                             %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Устроим перебор по временам переключения t1 и t2
        for t1 = 0.01:0.01:T-0.02
            for t2 = t1 + 0.01:0.01:T-0.01
                % Найдём psi10 и psi20
                AMat = [exp((k1+1).*t1), 1;
                        exp((k1+1).*t2), 1];
                fVec = [alpha/2; 0];
                resVec = AMat \ fVec;
                A = resVec(1);
                B = resVec(2);
                psi10 = (k1 + 1).*B;
                psi20 = A + B;
                
                if psi20 < alpha/2 || A > 0
                    break;
                end
                % Найдём x11 и x21
                x11   = 1 / (k1 + 1) .* ...
                        (-A + A           .* cosh((k1+1).*t1) + ...
                        (B - 1/2)    .* (t1- 1/(k1+1)*(1 - exp(-(k1+1).*t1))));
                x21   = 1 / (k1 + 1) .* ...
                        (A           .* sinh((k1+1).*t1) + ...
                        (B - 1/2)    .* (1 - exp(-(k1+1).*t1)));
                % Найдём x12 и x22
                x12 = x11 + x21 / (k1 + 1) .* (1 - exp((k1+1).*(t1-t2)));
                x22 = x21.*exp((k1+1).*(t1-t2));
                % Найдем x(T)
                x1T = x12 + x22 / (k2+1) .* (1 - exp((k2+1)*(t2-T)));
                x2T = x22 * exp((k2+1)*(t2 - T));
                if abs(x1T - L) < 0.001 && x2T >= S - eps && x2T <= S + eps
                    if strcmp(modeStr, 'strong')
                        ttt = 0:0.01:t1;
        x1   = 1 / (k1 + 1) .* ...
                  (-A + A           .* cosh((k1+1).*ttt) + ...
                  (B - 1/2)    .* (ttt - 1/(k1+1)*(1 - exp(-(k1+1).*ttt))));
        x2   = 1 / (k1 + 1) .* ...
                  (A           .* sinh((k1+1).*ttt) + ...
                  (B - 1/2)    .* (1 - exp(-(k1+1).*ttt)));
                        plot(x1, x2, 'b');
                        ttt =  t1:0.01:t2;
                        x1 = x11 + x21 / (k1 + 1) .* (1 - exp((k1+1).*(t1-ttt)));
                        x2 = x21.*exp((k1+1).*(t1-ttt));
                        plot(x1, x2, 'b');
                        ttt = t2:0.01:T;
                        x1 = x12 + x22 / (k2+1) .* (1 - exp((k2+1)*(t2-ttt)));
                        x2 = x22 * exp((k2+1)*(t2 - ttt));
                        plot(x1, x2, 'b');
                    end
                end
            end
        end
end
