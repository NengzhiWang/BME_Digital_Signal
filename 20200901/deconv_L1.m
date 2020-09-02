function x = deconv_L1(y, h, lambda)
% ��ʼ��
% x, y & h should be column vector
lambda = 1e-3 * lambda;
len_y = size(y, 1);
len_h = size(h, 1);
len_x = len_y - len_h + 1;
x = zeros(len_x, 1);
% ��ת���ģ��
h_tilde = flipud(h);
% ��ʼ��Ȩ�غ͵�������
weight = lambda * ones(len_x, 1);
lr = 0.01;
epoch_1 = 10;
epoch_2 = 100;

for i_1 = 1:epoch_1
    
    for i_2 = 1:epoch_2
        % �ݶ��½�������ֵ����
        
        % ���������������ݶ�
        grad = conv(h_tilde, (conv(x, h, 'full') - y), 'full');
        grad = grad(len_h:len_y);
        descent = lr .* grad;
        x = x - descent;
        % ����ֵ����������Ǹ���
        x = (x >= 0) .* (abs(x) > weight) .* (abs(x) - weight);
        
    end
    
    % �����ݶ��½����������Ȩ��
    weight = lambda .* (1 ./ (x + 1e-6));
end

end
