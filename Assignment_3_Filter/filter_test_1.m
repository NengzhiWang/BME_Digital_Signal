clc
clear all
% close all
TT = [1,0.1,10];
L=2048;
for i=1:length(TT)
    T=TT(i);
    W=linspace(0,2*pi/T,L);
    w=W*T;
    f=w/(pi);
    Y_a=analog(W);
    Y_d=digital(W,T);
    
    
    figure(i)
    subplot(2,1,1)
    plot(f,Y_a)
    xlabel('\Omega \pi/T')
    ylabel('|H_a(j\omega)|')
    subplot(2,1,2)
    plot(f,Y_d)
    xlabel('\omega \pi')
    ylabel('|H(e^{j\omega}|')
    
    sut=sprintf('T=%.2f',T);
    sgtitle(sut)
    saveas(gcf,[sut,'.svg'])
end



function Y=analog(W)
s=1j.*W;
y=2./(s.^2+4.*s+3);
Y=(abs(y));
end

function Y=digital(W,T)
w=W*T;
z=exp(1j*w);
A=T.*(exp(-T)-exp(-3*T)).*(z.^(-1));
B=1-(exp(-T)+exp(-3*T))*(z.^(-1))+exp(-4*T)*(z.^(-2));
y=A./B;
Y=(abs(y));
end
