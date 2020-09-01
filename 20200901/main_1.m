clc
clear all
% close all
%%
% �źŵĲ���
% ������λ����
x = zeros(1024, 1);
pulse = [200, 20, 220, 250, 500, 600, 800];
x(pulse, 1) = 1;
% ָ���½�ģ��
t = 10;
h = exp(-(0:1:ceil(3 * t)) / t)';
% �������ĸ��ź�
y = conv(x, h, 'full');
% �������ĸ��ź�
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
% ϡ���ؽ�
x_deconv_L1 = deconv_L1(y_noise, h, .75);

figure(2)
plot(x_deconv_L1, '-r');
hold on
plot(pulse, 1, '.b', 'MarkerSize', 20);
legend('Deconv Result with L1', 'Pulse Train')
hold off
title('L1 Deconv')
