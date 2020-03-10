clc
clear all
close all

addpath(genpath('./Function'));

X = zeros(10000, 1);
X(5050) = 1;
X(588) = 1;
X(7200) = 1;

h = [1; 2; 1];
y = conv(X, h, 'full');

x_1 = deconv_fast_grad_descent(y, h);
x_2 = deconv_fast_grad_descent_not_negative(y, h);

figure()
hold on
plot(x_1)
plot(x_2)
plot(X, '.', 'Color', 'r')
legend('快速逆卷积','非负快速逆卷积','原始信号')
hold off
ylim([-0.2, 1.2])


figure()
hold on
plot(x_1)
plot(x_2)
plot(X, '.', 'Color', 'r')
legend('快速逆卷积','非负快速逆卷积','原始信号')
hold off
ylim([-0.2, 1.2])
xlim([5030, 5070])