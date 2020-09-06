clc
clear all
close all

rs=25;
rp=2;
ws_bs=[0.4 0.6];
wp_bs=[0.2 0.8];
[N_bs,wc_bs]=my_buttord(wp_bs, ws_bs, rp, rs);
[b_bs,a_bs]=my_butter(N_bs, wc_bs,'bs');

wp_bp=[0.4 0.6];
ws_bp=[0.2 0.8];
[N_bp,wc_bp]=my_buttord(wp_bp, ws_bp, rp, rs);
[b_bp,a_bp]=my_butter(N_bp, wc_bp,'bp');

wp_hp=0.8;
ws_hp=0.6;
[N_hp,wc_hp]=my_buttord(wp_hp, ws_hp, rp, rs);
[b_hp,a_hp]=my_butter(N_hp, wc_hp,'hp');

wp_lp=0.2;
ws_lp=0.4;
[N_lp,wc_lp]=my_buttord(wp_lp, ws_lp, rp, rs);
[b_lp,a_lp]=my_butter(N_lp, wc_lp,'lp');


Fs=10000;
t=(1:1:Fs)'/Fs;

w=(1:1:19)/20;
W=w.*(pi*Fs);
x=zeros(Fs,1);
for Wi=W
    Xi=sin(Wi.*t);
    x=x+Xi;
end
freq=(1:1:Fs)/(Fs/2);

Fx=fft(x);
figure(1)
plot(freq,abs(Fx))
xlim([0,1])
ylim([-100,6000])
xlabel('Normalized Frequenct (\times \pi rad/sample)')
ylabel('Amplitude of Original Signal')
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'origin.svg')

x_lp=my_filter(b_lp,a_lp,x);
Fx_lp=fft(x_lp);
figure(2)
plot(freq,abs(Fx_lp))
xlim([0,1])
ylim([-100,6000])
xlabel('Normalized Frequenct (\times \pi rad/sample)')
ylabel('Amplitude of Low Pass Signal')
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'lp.svg')


x_bp=my_filter(b_bp,a_bp,x);
Fx_bp=fft(x_bp);
figure(3)
plot(freq,abs(Fx_bp))
xlim([0,1])
ylim([-100,6000])
xlabel('Normalized Frequenct (\times \pi rad/sample)')
ylabel('Amplitude of Band Pass Signal')
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'bp.svg')


x_hp=my_filter(b_hp,a_hp,x);
Fx_hp=fft(x_hp);
figure(4)
plot(freq,abs(Fx_hp))
xlim([0,1])
ylim([-100,6000])
xlabel('Normalized Frequenct (\times \pi rad/sample)')
ylabel('Amplitude of High Pass Signal')
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'hp.svg')

x_bs=my_filter(b_bs,a_bs,x);
Fx_bs=fft(x_bs);
figure(5)
plot(freq,abs(Fx_bs))
xlim([0,1])
ylim([-100,6000])
xlabel('Normalized Frequenct (\times \pi rad/sample)')
ylabel('Amplitude of Band Stop Signal')
set(gcf,'Position',[100 100 800 400])
saveas(gcf,'bs.svg')


x_matlab=filter(b_hp,a_hp,x);
x_diff=x_hp-x_matlab;
figure(6)
plot(t,x_diff);
ylim([-1e-15 1e-15])
title('库函数和自定义函数输出差值')
set(gcf,'Position',[100 100 800 200])
saveas(gcf,'diff.svg')