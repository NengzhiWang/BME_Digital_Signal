clc
clear all
close all

%%
% �źŵĲ���
% ������λ����
x = zeros(1024, 1);
ap_train = [200, 220, 250, 270, 300, 400, 500, 720, 600, 800, 900];
x(ap_train, 1) = 1;
% ָ���½�ģ��
t = 15;
h = exp(-(0:1:ceil(10 * t)) / t)';
% �������ĸ��ź�
y = conv(x, h, 'full');
% �����dB
SNR = 15;
% �������ĸ��ź�
y_noise = Add_Noise(y, SNR);
% ϡ���ؽ�
% ����ϵ����*1e-3)
L = 0.5;

% x_deconv_L1 = deconv_L1(y_noise, h, L);
x_deconv_L1 = deconv_L1_plot(y_noise, h, L);

%%
% ��ͼ
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
title(sprintf('Sparse Reconstruction, SNR=%d dB, ��=%.5f', SNR, L * 1e-3))
xlim([0, 1024])
ylim([-0.02, 1.3])
box off
