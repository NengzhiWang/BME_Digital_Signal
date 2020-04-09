function Signal_Noise = Add_Noise(Signal, SNR)
% 计算信号功率
Signal_Power = sum(abs(Signal(:)).^2) / numel(Signal);
Signal_dB = 10 * log10(Signal_Power);

% 计算噪声功率
Noise_dB = Signal_dB - SNR;
Noise_Power = 10^(Noise_dB / 10);

% 生成噪声信号
Rand_Noise = randn(size(Signal));
Noise = sqrt(Noise_Power) * Rand_Noise;

Signal_Noise = Signal + Noise;
% Signal_Noise = awgn(Signal, SNR);

% 调整动态范围
Signal_Noise = max(Signal_Noise, 0);
Signal_Noise = min(Signal_Noise, 1);
end
