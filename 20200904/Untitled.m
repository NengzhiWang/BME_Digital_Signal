clc
clear all
close all

rp=2;
rs=15;
wp=0.6;
ws=0.8;
[N,wc]=buttord(wp,ws,rp,rs)
[N,wc]=my_buttord(wp,ws,rp,rs)
