clc
clear all
% close all
set(0, 'defaultAxesFontSize', 24)

T = 1;
w = (2 * pi) / T;
num_sample = 65536;

t = linspace(-1, 1, num_sample);
x = double(cos(w * t) >= 0);

num_k = 128;
base = Get_Base(num_k, t, T);
spec = FS(x, base, T);
recover_x = IFS(spec, base, T);
figure(1)
plot(t, x, '-r', 'LineWidth', 2)

hold on
plot(t, recover_x, '-b', 'LineWidth', 1.5)

hold off
ylim([-0.2 1.2])
title_str = sprintf('离散点数%d，傅里叶级数项数%d', num_sample, num_k);
title(title_str)
saveas(gcf, [title_str, '.svg'])

function fourier_series = FS(f, base, T)
    fourier_series = Approx_Inner(f, base, T) ./ sqrt(T);
end

function recover_signal = IFS(fourier_series, base, T)
    recover_signal = real(fourier_series * base .* sqrt(T));
end

function base = Get_Base(num_k, t, T)
    K = -ceil(num_k / 2):1:ceil(num_k / 2);
    base = exp(1j .* 2 .* pi .* (1 / T) .* Outer(K, t)) ./ sqrt(T);
end

function z = Approx_Inner(f, g, T)
    num_sample = numel(f);
    z = (f * conj(g')) .* (T ./ num_sample);
end

function z = Outer(a, b)
    M = numel(a);
    N = numel(b);
    z = zeros(M, N);

    for i = 1:M

        for j = 1:N
            z(i, j) = a(i) .* b(j);
        end

    end

end
