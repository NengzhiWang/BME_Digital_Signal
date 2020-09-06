clc
clear lal
close all


rs=225;
rp=2;
ws=[0.4 0.6];
wp=[0.2 0.8];
[N1,wc1]=buttord(wp,ws,rp,rs)
[N2,wc2]=my_buttord(wp,ws,rp,rs)

