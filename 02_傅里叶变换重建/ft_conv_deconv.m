clc
clear all
% close all
set(0, 'defaultAxesFontSize', 18)
set(0, 'defaultAxesFontName', 'times new roman')


% �źŵĲ���
% ������λ����
x = zeros(1024, 1);
ap_train = [200, 220, 250, 270, 300, 400, 500, 720, 600, 800, 900];
x(ap_train, 1) = 1;
% ָ���½�ģ��
t = 15;
h = exp(-(0:1:ceil(10 * t)) / t)';
% �������ĸ��ź�
y = conv_ft(x, h);
% �����dB
SNR = 15;
% �������ĸ��ź�
y_noise = awgn(y, SNR, 'measured');
%%
x_deconv = deconv_dft(y_noise, h);
psnr(y_noise, y)
psnr(x_deconv, x)

figure(2)
plot(x_deconv, '-r');
hold on
plot(ap_train, 1, '.b', 'MarkerSize', 20);
legend('Reconstruction', 'AP Train')
hold off
title('Fourier Transform Reconstruction, no Noise')
xlim([0, 1024])
ylim([-0.02, 1.3])
box off

function y = conv_ft(x, h)
% ����Ҷ�任���
len_x = size(x, 1);
len_h = size(h, 1);
len_y = len_x + len_h - 1;

% �Ծ��ģ����źŽ��в���
x_circle = zeros(len_y, 1);
x_circle(1:len_x) = x;
h_circle = zeros(len_y, 1);
h_circle(1:len_h) = h;

Fy = fft(x_circle) .* fft(h_circle);
y = real(ifft(Fy));
end

function x = deconv_dft(y, h)
% ����Ҷ�任�����
len_y = size(y, 1);
len_h = size(h, 1);
len_x = len_y - len_h + 1;

% �Ծ��ģ����в���
h_circle = zeros(len_y, 1);
h_circle(1:len_h) = h;

Fx = fft(y) ./ fft(h_circle);
x = real(ifft(Fx));
x = x(1:len_x);
end
