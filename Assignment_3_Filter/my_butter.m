function [bz, az] = my_butter(N, wc, type)
%%
% pre-warped frequencies
T = 2;
Wc = (2 / T) .* tan(pi .* wc ./ 2);

%%
% AF system of butter prototype, with a cutoff frequency at 1 rad/s

% [zn, pn, kn] Zeros-Poles-Gain
% [bn, an] Transfer Function

zn = inf .* ones(N, 1);
pn = zeros(N, 1);
kn = 1;
num = 1;

for i = 1:2 * N
    if mod(N, 2) == 0
        P = exp(1j * pi * (i - 0.5) / N);
    elseif mod(N, 2) == 1
        P = exp(1j * pi * i / N);
    end
    if real(P) < 0
        % all poles should in the left hale plane
        pn(num) = P;
        num = num + 1;
    end
end

bn = kn .* poly(zn);
an = poly(pn);

%%
% cutoff frequency transformation, 1 rad/s to Wc rad/s
% [zs, ps, ka] Zeros-Poles-Gain
% [bs, as] Transfer Function
if type == 'lp'
    % low pass to low pass
    zs = zn;
    ps = Wc .* pn;
    ks = kn .* (Wc^N);
elseif type == 'hp'
    % low pass to high pass
    zs = 1 ./ zn;
    ps = Wc ./ pn;
    ks = 1;
end

bs = ks .* poly(zs);
as = poly(ps);

%%
% Bilinear transformation
% [zz, pz, kz] Zeros-Poles-Gain
% [bz, az] Transfer Function
zs = zs(isfinite(zs));
zz = (1 + zs * (T / 2)) ./ (1 - zs * (T / 2));
pz = (1 + ps * (T / 2)) ./ (1 - ps * (T / 2));
kz = (ks * prod((2 / T) - zs)) ./ prod((2 / T) - ps);

Z = -ones(size(pz));

for i = 1:numel(zz)
    Z(i) = zz(i);
end

zz = Z;

az = poly(pz);
bz = kz .* poly(zz);
az = real(az);
bz = real(bz);
end
