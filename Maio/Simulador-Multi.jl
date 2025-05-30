using StatsBase

MC = 10000
tempos = zeros(MC)

dimensoes = 5
piso = zeros(dimensoes)
tamanhos = [100, 100, 100, 100, 100]
#inicios = [50, 50, 50, 50, 50]
inicios = repeat([5], 5)
prob_dim = [0.2, 0.2, 0.2, 0.2, 0.2]
prob_dim_cum = cumsum(prob_dim)

if mean(length.([tamanhos, inicios, prob_dim])) != dimensoes
  error("Dimensões inconsistentes")
end


X = Dict(1 => 0.2, -1 => 0.5, 0 => 0.3)
probs = collect(values(X))
probs_cum = cumsum(probs)
suporte = collect(keys(X))
total = length(suporte)

if round(sum(probs), digits=2) != 1
  error("Nao é distribuição de probabilidade")
end

function f(p::Float64)
  for i in 1:total
    if p <= probs_cum[i]
      return suporte[i]
    end
  end
end

function dimensao(p::Float64)
  for i in 1:dimensoes
    if p <= prob_dim_cum[i]
      return i
    end
  end
end



tempos = zeros(MC)

for i in 1:MC
  tempo = 0
  posicoes = copy(inicios)
  while all(piso .< posicoes) && all(posicoes .< tamanhos)
    dim = dimensao(rand())
    posicoes[dim] += f(rand())
    tempo += 1
    #println(posicoes)
  end
  tempos[i] = tempo
end
print(mean(tempos))
