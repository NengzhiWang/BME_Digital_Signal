clc
clear all
% close all
set(0, 'defaultAxesFontSize', 24)

Fs = 1000;
T = 1 / Fs;
L = 1000;
t = (0:L - 1)' * T;

S = 0.7 * sin(2 * pi * 50 * t) + sin(2 * pi * 120 * t);

X = S + 1 * randn(size(t));

Fx_dft = dft(X);
Fx_fft = fft(X);

Fx_diff = Fx_dft - Fx_fft;

X_ifft = real(ifft(Fx_fft));
X_idft = real(idft(Fx_dft));

X_diff = (X_idft - X);

f = Fs * (1:1:L) / L - 500;

figure()
subplot(3, 1, 1)
plot(f, abs(fftshift(Fx_dft)))
ylim([0, 800])
title('DFT')
subplot(3, 1, 2)
plot(f, abs(fftshift(Fx_fft)))
ylim([0, 800])
title('FFT')
subplot(3, 1, 3)
plot(f, abs(fftshift(Fx_diff)))
title('≤Ó÷µ')

figure()
subplot(3, 1, 1)
plot(t, X_ifft)
title('IDFT')
subplot(3, 1, 2)
plot(t, X_idft)
title('IFFT')
subplot(3, 1, 3)
plot(f, abs(X_ifft - X_idft))
title('≤Ó÷µ')
