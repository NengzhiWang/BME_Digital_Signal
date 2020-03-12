function y = Image_Diff(x)
    [row, col] = size(x);

    y = zeros(row + 1, col);

    y(2:end, :) = x;
    y = diff(y, 1);

end
