function y = Rescale(x)
% ������̬��Χ��0-1
% x = gather(x);
x = double(x);
MAX = max(x(:));
MIN = min(x(:));
x = x - MIN;
y = x ./ (MAX - MIN);
end
