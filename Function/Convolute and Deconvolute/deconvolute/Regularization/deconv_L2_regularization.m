function x = deconv_L2_regularization(y, h, lambda)
    len_y = size(y, 1);
    len_h = size(h, 1);
    len_x = len_y - len_h + 1;

    h_tilde = flipud(h);

    x = zeros(len_x, 1);

    lr = 0.5 / ((h(:)' * h(:))^2);
    epoch = 10000;

    Loss_temp = Loss_Function(x, h, y,lambda);
    x_temp = x;
    
    for i = 1:epoch
        grad = conv(h_tilde, (conv(x, h, 'full') - y), 'full');
        grad = grad(len_h:len_y);
        Regular = lambda * x;
        descent = lr .* (grad + Regular);
        x = x - descent;
        x = max(x, 0);
        Loss = Loss_Function(x, h, y,lambda);

        if Loss >= Loss_temp
            x = x_temp;
            lr = 0.5 * lr;
        else
            Loss_temp = Loss;
            x_temp = x;

        end
    end
    
end

function L = Loss_Function(x, h, y,lambda)
    y_conv = conv(x, h, 'full');
    y_diff = y_conv - y;
    L2_Regular=x(:)'*x(:);
    L = y_diff(:)' * y_diff(:)+lambda.*L2_Regular;
end