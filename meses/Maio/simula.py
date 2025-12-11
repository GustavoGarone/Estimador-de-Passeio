import numpy as np
# Meio aleatório
# Um passeio aleatório de 0 a tamanho, começa no inicio
# O jogador anda 1 casa ou volta 1 casa.


def simulacao():
    tamanho = 6
    inicio = 2
    M = 10_000


    tempos = []

    i = 0
    while i < M:
        i += 1
        pos = inicio

        thetas = np.random.uniform(0.1, 0.9, tamanho+1).tolist()
        #Probabilidade de avançar

        tempo = 0
        while pos < tamanho and pos > 0:
            tempo += 1
            if np.random.rand() < thetas[pos]:
                pos += 1
            else:
                pos -= 1

            #print(decisao)
            #print(pos)
            #print(x)
            #print(comparar/2)
            #print(3*comparar/2)
            #print(pos)
            #print("-----------")
        tempos.append(tempo)

    print(f"Tempo médio simulado: {np.mean(tempos)}")

