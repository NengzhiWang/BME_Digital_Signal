clc
clear all
close all
addpath(genpath('./Function'))
! del *.tif
pause(1)
img=imread('Screenshot_2019-01-13-01-00-59-637_tv.danmaku.bili.png');
% img=imread('illust_63348042_20171227_134913.jpg');

x=double(img)/255;
h=double(rand(15,15,15)>0.5);

h=h/sum(h,'all');
y=convn(x,h,'full');


global X
X=convn(x,h,'same');
xx=deconvn(y,h);

imwrite(x,'origin.tif');
imwrite(xx,'deconv.tif');

function x = deconvn(y, h)

dims = ndims(y);
size_y = zeros(dims, 1);
size_h = zeros(dims, 1);

for each_dim = 1:dims
    size_y(each_dim) = size(y, each_dim);
    size_h(each_dim) = size(h, each_dim);
end

h_tilde = h;

for each_dim = 1:dims
    h_tilde = flip(h_tilde, each_dim);
end

lr = 0.05 / (h(:)' * h(:))^2;

lr=1e-3*lr;
epoch = 900;

size_x = size_y - size_h + 1;
%     x = zeros(size_x(:)');
%     x = rand(size_x(:)');
global X
x=X;
% x = rand(size_x(:)');

Loss_temp = loss_function(x, h, y);

vid=VideoWriter('./Epoch_4','MPEG-4');
open(vid);
frame=x;
frame=frame/max(frame(:));
frame=uint8(frame*255);
% frame=uint8(min(frame*255.0,255.0));
for j=1:30
    writeVideo(vid,frame);
end

for i = 1:epoch
    
    fprintf('%d \n', i)
    x_temp = x;
    grad = convn(h_tilde, convn(x, h, 'full') - y, 'full');
    
    for each_dim = 1:dims
        index = size_h(each_dim):size_y(each_dim);
        grad = extractMatrix(grad, each_dim, index);
    end
    
    descent = lr .* grad;
    x = x - descent;
    x = max(x, 0);
    Loss = loss_function(x, h, y);
    
    if Loss >= Loss_temp
        x = x_temp;
        lr = 0.5 * lr;
    else
        
        Loss_temp = Loss;
    end
    
    frame=x;
    frame=frame/max(frame(:));
    frame=uint8(frame*255);
    % frame=uint8(min(frame*255.0,255.0));
    for j=1:10
        writeVideo(vid,frame);
    end
    %     figure(1),imshow(frame);
    %     title(num2str(i))
end
close(vid)
end

function newMatrix = extractMatrix(matrix, dim, index)
id = repmat({':'}, 1, ndims(matrix));
id{dim} = index;
newMatrix = matrix(id{:});
end

function L = loss_function(x, h, y)
diff = convn(x, h, 'full') - y;
L = diff(:)' * diff(:);
end
