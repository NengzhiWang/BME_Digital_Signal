function [bz, az] = my_butter(N, wc, type)
%%
% 频率预畸变
T = 2;
Wc = (2 / T) .* tan(pi .* wc ./ 2);
%%
% 计算截止频率为1 rad/s的归一化模拟巴特沃斯滤波器的系统函数
% [zn, pn, kn]  零极点增益形式
% [bn, an]      传递函数形式
% 不存在零点（在无穷大处）
zn = inf .* ones(N, 1);
pn = zeros(N, 1);
num = 1;
% 计算归一化巴特沃斯滤波器的极点
for i = 1:2 * N
    if mod(N, 2) == 0
        P = exp(1j * pi * (i - 0.5) / N);
    elseif mod(N, 2) == 1
        P = exp(1j * pi * i / N);
    end
    if real(P) < 0
        % 所有的极点都需要在左半平面
        pn(num) = P;
        num = num + 1;
    end
end

kn = 1;
bn = kn .* poly(zn);
an = poly(pn);

%%
% 去归一化
% [zs, ps, ks]  零极点增益形式
% [bs, as]      传递函数形式
if type == 'lp'
    % 低通到低通
    zs = zn;
    ps = Wc .* pn;
    ks = kn .* (Wc^N);
elseif type == 'hp'
    % 低通到高通
    zs = 1 ./ zn;
    ps = Wc ./ pn;
    ks = kn;
elseif type == 'bp'
    % 低通到带通
    zs = 1 ./ zn;
    W0 = sqrt(Wc(1) * Wc(2));   % 中心频率
    Bw = abs(Wc(1) - Wc(2));    % 带宽
    for i = 1:N
        p = pn(i);
        ps(2 * i - 1:2 * i) = roots([1, -Bw * p, W0^2]);
    end
    ks = Bw^N;
end

bs = ks .* poly(zs);
as = poly(ps);

%%
% 双线性变换
% [zz, pz, kz]  零极点增益形式
% [bz, az]      传递函数形式
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
