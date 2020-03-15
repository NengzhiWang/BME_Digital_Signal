function x = deconv2_fast_grad_descent(y, h)
[row_y, col_y] = size(y);
[row_h, col_h] = size(h);
row_x = row_y - row_h + 1;
col_x = col_y - col_h + 1;

h_tilde = rot90(h, 2);

% half_row = (row_h - 1) / 2;
% half_col = (col_h - 1) / 2;
% 设置初值
x = zeros(row_x, col_x);
% x = y(half_row + 1:end - half_row, half_col + 1:end - half_col);

lr = 0.02;
epoch = 1000;
% 迭代计算
for i = 1:epoch
    grad = conv2(h_tilde, conv2(x, h, 'full') - y, 'full');
    grad = grad(row_h:row_y, col_h:col_y);
    descent = lr .* grad;
    x = x - descent;
    x = max(x, 0);
end

end
