# %%
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
# 初始参数设定
f = 1
T = 1 / f
sp_rate = 1024
num_k = 500
d = 0.5
# for num_k in [4, 10, 20, 50, 100, 300]:
    # 频率为w的⽅方波信号
t = np.linspace(-1.5 + T * d / 2, 1.5 + T * d / 2, sp_rate, endpoint=True)
sig = signal.square(2 * np.pi * f * t, duty=d) + 1
t = t - T * d / 2


#sig = 1*np.cos(2 * np.pi * f * t)
# 构建正交基
def get_base(K, t):
    return np.exp(1j * 2 * np.pi * f * np.outer(K, t)) / np.sqrt(T)


# 内积近似计算
def approx_inner(f, g, e, s=0):
    return f @ np.conj(g.T) * ((e - s) / sp_rate)


K = np.arange(-num_k / 2, num_k / 2 + 1)
K_omg = K / (T / d)
base = get_base(K, t)


def FS(sig, T=T):
    return approx_inner(sig, base, T) / np.sqrt(T)


def IFS(spec, T=T):
    return spec @ base * np.sqrt(T)


spec = FS(sig, T)

re_sig = IFS(spec, T)
plt.figure(figsize=(18, 5))
plt.subplot(131)
plt.plot(t, sig)
plt.ylim(-1, 3)
plt.xlim(-1, 1)
plt.title('Original signal with duty = {}'.format(d))
plt.subplot(132)
plt.scatter(K_omg, spec, c='black', s=6)
plt.vlines(K_omg, 0, spec, linewidths=0.8)
# plt.xlim(-5, 5)
plt.title('Signal spectrum with #k = {}'.format(num_k))
plt.subplot(133)
plt.plot(t, re_sig)
plt.ylim(-1, 3)
plt.xlim(-1, 1)
plt.title('Reconstructed signal with #k={}'.format(num_k))
plt.subplots_adjust(hspace=0.2)
plt.savefig('diff_K_FS.svg')
# %%
