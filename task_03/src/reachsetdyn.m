% Функция reachsetdyn как в задании
%
% Arguments
%   alpha    [scalar] -- значение параметра
%   t1       [scalar] -- начальное время
%   t2       [scalar] -- конечное время
%   N        [scalar] -- число кадров
%   filename [str]    -- имя файла (необяз.)
function reachsetdyn(alpha, t1, t2, N, filename)
    [xes, ~] = reachset(alpha, t2);
    xmin = min(xes(:, 1));
    xmax = max(xes(:, 1));
    ymin = min(xes(:, 2));
    ymax = max(xes(:, 2));
    xmin = xmin - (xmax - xmin)/10;
    xmax = xmax + (xmax - xmin)/10;
    ymin = ymin - (ymax - ymin)/10;
    ymax = ymax + (ymax - ymin)/10;
    
    if nargin == 5
        v = VideoWriter(filename);
        v.FrameRate = 2;
        v.Quality = 100;
        open(v);
        step = (t2 - t1) / N;
        for i = 1:N
            [xes, switches] = reachset(alpha, t1);
            ax = gca;
            ax.ColorOrderIndex = 1;
            plot([xes(:, 1); xes(1, 1)], [xes(:,2); xes(1, 2)]);
            hold on;
            grid on;
            ax.ColorOrderIndex = 2;
            if i == N
                    plot(switches(:, 1), switches(:,2));
                    ax = gca;
                    ax.ColorOrderIndex = 1;
                    p1 = plot([NaN, NaN]);
                    ax.ColorOrderIndex = 2;
                    p2 = plot([NaN, NaN]);
                    legend([p1 p2], {'Граница множества достижимости', 'Линия переключений'});
                else 
                    legend('Граница множества достижимости');
                end
            xlabel('x_1');
            ylabel('x_2');
            axis([xmin, xmax, ymin, ymax]);
            frame = getframe(gcf);
            writeVideo(v, frame);
            t1 = t1 + step;
        end
        close(v);
    else
        if t1 ~= t2
            step = (t2 - t1) / N;
            for i = 1:N
                [xes, switches] = reachset(alpha, t1);
                ax = gca;
                ax.ColorOrderIndex = 1;
                plot([xes(:, 1); xes(1, 1)], [xes(:,2); xes(1, 2)]);
                hold on;
                grid on;
                ax.ColorOrderIndex = 2;
                if i == N
                    plot(switches(:, 1), switches(:,2));
                    ax = gca;
                    ax.ColorOrderIndex = 1;
                    p1 = plot([NaN, NaN]);
                    ax.ColorOrderIndex = 2;
                    p2 = plot([NaN, NaN]);
                    legend([p1 p2], {'Граница множества достижимости', 'Линия переключений'});
                else 
                    legend('Граница множества достижимости');
                end
                xlabel('x_1');
                ylabel('x_2');
                axis([xmin, xmax, ymin, ymax]);
                t1 = t1 + step;
                pause on;
                pause(0.5);
                
            end
        else
            [xes, switches] = reachset(alpha, t1, 'draw');
            figure;
            plot([xes(:, 1); xes(1, 1)], [xes(:,2); xes(1, 2)]);
            hold on;
            grid on;
            plot(switches(:, 1), switches(:,2));
            xlabel('x_1');
            ylabel('x_2');
            legend('Граница множества достижимости', 'Линия переключений');
        end
    end
end

