# Convolute and De-convolute

## Convolute

### 1-D convolute

Equal to MATLAB function: `conv([],[],'full')`

Need `x` and `h` as column vector.

#### conv_define

有限序列卷积定义

Definition of finite sequences convolution

$$
y[s]=\sum_{k=-\infty}^{+\infty}{x[ k ] \cdot h[ s-k ]}
$$

#### conv_mask_slide

卷积模板移动并线性相加

Slide the convolute mask and add linearly

$$
y =
x_1 \cdot 
\begin{pmatrix}
    h_1 \\ h_2 \\ h_3 \\ \vdots \\ h_n \\ 0 \\ \vdots \\0 \\
\end{pmatrix}_{(m+n-1,1)} +
x_2 \cdot 
\begin{pmatrix}
    0 \\ h_1 \\ h_2 \\ \vdots \\ h_{n-1} \\ h_n \\ \vdots \\0 \\
\end{pmatrix}_{(m+n-1,1)} +
\cdots +
x_m \cdot 
\begin{pmatrix}
    0 \\ 0 \\ 0 \\ 0 \\ \vdots \\ h_{n-2} \\ h_{n-1} \\ h_n \\
\end{pmatrix}_{(m+n-1,1)}
$$

#### conv_matrix_dot

线性方程组化（矩阵乘法）

Matrix multiplication

$$
y = 
\begin{pmatrix}
    y_1 \\ y_2 \\ \vdots \\ y_{m+n-1}
\end{pmatrix}_{(m+n-1,1)} =
A_h \cdot x =
\begin{pmatrix}
    h_1 & 0 & \cdots & 0 & 0 \\
    h_2 & h_1 & \cdots & 0 & 0 \\
    h_3 & h_2 & \cdots & 0 & 0 \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    h_n & h_{n-1} & \cdots & \cdots & \cdots \\
    0 & h_n & \cdots & \cdots & \cdots \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    0 & 0 & \cdots & h_n & h_{n-1} \\
    0 & 0 & \cdots & 0 & h_n
\end{pmatrix}_{(m+n-1,m)}
\cdot
\begin{pmatrix}
    x_1\\x_2\\ \vdots \\x_m
\end{pmatrix}_{(m,1)}
$$

### 2-D convolute

Equal to MATLAB function: `conv2([],[],'full')`

Function `conv2_matrix_dot` has a huge memory footprint. 

#### conv2_define

有限序列卷积定义

Definition of finite matrixs convolution

$$
y[ s_1,s_2 ] = \sum_{k_1=-\infty}^{+\infty}{\sum_{k_2=-\infty}^{+\infty}{x[ k1,k2] \cdot h[ s_1-k_1,s_2-k_2]}}
$$

#### conv2_mask_slide

卷积模板移动并线性相加

Slide the convolute mask and add linearly

$$
y= 
\sum_{i=1}^{m} {
    \sum_{j=1}^n {
        x_{i,j} \cdot
        \begin{pmatrix}
            O_{i-1,j-1} & O_{i-1,q} & O_{i-1,n-j} \\
            O_{p,j-1} & h_{p,q} & O_{p,n-j} \\
            O_{m-i,j-1} & O_{m-i,q} & O_{m-i,n-j} \\
        \end{pmatrix}
    }
}
$$

#### conv2_double_conv

在行和列方向上进行两次一维卷积

Double one-dimensional convolution in the row and column directions

$$
x =
\begin{pmatrix}
    x_{(1,1)} & x_{(1,2)} & x_{(1,3)} & \cdots & x_{(1,n)} \\
    x_{(2,1)} & x_{(2,2)} & x_{(2,3)} & \cdots & x_{(2,n)} \\
    x_{(3,1)} & x_{(3,2)} & x_{(3,3)} & \cdots & x_{(3,n)} \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    x_{(m,1)} & x_{(m,2)} & x_{(m,3)} & \cdots & x_{(m,n)} \\
\end{pmatrix}_{m , n} =
\begin{pmatrix}
    X_1 \\ X_2 \\ X_3 \\ \vdots \\ X_m \\
\end{pmatrix}
$$

$$
h=
\begin{pmatrix}
    h_{(1,1)} & h_{(1,2)} & h_{(1,3)} & \cdots & h_{(1,q)} \\
    h_{(2,1)} & h_{(2,2)} & h_{(2,3)} & \cdots & h_{(2,q)} \\
    h_{(3,1)} & h_{(3,2)} & h_{(3,3)} & \cdots & h_{(3,q)} \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    h_{(p,1)} & h_{(p,2)} & h_{(p,3)} & \cdots & h_{(p,q)} \\
\end{pmatrix}_{p , q} =
\begin{pmatrix}
    H_1 \\ H_2 \\ H_3 \\ \vdots \\ H_p \\
\end{pmatrix}
$$

$$
\begin{cases}
    X_i=
    \begin{bmatrix}
        x_{(i,1)} & x_{(i,2)} & x_{(i,3)} & \cdots & x_{(i,n)} \\
    \end{bmatrix}\\
    H_i=
    \begin{bmatrix} 
        h_{(i,1)} & h_{(i,2)} & h_{(i,3)} & \cdots & h_{(i,q)} \\
    \end{bmatrix} \\
\end{cases}
$$

$$
y=
\begin{pmatrix}
    Y_1 \\ \vdots \\ Y_k \\ \vdots \\ Y_{m+p-1} \\
\end{pmatrix} =
\begin{pmatrix}
    X_1 \\ X_2 \\ X_3 \\ \vdots \\ X_m \\
\end{pmatrix} \ast
\begin{pmatrix}
    H_1 \\ H_2 \\ H_3 \\ \vdots \\ H_p \\
\end{pmatrix}
\\
Y_k= \sum_{i=-\infty}^{+\infty} {(X_i \ast H_{k-i+1})}=\sum_{i=\max(k-n+1,1)}^{\min{(m,k)}} {(X_i \ast H_{k-i+1})}
$$

#### conv2_matrix_dot

线性方程组化（矩阵乘法）

Matrix multiplication

$$
x =
\begin{pmatrix}
    x_{(1,1)} & x_{(1,2)} & x_{(1,3)} & \cdots & x_{(1,n)} \\
    x_{(2,1)} & x_{(2,2)} & x_{(2,3)} & \cdots & x_{(2,n)} \\
    x_{(3,1)} & x_{(3,2)} & x_{(3,3)} & \cdots & x_{(3,n)} \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    x_{(m,1)} & x_{(m,2)} & x_{(m,3)} & \cdots & x_{(m,n)} \\
\end{pmatrix}_{m , n} =
\begin{pmatrix}
    X_1 \\ X_2 \\ X_3 \\ \vdots \\ X_m \\
\end{pmatrix} 
$$

$$
h=
\begin{pmatrix}
    h_{(1,1)} & h_{(1,2)} & h_{(1,3)} & \cdots & h_{(1,q)} \\
    h_{(2,1)} & h_{(2,2)} & h_{(2,3)} & \cdots & h_{(2,q)} \\
    h_{(3,1)} & h_{(3,2)} & h_{(3,3)} & \cdots & h_{(3,q)} \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    h_{(p,1)} & h_{(p,2)} & h_{(p,3)} & \cdots & h_{(p,q)} \\
\end{pmatrix}_{p , q} =
\begin{pmatrix}
    H_1 \\ H_2 \\ H_3 \\ \vdots \\ H_p \\
\end{pmatrix}
$$

$$
y=
\begin{pmatrix}
    y_{(1,1)} & y_{(1,2)} & y_{(1,3)} & \cdots & y_{(1,n+q-1)} \\
    y_{(2,1)} & y_{(2,2)} & y_{(2,3)} & \cdots & y_{(2,n+q-1)} \\
    y_{(3,1)} & y_{(3,2)} & y_{(3,3)} & \cdots & y_{(3,n+q-1)} \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    y_{(p,1)} & y_{(p,2)} & y_{(p,3)} & \cdots & y_{(m+p-1,n+q-1)} \\
\end{pmatrix}_{m+p-1 , n+q-1} =
\begin{pmatrix}
    Y_1 \\ Y_2 \\ Y_3 \\ \vdots \\ Y_{m+p-1} \\
\end{pmatrix} 
$$

$$
\begin{cases}
    X_i=
    \begin{bmatrix}
        x_{(i,1)} & x_{(i,2)} & x_{(i,3)} & \cdots & x_{(i,n)} \\
    \end{bmatrix} \\
    H_i=
    \begin{bmatrix} 
        h_{(i,1)} & h_{(i,2)} & h_{(i,3)} & \cdots & h_{(i,q)} \\
    \end{bmatrix} \\
    Y_i=
    \begin{bmatrix} 
        y_{(1,1)} & y_{(1,2)} & y_{(1,3)} & \cdots & y_{(1,n+q-1)} \\
    \end{bmatrix} \\
\end{cases}
$$

$$
A_h=
\begin{pmatrix}
    E_1 & O & \cdots & O & O \\
    E_2 & E_1 & \cdots & O & O \\
    E_3 & E_2 & \cdots & O & O \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    E_p & E_{p-1} & \cdots & \cdots & \cdots \\
    O & E_p & \cdots & \cdots & \cdots \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    O & O & \cdots & E_p & E_{p-1} \\
    O & O & \cdots & O & E_p
\end{pmatrix}_{(m+n-1) \times (n+q-1) ,m \times n}
$$

$$
E_k=
\begin{pmatrix}
    h_{(k,1)} & 0 & \cdots & 0 & 0 \\
    h_{(k,2)} & h_{(k,1)} & \cdots & 0 & 0 \\
    h_{(k,3)} & h_{(k,2)} & \cdots & 0 & 0 \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    h_{(k,n)} & h_{(k,n-1)} & \cdots & \cdots & \cdots \\
    0 & h_n & \cdots & \cdots & \cdots \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    0 & 0 & \cdots & h_{(k,n)} & h_{(k,n-1)} \\
    0 & 0 & \cdots & 0 & h_{(k,n)}
\end{pmatrix}_{n+q-1 , n}
$$

$$
\vec{x \_ vec}=
\begin{bmatrix}
    X_1 & X_2 & \cdots & X_m
\end{bmatrix}^{T}
$$

$$
\vec{y \_ vec}=
\begin{bmatrix}
    Y_1 & Y_2 & \cdots & Y_{m+p-1}
\end{bmatrix}^{T} =
A_h \cdot \vec{x \_ vec}
$$

## De-convolute

### Least Squares

#### deconv_least_squares

最小二乘法

Least square.

$$
X^{*}=(A_h^T A_h)^{-1} A_h^T Y
$$

#### deconv_grad_descent

梯度下降

Gradient descent for the solution of least square.

$$
F(x)=X^T A_h^T A_h X - 2 x^T A_h^T Y \quad \nabla F(X))=2 (A_h^T A_h X - A_h^T Y)
$$

$$
X_{k+1}=X_k-\delta \cdot (A_h^T A_h X_k - A_h^T y) \quad F(X_{k+1}) < F(X_k)
$$

#### deconv_fast_grad_descent

快速梯度下降

Fast gradient descent.

矩阵的运算时间复杂度极高，因此会消耗非常长的时间，**需要将其优化为卷积运算**。

The time complexity of matrix operations are extremely high, so we need to **convert matrix operations to convolution operations**.

$$
\tilde{h} * Y = \tilde{A_h^T} \cdot Y 
=(\tilde{y_1},\tilde{y_2},\cdots,\tilde{y_{n-1}},\tilde{y_{n}},\cdots,\tilde{y_{m+n-1}},\tilde{y_{m+n}},\cdots,\tilde{y_{m+2n-2}})
$$

$$
\tilde{h}=(h_n,h_{n-1},\cdots,h_2,h_1) \quad A_h^T \cdot Y=(\tilde{y_{n}},\cdots,\tilde{y_{m+n-1}})
$$

定义提取操作：
Define extraction operation:

$$
M(\tilde{h} * Y)=A_h^T \cdot Y
$$

有快速梯度下降公式如下：

Gradient descent formula:

$$
X_{k+1}=X_k-\delta (A_h^T A_h X_k - A_h^T y) \quad F(X_{k+1}) < F(X_k) \\
\Leftrightarrow 
X_{k+1}=X_k-\delta \cdot M[ \tilde{h} * ( X_k * h -Y ) ]
$$

通过在每个维度上都定义同样的提取操作，该方法可以拓展到任意维度逆卷积。

By defining the same extraction operation in each dimension, the method can be extended to any dimension deconvolution.

见函数`deconvn_fast_grad_descent`

See in function `deconvn_fast_grad_descent`

#### deconv_fast_grad_descent_not_negative

快速梯度下降，非负约束

Fast gradient descent, with non-negative constraints

假设$ X $中的每个元素都非负。

Assume each element in $ X $ is not negative.

`X=max(X,0);` or `X=abs(X);`

#### deconv2_least_squares

通过使用函数`conv2_matrix_dot`中的方法，计算得到列向量$ \vec{y \_ vec} $和矩阵$ A_h $。

With the method in function `conv2_matrix_dot`, calculate the column vector $ \vec{y \_ vec} $ and matrix $ A_h $.

$$
\vec{x \_ vec ^{*}}=(A_h^T A_h)^{-1} \cdot A_h \cdot \vec{y \_ vec}
$$

之后将列向量$ \vec{x \_ vec} $还原为矩阵$ x $。

Then reduce column vector $ \vec{x \_ vec} $ back to matrix $ x $.

#### deconv2_fast_grad_descent

$$
h=
\begin{pmatrix}
    h_{(1,1)} & h_{(1,2)} & h_{(1,3)} & \cdots & h_{(1,q)} \\
    h_{(2,1)} & h_{(2,2)} & h_{(2,3)} & \cdots & h_{(2,q)} \\
    h_{(3,1)} & h_{(3,2)} & h_{(3,3)} & \cdots & h_{(3,q)} \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    h_{(p,1)} & h_{(p,2)} & h_{(p,3)} & \cdots & h_{(p,q)} \\
\end{pmatrix}
$$

$$
\tilde{h}=
\begin{pmatrix}
    h_{(p,q)} & h_{(p,q-1)} & h_{(p,q-2)} & \cdots & h_{(p,1)} \\
    h_{(p-1,q)} & h_{(p-1,q-1)} & h_{(p-1,q-2)} & \cdots & h_{(p-1,1)} \\
    h_{(p-2,q)} & h_{(p-2,q-1)} & h_{(p-2,q-2)} & \cdots & h_{(p-2,1)} \\
    \vdots & \vdots & \vdots & \vdots & \vdots \\
    h_{(1,q)} & h_{(1,q-1)} & h_{(1,q-2)} & \cdots & h_{(1,1)} \\
\end{pmatrix}
$$

定义：

Define:

$$
Z_{m+2p-1,n+2q-1} = \tilde{h_{p,q}} \ast Y_{m+p-1,n+q-1} \\
M(\tilde{h_{p,q}} \ast Y_{m+p-1,n+q-1})=Z(p:m+p-1,q:m+q-1)
$$

有快速梯度下降公式如下：

Gradient descent formula:

$$
X_{k+1} = X_k-\delta \cdot M[ \tilde{h} \ast ( X_k \ast h - Y ) ]
$$

#### deconvn_fast_grad_descent

将$ h $ 中所有维度翻转，得到向量$ \tilde{h} $。

Flip $ h $ in each dim, get a new vector $ \tilde{h} $.

在每个维度上定义提取操作：

Define extraction operations on each dim:

$$
M( \tilde{h} \ast y) = Z(len_h:len_y) \quad Z = \tilde{h} \ast y
$$

$ len_h $ 和 $ len_y $是在该维度上，矩阵$ h $  $ y $的长度。

$ len_h $ andb $ len_y $ are lengths of matrix $ h $ and $ y $ in this dim.

有快速梯度下降公式如下：

Gradient descent formula:

$$
X_{k+1} = X_k-\delta \cdot M[ \tilde{h} \ast ( X_k \ast h - Y ) ]
$$