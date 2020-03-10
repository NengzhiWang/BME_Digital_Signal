function y = PSF(s)
    len = 2 * s + 1;
    c = s + 1;
    y = zeros(len, len);

    for i = 1:len

        for j = 1:len
            d = sqrt((i - c)^2 + (j - c)^2);
            d = d / 5;

            if d == 0
                y(i, j) = 1;
            else
                y(i, j) = (2 * besselj(1, d) ./ d).^2;
            end

        end

    end

    y = y / sum(y(:));
end
