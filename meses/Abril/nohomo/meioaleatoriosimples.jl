using Random, Distributions, Plots, StatsPlots, StatsBase

function main()

  tamanho = 5
  M = 100_000

  d = Uniform(0.1, 0.9)

  function mc(a, αs)
    tempo = 0
    while a > 0 && a < tamanho
      p = rand()
      if p < αs[a]
        a += 1
      else
        a -= 1
      end
      tempo += 1
    end
    return tempo
  end

  function sim(a)
    tempos = zeros(Int64, M)
    for i in 1:M
      αs = rand(d, tamanho)
      tempos[i] = mc(a, αs)
    end
    return tempos
  end

  for i in 1:tamanho-1
    println("$i - $(mean(sim(i)))")
  end
end
