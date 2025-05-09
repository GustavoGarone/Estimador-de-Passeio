from sympy import symbols, Eq, solve 
import matplotlib.pyplot as plt
import numpy as np

def main():
    M = 50 
    tamanho = 5

    # Definindo variáveis mu_0 a mu_10 (mu_0 e mu_10 são 0)
    mu = symbols(f'mu0:{tamanho+1}')  # Isso cria mu0, mu2, ..., mu10
    alpha = symbols(f'alpha0:{tamanho+1}')

    def mc():

        thetas = np.random.uniform(0.1, 0.9, tamanho).tolist()


        def avanca(i):
            # return alpha[i]
            return thetas[i]


        eqs = [Eq(mu[0], 0), Eq(mu[tamanho], 0)]

        for i in range(1, tamanho):
            eqs.append(Eq(mu[i], 1 + mu[i+1] * avanca(i) + mu[i-1] * (1-avanca(i))))


        # Resolvendo o sistema
        solution = solve(eqs, mu)
        
        sol = [0] * 21
        i = 0
        for variavel in mu:
            sol[i] = solution[variavel]
            i = i + 1
        return sol

    def sim(M):
        mus = []
        for i in range(tamanho+1):
            mus.append([])

        for i in range(M):
            sols = mc()
            j = 0
            while j < tamanho:
                mus[j].append(sols[j])
                j += 1
            print(f"{i/M * 100:.2f}%")

        return mus

    mus = sim(M)
    k = 0
    for i in mus:
        print(f"media de mu{k} = {sum(i)/M}")
        k += 1


# Plotando os valores
def plotar(x_vals, y_vals):
    plt.figure(figsize=(10, 6))
    plt.plot(x_vals, y_vals, marker='o', label='Valores de mu')
    plt.title('Valores de E[T_a]')
    plt.xlabel('a')
    plt.ylabel('E[T_a]')
    plt.ylim(float(min([y for y in y_vals if int(y) != 0]))-1, float(max(y_vals)*1.01))
    plt.grid(True)
    plt.legend()
    plt.show()


main()
