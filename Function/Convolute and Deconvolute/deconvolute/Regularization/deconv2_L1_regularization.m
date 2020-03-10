function x = deconv2_L1_regularization(y, h, lambda)
[row_y, col_y] = size(y);
[row_h, col_h] = size(h);
row_x = row_y - row_h + 1;
col_x = col_y - col_h + 1;

h_tilde = rot90(h, 2);

paraM = 0.01 * ones(row_x, col_x);



half_row=(row_h-1)/2;
half_col=(col_h-1)/2;
x=y(half_row+1:end-half_row,half_col+1:end-half_col);
%     lr = 0.5 / ((sum(sum(h .* h)))^2 + 5^2);
lr=0.02;
epoch_1 = 200;
epoch_2=5;
epoch_3=500;

for i_1 =1:epoch_1
    fprintf('%d  \n',i_1);
    grad = conv2(h_tilde, (conv2(x, h, 'full') - y), 'full');
    grad = grad(row_h:row_y, col_h:col_y);
    descent = lr .* grad ;
    x = x - descent;
    x = max(x, 0);
    x=soft_thre(x,paraM);
end

for i_2 =1:epoch_2
    paraM=0.003*1./(x+lambda);
    for i_3 =1:epoch_3
        fprintf('%d \t %d \n',i_2,i_3);
        grad = conv2(h_tilde, (conv2(x, h, 'full') - y), 'full');
        grad = grad(row_h:row_y, col_h:col_y);
        descent = lr .* grad ;
        x = x - descent;
        x = max(x, 0);
        x=soft_thre(x,paraM);
    end
end
end



function XX = soft_thre(X, paraM)

[Nx, Ny] = size(X);
XX = zeros(Nx, Ny);

for i = 1:Nx
    
    for j = 1:Ny
        
        if abs(X(i, j)) > paraM(i, j)
            XX(i, j) = sign(X(i, j)) * (abs(X(i, j)) - paraM(i, j));
        end
        
    end
    
end
end