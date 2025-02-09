using Random, Plots, StatsBase

#=
Roteiro:

f Passo(lista de passeios)
  roda um valor aleatório e atualiza cada elemento do passeio,caso passeios se
  encontrem, exclui um dos passeios. Retorna a lista alterada
    ideias de otimização: hashmap para posição pode deixar verificar acoplamento
    mais rápido a custo de memória
  
=#

function passodiff!(passeios)
  for passeio in passeios
    if passeio[2] > rand()
      passeio[1] += 1
    else
      passeio[1] -= 1
    end
  end
  function rm(passeio)
    reps = [x for x in passeio if count(==(x[1]), [v[1] for v in passeio]) > 1]
    if length(reps) > 0
      println("acoplei")
      println(passeio)
      println(reps)
      println(reps[1:length(reps)-1])
      passeio = [x for x in passeio if !(x in reps[1:length(reps)-1])]
      println("após remoção")
      println(passeio)
    end
    return passeio
  end
  return rm(passeios), [x[1] for x in passeios]
end

function passo!(passeios)
  for passeio in passeios
     if passeio[2] > rand()
      passeio[1] += 1
    else
      passeio[1] -= 1
    end
  end
  return unique(passeios), [x[1] for x in passeios]
end

function passear(plotar = false)
  passeios = [[0, 0.5],[-10, 0.5],[10, 0.5]]
  duracoes = [[],[],[]]
  MAXIMO = 1 * 10^7
  i = 0 
  while length(passeios) > 1 && i < MAXIMO
    passeios, durs = passo!(passeios)
    for (i,j) in zip(duracoes, durs)
      append!(i,j)
    end
    i+=1
  end
  if plotar
    plot(duracoes[1])
    plot!(duracoes[2])
    plot!(duracoes[3])
  end
  maior = 0
  if length(duracoes[1]) > length(duracoes[2])
    if length(duracoes[1]) > length(duracoes[3])
      maior = duracoes[1]
    else
      maior = duracoes[3]
    end
  elseif length(duracoes[2]) > length(duracoes[3])
    maior = duracoes[2]
  else
    maior = duracoes[3]
  end
  return maior
end

function simula()
  M = 1000
  passeios = Vector{Int64}(undef, 0)
  for i in 1:M
    append!(passeios, length(passear()))
    println(i)
  end
  return passeios
end
