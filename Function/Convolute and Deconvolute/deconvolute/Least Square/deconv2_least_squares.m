function x = deconv2_least_squares(y, h)
    [row_y, col_y] = size(y);
    [row_h, col_h] = size(h);
    row_x = row_y - row_h + 1;
    col_x = col_y - col_h + 1;
    Ah = zeros(row_y * col_y, row_x * col_x);

    for x_r = 1:row_x

        for h_r = 1:row_h
            matrix_temp = zeros(col_y, col_x);
            h_vector_temp = h(h_r, :);
            % h_vector = h_vector';
            for x_c = 1:col_x
                matrix_temp(x_c:x_c + col_h - 1, x_c) = h_vector_temp;
            end

            % for x_c = 1:col_x
            %     for h_c = 1:col_h
            %         matrix_temp(x_c + h_c - 1, x_c) = h_vector(h_c);
            %     end
            % end
            upper = (x_r + h_r - 2) * col_y + 1;
            lower = (x_r + h_r - 1) * col_y;
            left = (x_r - 1) * col_x + 1;
            right = x_r * col_x;
            Ah(upper:lower, left:right) = matrix_temp;
        end

    end

    y_vector = reshape(y', [], 1);
    x_vector = (Ah' * Ah) \ Ah' * y_vector;
    %     x_vector = inv(Ah' * Ah) * Ah' * y_vector;
    x = reshape(x_vector, col_x, row_x)';
end
