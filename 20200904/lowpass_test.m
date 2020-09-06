clc
clear all
% close all
set(0, 'defaultAxesFontSize', 18)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
wp_lp=0.2;
ws_lp=0.4;

rs=25;
rp=2;
[N_1,wc_1]=my_buttord(wp_lp, ws_lp, rp, rs);
[N_2,wc_2]=buttord(wp_lp, ws_lp, rp, rs);
[b_1,a_1]=my_butter(N_1, wc_1,'lp');
[b_2,a_2]=butter(N_2, wc_2);

figure(1)
freqz(b_1,a_1)
title(sprintf('%d阶低通滤波器，自定义函数实现',N_1))
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'lp-1.svg')
figure(2)
freqz(b_2,a_2)
title(sprintf('%d阶低通滤波器，库函数实现',N_2))
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'lp-2.svg')

figure(3)
subplot(1,2,1)
zplane(b_1,a_1)
title('自定义函数实现')
subplot(1,2,2)
zplane(b_1,a_1)
title('库函数实现')
set(gcf,'Position',[100 100 800 300])
saveas(gcf,'lp-3.svg')
