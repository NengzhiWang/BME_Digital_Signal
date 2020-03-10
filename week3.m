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

y_n = awgn(y, 20);
% ��������������Ϊ20dB����˹������

x_1 = deconv_fast_grad_descent_not_negative(y_n, h);
% �����ݶ��½�����

x_2 = deconv_L2_regularization(y_n, h, 0.1);
% �⻬����

figure()
hold on
plot(x_1);
plot(x_2);
hold off
ylim([-0.2 1.2])
