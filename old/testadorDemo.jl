using Statistics
using DataFrames
using Plots
pgfplotsx()

function main()
  # Fixado valor piso em 0, compararemos para diversos ranges de dados fixados
  # e simulações com p livre  os dados esperados (fórmula teorica)
  # e obtidos pela Fórmula Estimadora.

  piso = 0
  arrTeto = [20,300,50,1000,5]
  arrIni = [5, 76,25,30,1]

  estimado = zeros(100)
  esperado  = zeros(100)
  diff = zeros(100)
  for item in 1:length(arrTeto)
    for i in 1:100 
      estimado[i], esperado[i] = calculaProb(arrTeto[item],arrIni[item],0,i/100,1-i/100,1,-1)
      diff[i] = abs(estimado[i] - esperado[i]) 
    end
    plEstimado = plot(estimado, label = ["V. Est."])
    plEsperado = plot(esperado, label = ["V. Esp."])
    plDiff = plot(diff, label = ["|Est. - Esp.|"])
    graficar(plEstimado, plEsperado, plDiff, item)
  end
#scatter!(valorEstimado, valorEsperado, label="points"
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


function graficar(plEstimado, plEsperado, plDiff, item)
  graficos = plot(plEstimado, plEsperado, plDiff,
        layout=@layout([a b; c]), title = ["Estimado" "Esperado" "Diferença"],
        titlelocation = :left)
  savefig(graficos, "~/Graficos/Estimador/GraficosDemo$item.pdf")
end

main()
