using Plots
using StatsBase
using Random

# Plot settings
gr()
theme(:solarized_light)


function main()
    i = 0
    graficos = []
    while i < 5
        j = 0
        while j < 10
            caminhada = passeio(i*10+j, 10+i*20, 100)
            grafico = plot(
                caminhada,
                title = "\$S_0=$(10+i*20)\$",
                xticks = 1:caminhada[end], #)∪(maximum(caminhada))
                legend = false,
            )
            vline!([maximum(caminhada)])
            append!(graficos, grafico)
            j+=1
        end
        i += 1
    end
    plot(graficos, layout=(i,10))
end

function passeio(semente, szero, teto)
    Random.seed!(semente)

    valor = szero

    passeio = []
    append!(passeio, valor)
    contador = 0
    maximo = 20000

    while valor > 0 && valor != teto && contador != maximo 
        if rand() > 0.5
            valor += 1
        else
            valor -= 1
        end
        append!(passeio, valor)
    end

    return passeio
end

main()