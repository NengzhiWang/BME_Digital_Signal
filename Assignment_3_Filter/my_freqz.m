function my_freqz(bz, az)
% TF-DF to ZPK-DF
zz = roots(bz);
pz = roots(az);
bz_not_0 = bz(bz ~= 0);
kz = bz_not_0(1) / az(1);
% [zz, pz, kz] = tf2zpk(bz, az);

L = 2048;
w = linspace(0, 1, L);
Y = zeros(1, L);
% calculate frequenct response
for i = 1:L
    wi = w(i);
    A = prod(exp(1j * pi * wi) - zz);
    B = prod(exp(1j * pi * wi) - pz);
    Y(i) = kz * A / B;
end

% Magnitude and Phase
Y_dB = 20 * log10(abs(Y));
Y_phase = rad2deg(angle(Y));

min_dB = min(Y_dB);
max_dB = max(max(Y_dB), 0);

subplot(2, 1, 1)
plot(w, Y_dB)
grid on
xlabel('Normalized Frequency (\times \pi rad/sample)')
ylabel('Magnitude (dB)')
xlim([0, 1])
ylim([min_dB, max_dB])
subplot(2, 1, 2)
plot(w, Y_phase)
grid on
xlabel('Normalized Frequency (\times \pi rad/sample)')
ylabel('Phase (degrees)')
xlim([0, 1])
end
