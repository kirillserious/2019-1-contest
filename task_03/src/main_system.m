% Основная система для подстановки в ode45
%
% Arguments
% t -- параметр ode45
% x -- параметр ode45
% u [scalar] -- управление

function dxdt = main_system(t, x, u)
    dxdt = [x(2); u - x(1) - 3*sin(3*(x(1).^3)) - x(1).*x(2)];
end