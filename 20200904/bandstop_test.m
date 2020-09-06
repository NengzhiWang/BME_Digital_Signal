clc
clear all
% close all
set(0, 'defaultAxesFontSize', 18)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
ws_bs=[0.4 0.6];
wp_bs=[0.2 0.8];

rs=25;
rp=2;
[N_1,wc_1]=my_buttord(wp_bs, ws_bs, rp, rs);
[N_2,wc_2]=buttord(wp_bs, ws_bs, rp, rs);
[b_1,a_1]=my_butter(N_1, wc_1,'bs');
[b_2,a_2]=butter(N_2, wc_2,'stop');

figure(1)
freqz(b_1,a_1)
title(sprintf('%d阶带阻滤波器，自定义函数实现',N_1))
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'bs-1.svg')
figure(2)
freqz(b_2,a_2)
title(sprintf('%d阶带阻滤波器，库函数实现',N_2))
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'bs-2.svg')

figure(3)
subplot(1,2,1)
zplane(b_1,a_1)
title('自定义函数实现')
subplot(1,2,2)
zplane(b_1,a_1)
title('库函数实现')
set(gcf,'Position',[100 100 800 300])
saveas(gcf,'bs-3.svg')
