import random

geracoes = 300

def main():
    org = 1
    dist = [0.27,0.7,1]
    i = 0
    passeio = [0] * geracoes
    while i < geracoes:
        ii = 0
        while ii < org:
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
    M = 100
    i = 0
    passeios = []
    while i < M:
        passeios.append(main())
        i += 1
    print(f"Média da geração 100: {mediaGeracaoN(passeios, 100)}")
    print(f"Média da geração 200: {mediaGeracaoN(passeios, 200)}")
    print(f"Média da geração 300: {mediaGeracaoN(passeios, 300)}")
    print(f"Proporção : {extincao(passeios)/geracoes}")
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
    soma = 0
    for i in passeios:
        if i[geracoes-1] == 0:
            geracaoExtinta = 0
            tempo = 1
            for ii in i:
                if ii == 0:
                    geracaoExtinta = tempo
                    break
                tempo += 1
            soma += geracaoExtinta

    return soma/extincao(passeios)

mc()
