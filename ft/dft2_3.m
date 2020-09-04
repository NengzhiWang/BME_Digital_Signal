clc
clear all
close all
set(0, 'defaultAxesFontSize', 18)

P = peaks(64);
img = repmat(P,[8 8]);


img_dft=ft2_matrix(img);
img_idft=real(ift2_matrix(img_dft));
img_freq_log=log10(abs(fftshift(img_dft)));

img_dft_2=fft2(img);
img_idft_2=real(ifft2(img_dft_2));
img_freq_log_2=log10(abs(fftshift(img_dft_2)));
img_dft_diff=(img_idft-img_idft_2);

img_mse=immse(img_idft,img_idft_2)
img_mse=immse(img,img_idft_2)


figure()
subplot(1,2,1)
imshow(img_idft,[])
colorbar
title('IDFT')
subplot(1,2,2)
imshow(img_freq_log,[])
colorbar
title('DFT / log')
saveas(gcf,'2-1.svg')

figure()
subplot(1,2,1)
imshow(img_idft_2,[]);
colorbar
title('IFFT')
subplot(1,2,2)
imshow(img_freq_log_2,[])
colorbar
title('FFT / log')
saveas(gcf,'2-2.svg')

figure()
subplot(1,2,1)
imshow(img_dft_diff,[])
colorbar
title('�ؽ�ͼ���ֵ')
subplot(1,2,2)
imshow(abs(fftshift(img_dft-img_dft_2)),[])
colorbar
title('Ƶ�ײ�ֵ')
saveas(gcf,'2-3.svg')
