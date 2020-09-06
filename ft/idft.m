function x = idft(F)
len_x = size(F, 1);
w = (0:1:len_x - 1);
G = exp(2 .* 1i .* pi .* (w' * w) / len_x) ./ len_x;
x = G * F;
end
