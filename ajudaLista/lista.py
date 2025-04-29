import random
import numpy
import time


M = 10000
n = 200

def main(estado):
    passeio = [0] * n
    i = 0
    while i < n:
        passeio[i] = estado
        p = random.random()
        if estado == 0:
            if p <= 0.5:
                estado = 1
            else:
                estado = 2
        elif estado == 1:
            if p <= 1/4:
                estado = 2
            else:
                estado = 0
        else:
            if p <= 1/4:
                estado = 1
            else:
                estado = 0
        i += 1
    return passeio


def mc():
    i = 0
    passeios = []
    while i < M:
        estado = 0
        p = random.random()
        estacionaria = [3/7, 2/7, 2/7]
        p -= estacionaria[0]
        if p <= 0:
            estado = 0
        else:
            p -= estacionaria[1]
            if p <= 0:
                estado = 1
            else:
                estado = 2
        passeios.append(main(estado))
        i += 1
    inicios = []
    fins = []
    for i in passeios:
        inicios.append(i[0])
    for i in passeios:
        fins.append(i[n-1])

    estados, iniciais = numpy.unique(inicios, return_counts=1)
    estados, finais = numpy.unique(fins, return_counts=1)

    print(
        f" Estado | Inicios |  Fins  |\n"
        f"--------|---------|--------|\n"
        f"   A    |  {iniciais[0]:.2f} | {finais[0]:.2f} |\n"
        f"   B    |  {iniciais[1]:.2f} | {finais[1]:.2f} |\n"
        f"   C    |  {iniciais[2]:.2f} | {finais[2]:.2f} |\n"
      
    )


inicio = time.time()
mc()
print(f"Número de simulações: {M}\n"
      f"Tempo: {(time.time() - inicio):.2f} segundos\n")
