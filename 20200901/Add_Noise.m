function Signal_Noise = Add_Noise(Signal, SNR)
% �����źŹ���
Signal_Power = sum(abs(Signal(:)).^2) / numel(Signal);
Signal_dB = 10 * log10(Signal_Power);

% ������������
Noise_dB = Signal_dB - SNR;
Noise_Power = 10^(Noise_dB / 10);

% ���������ź�
Rand_Noise = randn(size(Signal));
Noise = sqrt(Noise_Power) * Rand_Noise;

Signal_Noise = Signal + Noise;

end