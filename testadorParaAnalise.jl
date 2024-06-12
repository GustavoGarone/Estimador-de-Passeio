using Statistics
using DataFrames
using Plots

function main()
  # Fixado valor piso em 0, compararemos para diversos ranges de dados fixados
  # e simulações com p livre  os dados esperados (fórmula teorica)
  # e obtidos pela Fórmula Estimadora.
  ENV["GKSwstype"]="nul"
  piso = 0
  arrInis = [10, 100, 1000]
  arrMultTopos = [2, 3, 5]
  probs = 1:100
  

  valorEstimado = zeros(size(arrInis,1), size(arrMultTopos,1), 100)
  valorEsperado = zeros(size(arrInis,1), size(arrMultTopos,1), 100)
  i = 1
  for inicio in arrInis 
    t = 1
    for multiplicador in arrMultTopos
      topo = inicio * multiplicador
      for p in probs
        valorEstimado[i,t,p], valorEsperado[i,t,p] = 
        calculaProb(topo, inicio, 0, p/100, 1-p/100, 1, -1)
      end
      t += 1
    end
    i +=1 
  end
  surface(valorEstimado)
  #scatter!(valorEstimado, valorEsperado, label="points")
  savefig("~/xd.png")
end


function calculaProb(topo,inicial,piso,prob,q,acr,dec)

  # Calculando via Formula Estimadora
  f = (prob * acr)+(q * dec)
  valorEstimado = 0
  if f > 0
    valorEstimado = abs((topo-inicial)/f)
  else 
    valorEstimado = abs((inicial-piso)/f)
  end

  return valorEstimado, teorico(topo, inicial, piso, prob,q)
end

function teorico(topo,inicial,piso,p,q)
  r = q/p
  d = q-p
  return inicial/d-topo/d*((1-r^inicial)/(1-r^topo))
end

main()
