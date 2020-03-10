clc
clear all
close all

addpath(genpath('./Function'))

x=rand(32,32);

x=(x>0.95);
% x=(x);
x=imresize(x,[128 128]);
x=double(x);
figure,imagesc(x);
pause(1)

h=exp(-[-5:5].*[-5:5]);
h=h'*h;
h=h/sum(h,'all');

y=conv2(x,h,'full');

figure,imagesc(y);
pause(1)

xx=deconv2_fast_grad_descent(y,h);

figure,imagesc(xx);