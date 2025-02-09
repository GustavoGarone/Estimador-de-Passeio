using StatsBase

function main()
  duracao = 0
  p = 0.4
  teto = 100
  saldo = 30
  while saldo > 0 && saldo < 100
    if p > rand()
      duracao += 1
    end
  end
end
