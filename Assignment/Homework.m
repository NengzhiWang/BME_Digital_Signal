clc
clear all
close all
addpath(genpath('../Function'))

img = zeros(1024, 1024);

for x = 1:1024

    for y = 1:1024
        L1 = ((x - 160)^2) / 144^2 + ((y - 540)^2) / 320^2;

        if L1 < 1
            img(x, y) = 0.25;
        end

        L2 = ((x - 320)^2) / 144^2 + ((y - 540)^2) / 256^2;

        if L2 < 1
            img(x, y) = 0.5;
        end

        L3 = abs(x - 540) / 400 + abs(y - 480) / 400;

        if L3 < 1 && x > 540 && y < 480
            img(x, y) = 1;
        end

    end

end

img(720:760, 540:940) = 1;
img(540:940, 720:760) = 1;

figure(1)
imshow(img)
%%
h = PSF(25);
figure, imagesc(h)
axis equal

y = conv2(img, h);
figure, imshow(y)

y_n = awgn(y, 50);

X_n_1 = deconv2_fast_grad_descent(y_n, h);

X_n_2 = deconv2_L1_regularization(y_n, h, 5e-6);
figure, imshow(X_n_1);
figure, imshow(X_n_2);

function x = deconv2_fas_grad_descent(y, h)
    [row_y, col_y] = size(y);
    [row_h, col_h] = size(h);
    row_x = row_y - row_h + 1;
    col_x = col_y - col_h + 1;

    h_tilde = rot90(h, 2);

    x = zeros(row_x, col_x);

    lr = 0.005 / (h(:)' * h(:))^2;
    epoch = 1000;

    for i = 1:epoch
        i
        grad = conv2(h_tilde, conv2(x, h, 'full') - y, 'full');
        grad = grad(row_h:row_y, col_h:col_y);
        descent = lr .* grad;
        x = x - descent;
        x = max(x, 0);
        figure(3)
        imshow(x)
    end

end

function x = deconv2_L2(y, h, lambda)
    [row_y, col_y] = size(y);
    [row_h, col_h] = size(h);
    row_x = row_y - row_h + 1;
    col_x = col_y - col_h + 1;

    h_tilde = rot90(h, 2);

    x = zeros(row_x, col_x);

    lr = 0.005 / (h(:)' * h(:))^2;
    epoch = 1000;

    for i = 1:epoch

        grad = conv2(h_tilde, conv2(x, h, 'full') - y, 'full');
        grad = grad(row_h:row_y, col_h:col_y);
        Regular = lambda .* x;
        descent = lr .* (grad + Regular);
        x = x - descent;
        x = max(x, 0);
        figure(5)
        imshow(x)
    end

end
