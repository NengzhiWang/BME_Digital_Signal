function y = conv_matrix_dot(x, h)
    len_x = size(x, 1);
    len_h = size(h, 1);
    len_y = len_x + len_h - 1;
    A = zeros(len_y, len_x);

    for i = 1:len_x
        A(i:i + len_h - 1, i) = h;
    end

    y = A * x;
end
