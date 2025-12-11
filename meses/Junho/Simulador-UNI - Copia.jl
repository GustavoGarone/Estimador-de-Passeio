using StatsBase
using Plots

function main()
    tamanho=100
    # Imprime(regra, inicio, tamanho, tempos)

    X = Dict(1 => 0.2, -1 => 0.5, 0 => 0.3)
    X = Dict(1 => 0.2, -1 => 0.8, 0 => 0.0)

    Xs = 0:tamanho
    simulado = []
    original = []
    proposto = []
    for i in 0:tamanho
        push!(simulado, mean(MonteCarlo(;regra = X,inicio = i, MC=50_000)))
        a, b = Estimador(X, i, tamanho)
        push!(original, a)
        push!(proposto, b)

    end
    plot(Xs, [simulado, original, proposto],
    labels = ["Simulações" "Original" "Proposto"],
    title = "Tempo médio até o fim do jogo com início \n variando de 0 a 100",
    xlabel = "Início",
    ylabel = "Tempo médio até o fim")

end

function MonteCarlo(; inicio::Int64, regra::Dict, tamanho=100::Int64, 
    MC=10_000::Int64)::Vector{Float64}

    probs_cum = cumsum(collect(values(regra)))
    suporte = collect(keys(regra))
    total = length(collect(keys(regra)))

    if round(sum(collect(values(regra))), digits=1) != 1
        error("Nao é distribuição de probabilidade")
    end

    function Regra(p::Float64, acumulada=probs_cum, suporte=suporte ,total = total)
    for i in 1:total
        if p <= acumulada[i]
            return suporte[i]
        end
    end
    end

    if inicio < 0 || inicio > tamanho
        error("Início não faz sentido")
    end

    tempos = zeros(MC)

    for i in 1:MC
        pos = inicio
        tempo = 0
        while 0 < pos < tamanho
            tempo += 1
            pos += Regra(rand())
        end
        tempos[i] = tempo
    end
    return tempos
end

function Estimador(regra, inicio, tamanho)
    probs = collect(values(regra))
    suporte = collect(keys(regra))
    total = length(suporte)
    esperanca = sum(suporte[i] * probs[i] for i in 1:total)

    esp_inf = abs(inicio / esperanca)
    esp_sup = abs((tamanho - inicio) / esperanca)
    if esperanca < 0
        estimativa = round(abs(esp_inf), digits=3)
    elseif esperanca > 0
        estimativa = round(abs(esp_sup), digits=3)
    else
        estimativa = inicio*(tamanho-inicio)
    end
    if inicio in [tamanho, 0]
        estimativa = 0
    end

    beti = round(min(esp_inf, esp_sup), digits=3)
    return estimativa, beti
end



function Imprime(regra, inicio, tamanho, tempos)
    probs = collect(values(regra))
    suporte = collect(keys(regra))
    total = length(suporte)
    esperanca = sum(suporte[i] * probs[i] for i in 1:total)

    println("A Esperança é: $esperanca")

    beti, estimativa = Estimador(regra, inicio, tamanho)

    println("A estimativa original é: ", estimativa)
    println("Pelo método betístico é: ", beti)
    println("A média dos tempos é: ", mean(tempos))
    println("A variância dos tempos é: ", var(tempos))
end


main()


