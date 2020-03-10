clc
clear all
close all

X = zeros(100, 100);
X(11:90, 11:90) = double(rand(80, 80) > 0.98);
position = zeros(2, 100 * 100);
kk = 0;

for i = 1:100

    for j = 1:100

        if X(i, j) > 0
            kk = kk + 1;
            position(:, kk) = [i; j];
        end

    end

end

position = position(:, 1:kk);

L = exp(- [-3:3] .* [-3:3] ./ 3);
temp = L' * L;
Y = conv2(X, temp);
temp_1 = temp(end:-1:1, :);
temp_1 = temp_1(:, end:-1:1);
% step0 = 0.5 / ((sum(sum(temp .* temp)))^2 + 5^2);
step0 = 0.5 / ((sum(sum(temp .* temp)))^2);
ss = zeros(106, 106);
ss1 = zeros(112, 112);
x0 = zeros(100, 100);
paraM = 0.01 * ones(100, 100);

for i = 1:500
    ss = conv2(x0, temp) - Y;
    ss1 = conv2(ss, temp_1);
    x0 = max(x0 - step0 * (ss1(7:106, 7:106)), 0);
    x0 = SoftThre(x0, paraM);
end

for mm = 1:5
    paraM = 0.003 * 1 ./ (x0 + 0.001);

    for i = 1:500
        ss = conv2(x0, temp) - Y;
        ss1 = conv2(ss, temp_1);
        x0 = max(x0 - step0 * (ss1(7:106, 7:106)), 0);
        x0 = SoftThre(x0, paraM);
    end

end

abs_error = abs(x0 - X);
sum(abs_error(:)) / (100 * 100)
figure()
imagesc(Y)
figure()
imagesc(x0)
hold on
plot(position(2, :), position(1, :), 'ro')

function XX = SoftThre(X, paraM)

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
