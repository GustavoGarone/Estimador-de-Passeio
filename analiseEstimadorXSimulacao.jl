using Plots

"""
    main()

Construa uma análise do estimador comparando-o com simulações de passeios aleatórios
"""
function main()
    totalcomparacoes = 10^1
   
    difftotal = 0
    for i in 0:totalcomparacoes
        difftotal += compara_resultados() 
    end

    media = difftotal/totalcomparacoes    

    print("Média dos erros: $media")
end 

"""
compara_resultados(completo::Bool = false) -> diff || diff, parametros

Retorne a comparação de duração de um passeio aleatório e sua estimação

Opcionalmente, pode retornar seus parâmetros ao fornecer o argumento (true)
"""
function compara_resultados(completo::Bool = false)
    piso = rand(0.0:10.0)
    topo = rand(piso+2.0:100.0)
    inicial = rand(piso+1.0:topo-1.0)

    acr = rand(1.0:5.0)
    decr = rand(-5.0:-1.0)

    p = 0.0
    while p == 0.0
        p = rand()
    end

    duracaoestimado = estimatempo(topo, inicial, piso, p, acr, decr)
    duracaosimulada = simulador(topo, inicial, piso, p, acr, decr)

    diff = abs(duracaoestimado - duracaosimulada)

    completo ? (return diff, topo, inicial, piso, p, acr, decr) : (return diff)
end

"""
    simulador(topo, inicial, piso, probabilidade, acrescimo, decrescimo)

Simule um passeios aleatórios idênticos e retorne sua duração média.
"""
function simulador(topo, inicial, piso, p, acr, decr)

    totalsims = 10^6 # Aumente para maior precisão
    maxits = 10^10
    duracaototal = 0.0

    for i in 1:totalsims
      duracao = 0.0  
      valoratual = inicial
      while valoratual > piso && valoratual < topo
          duracao += 1.0
          if rand() > p
              valoratual += decr
          else
              valoratual += acr
          end
      end
      duracaototal += duracao
    end
    return ceil(duracaototal/totalsims)
end

"""
    estimatempo(topo, inicial, piso, probabilidade, acrescimo, decrescimo)

Estima pela fórmula Yukiana a duração de um passeio aleatório qualquer
"""
function estimatempo(topo, inicial, piso, p, acr, decr)

    fator = p * acr + (1-p) * decr
    return fator > 0 ? (topo-inicial)/fator : (inicial-piso)/fator 
end

main()
