function [bz, az] = my_butter(N, wc, ftype)
%%
% 频率预畸变
T = 2;
Wc = (2 / T) .* tan(pi .* wc ./ 2);
%%
% 计算截止频率为1 rad/s的归一化模拟巴特沃斯滤波器的系统函数
% [zn, pn, kn]  零极点增益形式
% [bn, an]      传递函数形式
% H(s)不存在零点（在无穷大处）
zn = inf .* ones(N, 1);
% 计算归一化巴特沃斯滤波器的极点
% P为H(s)*H(-s)的所有极点
if mod(N, 2) == 0
    P = exp(1j .* pi .* ((1:2 * N) - 0.5) ./ N);
elseif mod(N, 2) == 1
    P = exp(1j .* pi .* (1:2 * N) ./ N);
end
% H(s)的极点都需要在左半平面
pn = P(real(P) < 0);
kn = 1;

bn = kn .* poly(zn);
an = poly(pn);
%%
% 去归一化，将归一化低通滤波器映射到低通/高通/带通滤波器
% [zs, ps, ks]  零极点增益形式
% [bs, as]      传递函数形式
if ftype == 'lp'
    % 模拟低通到模拟低通
    zs = zn;
    ps = Wc .* pn;
    ks = kn * (Wc^N);
elseif ftype == 'hp'
    % 模拟低通到模拟高通
    zs = 1 ./ zn;
    ps = Wc ./ pn;
    ks = kn * prod(-pn);
elseif ftype == 'bp'
    % 模拟低通到模拟带通
    W0 = sqrt(Wc(1) * Wc(2)); % 中心频率
    Bw = abs(Wc(1) - Wc(2)); % 带宽
    zs = 1 ./ zn;
    for i = 1:N
        ps(2 * i - 1:2 * i) = roots([1, -Bw * pn(i), W0^2]);
    end
    ks = kn * (Bw^N);
elseif ftype == 'bs'
    % 模拟低通到模拟带阻
    W0 = sqrt(Wc(1) * Wc(2)); % 中心频率
    Bw = abs(Wc(1) - Wc(2)); % 带宽
    for i = 1:N
        zs(2 * i - 1:2 * i) = roots([1, 0, W0^2]);
        ps(2 * i - 1:2 * i) = roots([1, -Bw * pn(i), W0^2]);
    end
    ks = kn * prod(-1 ./ pn);
end

bs = ks .* poly(zs);
as = poly(ps);
%%
% 双线性变换，将模拟系统映射到数字系统
% [zz, pz, kz]  零极点增益形式
% [bz, az]      传递函数形式
zs = zs(isfinite(zs));
Z = (1 + zs * (T / 2)) ./ (1 - zs * (T / 2));
pz = (1 + ps * (T / 2)) ./ (1 - ps * (T / 2));
kz = ks .* real((prod((2 / T) - zs)) ./ prod((2 / T) - ps));
zz = -ones(size(pz));
for i = 1:numel(Z)
    zz(i) = Z(i);
end

az = real(poly(pz));
bz = real(kz .* poly(zz));
end
