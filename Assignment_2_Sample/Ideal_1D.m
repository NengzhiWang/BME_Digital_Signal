clc
clear all
close all
%%
% 一维高斯函数的理想采样与重建
%%
% 高斯函数标准差
sigma = 1;
f_sigma = (1 / sigma) / (2 * pi);
% 采样率与采样周期
Ts = sigma * (pi / 3);
Fs = (1 / Ts);

N = 3001;
half_range = 5 * sigma;
three_sigma = 3 * sigma;

%%
% 生成一维高斯信号
x = linspace(-half_range, half_range, N);
f_x = linspace(-(N - 1) / 2, (N - 1) / 2, N) ./ (2 * half_range);
Gauss_1D = (1 / (sqrt(2 * pi) * sigma)) * exp(-(x.^2) / (2 * sigma^2));
Gauss_1D = Gauss_1D / max(Gauss_1D(:));

%%
% 采样
NT = Ts / ((2 * half_range) / (N - 1));
NT = round(NT, 0);
sample_num = floor((N - 1) / NT);

% 确保进行奇数次采样
% 最外侧采样时会超出范围，这里忽略。
sample_num = sample_num + mod(sample_num - 1, 2) - 2;
% 去除三倍标准差外的信号
Gauss_3_sigma = double(x >= -3 * sigma & x <= 3 * sigma) .* Gauss_1D;
% 计算位置偏移，确保采样脉冲也关于高斯函数的中心对称
center_sample = NT * (sample_num - 1) / 2;
center_Gauss = (N - 1) / 2;
offset = center_sample - center_Gauss;

pulse_sample = zeros(1, N);
for i = 1:sample_num
    center = NT * i - offset;
    pulse_sample(center) = Gauss_3_sigma(center);
end
%%
% 计算频谱
Freq_Gauss = fft(Gauss_1D, N);
Freq_Gauss = abs(fftshift(Freq_Gauss));
Freq_Gauss = Freq_Gauss / max(Freq_Gauss(:));

Freq_sample = fft(pulse_sample, N);
Freq_sample = abs(fftshift(Freq_sample));
Freq_sample = Freq_sample / max(Freq_sample(:));

%%
% 频域滤波重建
Freq_Recover = zeros(1, N);

for i = 1:N
    if f_x(i) <= (Fs / 2) && f_x(i) >= -(Fs / 2)
        Freq_Recover(i) = Freq_sample(i);
    end
end

Freq_Recover = ifftshift(Freq_Recover);
Gauss_Recover_Freq = abs(ifft(Freq_Recover));
Gauss_Recover_Freq = ifftshift(Gauss_Recover_Freq);
Gauss_Recover_Freq = Gauss_Recover_Freq / max(Gauss_Recover_Freq(:));

%%
% 空域内插重建
h = sinc(x / Ts);
Gauss_Recover_Space = conv(pulse_sample, h, 'same');
Gauss_Recover_Space = Gauss_Recover_Space / max(Gauss_Recover_Space(:));

%%
figure()
subplot(3, 2, 1)
figure(1)
plot(x, Gauss_1D)
xlim([-half_range, half_range])
ylim([-0.1, 1.1])
xticks(-5:1:5)
title('一维高斯函数')
xlabel('x')
ylabel('y')
saveas(gcf, '1-1 一维理想采样 一维高斯函数.svg')
%%
subplot(3, 2, 2)
plot(x, pulse_sample)
xlim([-half_range, half_range])
ylim([-0.1, 1.1])
xticks(-5:1:5)
title('一维高斯函数的矩形脉冲采样')
xlabel('x')
ylabel('y')
saveas(gcf, '1-2 一维理想采样 一维高斯函数的非理想采样.svg')
%%
subplot(3, 2, 3)
plot(f_x, Freq_Gauss)
xlim([-5 * Fs, 5 * Fs])
ylim([-0.1, 1.1])
title('一维高斯函数的归一化频谱')
xlabel('f')
ylabel('F')
saveas(gcf, '1-3 一维理想采样 一维高斯函数的归一化频谱.svg')
%%
subplot(3, 2, 4)
plot(f_x, Freq_sample)
xlim([-5 * Fs, 5 * Fs])
ylim([-0.1, 1.1])
title('一维高斯函数矩形脉冲采样的归一化频谱')
xlabel('f')
ylabel('F')
saveas(gcf, '1-4 一维理想采样 一维高斯函数矩形非理想采样的归一化频谱.svg')
%%
subplot(3, 2, 5)
plot(x, Gauss_Recover_Freq)
xlim([-half_range, half_range])
ylim([-0.1, 1.1])
xticks(-5:1:5)
title('频域滤波重建结果')
xlabel('x')
ylabel('y')
saveas(gcf, '1-5 一维理想采样 频域滤波重建结果.svg')
%%
subplot(3, 2, 6)
plot(x, Gauss_Recover_Space)
xlim([-half_range, half_range])
ylim([-0.1, 1.1])
xticks(-5:1:5)
title('空域内插重建结果')
xlabel('x')
ylabel('y')
saveas(gcf, '1-6 一维理想采样 空域内插重建结果.svg')