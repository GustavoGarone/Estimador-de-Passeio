using Plots
using Random
using StatsBase

function monteCarlo(M)
    a::Int64 = 2
    b::Int64 = 1
    c::Int64 = 0
    tamanho::Int64 = 100
    k::Int64 = 50
    medias::Vector{Float64} = zeros(tamanho)
    estimados::Vector{Float64} = zeros(tamanho)
    for i in 1:100
        p = i / 100
        esp = a * p - b * (1 - p)
        estimados[i] = esp > 0 ? (tamanho - k) / esp : k / abs(esp)
        medias[i] = simula(M, p, k, tamanho, a, b, c)
    end
    # pushfirst!(medias, 0)
    plt = plot(
        medias,
        guidefontfamily = "times",
        tickfontfamily = "times",
        legendfontfamily = "times",
        label = "Simulated",
        yrotation = 60,
        xlabel = "Probability of round victory",
        ylabel = "Average duration in steps",
        legendfontsize = 13,
        ylims = (0, maximum(medias) + 200),
        xticks = ([0, 25, 50, 75, 100], [0, 0.25, 0.5, 0.75, 1])
    )
    plot!(estimados, label = "Estimated")
    savefig("graficoest-en.pdf")
    return
end

function simula(M, p, k, tamanho, a, b, c)
    somatempo = 0
    for _ in 1:M
        pos::Int64 = k
        tempo = 0
        while pos > 0 && pos < tamanho
            rodad = rand()
            if rodad < 0.25
                pos += 0
            elseif rodad < p
                pos += a
            else
                pos -= b
            end
            tempo += 1
        end
        somatempo += tempo
    end
    return somatempo / M
end

Random.seed!(25)
monteCarlo(100_000)
