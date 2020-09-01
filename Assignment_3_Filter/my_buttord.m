function [order, wc] = my_buttord(wp, ws, Rp, Rs)
% in MATLAB $ w = W / (pi * Fs) $ not $ w = W / Fs $ in textbook
T = 2;

% D-A, pre-warped frequencies
Wp = (2 / T) .* tan(pi .* wp ./ 2);
Ws = (2 / T) .* tan(pi .* ws ./ 2);
G = (10^(0.1 * Rs) - 1) / (10^(0.1 * Rp) - 1);

if Wp < Ws
    % low pass
    Wa = Ws / Wp;
elseif Wp > Ws
    % high pass
    Wa = Wp / Ws;
end

% min order
order = ceil(log(G) / (2 * log(Wa)));
% cutoff frequency
Wp0 = Wa / ((10^(0.1 * Rp) - 1)^(1 / (2 * order)));
Ws0 = Wa / ((10^(0.1 * Rs) - 1)^(1 / (2 * order)));

if Wp < Ws
    Wc = Wp * Ws0;
elseif Wp > Ws
    Wc = Wp / Ws0;
end

% A-D, anti-warped frequencies
wc = (2 / pi) .* atan(T .* Wc ./ 2);
end
