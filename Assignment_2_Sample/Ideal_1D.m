clc
clear all
close all
%%
% һά��˹����������������ؽ�
%%
% ��˹������׼��
sigma = 1;
f_sigma = (1 / sigma) / (2 * pi);
% ���������������
Ts = sigma * (pi / 3);
Fs = (1 / Ts);

N = 3001;
half_range = 5 * sigma;
three_sigma = 3 * sigma;

%%
% ����һά��˹�ź�
x = linspace(-half_range, half_range, N);
f_x = linspace(-(N - 1) / 2, (N - 1) / 2, N) ./ (2 * half_range);
Gauss_1D = (1 / (sqrt(2 * pi) * sigma)) * exp(-(x.^2) / (2 * sigma^2));
Gauss_1D = Gauss_1D / max(Gauss_1D(:));

%%
% ����
NT = Ts / ((2 * half_range) / (N - 1));
NT = round(NT, 0);
sample_num = floor((N - 1) / NT);

% ȷ�����������β���
% ��������ʱ�ᳬ����Χ��������ԡ�
sample_num = sample_num + mod(sample_num - 1, 2) - 2;
% ȥ��������׼������ź�
Gauss_3_sigma = double(x >= -3 * sigma & x <= 3 * sigma) .* Gauss_1D;
% ����λ��ƫ�ƣ�ȷ����������Ҳ���ڸ�˹���������ĶԳ�
center_sample = NT * (sample_num - 1) / 2;
center_Gauss = (N - 1) / 2;
offset = center_sample - center_Gauss;

pulse_sample = zeros(1, N);
for i = 1:sample_num
    center = NT * i - offset;
    pulse_sample(center) = Gauss_3_sigma(center);
end
%%
% ����Ƶ��
Freq_Gauss = fft(Gauss_1D, N);
Freq_Gauss = abs(fftshift(Freq_Gauss));
Freq_Gauss = Freq_Gauss / max(Freq_Gauss(:));

Freq_sample = fft(pulse_sample, N);
Freq_sample = abs(fftshift(Freq_sample));
Freq_sample = Freq_sample / max(Freq_sample(:));

%%
% Ƶ���˲��ؽ�
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
% �����ڲ��ؽ�
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
title('һά��˹����')
xlabel('x')
ylabel('y')
saveas(gcf, '1-1 һά������� һά��˹����.svg')
%%
subplot(3, 2, 2)
plot(x, pulse_sample)
xlim([-half_range, half_range])
ylim([-0.1, 1.1])
xticks(-5:1:5)
title('һά��˹�����ľ����������')
xlabel('x')
ylabel('y')
saveas(gcf, '1-2 һά������� һά��˹�����ķ��������.svg')
%%
subplot(3, 2, 3)
plot(f_x, Freq_Gauss)
xlim([-5 * Fs, 5 * Fs])
ylim([-0.1, 1.1])
title('һά��˹�����Ĺ�һ��Ƶ��')
xlabel('f')
ylabel('F')
saveas(gcf, '1-3 һά������� һά��˹�����Ĺ�һ��Ƶ��.svg')
%%
subplot(3, 2, 4)
plot(f_x, Freq_sample)
xlim([-5 * Fs, 5 * Fs])
ylim([-0.1, 1.1])
title('һά��˹����������������Ĺ�һ��Ƶ��')
xlabel('f')
ylabel('F')
saveas(gcf, '1-4 һά������� һά��˹�������η���������Ĺ�һ��Ƶ��.svg')
%%
subplot(3, 2, 5)
plot(x, Gauss_Recover_Freq)
xlim([-half_range, half_range])
ylim([-0.1, 1.1])
xticks(-5:1:5)
title('Ƶ���˲��ؽ����')
xlabel('x')
ylabel('y')
saveas(gcf, '1-5 һά������� Ƶ���˲��ؽ����.svg')
%%
subplot(3, 2, 6)
plot(x, Gauss_Recover_Space)
xlim([-half_range, half_range])
ylim([-0.1, 1.1])
xticks(-5:1:5)
title('�����ڲ��ؽ����')
xlabel('x')
ylabel('y')
saveas(gcf, '1-6 һά������� �����ڲ��ؽ����.svg')