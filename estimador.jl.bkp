function main()
  i = 0
  max = 10
  while i < max
    valorPiso = rand(0:10)
    valorTopo = rand(valorPiso+2:100)
    valorInicial = rand(valorPiso+1:valorTopo-1)
    valorAcresc = rand(1:5)
    valorDecresc = rand(-5:-1)

    prob = rand(0:100)/100
    while prob == 1 || prob == 0
      prob = rand(0:100)/100
    end
    
    q = 1 - prob

    print("\nIteração $i\n")
    print("\nPars: \nPiso: $valorPiso, Inicial: $valorInicial, Topo: $valorTopo, ",
          "Acresc: $valorAcresc, Decresc: $valorDecresc, P: $prob\n")

    valorYu, valorBet = calculaProb(valorTopo, valorInicial, valorPiso,
                                    prob, q, valorAcresc, valorDecresc)

    valSim = simulador(valorTopo, valorInicial, valorPiso,
                        prob, q, valorAcresc, valorDecresc)

    erro = valorYu-valSim # Distância até o simulado
    
    caminho = valorTopo-valorPiso # Amplitude entre topo e baixo
    dProb = prob-0.5 # Distância de p até 0.5
    estimadorErro = 1/(valorTopo-valorPiso)*(abs(prob-0.5))

    print("\nYu: $valorYu, Bet: $valorBet, Sim: $valSim \n")

    print("\nΔ: $erro, Amp: $caminho, dProb: $dProb \n",
          "Estimativa de Erro: $estimadorErro \n")
    print("======================================================")
    i+= 1
  end
end

function calculaProb(topo,inicial,piso,prob,q,acr,dec)

  # Calculando via loucura de Yukio
  f = (prob * acr)+(q * dec)
  valorYu = 0
  if f > 0
    valorYu = abs(ceil((topo-inicial)/f))
  else 
    valorYu = abs(ceil((inicial-piso)/f))
  end

  return valorYu, formulete(topo,inicial,piso,prob,q)
end

function formulete(topo,inicial,piso,p,q)
  r = q/p
  d = q-p
  return ceil(inicial/d-topo/d*((1-r^inicial)/(1-r^topo)))
end

function simulador(topo,inicial,piso,p,q,acr,dec)
  corretor = 100
  simuls = 100000
  somaMedias = 0
  maxits = 10^10
  k = 0
  while k < corretor
    j = 0
    soma = 0
    while j < simuls
      itTopo = topo
      itPiso = piso
      itValor = inicial
      i = 0
      while itValor > itPiso && itValor < itTopo && i < maxits 
        i+=1
        if rand() < p
          itValor += acr 
        else
          itValor += dec
        end
      end
      soma += i
      j += 1
    end
    k += 1
    somaMedias+= soma/simuls
  end
  #print("Média de $simuls simuls: $(ceil(somaMedias/corretor))")
  return ceil(somaMedias/corretor)
end
main()
