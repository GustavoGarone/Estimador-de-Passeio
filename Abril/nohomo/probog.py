from sympy import symbols, Eq, solve # type: ignore
import numpy as np

tamanho = 20

mu = symbols(f'mu0:{tamanho+1}')  # Isso cria mu0, mu2, ..., mu10

# thetas = np.random.uniform(0.1, 0.9, tamanho).tolist()
def avanca(i):
    # return thetas[i]
    if i <= tamanho/2:
        return (1 - i/tamanho)
    return i/tamanho
    # return (1 - i/tamanho)

eqs = [Eq(mu[0], 0), Eq(mu[tamanho], 0)]
for i in range(1, tamanho):
    eqs.append(Eq(mu[i], 1 + mu[i+1] * avanca(i) + mu[i-1] * (1-avanca(i))))

solution = solve(eqs, mu)

for var in mu:
    print(f"{var} = {solution[var]}")

import matplotlib.pyplot as plt

x_vals = list(range(tamanho + 1))  # Índices de mu (mu0, mu1, ..., mu50)
y_vals = [solution[mu[i]] for i in range(tamanho + 1)]  # Valores correspondentes

plt.figure(figsize=(10, 6))
plt.plot(x_vals, y_vals, marker='o', label='Valores de mu')
plt.title('Valores de E[T_a]')
plt.xlabel('a')
plt.ylabel('E[T_a]')
plt.ylim(float(min([y for y in y_vals if int(y) != 0]))-1, float(max(y_vals)*1.01))
plt.grid(True)
plt.legend()
plt.show()
