clc
clear all
% close all
%%
% 信号的产生
% 动作电位脉冲
x = zeros(1024, 1);
pulse = [200, 20, 220, 250, 500, 600, 800];
x(pulse, 1) = 1;
% 指数下降模板
t = 10;
h = exp(-(0:1:ceil(3 * t)) / t)';
% 无噪音的钙信号
y = conv(x, h, 'full');
% 有噪音的钙信号
y_noise = Add_Noise(y, 10);

figure(1)
plot(y_noise, '-r')
hold on
plot(y, '-g');

plot(pulse, 1, '.b', 'MarkerSize', 20);
hold off
title('Ca Signal with noise')
legend('Signal with Noise', 'Signal without Noise', 'Pulse Train')
%%
% 稀疏重建
x_deconv_L1 = deconv_L1(y_noise, h, .75);

figure(2)
plot(x_deconv_L1, '-r');
hold on
plot(pulse, 1, '.b', 'MarkerSize', 20);
legend('Deconv Result with L1', 'Pulse Train')
hold off
title('L1 Deconv')
