import numpy as np

tamanho = 10
inicio = 0

# Define o array com as propabilidades (o meio)
numeros = np.array(list(range(tamanho+1)))
thetas = 1-numeros/tamanho
thetas = np.array([thetas, 1-thetas]).reshape(2,tamanho+1).transpose()

tempos = []

#Simulador
i = 0
while i < 10000:
    i += 1
    pos = inicio
    tempo = 0
    while pos < tamanho:
        tempo += 1
        if np.random.rand() < thetas[pos][0]:
            pos += 1
    tempos.append(tempo)

# Estimador
s = 0
for a,b in thetas[inicio:tamanho]:
    s += 1/a

print(f"Tempo médio simulado: {np.mean(tempos)}")
print(f"Esperança: {s}")
print("P(Avançar) | P(Ficar)")
print(thetas)



#%%
# Meio uniformemente variado
# Um passeio aleatório de 0 a tamanho
# O jogador anda 1 casa, fica parado, ou volta.
# P(Avançar | está na casa I) = (1 - I/10)/2
# P(Avançar | está na casa I) = (1 - I/10)/4
# Começa no 0 e ganha quando chega no 10, ou seja, tem que dar 10 passos


tamanho = 100
inicio = 80

# Define o array com as propabilidades (o meio)
numeros = np.array(list(range(tamanho+1)))
thetas = (1-abs(numeros)/tamanho)/2
thetas = np.array([thetas, thetas/2, 1-3*thetas/2]).reshape(3,tamanho+1).transpose()

tempos = []

#Simulador
i = 0
while i < 1000:
    i += 1
    pos = inicio
    tempo = 0
    while pos < tamanho and pos > 0:
        tempo += 1
        decisao = int(np.random.choice([1,-1,0], 1, p=thetas[pos])[0])
        pos += decisao
    tempos.append(tempo)

#Estimador
s = 0
for a,b,c in thetas[inicio:tamanho,]:
    s += 1/(a-b)

print(f"Tempo médio simulado: {np.mean(tempos)}")
print(f"Estimador: {s}")
print("P(Avançar) | P(Voltar) | P(Ficar)")
print(thetas)









#%%
# Meio baseado na distância
# Um passeio aleatório de 0 a tamanho, começa no inicio
# O jogador anda 1 casa, volta 1 casa ou fica parado.
# P(Avançar | está na casa I) = (1 - |10-I|/20)/2
# P(Voltar  | está na casa I) = (1 - |10-I|/20)/4
# Começa no inicio e acaba quando chega no 0 ou no tamanho
# Note que as probabilidades são simétricas em relação ao inicio

tamanho = 40
inicio = 15

numeros = np.array(list(range(tamanho+1)))
#Probabilidade de avançar
thetas = (1-abs(numeros-inicio)/tamanho)/2
thetas = np.array([thetas, thetas/2, 1-3*thetas/2]).reshape(3,tamanho+1).transpose()

tempos = []

i = 0
while i < 1000:
    i += 1
    pos = inicio
    tempo = 0
    while pos < tamanho and pos > 0:
        tempo += 1
        decisao = int(np.random.choice([1,-1,0], 1, p=thetas[pos])[0])
        pos += decisao

        
        #print(decisao)
        #print(pos)
        #print(x)
        #print(comparar/2)
        #print(3*comparar/2)
        #print(pos)
        #print("-----------")
    tempos.append(tempo)

s = 0
for a,b,c in thetas[inicio:tamanho]:
    s += 1/(a-b)

print(f"Tempo médio simulado: {np.mean(tempos)}")
print(f"Estimador: {s}")
print("P(Avançar) | P(Voltar) | P(Ficar)")
print(thetas)

# %%
#%%
# Meio baseado na distância, mas trocas as probabilidades
# Um passeio aleatório de 0 a tamanho, começa no inicio
# O jogador anda 1 casa, volta 1 casa ou fica parado.
# P(Avançar | está na casa I) = (1 - |10-I|/20)/4
# P(Voltar  | está na casa I) = (1 - |10-I|/20)/2
# Começa no inicio e acaba quando chega no 0 ou no tamanho
# Note que as probabilidades são simétricas em relação ao inicio

tamanho = 40
inicio = 15

numeros = np.array(list(range(tamanho+1)))
#Probabilidade de avançar
thetas = (1-abs(numeros-inicio)/tamanho)/2
thetas = np.array([thetas, thetas/2, 1-3*thetas/2]).reshape(3,tamanho+1).transpose()

tempos = []

i = 0
while i < 1000:
    i += 1
    pos = inicio
    tempo = 0
    while pos < tamanho and pos > 0:
        tempo += 1
        decisao = int(np.random.choice([-1,1,0], 1, p=thetas[pos])[0])
        pos += decisao

        
        #print(decisao)
        #print(pos)
        #print(x)
        #print(comparar/2)
        #print(3*comparar/2)
        #print(pos)
        #print("-----------")
    tempos.append(tempo)

s = 0
for a,b,c in thetas[inicio:tamanho]:
    s += 1/(b-a)

print(f"Tempo médio simulado: {np.mean(tempos)}")
print(f"Estimador: {s}")
print("P(Avançar) | P(Voltar) | P(Ficar)")
print(thetas)

# %%
