function h = conv_core(m, n, sigma)
m = (m - 1) / 2;
n = (n - 1) / 2;
[h1, h2] = meshgrid(-m:+m, -n:+n);
hg = exp(-(h1.^2 + h2.^2) / (2 * sigma^2));
h = hg ./ sum(hg, 'all');
end
