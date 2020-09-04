clc
clear all
close all

x=rand(1024,1);
Fx=fft(x);


xxx=(0:1:1023)'*(0:1:1023);
W=exp(-2*pi*1i*xxx/1024);
%
FXX=W*x;

xx=inv(W)*FXX;

immse(real(xx),real(x))


len_x=size(x,1);
w_1=exp(-1i*2*pi/len_x);
G=zeros(len_x,len_x);
for row =1:len_x
    for col=1:len_x
        G(row, col) = w_1^((row - 1) * (col - 1));  
    end
end

F=G*x;

immse(F,Fx)
