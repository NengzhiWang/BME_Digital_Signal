clc
clear all
close all
%%
% 二维高斯函数的理想采样与重建
%%
% 高斯函数标准差
sigma = 1;
f_sigma = (1 / sigma) / (2 * pi);

% 采样率与采样周期
Ts = sigma * (pi / 3);
Fs = (1 / Ts);
% 采样脉冲的占空比
alpha = 0.95;
half_width = 0.5 * alpha * Ts;

N = 1501;
half_range = 5 * sigma;
three_sigma = 3 * sigma;

%%
% 生成二维高斯信号
x = linspace(-half_range, half_range, N);
y = linspace(-half_range, half_range, N);
[mx, my] = meshgrid(x, y);

f_x = linspace(-(N - 1) / 2, (N - 1) / 2, N) ./ (2 * half_range);
f_y = linspace(-(N - 1) / 2, (N - 1) / 2, N) ./ (2 * half_range);
Gauss_2D = 1 / (sqrt(2 * pi) * sigma) * exp(-(mx.^2 + my.^2) / (2 * sigma^2));
Gauss_2D = Gauss_2D / max(Gauss_2D(:));

%%
% 采样
NT = Ts / ((2 * half_range) / (N - 1));
NT = round(NT, 0);
sample_num = floor((N - 1) / NT);

% 确保进行奇数次采样
% 最外侧采样时会超出范围，这里忽略。
sample_num = sample_num + mod(sample_num - 1, 2) - 2;
% 去除三倍标准差外的信号
Gauss_3_sigma = double(x >= -3 * sigma & x <= 3 * sigma & y >= -3 * sigma & y <= 3 * sigma) .* Gauss_2D;
% 计算位置偏移，确保采样脉冲也关于高斯函数的中心对称
center_sample = NT * (sample_num - 1) / 2;
center_Gauss = (N - 1) / 2;
offset = center_sample - center_Gauss;

pulse_sample = zeros(N, N);

for i = 1:sample_num
    for j = 1:sample_num
        center_x = NT * i - offset;
        center_y = NT * j - offset;
        pulse_sample(center_x, center_y) =Gauss_3_sigma(center_x, center_y);
    end
end

%%
% 计算频谱
Freq_Gauss = fft2(Gauss_2D);
Freq_Gauss = abs(fftshift(Freq_Gauss));
Freq_Gauss = Freq_Gauss / max(Freq_Gauss(:));

Freq_sample = fft2(pulse_sample);
Freq_sample = abs(fftshift(Freq_sample));
Freq_sample = Freq_sample / max(Freq_sample(:));

%%
% 频域滤波重建
Freq_Recover = zeros(N, N);

for i = 1:N
    for j = 1:N
        if f_x(i) <= (Fs / 2) && f_x(i) >= -(Fs / 2)
            if f_y(j) <= (Fs / 2) && f_y(j) >= -(Fs / 2)
                Freq_Recover(i, j) = Freq_sample(i, j);
            end
        end
    end
end

Freq_Recover = ifftshift(Freq_Recover);
Gauss_Recover_Freq = abs(ifft2(Freq_Recover));
Gauss_Recover_Freq = ifftshift(Gauss_Recover_Freq);
Gauss_Recover_Freq = Gauss_Recover_Freq / max(Gauss_Recover_Freq(:));

%%
% 空域内插重建
h = sinc(sqrt(mx.^2 + my.^2) / Ts);
Gauss_Recover_Space = conv2(pulse_sample, h, 'same');
Gauss_Recover_Space = Gauss_Recover_Space / max(Gauss_Recover_Space(:));

%%
subplot(3, 4, 1)
mesh(x, y, Gauss_2D)

xlim([-half_range, half_range])
ylim([-half_range, half_range])
zlim([0, 1])
xticks(-5:1:5)
yticks(-5:1:5)
title('二维高斯函数')
xlabel('x')
ylabel('y')
%%
subplot(3, 4, 2)
imagesc(x, y, Gauss_2D)
axis equal
xlim([-half_range, half_range])
ylim([-half_range, half_range])
zlim([0, 1])
xticks(-5:1:5)
yticks(-5:1:5)
title('二维高斯函数')
xlabel('x')
ylabel('y')
%%
subplot(3, 4, 3)
mesh(x, y, pulse_sample)

xlim([-half_range, half_range])
ylim([-half_range, half_range])
zlim([0, 1])
xticks(-5:1:5)
yticks(-5:1:5)
title('二维高斯函数的理想采样')
xlabel('x')
ylabel('y')
%%
subplot(3, 4, 4)
imagesc(x, y, pulse_sample)
axis equal
xlim([-half_range, half_range])
ylim([-half_range, half_range])
zlim([0, 1])
xticks(-5:1:5)
yticks(-5:1:5)
title('二维高斯函数的理想采样')
xlabel('x')
ylabel('y')
%%
subplot(3, 4, 5)
mesh(f_x, f_y, Freq_Gauss)

xlim([-5 * Fs, 5 * Fs])
ylim([-5 * Fs, 5 * Fs])
zlim([0, 1])
title('二维高斯函数的归一化频谱')
xlabel('f_x')
ylabel('f_y')
%%
subplot(3, 4, 6)
imagesc(f_x, f_y, Freq_Gauss)
axis equal
xlim([-5 * Fs, 5 * Fs])
ylim([-5 * Fs, 5 * Fs])
zlim([0, 1])
title('二维高斯函数的归一化频谱')
xlabel('f_x')
ylabel('f_y')
%%
subplot(3, 4, 7)
mesh(f_x, f_y, Freq_sample)

xlim([-5 * Fs, 5 * Fs])
ylim([-5 * Fs, 5 * Fs])
zlim([0, 1])
title('二维高斯函数理想采样的归一化频谱')
xlabel('f_x')
ylabel('f_y')
%%
subplot(3, 4, 8)
imagesc(f_x, f_y, Freq_sample)
axis equal
xlim([-5 * Fs, 5 * Fs])
ylim([-5 * Fs, 5 * Fs])
zlim([0, 1])
title('二维高斯函数理想采样的归一化频谱')
xlabel('f_x')
ylabel('f_y')
%%
subplot(3, 4, 9)
mesh(x, y, Gauss_Recover_Freq)

xlim([-half_range, half_range])
ylim([-half_range, half_range])
zlim([0, 1])
xticks(-5:1:5)
yticks(-5:1:5)
title('频域滤波重建结果')
xlabel('x')
ylabel('y')
%%
subplot(3, 4, 10)
imagesc(x, y, Gauss_Recover_Freq)
axis equal
xlim([-half_range, half_range])
ylim([-half_range, half_range])
zlim([0, 1])
xticks(-5:1:5)
yticks(-5:1:5)
title('频域滤波重建结果')
xlabel('x')
ylabel('y')
%%
subplot(3, 4, 11)
mesh(x, y, Gauss_Recover_Space)

xlim([-half_range, half_range])
ylim([-half_range, half_range])
zlim([0, 1])
xticks(-5:1:5)
yticks(-5:1:5)
title('空域内插重建结果')
xlabel('x')
ylabel('y')
%%
subplot(3, 4, 12)
imagesc(x, y, Gauss_Recover_Space)
axis equal
xlim([-half_range, half_range])
ylim([-half_range, half_range])
zlim([0, 1])
xticks(-5:1:5)
yticks(-5:1:5)
title('空域内插重建结果')
xlabel('x')
ylabel('y')
