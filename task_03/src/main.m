%% Вид решения при alpha = const
alpha = 1;
t_end = 6;
positive_system = @(t, x) main_system(t, x,  alpha);
negative_system = @(t, x) main_system(t, x, -alpha);

[times, xes] = ode45(positive_system, [0 t_end], [0; 0]);
plot(xes(:, 1), xes(:, 2));
grid on;
hold on;
[times, xes] = ode45(negative_system, [0 t_end], [0; 0]);
plot(xes(:, 1), xes(:, 2));
xlabel('x_1');
ylabel('x_2');
legend('\alpha > 0', '\alpha < 0');
hold off;
%% Проблема с 