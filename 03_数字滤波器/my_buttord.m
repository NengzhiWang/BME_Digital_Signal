function [order, wc] = my_buttord(wp, ws, Rp, Rs)
% in MATLAB $ w = W / (pi * Fs) $ not $ w = W / Fs $ in textbook
% 滤波器类型
wp = sort(abs(wp));
ws = sort(abs(ws));
if numel(wp) == 1
    if wp < ws
        % 低通
        ftype = 1;
    elseif wp > ws
        % 高通
        ftype = 2;
    end
elseif numel(wp) == 2
    if wp(1) > ws(1) && wp(2) < ws(2)
        % 带通
        ftype = 3;
    elseif wp(1) < ws(1) && wp(2) > ws(2)
        % 带阻，直接调用库函数
        ftype = 4;
    end
end

if ftype ~= 4
    % 根据数字频率计算模拟频率，进行预畸变
    T = 2;
    Wp = (2 / T) .* tan(pi .* wp ./ 2);
    Ws = (2 / T) .* tan(pi .* ws ./ 2);
    
    if ftype == 1
        % 低通
        Wst = Ws / Wp;
    elseif ftype == 2
        % 高通
        Wst = Wp / Ws;
    elseif ftype == 3
        % 带通
        Wst = (Ws.^2 - Wp(1) * Wp(2)) ./ (Ws * (Wp(1) - Wp(2)));
        Wst = min(abs(Wst));
    elseif ftype == 4
        % 带阻，直接调用库函数
    end
    
    % 计算最小阶数
    G = (10^(0.1 * Rs) - 1) / (10^(0.1 * Rp) - 1);
    order = ceil(log(G) / (2 * log(Wst)));
    % 计算截止频率
    W0 = Wst / ((10^(0.1 * Rs) - 1)^(1 / (2 * order)));
    
    if ftype == 1
        % 低通
        Wc = Wp * W0;
    elseif ftype == 2
        % 高通
        Wc = Wp / W0;
    elseif ftype == 3
        % 带通
        W0 = [-W0, W0];
        W2 = Wp(2);
        W1 = Wp(1);
        Wc = W0 * (W2 - W1) / 2 + sqrt((W0.^2) / 4 * (W2 - W1)^2 + W1 * W2);
        Wc = sort(abs(Wc));
    end
    % 根据模拟频率计算数字频率，反畸变
    wc = (2 / pi) .* atan(T .* Wc ./ 2);
elseif ftype == 4
    % 带阻，直接调用库函数
 end
end
