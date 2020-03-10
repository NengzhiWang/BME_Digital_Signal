function x = deconv_fast_grad_descent(y, h)
    len_y = size(y, 1);
    len_h = size(h, 1);
    len_x = len_y - len_h + 1;

    h_tilde = flipud(h);

    x = zeros(len_x, 1);

    lr = 0.5 / ((h' * h)^2);
    epoch = 10000;

    Loss_temp = Loss_Function(x, h, y);
    x_temp = x;

    for i = 1:epoch
        grad = conv(h_tilde, (conv(x, h, 'full') - y), 'full');
        grad = grad(len_h:len_y);
        descent = lr .* grad;
        x = x - descent;
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
    y_conv = conv(x, h, 'full');
    y_diff = y_conv - y;
    L = y_diff(:)' * y_diff(:);
end
