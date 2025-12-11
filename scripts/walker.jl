using Random

function simulador(;a = 30, N = 100,
                   X=[[1, 0.5],[-1, 0.5]], M=10_000, mostra=true, seed=nothing)

  try
    if sum(X)[2] != 1
      return error("Probabilidade não somando 1")
    end
  catch
    return error("Use X da forma X=[[v1,p1],[v2,p2]...]")  
  end

  if seed != isnothing
    Random.seed!(seed)
  end

  duracaoSoma = 0

  for i in 1:M
    saldo = a
    duracao = 0
    while saldo > 0 && saldo < N
      p = rand()
      for x in X
        p -= x[2]
        if p < 0
          saldo += x[1]
          break
        end
      end
      duracao += 1
    end
    duracaoSoma += duracao
  end
  return duracaoSoma / M
end

