function [is, controlMat, timeVec, value, points] = strong(t2, xi, T, L, alpha, k1, k2, modeStr, colorStr)
    if nargin < 9
        modeStr = 'default';
    end
    
    % Вычислим x_1^2 и x_2^2
    x22 = xi / (exp((k2+1)*(t2-T)));
    x12 = L - (x22 - xi)/(k2 + 1);
    
    timeVecAfter = t2:0.01:T;
    x1Vec = x12 + x22 / (k2 + 1) .* (1 - exp((k2+1).*(t2-timeVecAfter)));
    x2Vec = x22.*exp((k2+1).*(t2-timeVecAfter));
    plot(x1Vec, x2Vec, 'b');
    plot(x1Vec(end), x2Vec(end), '*');
    plot()
    
    %weakFcn = @(eta, xi) eta .* (x12 + xi/(k1+1)) - xi .* exp((k1+1).*t2)/(k1+1) ...
    %            - xi*exp((k1+1).*t2) * (2.*eta.*eta.*log(eta) - eta.*eta - 2.*eta + 1) ...
    %            ./ ((eta-1).*(eta-1));
    %curWeakFcn = @(t1) weakFcn(exp((k1+1)*t1), x22);
    %        
    %firstT1 = fzero(curWeakFcn, 0.01);
    %secondT1 = fzero(curWeakFcn, t2);
    %
    value = inf;
    is = 0;
    controlMat = 0;
    timeVec = 0;
    value = 0;
    points = 0;
    %if ~isnan(firstT1) && firstT1 > 0 && firstT1 < T
    %    [prevIs, controlMat, timeVec, prevValue, point] = weak(firstT1, x22, t2, x12, alpha, k1, modeStr, colorStr);
    %    if prevIs
    %        timeVecPlus = t2:0.01:T;
    %        timeVec     = [timeVec, timeVecPlus];
    %        controlMatPlus = [0.*ones(numel(timeVecPlus), 1), k2.*ones(numel(timeVecPlus), 1)];
    %        controlMat = [controlMat; controlMatPlus];
    %        value = prevValue;
    %        points = [point; [x12, x22]];
    %        is = 1;
    %    end
    %end
    %if ~isnan(secondT1) && secondT1 > 0 && secondT1 < T
    %        [prevIs, controlMat, timeVec, prevValue, point] = weak(secondT1, x22, t2, x12, alpha, k1, modeStr, colorStr);
    %        if prevIs && prevValue < value
    %            timeVecPlus = t2:0.01:T;
    %            timeVec     = [timeVec, timeVecPlus];
    %            controlMatPlus = [0.*ones(numel(timeVecPlus), 1), k2.*ones(numel(timeVecPlus), 1)];
    %            controlMat = [controlMat; controlMatPlus];
    %            value = prevValue;
    %            points = [point; [x12, x22]];
    %            is = 1;
    %        end
    %end
    
    %if strcmp(modeStr, 'draw') && is
        
    %end
end

