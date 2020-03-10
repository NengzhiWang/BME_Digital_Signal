function y = conv2_define(x, h)
    [row_x, col_x] = size(x);
    [row_h, col_h] = size(h);
    row_y = row_x + row_h - 1;
    col_y = col_x + col_h - 1;
    y = zeros(row_y, col_y);

    for y_r = 1:row_y

        for y_c = 1:col_y

            for x_r = max(y_r - row_h + 1, 1):min(row_x, y_r)

                for x_c = max(y_c - col_h + 1, 1):min(col_x, y_c)
                    h_r = y_r - x_r + 1;
                    h_c = y_c - x_c + 1;
                    X = x(x_r, x_c);
                    H = h(h_r, h_c);
                    y(y_r, y_c) = y(y_r, y_c) + X * H;
                end

            end

        end

    end

end
