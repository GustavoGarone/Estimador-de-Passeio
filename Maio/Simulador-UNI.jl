using StatsBase, Plots

function main(X=Dict(1 => 0.2, -1 => 0.5, 0 => 0.3), tamanho=100, MC=10_000)

  probs = collect(values(X))
  probs_cum = cumsum(probs)
  suporte = collect(keys(X))
  total = length(suporte)

  if round(sum(probs), digits=2) != 1
    error("Não é distribuição de probabilidade")
  end

  function f(p::Float64)
    for i in 1:total
      if p <= probs_cum[i]
        return suporte[i]
      end
    end
  end

  function mc(inicio)
    tempos = zeros(MC)
    for i in 1:MC
      pos = inicio
      tempo = 0
      while 0 < pos < tamanho
        tempo += 1
        pos += f(rand())
      end
      tempos[i] = tempo
    end
    return tempos
  end

  estimativaPorMinimos = zeros(tamanho)
  estimativaMetodoVelho = zeros(tamanho)
  simulados = []
  mediasSim = zeros(tamanho)
  for i in 1:tamanho
    esperanca = sum(suporte[j] * probs[j] for j in 1:total)
    esp_inf = abs(i / esperanca)
    esp_sup = abs((tamanho - i) / esperanca)
    if esperanca < 0
      estimativaMetodoVelho[i] = round(esp_inf, digits=3)
    elseif esperanca > 0
      estimativaMetodoVelho[i] = round(esp_sup, digits=3)
    else
      estimativaMetodoVelho[i] = i * (tamanho - i)
    end
    estimativaPorMinimos[i] = round(min(esp_inf, esp_sup), digits=3)
    push!(simulados, mc(i))
    mediasSim[i] = mean(simulados[i])
  end

  pest = scatter(estimativaPorMinimos,
    title="Comparação de estimadores",
    label="Estimativa por Mínimo",
    xlabel="Início",
    markersize=1.5,
    markerstrokewidth=0
  )
  scatter!(estimativaMetodoVelho,
    label="Estimativa pelo método antigo",
    markersize=1.5,
    markerstrokewidth=0
  )
  scatter!(mean.(simulados),
    label="Valores simulados",
    markersize=1.5,
    markerstrokewidth=0
  )
  ppasseio1 = histogram(
    simulados[50],
    title="Passeios ini. 50",
    label="",
    xlabel="Duração",
    normalize=:pdf,
    color=:tomato,
    linecolor=:gray45)
  plot(pest, ppasseio1)
end

main()


