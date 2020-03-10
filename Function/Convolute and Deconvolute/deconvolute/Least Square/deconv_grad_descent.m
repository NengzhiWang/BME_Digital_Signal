function x = deconv_grad_descent(y, h)
    len_y = size(y, 1);
    len_h = size(h, 1);
    len_x = len_y - len_h + 1;
    A = zeros(len_y, len_x);

    for i = 1:len_x
        A(i:i + len_h - 1, i) = h;
    end

    x = zeros(len_x, 1);

    lr = 0.5 / ((h' * h)^2);
    epoch = 10000;

    Loss_temp = Loss_Function(x, A, y);
    x_temp = x;

    for i = 1:epoch
        grad = A' * (A * x - y);
        descent = lr .* grad;
        x = x - descent;
        Loss = Loss_Function(x, A, y);

        if Loss >= Loss_temp
            x = x_temp;
            lr = 0.5 * lr;
        else
            Loss_temp = Loss;
            x_temp = x;
        end

    end

end

function L = Loss_Function(x, A, y)
    y_conv = A * x;
    y_diff = y_conv - y;
    L = y_diff(:)' * y_diff(:);
end
