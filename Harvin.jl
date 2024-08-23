using CSV
using DataFrames
using Plots
using StatsBase
using LoopVectorization
theme(:ggplot2, alpha=0.1)

pgfplotsx()

"""
main() --flags: toCSV fromCSV graficar

Construa uma análise do estimador comparando-o com simulações de passeios aleatórios

Essa versão do programa compila os dados em um DataFrame para uso em outros processos.

toCSV: Salvará o data frame em CSV/dados.csv

fromCSV: Criará o DataFrame através de CSV/dados.csv

graficar: Gerará um gráfico em ./Graficos/Grafico.pdf
"""
function main()
    totalcomparacoes = 10 # DURAÇÃO: ~ 0.15segundos * 10^i (deixe entre 4 e 5)

    dfpasseios = DataFrame(
        :Estimada => Float64[],
        :Simulada => Float64[],
        :Topo => Float64[],
        :Piso => Float64[],
        :Movimentos => String[],
        :Probabilidade => String[],
    )
    if "fromCSV" in ARGS
        dfpasseios = DataFrame(CSV.File("./CSV/dados.csv"))
    else
        for i in 1:totalcomparacoes
            print("H")
            push!(dfpasseios, gera_passeios())
        end
    end

    dfpasseios.:Diferenca = dfpasseios.:Estimada - dfpasseios.:Simulada
    transform!(dfpasseios, :Diferenca => ByRow(abs) => :Diferenca)
    transform!(dfpasseios, :Diferenca => ByRow(ceil) => :Diferenca)

    media = mean(dfpasseios.:Simulada)
    print("Média dos erros: $media\n")

    if "toCSV" in ARGS
        CSV.write("./CSV/dados.csv", dfpasseios)
    end

    if "graficar" in ARGS
        graficar(dfpasseios)
    end

end

"""
    gera_passeios() ->
    (duracaoestimadaa, duracaosimulada, topo, inicial, piso, probabilidade, acrescimo, decrescimo)

Retorne a duracao simulada e estimada de um passeio aleatório e seus parâmetros

"""
function gera_passeios()
    piso = rand(-100:0)
    topo = rand(1:100)


    valoresX = [1, -1]
    probsX = [0.5, 0.5]
    pesosX = weights(probsX)

    duracaoestimada = estimatempo(topo, piso, mean(valoresX, pesosX))
    duracaosimulada = simulador(topo, piso, valoresX, pesosX)

    strValores = ""
    strProbs = ""
    for i in valoresX
        strValores * string(i) * "-"
    end
    for j in probsX
        strProbs * string(j) * "-"
    end
    strValores = chop(strValores)
    strProbs = chop(strProbs)
    return duracaoestimada, duracaosimulada, topo, piso, strValores, strProbs
end

"""
    simulador(topo, inicial, piso, probabilidade, acrescimo, decrescimo)

Simule um passeios aleatórios idênticos e retorne sua duração média.
"""
function simulador(topo, piso, valoresX, pesosX)

    totalsims = 10^6 # Aumente para maior precisão. Em ^6, cada loop de main() demora 0.15s.
    maxits = 10^10
    duracaototal = 0.0

    @turbo for i in 1:totalsims
        duracao = 0.0
        valoratual = 0
        while valoratual > piso && valoratual < topo && duracao < maxits
            duracao += 1.0
            valoratual += sample(valoresX, pesosX)
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
function estimatempo(topo, piso, fator)

    return fator > 0 ? (topo / fator ) : piso / fator
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

    savefig(graficos, "~/Projetos/Estimador-de-Passeio/Graficos/Grafico.pdf")
end
# main()
