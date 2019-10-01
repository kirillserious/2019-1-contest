function [is, controlMat, timeVec, value, point] = weak(t1, xi, T, L, alpha, k1, modeStr, colorStr)
    if nargin < 8
        modeStr = 'default';
    end
    
    % Вычислим x_1^1 и x_2^1
    x21 = xi / (exp((k1+1)*(t1-T)));
    x11 = L - (x21 - xi)/(k1 + 1);
    
    % Вычислим A и B
    AMat = 1/(k1+1) .* ...
            [ cosh((k1+1)*t1), t1 - 1/(k1+1)*(1 - exp(-(k1+1)*t1)) ; ...
              sinh((k1+1)*t1), 1 - exp(-(k1+1)*t1)];
    fVec = [x11; x21];
    
    resVec = AMat \ fVec;
    A = resVec(1);
    B = resVec(2) + 1/2;
    
    % Проверим A<0 и t2<T
    if A > 0 || abs(A*exp((k1 + 1)*t1) + B) - alpha/2 > 0.001
        is = 0;
        controlMat = 0;
        timeVec = 0;
        value = 0;
        point = 0;
        return
    end
    t2 = log(-B / A) / (k1 + 1);
    if t2 > T
        is = 0;
        controlMat = 0;
        timeVec = 0;
        value = 0;
        point = 0;
        return
    end
    
    % Построим управление
    point = fVec;
    
    timeVecBefore = 0:0.01:t1;
    timeVecAfter  = t1:0.01:T;
    timeVec       = [timeVecBefore, timeVecAfter];
    
    psi2VecBefore = A .* exp((k1+1).*timeVecBefore) + B;
    
    control1Vec = [(psi2VecBefore - alpha/2), zeros(1, numel(timeVecAfter))];
    control2Vec = k1 .* ones(1, numel(timeVec));
    controlMat = [control1Vec', control2Vec'];
    
    value = trapz(timeVec, control1Vec.^2 + alpha.*abs(control1Vec));
      
    % Нарисуем
    if strcmp(modeStr, 'draw')
        x1Vec   = 1 / (k1 + 1) .* ...
                  (A           .* cosh((k1+1).*timeVecBefore) + ...
                  (B - 1/2)    .* (timeVecBefore - 1/(k1+1)*(1 - exp(-(k1+1).*timeVecBefore))));
        x2Vec   = 1 / (k1 + 1) .* ...
                  (A           .* sinh((k1+1).*timeVecBefore) + ...
                  (B - 1/2)    .* (1 - exp(-(k1+1).*timeVecBefore)));
        plot(x1Vec, x2Vec, colorStr);
        plot(point(1), point(2), '*r');
        x1Vec = x11 + x21 / (k1 + 1) .* (1 - exp((k1+1).*(t1-timeVecAfter)));
        x2Vec = x21.*exp((k1+1).*(t1-timeVecAfter));
        plot(x1Vec, x2Vec, 'b');
    end
end

