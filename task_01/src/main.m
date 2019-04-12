% Переменные для множества управлений
a = 4;
b = 7;
c = 2;
% Переменные для начального множества
r = a;
p = [-3, -7];
% Переменные для конечного множества
gMat = [0.3, 4; -0.4, -2; 0.2, -2];
gVec = [-10; -3; -4];


figure;
drawingRho(@(dir)startRho(dir, r, p), 100);

hold on;
drawingRho(finishRhoFunc(gMat, gVec), 100);

aMat = @(t) [-1, -2; 3, -4];
bMat = @(t) [1, 2*sin(t); 3, 4];
maxT = 1;


N = 10;
angle = linspace(0, 2*pi, N);
psi0  = [transpose(cos(angle)), transpose(sin(angle))];
tspan = [0, maxT];

hold on;
for i = 1:N
    [~, optimalX0] = startRho(transpose(psi0(i, :)), r, p);
    [tMat, psiMat] = ode45(@(t, psi)psiOdeFun(aMat, t, psi), tspan, transpose(psi0(i, :)));
    [n, ~] = size(tMat);
    optimalManagement = zeros(n, 2);
    for j = 1:n
        psi = transpose(psiMat(j, :));
        % ksi = B.T * psi 
        ksi = transpose(bMat(0)) * psi; 
        [~, optimalManagement(j, :)] = managementRho(ksi, a, b, c);
    end
    
    [tMat, optimalXMat] = ode45(@(t, x)xOdeFun(aMat, bMat, optimalManagement, tMat, t, x), tspan, optimalX0); 
    
    [is, index] = isInFinish(optimalXMat, gMat, gVec);
    if is == 1
        plot(optimalXMat(1:index, 1), optimalXMat(1:index, 2), 'b');
    end
end

axis([-20 20 -20 20]);

function dxdt = xOdeFun (aMat, bMat, managementMat, tVec, t, x)
    tVec = abs(tVec - t);
    index = find(tVec == max(tVec));
    dxdt = aMat(t) * x + bMat(t) * transpose(managementMat(index, :));
end

function dxdt = psiOdeFun (aMat, t, psi)
    dxdt = transpose(aMat(t)) * psi;
end