function y = conv2_mask_slide(x, h)
    [row_x, col_x] = size(x);
    [row_h, col_h] = size(h);
    row_y = row_x + row_h - 1;
    col_y = col_x + col_h - 1;
    y = zeros(row_y, col_y);

    for x_r = 1:row_x

        for x_c = 1:col_x
            upper = x_r;
            lower = upper + row_h - 1;
            left = x_c;
            right = left + col_h - 1;
            X = x(x_r, x_c);
            Y = X .* h;
            y(upper:lower, left:right) = y(upper:lower, left:right) + Y;
        end

    end

end
