using StatsBase, Plots

function main(tamanhos=[100, 100, 100, 100, 100], X=Dict(1 => 0.2, -1 => 0.5, 0 => 0.3), MC=10_000)


  dimensoes = length(tamanhos)
  piso = zeros(dimensoes)
  inicios(n) = repeat([n], dimensoes)
  prob_dim = ones(dimensoes) .* (1 / dimensoes)
  prob_dim_cum = cumsum(prob_dim)
  probs = collect(values(X))
  probs_cum = cumsum(probs)
  suporte = collect(keys(X))
  total = length(suporte)

  if round(sum(probs), digits=2) != 1
    error("Não é distribuição de probabilidade")
  end

  function f(p::Float64)
    for i in 1:total
      if p < probs_cum[i]
        return suporte[i]
      end
    end
  end

  function dimensao(p::Float64)
    for i in 1:dimensoes
      if p < prob_dim_cum[i]
        return i
      end
    end
  end

  function mc(inicios)
    tempos::Vector{Int64} = zeros(MC)
    for i in 1:MC
      tempo::Int64 = 0
      posicoes::Vector{Int64} = copy(inicios)
      while all(piso .< posicoes) && all(posicoes .< tamanhos)
        dim::Int64 = dimensao(rand())
        posicoes[dim] += f(rand())
        tempo += 1
      end
      tempos[i] = tempo
    end
    return tempos
  end

  println("Regra X: $X")
  medias = zeros(minimum(tamanhos))
  for i in 1:minimum(tamanhos)
    inicios = ones(dimensoes) * i
    medias[i] = mean(mc(inicios))
    println("Média das durações simuladas no início $i: $(medias[i])")
  end
  scatter(medias, title="Passeio multidimensional", xlabel="Início(s)",
    ylabel="Média tempos simulados", label="", markersize=1.5)
end

main([100, 100])


