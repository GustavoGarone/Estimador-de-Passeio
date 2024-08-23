"""
    simulador(topo, inicial, piso, probabilidade, acrescimo, decrescimo)

Simule um passeios aleatórios idênticos e retorne sua duração média.
"""
function simulador(topo, inicial, piso, p, acr, decr)

    totalsims = 10^6 # Aumente para maior precisão. Em ^6, cada loop de main() demora 0.15s.
    maxits = 10^10
    duracaototal = 0.0

    for i in 1:totalsims
        duracao = 0.0
        valoratual = inicial
        while valoratual > piso && valoratual < topo && duracao < maxits
            duracao += 1.0
            if rand() > p
                valoratual += decr
            else
                valoratual += acr
            end
        end
        duracaototal += duracao
    end
    # Com ou sem arredondamento para cima (considerando como funcionam passeios, pode-se
    # querer um valor inteiro)
    # return ceil(duracaototal / totalsims) 
    return duracaototal / totalsims
end
