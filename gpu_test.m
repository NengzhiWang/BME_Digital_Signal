clc
clear all
close all
addpath(genpath('./Function'))
! del *.tif
pause(1)
img=imread('Screenshot_2019-01-13-01-00-59-637_tv.danmaku.bili.png');

x=double(img)/255;
h=double(rand(15,15,15)>0.5);

h=h/sum(h,'all');
y=convn(x,h,'full');


global X
X=convn(x,h,'same');
xx=deconvn_gpu(y,h);

imwrite(x,'origin.tif');
imwrite(xx,'deconv.tif');

function x = deconvn_gpu(y, h)

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

epoch = 100;

size_x = size_y - size_h + 1;
global X
x=X;
% x = rand(size_x(:)');



% 
y=single(y);
% y=gpuArray(y);
x=single(x);
% x=gpuArray(x);
h=single(h);
% h=gpuArray(h);

Loss_temp = loss_function(x, h, y);


for i = 1:epoch
    tic
%     fprintf('%d \n', i)
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
    
toc
end

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
