function x = deconv2_sparse(y, h, lambda)
[row_y, col_y] = size(y);
[row_h, col_h] = size(h);
row_x = row_y - row_h + 1;
col_x = col_y - col_h + 1;

h_tilde = rot90(h, 2);

weight = lambda * ones(row_x, col_x);
% half_row = (row_h - 1) / 2;
% half_col = (col_h - 1) / 2;

% 设置初值
x = zeros(row_x, col_x);
% x = y(half_row + 1:end - half_row, half_col + 1:end - half_col);

% 设置迭代参数
lr = 0.02;
epoch_1 = 500;
epoch_2 = 5;
epoch_3 = 500;

% 第一次迭代，等权重
for i_1 = 1:epoch_1
    grad = conv2(h_tilde, (conv2(x, h, 'full') - y), 'full');
    grad = grad(row_h:row_y, col_h:col_y);
    descent = lr .* grad;
    x = x - descent;
    x = soft_thre(x, weight);
end

for i_2 = 1:epoch_2
%     根据上一轮迭代的解调整稀疏性权重
    weight = lambda * 1 ./ (x + 1e-5);
    for i_3 = 1:epoch_3
        grad = conv2(h_tilde, (conv2(x, h, 'full') - y), 'full');
        grad = grad(row_h:row_y, col_h:col_y);
        descent = lr .* grad;
        x = x - descent;
        x = soft_thre(x, weight);
    end
end

end

function y = soft_thre(x, L)
y = sign(x) .* (abs(x) - L) .* (abs(x) > L);
end
