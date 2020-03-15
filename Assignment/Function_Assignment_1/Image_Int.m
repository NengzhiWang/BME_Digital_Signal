function y = Image_Int(x)
    [row, col] = size(x);

    for i = 2:row
        x(i, :) = x(i, :) + x(i - 1, :);
    end

    y = x;
end
