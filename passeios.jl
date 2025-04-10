using Random, LaTeXStrings

function simulador(; a=50, N=100,
  X=[[1, 0.5], [-1, 0.5]],
  M=10_000, semente=0)
  Random.seed!(semente)
  duracoesSoma = 0
  edex = 0
  for x in X
    edex += x[1] * x[2]
  end
  edex = round(edex, digits=2)

  for i in 1:M
    saldo = a
    duracao = 0
    while saldo > 0 && saldo < N
      p = rand()
      for x in X
        p -= x[2]
        if p <= 0
          saldo += x[1]
          break
        end
      end
      duracao += 1
    end
    duracoesSoma += duracao
  end

  # display(LaTeXString("\$\$ \\left\\{\\begin{array}{ll}"))
  # for i in X
  #   display(LaTeXString("$(i[1]), & $(i[2])"))
  # end
  # display(LaTeXString("\\end{array}\\right.\$\$"))
  # display(LaTeXString("A média da duração de \$$M\$ passeios do jogo
  #                     com \$a = $a, N=$N\$ e \$E(X)=$edex\$ é
  #                     \$\\bar{\\psi}_{M,J}=
  #                     $(round(duracoesSoma/M, digits = 2))\$"))

  p0 = 0
  esperanca = 0
  for i in X
    if i[1] == 0
      p0 += i[2]
    end
    esperanca += abs(i[1] * i[2])
  end
  estimador = a * (N - a) / ((1 - p0) * esperanca)
  estimadorQuadrado = a * (N - a) / ((1 - p0) * esperanca^2)
  estimadorQuadradop0cima = (1 - p0) * a * (N - a) / (esperanca^2)
  estimadorQuadradop0cimacheio = p0 * a * (N - a) / (esperanca^2)
  estimadorsemp = a * (N - a) / (esperanca)
  estimadorsempquadrado = a * (N - a) / (esperanca^2)

  # display(LaTeXString("Esperança da duração do jogo
  #                     com \$a = $a, N=$N\$ é
  #                     \$\\widehat{E}(T_{a})
  #                     $(round(estimador, digits = 2))\$"))
  println("Valor p0: $(round(p0, digits=2))")
  println("Valor esp: $(round(esperanca, digits=2))")
  println("Valor simulado: $(round(duracoesSoma/M, digits=2))")
  println("Valor estimado com E[|X|]: $(round(estimador, digits=2))")
  println("Valor estimado com E[|X|]^2: $(round(estimadorQuadrado, digits=2))")
  println("Valor estimado sem (1-p0): $(round(estimadorsemp, digits=2))")
  println("Valor estimado sem (1-p0) com E[|X|]^2: $(round(estimadorsempquadrado, digits=2))")
  println("Valor estimado * (1-p0) com E[|X|]^2: $(round(estimadorQuadradop0cima, digits=2))")
  println("Valor estimado * p0 com E[|X|]^2: $(round(estimadorQuadradop0cimacheio, digits=2))")
end
