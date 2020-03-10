clc
clear all
close all
addpath(genpath('../Function'))

temp = conv_core(25, 25, 9);
% temp = conv_core(9,9,3);
figure, imagesc(temp)
axis equal
axis off

% figure, imshow(temp ./ max(temp(:)))
img = Test_Image();
X = zeros(100, 100);
X(11:90, 11:90) = double(rand(80, 80) > 0.98);
% img=X;

figure, imshow(img);
Y = conv2(img, temp, 'full');
Y = Y / max(Y(:));
Y = awgn(Y, 25);
figure, imshow(Y)

x = deconv2_fast_grad_descent(Y, temp);
figure, imshow(x);

x2 = deconv2_L2_regularization(Y, temp, 0.1);
figure, imshow(x2);

x3=deconv2_L1_regularization(Y,temp,1);
figure,imshow(x3)
