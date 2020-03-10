function y = conv2_double_conv(x, h)
[row_x, col_x] = size(x);
[row_h, col_h] = size(h);

row_y = row_x + row_h - 1;
col_y = col_x + col_h - 1;

y = zeros(row_y, col_y);

for y_r = 1:row_y
    for x_r = max(y_r - row_h + 1, 1):min(row_x, y_r)
        h_r = y_r - x_r + 1;
        X = x(x_r, :);
        H = h(h_r, :);
        y(y_r, :) = y(y_r, :) + conv(X, H, 'full');
    end 
end

end
