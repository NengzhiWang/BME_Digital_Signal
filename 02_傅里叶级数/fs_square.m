clc
clear all
% close all
set(0, 'defaultAxesFontSize', 24)
% 生成离散方波信号
T = 1;                              % 周期
w = (2 * pi) / T;
num_sample = 65536;                 % 采样点数
t = linspace(-1, 1, num_sample);
x = double(cos(w * t) >= 0);

num_k = 128;
% 计算傅里叶级数的正交基
base = Get_Base(num_k, t, T);
% 计算傅里叶级数的系数
spec = FS(x, base, T);
% 计算重建信号
recover_x = IFS(spec, base, T);
figure(1)
plot(t, x, '-r', 'LineWidth', 2)
hold on
plot(t, recover_x, '-b', 'LineWidth', 1.5)
hold off
ylim([-0.2 1.2])
title_str = sprintf('离散点数%d，傅里叶级数项数%d', num_sample, num_k);
title(title_str)

function fourier_series = FS(f, base, T)
% 计算傅里叶级数
fourier_series = Approx_Inner(f, base, T) ./ sqrt(T);
end

function recover_signal = IFS(fourier_series, base, T)
% 根据傅里叶级数逼近原信号
recover_signal = real(fourier_series * base .* sqrt(T));
end

function base = Get_Base(num_k, t, T)
% 计算正交基
K = -ceil(num_k / 2):1:ceil(num_k / 2);
base = exp(1j .* 2 .* pi .* (1 / T) .* Outer(K, t)) ./ sqrt(T);
end

function z = Approx_Inner(f, g, T)
% 对于给定的函数（值）f和g，以及采样点序列T，近似计算f和g的内积
num_sample = numel(f);
z = (f * conj(g')) .* (T ./ num_sample);
end

function z = Outer(a, b)
% a = [a1, …, am] and b = [b1, …, bn]
% result = [
% a1 * b1, a1 * b2, …, a1 * bn;
% a2 * b1, a2 * b2 ,…, a2 * bn;
% …
% am * b1, am * b2, …, am * bn;
% ]
% 效果和numpy.outer相同
M = numel(a);
N = numel(b);
z = zeros(M, N);
for i = 1:M  
    for j = 1:N
        z(i, j) = a(i) .* b(j);
    end
end
end
