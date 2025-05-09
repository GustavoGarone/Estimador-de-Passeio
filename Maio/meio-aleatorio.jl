using Symbolics, LinearSolve, LinearSolve

function main(n::Int64)

  function resolve_sistema()
    @variables μ[1:n]
    @variables p[1:n]

    eqs::Vector{Real} = [μ[1]]
    for i in 2:(n-1)
      append!(eqs, p[i] * μ[i+1] + (1 - p[i]) * μ[i-1] + 1 - μ[i])
    end
    append!(eqs, μ[n])
    return symbolic_linear_solve(eqs .~ 0, collect(μ))
  end

  resolve_sistema()
  function integrar()

  end
end

