%% Уравнения, ограничивающие множество Omega
a = 1;
b = 2;
c = 3;

x1Vec = -2:0.01:2;

plot(x1Vec, a.*(x1Vec.^2));
hold on;
plot(x1Vec, b - c.*(x1Vec.^2));
xlabel('x_1');
ylabel('x_2');

x11 = sqrt(b / (a + c));
x12 = -x11;
x20 = a*b / (a + c);

plot(x11, x20, 'r*');
plot(x12, x20, 'r*');

legend('x_2 = ax_1^2', 'x_2 = b - cx_1^2', '(x_{11}, x_{20})', '(x_{12}, x_{20})');
clear a b c x1Vec x11 x12 x20;