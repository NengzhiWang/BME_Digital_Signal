function x = deconvn_fast_grad_descent(y, h)

    dims = ndims(y);
    size_y = zeros(dims, 1);
    size_h = zeros(dims, 1);

    for each_dim = 1:dims
        size_y(each_dim) = size(y, each_dim);
        size_h(each_dim) = size(h, each_dim);
    end

    h_tilde = h;

    for each_dim = 1:dims
        h_tilde = flip(h_tilde, each_dim);
    end

    size_x = size_y - size_h + 1;
    x = zeros(size_x(:)');

    lr = 0.5 / (h(:)' * h(:))^2;
    epoch = 1000;

    Loss_temp = Loss_Function(x, h, y);
    x_temp = x;

    for i = 1:epoch
        grad = convn(h_tilde, convn(x, h, 'full') - y, 'full');

        for each_dim = 1:dims
            index = size_h(each_dim):size_y(each_dim);
            grad = extractMatrix(grad, each_dim, index);
        end

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

function newMatrix = extractMatrix(matrix, dim, index)
    id = repmat({':'}, 1, ndims(matrix));
    id{dim} = index;
    newMatrix = matrix(id{:});
end

function L = Loss_Function(x, h, y)
    y_conv = convn(x, h, 'full');
    y_diff = y_conv - y;
    L = y_diff(:)' * y_diff(:);
end
