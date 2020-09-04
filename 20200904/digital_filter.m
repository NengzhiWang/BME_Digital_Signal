clc
clear all
close all

wp=[0.24 0.6];
ws=[0.12 0.8];

% wp= 0.6;
% ws= 0.8;
rs=15;
rp=2;
[N,wc]=my_buttord(wp, ws, rp, rs)
[N,wc]=buttord(wp, ws, rp, rs)

[b,a]=butter(N,wc);
[bb,aa]=my_butter(N,wc,'bp');

aa-a

bb-b