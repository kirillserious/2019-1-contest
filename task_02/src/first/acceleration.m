%
% Режимы акселерации и отсутствия торможения
%
function [uMat, timeVec, value] = acceleration(A, B, T, alpha, k1, modeStr, colorStr)
    if nargin < 7
        modeStr = 'default';
    end
    
    psi10 = (k1 + 1) * B;
    
    timeVec = 0:0.01:T;
    psi2Vec = A .* exp((k1+1).*timeVec) + B;
    
    u1Vec = psi2Vec - alpha/2;
    u2Vec = k1 .* ones(1, numel(psi2Vec));
    uMat = [u1Vec', u2Vec'];

    value = trapz(timeVec, u1Vec.^2 + alpha.*abs(u1Vec));
    
    if strcmp(modeStr, 'draw')
    % Построим траектории
        x1Vec   = 1 / (k1 + 1) .* ...
                  (-A + A           .* cosh((k1+1).*timeVec) + ...
                  (B - 1/2)    .* (timeVec - 1/(k1+1)*(1 - exp(-(k1+1).*timeVec))));
        x2Vec   = 1 / (k1 + 1) .* ...
                  (A           .* sinh((k1+1).*timeVec) + ...
                  (B - 1/2)    .* (1 - exp(-(k1+1).*timeVec)));
        plot(x1Vec, x2Vec, colorStr);
    end
end


