function F = dft2(x)
[row, col] = size(x);
w_row = (0:1:row - 1);
w_col = (0:1:col - 1);
Gm = exp(-2 .* 1i .* pi .* (w_row' * w_row) / row);
Gn = exp(-2 .* 1i .* pi .* (w_col' * w_col) / col);
F = Gm * x * Gn;
end
