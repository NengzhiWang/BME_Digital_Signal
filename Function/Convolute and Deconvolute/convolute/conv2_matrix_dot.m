function y = conv2_matrix_dot(x, h)
    [row_x, col_x] = size(x);
    [row_h, col_h] = size(h);
    row_y = row_x + row_h - 1;
    col_y = col_x + col_h - 1;

    x_vector = reshape(x', [], 1);

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

    y_vector = Ah * x_vector;

    y = reshape(y_vector, col_y, row_y)';

end
