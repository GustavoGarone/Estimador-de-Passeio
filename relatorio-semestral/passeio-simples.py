import random
import time


def main():
    random.seed(1)
    duracoes = []
    M = 100000
    p = 0.4
    teto = 100
    for i in range(M + 1):
        saldo = 30
        duracao = 0
        while saldo > 0 and saldo < teto:
            if p > random.random():
                saldo += 1
            else:
                saldo -= 1
            duracao += 1
        duracoes.append(duracao)
    media = sum(duracoes) / len(duracoes)
    print(f"Média da duração de {M} passeios: ${media:.2f}$")


start_time = time.time()
main()
print(f"Duração da execução: ${time.time() - start_time}$ segundos")
