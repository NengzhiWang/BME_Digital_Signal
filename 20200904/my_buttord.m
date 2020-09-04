function [order, wc] = my_buttord(wp, ws, Rp, Rs)
% in MATLAB $ w = W / (pi * Fs) $ not $ w = W / Fs $ in textbook
% �˲�������
wp = sort(abs(wp));
ws = sort(abs(ws));
if numel(wp) == 1
    if wp < ws
        % ��ͨ
        ftype = 1;
    elseif wp > ws
        % ��ͨ
        ftype = 2;
    end
elseif numel(wp) == 2
    if wp(1) < ws(1) && wp(2) > ws(2)
        % ���裬δ���
        ftype = 3;
    elseif wp(1) > ws(1) && wp(2) < ws(2)
        % ��ͨ
        ftype = 4;
    end
end

% ��������Ƶ�ʼ���ģ��Ƶ�ʣ�����Ԥ����
T = 2;
Wp = (2 / T) .* tan(pi .* wp ./ 2);
Ws = (2 / T) .* tan(pi .* ws ./ 2);
if ftype == 1
    % ��ͨ
    Wst = Ws / Wp;
elseif ftype == 2
    % ��ͨ
    Wst = Wp / Ws;
elseif ftype == 4
    % ��ͨ
    Wst = (Ws.^2 - Wp(1) * Wp(2)) ./ (Ws * (Wp(1) - Wp(2)));
    Wst = min(abs(Wst));
end

% ������С����
G = (10^(0.1 * Rs) - 1) / (10^(0.1 * Rp) - 1);
order = ceil(log(G) / (2 * log(Wst)));
% �����ֹƵ��
W0 = Wst / ((10^(0.1 * Rs) - 1)^(1 / (2 * order)));
if ftype == 1
    %     W0 = Wst / ((10^(0.1 * Rs) - 1)^(1 / (2 * order)));
    Wc = Wp * W0;
elseif ftype == 2
    %     W0 = Wst / ((10^(0.1 * Rs) - 1)^(1 / (2 * order)));
    Wc = Wp / W0;
elseif ftype == 4
    %     W0 = Wst / ((10^(0.1 * Rs) - 1)^(1 / (2 * order)));
    W0 = [-W0, W0];
    W2 = Wp(2);
    W1 = Wp(1);
    Wc = W0 * (W2 - W1) / 2 + sqrt((W0.^2) / 4 * (W2 - W1)^2 + W1 * W2);
    Wc = sort(abs(Wc));
end

% ����ģ��Ƶ�ʼ�������Ƶ�ʣ�������
wc = (2 / pi) .* atan(T .* Wc ./ 2);
end
