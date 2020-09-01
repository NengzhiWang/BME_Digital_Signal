01	function x = deconv_L1(y, h, lambda)
02	% ��ʼ��
03	% x, y & h should be column vector
04	lambda = 1e-3 * lambda;
05	len_y = size(y, 1);
06	len_h = size(h, 1);
07	len_x = len_y - len_h + 1;
08	x = zeros(len_x, 1);
09	% ��ת���ģ��
10	h_tilde = flipud(h);
11	% ��ʼ��Ȩ�غ͵�������
12	weight = lambda * ones(len_x, 1);
13	lr = 0.01;
14	epoch_1 = 10;
15	epoch_2 = 50;
16
17	for i_1 = 1:epoch_1
18		
19		for i_2 = 1:epoch_2
20			% �ݶ��½�������ֵ����
21			
22			% ���������������ݶ�
23			grad = conv(h_tilde, (conv(x, h, 'full') - y), 'full');
24			grad = grad(len_h:len_y);
25			descent = lr .* grad;
26			x = x - descent;
27			% ����ֵ����
28			x = (abs(x) > weight) .* sign(x) .* (abs(x) - weight);
29			% ����Ǹ���
30			x = max(x, 0);       
31		end
32		
33		% �����ݶ��½����������Ȩ��
34		weight = lambda .* (1 ./ (x + 1e-6));
35		
36	end
37
38	end
39