import random
import time

geracoes = 300
M = 1000


def main():
    org = 1
    dist = [0.27, 0.7, 1]
    i = 0
    passeio = [0] * geracoes
    while i < geracoes:
        ii = 0
        atual = org
        while ii < atual:
            p = random.random()
            if p < dist[0]:
                org -= 1
            elif p > dist[1]:
                org += 1
            ii += 1
        passeio[i] = org
        if org == 0:
            break
        i += 1
    return passeio


def mc():
    i = 0
    passeios = []
    while i < M:
        passeios.append(main())
        i += 1
    print(f"Média da geração 100: {mediaGeracaoN(passeios, 100)}")
    print(f"Média da geração 200: {mediaGeracaoN(passeios, 200)}")
    print(f"Média da geração 300: {mediaGeracaoN(passeios, 300)}")
    print(f"Proporção : {extincao(passeios)/M}")
    print(f"Média até extinção: {mediaExtincao(passeios)}")


def mediaGeracaoN(passeios, n):
    soma = 0
    for i in passeios:
        soma += i[n-1]
    return soma/len(passeios)


def extincao(passeios):
    extintos = 0
    for i in passeios:
        if i[geracoes-1] == 0:
            extintos += 1
    return extintos


def mediaExtincao(passeios):
    extincoes = []
    for i in passeios:
        if i[geracoes-1] == 0:
            tempo = 1
            for ii in i:
                if ii == 0:
                    break
                tempo += 1
            extincoes.append(tempo)

    return sum(extincoes)/extincao(passeios)


inicio = time.time()
mc()
print(f"-------------------------\n"
      f"Simulações: {M}\n"
      f"Gerações: {geracoes}\n"
      f"Tempo: {(time.time() - inicio):.2f} segundos\n"
      f"-------------------------")
