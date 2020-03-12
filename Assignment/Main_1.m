clc
clear all
close all
addpath(genpath('./Function_Assignment_1'))




h = Conv_Core(25, 25, 8);
figure, imagesc(h)
axis equal
axis off

img = Test_Image();


figure, imshow(img);
Y = conv2(img, h, 'full');
snr=0;
Y1 = Add_Noise(Y, snr);
% Y1=awgn(Y,snr);
figure, imshow(Y)
figure, imshow(Y1)

Y1=single(Y1);
Y1=gpuArray(Y1);
h=single(h);
h=gpuArray(h);
close all

x = deconv2_fast_grad_descent(Y1, h);
x_r=rescale(x);
figure, imshow(x);
title('快速梯度下降')
figure, imshow(x_r);
title('快速梯度下降 调整')

pause(1)

x2 = deconv2_L2_regularization(Y1, h, 1);
x2_r=rescale(x2);

figure, imshow(x2);
title('L2')

figure, imshow(x2_r);
title('L2 调整')
pause(1)
close all
x3 = deconv2_L1_regularization(Y1, h, 0.00009);
x3_r=rescale(x3);

figure, imshow(x3);
title('L1')

figure, imshow(x3_r);
title('L1 调整')
pause(1)


