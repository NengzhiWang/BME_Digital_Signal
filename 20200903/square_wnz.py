import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
T = np.pi
f = 1 / T
w = (2 * np.pi) / T
num_sample = 1024
t = np.linspace(-np.pi, np.pi, num_sample)

x = np.cos(w * t)
