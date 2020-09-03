clc
clear all
close all

%%
% 信号的产生
% 动作电位脉冲
x = zeros(1024, 1);
ap_train = [200, 220, 250, 270, 300, 400, 500, 720, 600, 800, 900];
x(ap_train, 1) = 1;
% 指数下降模板
t = 15;
h = exp(-(0:1:ceil(10 * t)) / t)';
% 无噪声的钙信号
y = conv(x, h, 'full');
% 信噪比dB
SNR = 15;
% 有噪声的钙信号
y_noise = Add_Noise(y, SNR);
% 稀疏重建
% 正则化系数（*1e-3)
L = 0.5;

% x_deconv_L1 = deconv_L1(y_noise, h, L);
x_deconv_L1 = deconv_L1_plot(y_noise, h, L);

%%
% 绘图
figure(1)
plot(y_noise, '-', 'color', [0.46, 0.67, 0.19])
hold on
plot(y, '-', 'LineWidth', 1.5, 'color', [0.85, 0.32, 0.01]);
plot(ap_train, 1, '.b', 'MarkerSize', 20);
hold off
title(sprintf('Ca Signal, SNR=%d dB', SNR))
legend('Signal with Noise', 'Signal without Noise', 'AP Train')
xlim([0, 1024])
ylim([-0.4, 1.6])
box off

figure(2)
plot(x_deconv_L1, '-r');
hold on
plot(ap_train, 1, '.b', 'MarkerSize', 20);
legend('Sparse Reconstruction', 'AP Train')
hold off
title(sprintf('Sparse Reconstruction, SNR=%d dB, λ=%.5f', SNR, L * 1e-3))
xlim([0, 1024])
ylim([-0.02, 1.3])
box off
