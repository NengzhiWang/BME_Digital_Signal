clc
clear all
% close all
set(0, 'defaultAxesFontSize', 18)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
wp_hp=0.8;
ws_hp=0.6;

rs=25;
rp=2;
[N_1,wc_1]=my_buttord(wp_hp, ws_hp, rp, rs);
[N_2,wc_2]=buttord(wp_hp, ws_hp, rp, rs);
[b_1,a_1]=my_butter(N_1, wc_1,'hp');
[b_2,a_2]=butter(N_2, wc_2,'high');

figure(1)
freqz(b_1,a_1)
title(sprintf('%d�׸�ͨ�˲������Զ��庯��ʵ��',N_1))
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'hp-1.svg')
figure(2)
freqz(b_2,a_2)
title(sprintf('%d�׸�ͨ�˲������⺯��ʵ��',N_2))
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'hp-2.svg')

figure(3)
subplot(1,2,1)
zplane(b_1,a_1)
title('�Զ��庯��ʵ��')
subplot(1,2,2)
zplane(b_1,a_1)
title('�⺯��ʵ��')
set(gcf,'Position',[100 100 800 300])
saveas(gcf,'hp-3.svg')
