using Random, StatsBase


function fuel()
  S = 10
  i = 1
  t = 0
  meio = rand(S)
  meio = meio ./ 2
  while i <= S
    if rand() < meio[i]
      i += 1
    end
    t += 1
  end
  return t
end

function fuel2()
  S = 10
  i = 1
  t = 0
  while i <= S
    p = rand()
    if p < (1 + abs(i)) / 20
      i == 0 ? i = 0 : i += 1
    elseif p < 2 * (abs(i) + 1) / 20
      i += 2
    end
    t += 1
  end
  return t
end

function MCMC()
  M = 1_000_000
  rodados = []
  for i in 1:M
    append!(rodados, fuel2())
  end
  println("Média: $(mean(rodados))")
end

MCMC()
