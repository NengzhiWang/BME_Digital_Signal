function [bz, az] = my_butter(N, wc, type)
%%
% Ƶ��Ԥ����
T = 2;
Wc = (2 / T) .* tan(pi .* wc ./ 2);
%%
% �����ֹƵ��Ϊ1 rad/s�Ĺ�һ��ģ�������˹�˲�����ϵͳ����
% [zn, pn, kn]  �㼫��������ʽ
% [bn, an]      ���ݺ�����ʽ
% ��������㣨������󴦣�
zn = inf .* ones(N, 1);
pn = zeros(N, 1);
num = 1;
% �����һ��������˹�˲����ļ���
for i = 1:2 * N
    if mod(N, 2) == 0
        P = exp(1j * pi * (i - 0.5) / N);
    elseif mod(N, 2) == 1
        P = exp(1j * pi * i / N);
    end
    if real(P) < 0
        % ���еļ��㶼��Ҫ�����ƽ��
        pn(num) = P;
        num = num + 1;
    end
end

kn = 1;
bn = kn .* poly(zn);
an = poly(pn);

%%
% ȥ��һ��
% [zs, ps, ks]  �㼫��������ʽ
% [bs, as]      ���ݺ�����ʽ
if type == 'lp'
    % ��ͨ����ͨ
    zs = zn;
    ps = Wc .* pn;
    ks = kn .* (Wc^N);
elseif type == 'hp'
    % ��ͨ����ͨ
    zs = 1 ./ zn;
    ps = Wc ./ pn;
    ks = kn;
elseif type == 'bp'
    % ��ͨ����ͨ
    zs = 1 ./ zn;
    W0 = sqrt(Wc(1) * Wc(2));   % ����Ƶ��
    Bw = abs(Wc(1) - Wc(2));    % ����
    for i = 1:N
        p = pn(i);
        ps(2 * i - 1:2 * i) = roots([1, -Bw * p, W0^2]);
    end
    ks = Bw^N;
end

bs = ks .* poly(zs);
as = poly(ps);

%%
% ˫���Ա任
% [zz, pz, kz]  �㼫��������ʽ
% [bz, az]      ���ݺ�����ʽ
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
