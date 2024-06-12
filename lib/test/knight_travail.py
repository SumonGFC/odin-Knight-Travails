import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import curve_fit

vals = [5, 4, 4, 5, 6, 6, 7, 8, 8, 9, 10, 10, 11, 12, 12, 13, 14, 14, 15, 16,
        16, 17, 18, 18, 19, 20, 20, 21, 22, 22, 23, 24, 24, 25, 26, 26, 27, 28,
        28, 29, 30, 30, 31, 32, 32, 33, 34, 34, 35, 36, 36, 37, 38, 38, 39, 40,
        40, 41, 42, 42, 43, 44, 44, 45, 46, 46, 47, 48, 48, 49, 50, 50, 51, 52,
        52, 53, 54, 54, 55, 56, 56, 57, 58, 58, 59, 60, 60, 61, 62, 62, 63, 64,
        64, 65, 66, 66, 67]

board_size = np.array([(i + 4) for i in range(97)])


def test(x, a, b):
    return a*x + b

param, p_cov = curve_fit(test, board_size, vals)
a = str(round(param[0], 4))
b = str(round(param[1], 5))
perr = np.sqrt(np.diag(p_cov))
a_err = round(perr[0], 5)
b_err = round(perr[1], 5)
ans = param[0]*board_size + param[1]

plt.plot(board_size, vals, 'o', color='red', label='data', markersize=2)
plt.plot(board_size, ans, '--', label='fit')
plt.legend()
plt.title('Knight moves from corner to corner vs. Board Size')
plt.text(4, 55, f"Model: f = ax + b, a = {a}, b = {b}")
plt.text(4, 50, f"Error: a: {a_err}, b: {b_err}")
plt.xlabel("Board size n (of n x n grid)")
plt.ylabel("Num. of knight moves from corner to corner")
plt.show()
