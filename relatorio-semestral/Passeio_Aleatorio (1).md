# Relatório Semestral

## PASSEIO ALEATÓRIO: MODELOS, APLICAÇÕES E SIMULAÇÃO

## Introdução

O problema da Ruína do Jogador foi inicialmente proposto por Blaise Pascal no século XVII e, desde então, tem sido
amplamente estudado por diversos pesquisadores. Neste artigo, apresentamos uma revisão dos principais resultados conhecidos
sobre o problema clássico e introduzimos uma nova abordagem. Consideramos um jogo entre dois jogadores, A e B, que começam
com $a$ e $b$ reais, respectivamente. Definimos uma variável aleatória discreta $X_i$, que determina a quantidade de dinheiro
que o jogador A ganhará ou perderá dado que ele possui $i$ reais. O jogo termina quando um dos jogadores atinge um saldo
de zero reais ou não pode honrar a quantia devida ao oponente.

Neste estudo, propomos um estimador para a esperança da duração total do jogo, considerando dois cenários distintos: um
em que $X_i$ é fixo (caso homogêneo) e outro em que $X_i$ varia conforme a fortuna atual dos jogadores (caso não homogêneo).
Para validar os resultados teóricos obtidos com o estimador, utilizamos algoritmos de simulações de Monte Carlo.

<Inclusive podemos manter Xi aleatorio ou fixo> 

## Discussão (o que fizemos)

Inicialmente, realizamos uma revisão da literatura existente para identificar os principais resultados sobre o problema
da Ruína do Jogador e suas variações. Encontramos estudos abordando até o quinto momento (centrado e não centrado) da
duração do jogo, assim como variações que incluem possibilidade de empate, probabilidades de vitória assimétricas entre
os jogadores, aumento no número de participantes e probabilidades de vitória não uniformes ao longo do jogo, um meio não
uniforme.

Com base nesses resultados, utilizamos equações de diferenças finitas não homogêneas para reproduzir as formulações teóricas.
Paralelamente, desenvolvemos algoritmos de simulação baseados no método de Monte Carlo. A primeira versão do algoritmo,
implementada em Python, não obteve resultados satisfatórios em um tempo razoável. Para solucionar essa limitação, migramos
para a linguagem Julia, especializada na manipulação de *arrays*, o que resultou em um aumento significativo na eficiência computacional
e na qualidade dos resultados obtidos. As simulações apresentaram uma forte correspondência com a teoria existente..

Durante o desenvolvimento dos algoritmos, introduzimos novas regras ao jogo. Nas primeiras simulações, definimos que o
jogador A ganhava $1$ real com probabilidade $\frac{1}{3}$, ganhava $3$ reais com probabilidade $\frac{1}{3}$ e perdia $1$
real com probabilidade $\frac{1}{3}$. O novo estimador apresentou um resultado teórico muito próximo ao obtido nas simulações.
Testamos o estimador sob diferentes regras e, em todos os casos, os resultados teóricos mostraram forte concordância com
os valores simulados.



## Conclusão e Passos Seguintes

Os resultados obtidos indicam que o estimador proposto possui grande flexibilidade para diferentes configurações do jogo
e mostra-se especialmente útil, pois as técnicas atuais não são capazes de fornecer um resultado teórico exato para as
configurações de jogos propostas. Ademais, o estimador fornece estimativas mais precisas quando há maior circulação de
dinheiro entre os jogadores. No entanto, observamos que o estimador tende a divergir rapidamente dos resultados simulados
quando a esperança da variável aleatória que rege as regras do jogo aproxima-se de zero.

Outro desafio identificado foi a complexidade computacional envolvida na simulação de jogos com muitas regras, isto é,
quando a variável aleatória pode assumir um grande número de valores. Essa limitação impõe a necessidade de soluções mais
eficientes para lidar com cenários de alta complexidade.



## Bibliografia

<Artigo bonitinho do capeta>

ANDĚL, J.; HUDECOVÁ, Š. Variance of the game duration in the gambler’s ruin problem. **Statistics & Probability Letters**, v. 82, n. 9, p. 1750–1754, 31 maio 2012.

<Origem da ruina do jogador>

‌EDWARDS, A. W. F. Pascal’s Problem: The “Gambler’s Ruin”. **International Statistical Review / Revue Internationale de Statistique**, v. 51, n. 1, p. 73–79, 1983.

‌
