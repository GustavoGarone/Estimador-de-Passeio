using StatsBase
using Random
using Base.Threads
using DataFrames
using StatsPlots

function main(inicio = 1, passo = 1, n = 20, MC = 10_000)
    seq = inicio:passo:n
    dims = Int(ceil(n / passo))
    df = DataFrame(dim = zeros(dims * MC), t = zeros(dims * MC))
    j = 0
    for i in seq
        df.dim[(1 + j * MC):(MC * (j + 1))] .= i
        j += 1
    end

    j = 0
    for totalDim in seq
        if totalDim % 10 == 0
            for _ in 1:(floor(log(10, totalDim)) + 1)
                print("\b")
            end
            print("dim: $totalDim")
        end
        # dist uniforme entre dimensões
        dims_prob::Vector{Float64} = fill(1 / totalDim, totalDim)
        dims_cum::Vector{Float64} = cumsum(dims_prob)

        inicio::Int64 = 50
        tamanho::Int64 = 100
        inicios::Vector{Int64} = fill(inicio, totalDim)
        tamanhos::Vector{Int64} = fill(tamanho, totalDim)

        X = Dict(1 => 0.2, -1 => 0.8, 0 => 0.0)
        suporte = sort(collect(keys(X)))
        probs = [X[k] for k in suporte]
        cumulada = cumsum(probs)

        # mesma regra em todas as dimensões
        Probs_cums = [cumulada for _ in 1:totalDim]
        Passos = [suporte for _ in 1:totalDim]

        tempo = montecarlo(inicios, tamanhos, dims_cum, Probs_cums, Passos, MC)
        df.t[(1 + j * MC):(MC * (j + 1))] .= tempo
        j += 1
    end
    return df
end

function montecarlo(inicios, tamanhos, dims_cum, prob_cums, passos, MC)
    tempos::Vector{Int64} = zeros(MC)

    @threads for i in 1:MC
        estados::Vector{Int64} = copy(inicios)
        tempo::Int64 = 0

        while all(estados .> 0) && all(estados .< tamanhos)
            tempo += 1

            r1::Float64 = rand()
            dim::Int64 = searchsortedfirst(dims_cum, r1)  # vetor cumulativo ordenado
            r2::Float64 = rand()
            passo::Int64 = passos[dim][searchsortedfirst(prob_cums[dim], r2)]
            estados[dim] += passo
        end

        tempos[i] = tempo
    end

    return tempos
end

Random.seed!(25)
dados = main(1, 10, 500, 1000)
boxplot(
    dados.dim, dados.t, yrotation = 60, markersize = 0.6, msw = 0.4, label = "", xlabel = "Dimensão", bar_width = 4.5, ylabel = "Duração em passos", color = :red, markercolor = :yellow
)
savefig("boxplots.pdf")
