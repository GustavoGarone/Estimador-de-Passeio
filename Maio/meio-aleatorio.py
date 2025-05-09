from sympy import symbols, Eq, solve, simplify, lambdify
from scipy.integrate import nquad
import numpy as np


global tamanho
tamanho = 6


def resolve_sistema():
    '''
    Calcula o sistema de equações e imprime as soluções
    '''
    global mu, p, solution
    mu = symbols(f'mu0:{tamanho+1}')
    # p = symbols("a b c d e f g")
    p = symbols(f'p0:{tamanho+1}')

    def avanca(i):
        return p[i]
    eqs = [Eq(mu[0], 0), Eq(mu[tamanho], 0)]
    for i in range(1, tamanho):
       eqs.append(Eq(mu[i], 1 + mu[i+1] * avanca(i) + mu[i-1] * (1 - avanca(i))))
    solution = solve(eqs, mu)
    for var in mu:
        print(f"{var} = {solution[var]}")


def calcula_tempo(i, Monte_Carlo=False):
    '''
    Calcula utilizando integração numérica e imprime o tempo esperado da duração
    do jogo para um jogador que começa na casa i. 0 < i < tamanho
    '''

    expr = simplify(solution[mu[i]])
    # Seleciona as variáveis de integração: p[1] a p[tamanho-1]
    p_vars = list(p)[1:tamanho]
    # Converte a expressão simbólica em uma função numérica vetorizada (usando numpy)
    f_numeric = lambdify(p_vars, expr, 'numpy')
    
    # Função de wrapper para nquad: nquad exige função que receba uma lista de argumentos.
    def f_wrapper(*args):
        # args já é uma tupla com (tamanho-1) valores, correspondente a p[1]...p[tamanho-1]
        return f_numeric(*args)
    
    if not Monte_Carlo:
        fronteiras = [[0.1, 0.9]] * (tamanho-1)
        valor, erro = nquad(f_wrapper, fronteiras)
        tempo = valor / ((0.8)**(tamanho-1))
        print(tempo)
    
    else:
        S = 0
        M = 10_000
        i = 0
        while i < M:
            vetor = np.random.uniform(0.1, 0.9, tamanho-1).tolist()
            S += f_wrapper(*vetor)
            i += 1
        print(S/M)



# resolve_sistema()
# calcula_tempo(2, True)
