clc
clear all
close all
addpath(genpath('./Function'))

x=double(rand(100,100)>0.9);
h=rand(15,15);
h=h/sum(h,'all');
y=conv2(x,h,'full');
figure,imagesc(x)

x_1=deconv2_fast_grad_descent(y,h);
figure,imagesc(x_1)
