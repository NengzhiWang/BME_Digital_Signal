function F = ft_matrix(x)
    len_x = size(x, 1);
    w = (0:1:len_x - 1);
    W = exp(-2 .* 1i .* pi .* (w' * w) / len_x);
    F = W * x;
end
