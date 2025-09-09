using CairoMakie
using Random
using StatsBase

function monteCarlo(M)
    a::Int64 = 2
    b::Int64 = 1
    tamanho::Int64 = 100
    k::Int64 = 50
    medias::Vector{Float64} = zeros(tamanho)
    estimados::Vector{Float64} = zeros(tamanho + 1)
    for i in 1:100
        p = i / 100
        somatempo = 0
        for _ in 1:M
            pos::Int64 = 50
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
        esp = a * p - b * (1 - p)
        estimados[i + 1] = esp > 0 ? (tamanho - k) / esp : k / abs(esp)
        medias[i] = somatempo / M
    end
    pushfirst!(medias, 0)
    # plt = plot(
    #     medias,
    #     label = "Simulated",
    #     yrotation = 60,
    #     xlabel = "Probability of Round Victory",
    #     ylabel = "Average duration in steps",
    #     legendfontsize = 13,
    #     ylims = (0, maximum(medias) + 200)
    # )
    # plot!(estimados, label = "Estimated")
    f = Figure()
    ax = Axis(
        f[1, 1],
        xlabel = "Probability of Round Victory",
        ylabel = "Average game duration in steps"
    )
    lines!(ax, medias, label = "Simulated")
    lines!(ax, estimados, label = "Estimated")
    save("graficoest-en.pdf", f)
    return
end

Random.seed!(25)
monteCarlo(100_000)
