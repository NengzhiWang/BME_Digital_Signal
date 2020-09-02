function x = deconv_L1(y, h, lambda)
% 初始化
% x, y & h should be column vector
lambda = 1e-3 * lambda;
len_y = size(y, 1);
len_h = size(h, 1);
len_x = len_y - len_h + 1;
x = zeros(len_x, 1);
% 反转卷积模板
h_tilde = flipud(h);
% 初始化权重和迭代参数
weight = lambda * ones(len_x, 1);
lr = 0.01;
epoch_1 = 10;
epoch_2 = 100;

for i_1 = 1:epoch_1
    
    for i_2 = 1:epoch_2
        % 梯度下降和软阈值迭代
        
        % 快速逆卷积，计算梯度
        grad = conv(h_tilde, (conv(x, h, 'full') - y), 'full');
        grad = grad(len_h:len_y);
        descent = lr .* grad;
        x = x - descent;
        % 软阈值操作并引入非负性
        x = (x >= 0) .* (abs(x) > weight) .* (abs(x) - weight);
        
    end
    
    % 根据梯度下降结果，更新权重
    weight = lambda .* (1 ./ (x + 1e-6));
end

end
