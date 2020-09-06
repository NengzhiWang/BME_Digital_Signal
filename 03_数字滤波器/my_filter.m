function y = my_filter(b, a, x)
% 直接II型IIR滤波器的转置结构
% x     输入信号
% y     输出信号
% u     缓存
order = max(numel(a), numel(b)) - 1;

a = a ./ a(1);
b = b ./ a(1);
a(1) = [];
y = zeros(size(x));
u = zeros(1, order);

for i = 1:length(x)
    y(i) = b(1) * x(i) + u(1);
    u = [u(2:order), 0] + b(2:end) * x(i) - a * y(i);
end
end
