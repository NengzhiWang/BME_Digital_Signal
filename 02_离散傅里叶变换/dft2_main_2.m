clc
clear all
% close all
set(0, 'defaultAxesFontSize', 18)

img = imread('cameraman.tif');
img = im2double(img);
img = imresize(img, [512 512]);

img_dft = dft2(img);
img_idft = real(idft2(img_dft));
img_freq_log = log10(abs(fftshift(img_dft)));

img_dft_2 = fft2(img);
img_idft_2 = real(ifft2(img_dft_2));
img_freq_log_2 = log10(abs(fftshift(img_dft_2)));
img_dft_diff = (img_idft - img_idft_2);

figure(1)
subplot(1, 2, 1)
imshow(img_idft, [])
colorbar
title('IDFT')
subplot(1, 2, 2)
imshow(img_freq_log, [])
colorbar
title('DFT / log')

figure(2)
subplot(1, 2, 1)
imshow(img_idft_2, []);
colorbar
title('IFFT')
subplot(1, 2, 2)
imshow(img_freq_log_2, [])
colorbar
title('FFT / log')

figure(3)
subplot(1, 2, 1)
imshow(img_dft_diff, [])
colorbar
title('重建图像差值')
subplot(1, 2, 2)
imshow(abs(fftshift(img_dft - img_dft_2)), [])
colorbar
title('频谱差值')
