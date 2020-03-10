function y = conv_define(x, h)
    len_x = size(x, 1);
    len_h = size(h, 1);
    len_y = len_x + len_h - 1;
    y = zeros(len_y, 1);

    for i = 1:len_y

        for j = max(i - len_h + 1, 1):min(len_x, i)
            k = i - j + 1;
            y(i) = y(i) + x(j) * h(k);
        end

    end

end
