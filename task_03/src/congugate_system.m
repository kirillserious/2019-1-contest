% Сопряженная система для подстановки в ode45
%
% Arguments
% t   -- параметр ode45
% psi -- параметр ode45
% xes     [N, 2]   -- решение основной системы
% x_times [N]      -- время, соответсвующее решению основной системы

function dpsidt = congugate_system (t, psi, xes, x_times)
    % Найдем ближайшее доступное время к принимаемому t
    [~, index] = min(abs(x_times - t));
    % Положим x вектором в тот момент
    x = transpose(xes(index, :));
    % Результат
    dpsidt = [psi(2) + 27*psi(2).*cos(3*(x(1).^3)).*(x(1)^2) + psi(2).*x(2); ...
        - psi(1) + psi(2).*x(1)];
end
