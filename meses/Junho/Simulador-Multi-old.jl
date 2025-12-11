using StatsBase
using Plots
using Random
using Base.Threads

function main()
  n = 20
  seq = 1:1:n
  medias = zeros(n)

  for totalDim in seq
    print("Dim $totalDim | ")
    # dist uniforme entre dimensões
    dims_prob = fill(1 / totalDim, totalDim)
    dims_cum = cumsum(dims_prob)

    inicio = 50
    tamanho = 100
    inicios = fill(inicio, totalDim)
    tamanhos = fill(tamanho, totalDim)

    X = Dict(1 => 0.2, -1 => 0.8, 0 => 0.0)
    suporte = sort(collect(keys(X)))
    probs = [X[k] for k in suporte]
    cumulada = cumsum(probs)

    # mesma regra em todas as dimensões
    Probs_cums = [cumulada for _ in 1:totalDim]
    Passos = [suporte for _ in 1:totalDim]


    MC = 10_000
    tempos = montecarlo(inicios, tamanhos, dims_cum, Probs_cums, Passos, MC)
    medias[totalDim] = mean(tempos)
    println(medias[totalDim])
  end

  # Plotagem
  # plot(seq, medias, xlabel="Dimensões", ylabel="Tempo médio até o fim",
  #   title="Simulações da duração do passeio \n em dimensões superiores", legend=false, lw=2, marker=:circle)
end

function montecarlo(inicios, tamanhos, dims_cum, prob_cums, passos, MC)
  totalDim = length(inicios)
  tempos = zeros(MC)

  @threads for i in 1:MC
    estados = copy(inicios)
    tempo = 0

    while all(estados .> 0) && all(estados .< tamanhos)
      tempo += 1

      r1 = rand()
      dim = searchsortedfirst(dims_cum, r1)  # vetor cumulativo ordenado
      r2 = rand()
      passo = passos[dim][searchsortedfirst(prob_cums[dim], r2)]
      estados[dim] += passo
    end

    tempos[i] = tempo
  end

  return tempos
end

main()
