img_dft_2=fft2(img);
img_idft_2=real(ifft2(img_dft_2));
img_freq_log_2=log10(abs(fftshift(img_dft_2)));


figure()
subplot(1,3,1)
imshow(img)
title('ԭͼ')
subplot(1,3,2)
imagesc(img_freq_log_2)
axis equal
colorbar
xlim([1,512])
ylim([1,512])
grid off
axis off
title('ԭͼƵ��')

subplot(1,3,3)
imshow(img_idft_2)
title('����Ҷ��任�ؽ�')