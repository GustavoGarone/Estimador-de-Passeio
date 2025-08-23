using Plots
using Random
using StatsBase

function monteCarlo(M)
    a::Int64 = 1
    b::Int64 = 1
    p::Float64 = 0.25
    tamanho::Int64 = 100
    medias::Vector{Float64} = zeros(tamanho)
    for i in 1:tamanho
        somatempo = 0
        for _ in 1:M
            pos = i
            tempo = 0
            while pos > 0 && pos < tamanho
                if rand() < p
                    pos += a
                else
                    pos -= b
                end
                tempo += 1
            end
            somatempo += tempo
        end
        medias[i] = somatempo / M
    end
    pushfirst!(medias, 0)
    esp = a * p - b * (1 - p)
    est(k) = esp > 0 ? (tamanho - k) / esp : k / abs(esp)
    plt = plot(medias, label = "Simulada", yrotation = 60, xlabel = "Posição inicial", ylabel = "Duração em passos", legendfontsize = 13)
    plot!(est, label = "Estimada")
    savefig("graficoest.pdf")
    return
end

monteCarlo(100_000)
