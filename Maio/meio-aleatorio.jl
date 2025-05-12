using Symbolics, LinearAlgebra, LinearSolve, Integrals

function main(n::Int64)

  @variables μ[1:n]
  @variables prob[1:n]

  function resolve_sistema()
    eqs::Vector{Real} = [μ[1]]
    for i in 2:(n-1)
      append!(eqs, prob[i] * μ[i+1] + (1 - prob[i]) * μ[i-1] + 1 - μ[i])
    end
    append!(eqs, μ[n])
    return symbolic_linear_solve(eqs .~ 0, collect(μ))
  end

  function integrar(sisSol, i)
    expr = simplify(sisSol[i])
    expr += 0 * (prob[1:n])
    println(expr)
    funcao_expressao = build_function(expr, prob)
    println("1")
    # avaliavel = eval(funcao_expressao)
    println("2")
    # f(prob, p) = avaliavel(prob)
    f(valores, p) = substitute(funcao_expressao,
                               Dict(prob[i]=>valores[i] for i in 2:(n-1)))
    println("3")
    println("4")
    dominio = (0.1ones(n-2), 0.9ones(n-2))
    println("5")
    integral = IntegralProblem(f, dominio)
    println("6")
    return solve(integral, HCubatureJL())
  end

  integrar(resolve_sistema(), 2)
end

main(5)
