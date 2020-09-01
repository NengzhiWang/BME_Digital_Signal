clc
clear all
close all
%%

%%
% pass
Rp = 1;
Wp = 2 * pi * 4000;

% stop
Rs = 15;
Ws = 2 * pi * 3000;
Fs = 10000;
wp = Wp / (pi * Fs);
ws = Ws / (pi * Fs);

[N, wc] = my_buttord(wp, ws, Rp, Rs);
[N2, wc2] = buttord(wp, ws, Rp, Rs);

[b1, a1] = my_butter(N, wc, 'hp');
[b2, a2] = butter(N2, wc2, 'high');

figure(1)
subplot(1, 2, 1)
zplane(b1, a1)
title('�Զ��庯��ʵ��')
subplot(1, 2, 2)
zplane(b2, a2)
title('�⺯��ʵ��')

figure(2)
my_freqz(b1, a1)

%%
% Test signal
t = (1:1:10000) / Fs;

f = [1500, 2500, 3500, 4500];
x = (sin(2 * pi * f(1) * t) + cos(2 * pi * f(2) * t) + sin(2 * pi * f(3) * t) + cos(2 * pi * f(4) * t)) ./ 4;
y1 = my_filter(b1, a1, x);
y2 = filter(b2, a2, x);

y_err = y1 - y2;
figure(3)
plot(t, y_err)
title('�ź��˲�������')

X = abs((fft(x)));
Y = abs((fft(y2)));
freq = 1:Fs;

figure(4)
subplot(2, 1, 1)
plot(freq, X)
xlim([1 Fs / 2])
ylim([-100, 1500])
xlabel('f/Hz')
title('�˲�ǰ�ź�Ƶ��')
subplot(2, 1, 2)
plot(freq, Y)
xlim([1 Fs / 2])
ylim([-100, 1500])
xlabel('f/Hz')
title('�˲����ź�Ƶ��')

saveas(1,'HP-1.svg')
saveas(2,'HP-2.svg')
saveas(3,'HP-3.svg')
saveas(4,'HP-4.svg')
