function [bz, az] = my_butter(N, wc, type)
%%
% Ƶ��Ԥ����
T = 2;
Wc = (2 / T) .* tan(pi .* wc ./ 2);
%%
% �����ֹƵ��Ϊ1 rad/s�Ĺ�һ��ģ�������˹�˲�����ϵͳ����
% [zn, pn, kn]  �㼫��������ʽ
% [bn, an]      ���ݺ�����ʽ
% H(s)��������㣨������󴦣�
zn = inf .* ones(N, 1);
% �����һ��������˹�˲����ļ���
% PΪH(s)*H(-s)�����м���
if mod(N, 2) == 0
    P = exp(1j .* pi .* ((1:2 * N) - 0.5) ./ N);
elseif mod(N, 2) == 1
    P = exp(1j .* pi .* (1:2 * N) ./ N);
end
% H(s)�ļ��㶼��Ҫ�����ƽ��
pn = P(real(P) < 0);
kn = 1;

bn = kn .* poly(zn);
an = poly(pn);
%%
% ȥ��һ��������һ����ͨ�˲���ӳ�䵽��ͨ/��ͨ/��ͨ�˲���
% [zs, ps, ks]  �㼫��������ʽ
% [bs, as]      ���ݺ�����ʽ
if type == 'lp'
    % ģ���ͨ��ģ���ͨ
    zs = zn;
    ps = Wc .* pn;
    ks = kn .* (Wc^N);
elseif type == 'hp'
    % ģ���ͨ��ģ���ͨ
    zs = 1 ./ zn;
    ps = Wc ./ pn;
    ks = kn;
elseif type == 'bp'
    % ģ���ͨ��ģ���ͨ
    zs = 1 ./ zn;
    W0 = sqrt(Wc(1) * Wc(2));   % ����Ƶ��
    Bw = abs(Wc(1) - Wc(2));    % ����
    for i = 1:N
        ps(2 * i - 1:2 * i) = roots([1, -Bw * pn(i), W0^2]);
    end   
    ks = Bw^N;
end

bs = ks .* poly(zs);
as = poly(ps);
%%
% ˫���Ա任����ģ��ϵͳӳ�䵽����ϵͳ
% [zz, pz, kz]  �㼫��������ʽ
% [bz, az]      ���ݺ�����ʽ
zs = zs(isfinite(zs));
zz = (1 + zs * (T / 2)) ./ (1 - zs * (T / 2));
pz = (1 + ps * (T / 2)) ./ (1 - ps * (T / 2));
kz = (ks * prod((2 / T) - zs)) ./ prod((2 / T) - ps);
% kz = ks.*real((prod((2 / T) - zs)) ./ prod((2 / T) - ps));

Z = -ones(size(pz));

for i = 1:numel(zz)
    Z(i) = zz(i);
end

zz = Z;

az = real(poly(pz));
bz = real(kz .* poly(zz));
end
