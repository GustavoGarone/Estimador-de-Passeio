using Random, Distributions, StatsBase

M = 10_000
function mc()
  z1 = 50
  z2 = 50
  latice = [100, 100]

  tempo = 0
  while 0 < z1 < latice[1] && 0 < z2 < latice[2]
    p = rand()
    if p <= 0.4
      z1 -= 1
    elseif p <= 0.5
      z1 += 1
    elseif p <= 0.8
      z2 -= 1
    else
      z2 += 1
    end
    tempo += 1
  end
  return tempo
end

function mcmc()
  tempos = []
  for _ in 1:M
    push!(tempos, mc())
  end
  println("Média dos $M passeios: $(mean(tempos))")
  println("Variânia dos $M passeios: $(var(tempos, corrected=false))")
end
