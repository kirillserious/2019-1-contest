% Функция reachset как в задании
%
% Arguments
%   alpha     [scalar] -- значение управления
%   t         [scalar] -- время
%   draw_mode [str]    -- режим рисования (необяз.)
% Returns
%   xes      [N, 2] -- конечные точки траекторий
%   switches [M, 2] -- точки линий переключения
function [xes, switches] = reachset(alpha, t, mode)
    % Проверяем режим рисования траекторий
    if nargin < 3 || ~strcmp(mode, 'draw')
        mode = 'default';
    end
    
    switches = [];
    xes = [];
    if strcmp(mode, 'draw')
        figure;
        hold on;
        grid on;
    end
    
    [xes_part, switches_part] = x_switch(0, t, alpha, mode);
    xes      = cat(1,      xes,      xes_part);
    switches = cat(1, switches, switches_part);
    
    [xes_part, switches_part] = x_switch(1, t, alpha, mode);
    xes      = cat(1,      xes,      xes_part);
    switches = cat(1, switches, switches_part);
    
    % Удалим самопересечения из "границы"
    [~, ind] = min(xes(:, 2));
    xes = cat(1, xes(ind:end,:), xes(1:ind-1, :));
   
    n = 4;
    while (n < size(xes, 1))
        k = 2;
        while k < n - 2
            if is_intersected(xes(n-1,:), xes(n,:), xes(k-1,:), xes(k,:))
                
                xes = cat(1, xes(1:k-1, :), xes(n:end, :));
                n = n - (n - k);
                break;
            end
            k = k + 1;
        end
        n = n + 1;  
    end
    
    % Сделаем из точек линий переключения подобие линии
    [~, ind] = sort(switches(:, 1));
    switches = switches(ind, :);
    
    % Альтернативный способ, по-моему, работает хуже
    %
    %[~, ind] = min(switches(:, 1));
    %tmp = switches(1, :);
    %switches(1, :) = switches(ind, :);
    %switches(ind, :) = tmp;
    %n = size(switches, 1);
    %for i = 1 : n-2
    %    [~, ind] = min((switches(i+1:n, 1) - switches(i, 1)).^2 + ...
    %        (switches(i+1:n, 2) - switches(i, 2)).^2);
    %    tmp = switches(i+1, :);
    %    switches(i+1, :) = switches(i+ind, :);
    %    switches(i+ind, :) = tmp;
    %end
    
    if strcmp(mode, 'draw')
        xlabel('x_1');
        ylabel('x_2');
        ax = gca;
        ax.ColorOrderIndex = 1;
        p1 = plot([NaN, NaN]);
        ax.ColorOrderIndex = 2;
        p2 = plot([NaN, NaN], '*');
        ax.ColorOrderIndex = 3;
        p3 = plot([NaN, NaN], '*');
        %legend('', 'Оптимальные траектории', 'Точки переключения', 'Конечные точки');
        legend([p1, p2, p3], {'Оптимальные траектории', 'Точки переключения', 'Конечные точки'});
        hold off;
    end
end


% Считает траектории
%
% Arguments
%   mode      [scalar] -- начальная система (1 - положительная, 0 - отрицательная)
%   t_end     [scalar] -- конечное время
%   alpha     [scalar] -- значение управления
%   draw_mode [str]    -- режим рисования
%
% Returns
%   x_ends   [N, 2] -- конечные точки траекторий
%   switches [M, 2] -- точки линий переключения
function [x_ends, switches] = x_switch(mode, t_end, alpha, draw_mode)
    x_ends   = [];
    switches = [];
    
    if mode
        odefcn = @(t, x) main_system(t, x, alpha);
        psi_start = [ 1; 0];
    else
        odefcn = @(t, x) main_system(t, x, -alpha);
        psi_start = [ -1; 0];
    end
    
    options = odeset('Events', @event_fcn);
    [times, xes, ~, ~, ~] = ode45(odefcn, [0 t_end], [0; 0], options);
    
    for i = 2:numel(times)
        x_start = transpose(xes(i, :));
        t_start = times(i);
        [x_end, psi_switches] = psi_switch(~mode, t_start, t_end, x_start, psi_start, alpha, draw_mode);
        
        if psi_switches
            switches = cat(1, switches, psi_switches);
            if strcmp(draw_mode, 'draw')
                ax = gca;
                ax.ColorOrderIndex = 2;
                plot(psi_switches(:, 1), psi_switches(:, 2), '*');
            end
        end
        
        x_ends = cat(1, x_ends, transpose(x_end));
        if strcmp(draw_mode, 'draw')
            ax = gca;
            ax.ColorOrderIndex = 3;
            plot(x_end(1), x_end(2), '*');
        end
    end
end

% Считает оптимальную траекторию системы
%  
% Arguments
%   mode      [scalar] -- начальная система (1 - положительная, 0 - отрицательная)
%   t_start   [scalar] -- начальное время
%   t_end     [scalar] -- конечное время
%   x_start   [2, 1]   -- начальная точка по x
%   psi_start [2, 1]   -- начальная точка по psi
%   alpha     [scalar] -- значение параметра
%   draw_mode [str]    -- режим рисования
%
% Returns
%   x_end    [2, 1] -- конечная точка по х
%   switches [M, 2] -- точки переключения
function [x_end, switches] = psi_switch(mode, t_start, t_end, x_start, psi_start, alpha, draw_mode)
    switches = transpose(x_start);
    options = odeset('Events', @event_fcn);
    
    
    while t_start < t_end
        if mode
            odefcn = @(t, x) main_system(t, x, alpha);
        else
            odefcn = @(t, x) main_system(t, x, -alpha);
        end
        
        [x_times, xes] = ode45(odefcn, [t_start, t_end], x_start);
                
        odefcn = @(t, psi) congugate_system(t, psi, xes, x_times); 
        [psi_times, psis, ~, ~, ~] = ode45(odefcn, x_times, psi_start, options);
        
        t_start = psi_times(end);
        t_start_ind = numel(psi_times);
        
        if strcmp(draw_mode, 'draw')
            ax = gca;
            ax.ColorOrderIndex = 1;
            plot (xes(1:t_start_ind, 1), xes(1:t_start_ind, 2));
        end
        
        switches = cat(1, switches, xes(t_start_ind, :));
        
        x_start   = xes  (t_start_ind, :).';
        psi_start = psis (t_start_ind, :).';
        
        mode = ~mode;
    end
    switches = switches(1:end-1, :);
    x_end = x_start;
end

function [value, isterminal, direction] = event_fcn(t, x)
    value = x(2);
    isterminal = 1;
    direction = 0;
end