clc
clear all
close all
addpath(genpath('./Function_Assignment_1'))
%%
% 生成原始数据
SNR = 0;
img = Test_Image();
h = Conv_Core(25, 25, 8);
y = conv2(img, h, 'full');
y_N = Add_Noise(y, SNR);
figure, imshow(img)
title('origin image')

figure, imshow(y)
title('image without noise')

figure, imshow(y_N)
title('image with noise')

imwrite(img, './Image/test image.tif');
imwrite(y, './Image/conv image without noise.tif');
imwrite(y_N, './Image/conv image with noise.tif')
pause(1)

%%
% 使用GPU数组，加快计算
y_N = single(y_N);
y_N = gpuArray(y_N);
h = single(h);
h = gpuArray(h);

%%
% 快速梯度下降
x_1 = deconv2_fast_grad_descent(y_N, h);
x_1 = gather(x_1);
x_1 = Rescale(x_1);
figure, imshow(x_1)
title('deconv grad descent')
imwrite(x_1, './Image/deconv grad descent.tif')
pause(1)

%%
% 光滑性逆卷积
x_L2_1 = deconv2_smooth(y_N, h, 0.5);
x_L2_1 = gather(x_L2_1);
x_L2_1 = Rescale(x_L2_1);
figure, imshow(x_L2_1)
title('deconv smooth 0.5')
imwrite(x_L2_1, './Image/deconv smooth 0.5.tif')
pause(1)

x_L2_2 = deconv2_smooth(y_N, h, 0.05);
x_L2_2 = gather(x_L2_2);
x_L2_2 = Rescale(x_L2_2);
figure, imshow(x_L2_2)
title('deconv smooth 0.05')
imwrite(x_L2_2, './Image/deconv smooth 0.05.tif')
pause(1)

x_L2_3 = deconv2_smooth(y_N, h, 5);
x_L2_3 = gather(x_L2_3);
x_L2_3 = Rescale(x_L2_3);
figure, imshow(x_L2_3)
title('deconv smooth 5')
imwrite(x_L2_3, './Image/deconv smooth 5.tif')
pause(1)

%%
% 稀疏性逆卷积
x_L1_1 = deconv2_sparse(y_N, h, 1e-3);
x_L1_1 = gather(x_L1_1);
x_L1_1 = Rescale(x_L1_1);
figure, imshow(x_L1_1)
title('deconv sparse 1e-3')
imwrite(x_L1_1, './Image/deconv sparse 1e-3.tif')
pause(1)

x_L1_2 = deconv2_sparse(y_N, h, 5e-3);
x_L1_2 = gather(x_L1_2);
x_L1_2 = Rescale(x_L1_2);
figure, imshow(x_L1_2)
title('deconv sparse 5e-3')
imwrite(x_L1_2, './Image/deconv sparse 5e-3.tif')
pause(1)

x_L1_3 = deconv2_sparse(y_N, h, 2e-4);
x_L1_3 = gather(x_L1_3);
x_L1_3 = Rescale(x_L1_3);
figure, imshow(x_L1_3)
title('deconv sparse 2e-4')
imwrite(x_L1_3, './Image/deconv sparse 2e-4.tif')
pause(1)
