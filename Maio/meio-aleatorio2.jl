using Symbolics, LinearAlgebra, LinearSolve, Integrals

function main(n::Int64, distribuicao)

  @variables μ[-1:n+1]
  @variables prob[1:n]

  function resolve_sistema()
    eqs::Vector{Real} = [μ[-1], μ[0]]
    println("b")
    for i in 1:(n-1)
      append!(eqs, prob[i] * μ[i+2] + (1 - prob[i]) * μ[i-2] + 1 - μ[i])
    end
    append!(eqs, μ[n])
    append!(eqs, μ[n+1])
    println("a")
    print(eqs)
    return symbolic_linear_solve(eqs .~ 0, collect(μ))
  end

  # function integrar(sisSol, i)
  #   expr = simplify(sisSol[i])
  #   funcao_expressao = build_function(expr, prob)
  #   f(valores, p) = substitute(funcao_expressao,
  #     Dict(prob[i] => valores[i] for i in 1:n))
  # end

  integrar(resolve_sistema(), 2)
end

main(5)
