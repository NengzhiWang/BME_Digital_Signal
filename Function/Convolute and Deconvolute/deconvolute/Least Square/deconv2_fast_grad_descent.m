function x = deconv2_fast_grad_descent(y, h)
[row_y, col_y] = size(y);
[row_h, col_h] = size(h);
row_x = row_y - row_h + 1;
col_x = col_y - col_h + 1;

h_tilde = rot90(h, 2);

half_row = (row_h - 1) / 2;
half_col = (col_h - 1) / 2;
x = y(half_row + 1:end - half_row, half_col + 1:end - half_col);

x = zeros(row_x, col_x);
lr = 0.5 / (h(:)' * h(:))^2;
lr = 0.02;
epoch = 1000;

Loss_temp = Loss_Function(x, h, y);
x_temp = x;

for i = 1:epoch
    
    grad = conv2(h_tilde, conv2(x, h, 'full') - y, 'full');
    grad = grad(row_h:row_y, col_h:col_y);
    descent = lr .* grad;
    x = x - descent;
    x = max(x, 0);
    Loss = Loss_Function(x, h, y);
    
    if Loss >= Loss_temp
        x = x_temp;
        lr = 0.5 * lr;
    else
        Loss_temp = Loss;
        x_temp = x;
    end
    
end

end

function L = Loss_Function(x, h, y)
y_conv = conv2(x, h, 'full');
y_diff = y_conv - y;
L = y_diff(:)' * y_diff(:);
end
