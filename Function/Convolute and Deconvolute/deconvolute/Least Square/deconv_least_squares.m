function x = deconv_least_squares(y, h)
    len_y = size(y, 1);
    len_h = size(h, 1);
    len_x = len_y - len_h + 1;
    A = zeros(len_y, len_x);

    for i = 1:len_x
        A(i:i + len_h - 1, i) = h;
    end

    x = (A' * A) \ A' * y;
    %     x = inv(A' * A) * A' * y;
end
