function y = conv_mask_slide(x, h)
    len_x = size(x, 1);
    len_h = size(h, 1);
    len_y = len_x + len_h - 1;
    y = zeros(len_y, 1);

    for i = 1:len_x
        y(i:i + len_h - 1) = y(i:i + len_h - 1) + x(i) * h;
    end

end
