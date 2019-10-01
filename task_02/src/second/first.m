function first(T, L, S, eps, alpha, k1, k2, N)
    % Решение при первом типе ограничений на управление
 
    % По умолчанию N = 1000
    if nargin < 8
        N = 1000;
    end
    
    % Закинем стандартные начала
    is = 0;
    uMat = [];
    xMat = [];
    timeVec = [];
    value = inf;
    
    disp('Анализ режимов акселерации и отсутствия торможения ...');
    [cis, cuMat, cxMat, ctimeVec, cvalue] = acceleration(T, L, S, eps, alpha, k1, k2, N);
    if cis && cvalue < value
        is = cis;
        uMat = cuMat;
        xMat = cxMat;
        timeVec = ctimeVec;
        value = cvalue;
    end
    
    disp('Анализ режима слабого торможения ...');
    if alpha == 0
        [cis, cuMat, cxMat, ctimeVec, cvalue] = weakZeroFirst(T, L, S, eps, alpha, k1, k2, N);
        if cis && cvalue < value
            is = cis;
            uMat = cuMat;
            xMat = cxMat;
            timeVec = ctimeVec;
            value = cvalue;
        end
    else
        [cis, cuMat, cxMat, ctimeVec, cvalue] = weakAlpha(T, L, S, eps, alpha, k1, k2, N);
        if cis && cvalue < value
            is = cis;
            uMat = cuMat;
            xMat = cxMat;
            timeVec = ctimeVec;
            value = cvalue;
        end
        
        disp('Анализ режима сильного торможения ...');
        [cis, cuMat, cxMat, ctimeVec, cvalue] = strong(T, L, S, eps, alpha, k1, k2, N);
        if cis && cvalue < value
            is = cis;
            uMat = cuMat;
            xMat = cxMat;
            timeVec = ctimeVec;
            value = cvalue;
        end
    end
   
    if ~is
        disp('Траектории не найдены');
    else
        disp('Всё готово!');
        figure;
        plot(0, 0, '*r');
        hold on, grid on;
        plot([L, L], [S-eps, S+eps], 'r');
        title('Траектории');
        xlabel('x_1');
        ylabel('x_2');
        bestPlt = plot(xMat(:,1), xMat(:,2), 'b');
        legend(bestPlt, 'Лучшая траектория');
    end
end

