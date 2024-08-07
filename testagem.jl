using CSV
using DataFrames
using Plots
using Statistics
theme(:ggplot2, alpha=0.1)

pgfplotsx()

"""
main(toCSV = false fromCSV = false graficar = false)

Construa uma análise do estimador comparando-o com simulações de passeios aleatórios

Essa versão do programa compila os dados em um DataFrame para uso em outros processos.

toCSV: Salvará o data frame em ./CSV/dados.csv

fromCSV: Criará o DataFrame através de CSV/dados.csv

graficar: Gerará um gráfico em ./Graficos/Grafico.pdf
"""
function main(toCSV = false, fromCSV = false, graficar = false)
    totalcomparacoes = 10^4 # DURAÇÃO: ~ 0.15segundos * 10^i (deixe entre 4 e 5)

    dfpasseios = DataFrame(
        :Estimada => Float64[],
        :Simulada => Float64[],
        :Topo => Float64[],
        :Inicial => Float64[],
        :Piso => Float64[],
        :Probabilidade => Float64[],
        :Acrescimo => Float64[],
        :Decrescimo => Float64[]
    )
    if fromCSV
        dfpasseios = DataFrame(CSV.File("./CSV/dados.csv"))
    else
        difftotal = 0
        for i in 1:totalcomparacoes
            push!(dfpasseios, gera_passeios())
        end
    end

    dfpasseios.:Diferenca = dfpasseios.:Estimada - dfpasseios.:Simulada
    transform!(dfpasseios, :Diferenca => ByRow(abs) => :Diferenca)
    transform!(dfpasseios, :Diferenca => ByRow(ceil) => :Diferenca)

    media = mean(dfpasseios.:Simulada)
    print("Média dos erros: $media\n")

    if toCSV
        CSV.write("./CSV/dados.csv", dfpasseios)
    end

    if graficar
        graficar(dfpasseios)
    end

end

"""
    gera_passeios() ->
    (duracaoestimadaa, duracaosimulada, topo, inicial, piso, probabilidade, acrescimo, decrescimo)

Retorne a duracao simulada e estimada de um passeio aleatório e seus parâmetros

"""
function gera_passeios()
    piso = rand(0.0:10.0)
    topo = rand(piso+2.0:100.0)
    inicial = rand(piso+1.0:topo-1.0)

    acr = rand(1.0:5.0)
    decr = rand(-5.0:-1.0)

    p = 0.0
    while p == 0.0
        p = rand()
    end

    duracaoestimada = estimatempo(topo, inicial, piso, p, acr, decr)
    duracaosimulada = simulador(topo, inicial, piso, p, acr, decr)


    return duracaoestimada, duracaosimulada, topo, inicial, piso, p, acr, decr
end

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

"""
    estimatempo(topo, inicial, piso, probabilidade, acrescimo, decrescimo)

Estima pela fórmula Yukiana a duração de um passeio aleatório qualquer
"""
function estimatempo(topo, inicial, piso, p, acr, decr)

    fator = p * acr + (1 - p) * decr
    return fator > 0 ? (topo - inicial) / fator : abs((inicial - piso) / fator)
end

"""
    graficar(dfpasseios)

Receba um dataframe e crie três gráficos para comparação
"""
function graficar(dfpasseios)

    x = dfpasseios.:Probabilidade
    y = dfpasseios.:Inicial
    distancia = dfpasseios.:Diferenca

    graficos = scatter(x, y, marker_z=distancia)

    # plotestimada = plot(x,y, dfpasseios.:Estimada)
    # plotsimulada = plot(x,y, dfpasseios.:Simulada)
    # plotdiff = plot(x,y, distancia)
    #
    # graficos = plot(plotestimada, plotsimulada, plotdiff,
    #     layout=@layout([a b; c]), title = ["Estimada" "Esperada" "Erro"],
    #     titlelocation = :left
    # )

    savefig(graficos, "./Graficos/Grafico.pdf")
end

