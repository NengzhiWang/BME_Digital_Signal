function y=Image_Scale_Color(x)
x=Rescale(x);
[row,col]=size(x);
y=ones(row,col,3);
y(:,:,3)=x;
y=ntsc2rgb(y);
end

