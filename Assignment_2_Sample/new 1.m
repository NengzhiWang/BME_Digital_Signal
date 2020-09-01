01	function x = deconv_L1(y, h, lambda)
02	% 初始化
03	% x, y & h should be column vector
04	lambda = 1e-3 * lambda;
05	len_y = size(y, 1);
06	len_h = size(h, 1);
07	len_x = len_y - len_h + 1;
08	x = zeros(len_x, 1);
09	% 反转卷积模板
10	h_tilde = flipud(h);
11	% 初始化权重和迭代参数
12	weight = lambda * ones(len_x, 1);
13	lr = 0.01;
14	epoch_1 = 10;
15	epoch_2 = 50;
16
17	for i_1 = 1:epoch_1
18		
19		for i_2 = 1:epoch_2
20			% 梯度下降和软阈值迭代
21			
22			% 快速逆卷积，计算梯度
23			grad = conv(h_tilde, (conv(x, h, 'full') - y), 'full');
24			grad = grad(len_h:len_y);
25			descent = lr .* grad;
26			x = x - descent;
27			% 软阈值操作
28			x = (abs(x) > weight) .* sign(x) .* (abs(x) - weight);
29			% 引入非负性
30			x = max(x, 0);       
31		end
32		
33		% 根据梯度下降结果，更新权重
34		weight = lambda .* (1 ./ (x + 1e-6));
35		
36	end
37
38	end
39