function x = deconv_L2(y, h, lambda)
    len_y = size(y, 1);
    len_h = size(h, 1);
    len_x = len_y - len_h + 1;

    h_tilde = flipud(h);

    x = zeros(len_x, 1);

    lr = 0.5 / ((h(:)' * h(:))^2);
    epoch = 1000;

    for i = 1:epoch
        grad = conv(h_tilde, (conv(x, h, 'full') - y), 'full');
        grad = grad(len_h:len_y);
        regular = lambda * x;
        descent = lr .* (grad + regular);
        x = x - descent;
        x = max(x, 0);

    end

end
