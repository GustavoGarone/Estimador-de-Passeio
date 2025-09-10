"""
Considere o problema da ruína do jogador em duas dimensões. Ambas de tamanho n.
O jogador ganha 1 real na d1 com probabilidade p, perde 1 real na d1 com proba-
bilidade q, ganha 1 real na d2 com probabilidade r, perde 1 real na d2 com pro-
babilidade s de tal modo que p+q+r+s=1.
O jogo termina quando, em qualquer dimensão, o jogador chega a 0 ou n reais.
"""

using SciMLBase, Symbolics, SciPy, Plots, NamedArrays

function main(n, probs)
    println("Comecei")

    # Cria uma matriz de elementos μ[i,j], tempo médio começando em i,j
    @variables μ[1:(n + 1), 1:(n + 1)] p q r s

    p = big(probs[1])
    q = big(probs[2])
    r = big(probs[3])
    s = big(probs[4])

    if round(p + q + r + s, digits = 2) != 1
        error("Probabilidades não somam 1")
    end


    # Inicializa o vetor de equações
    eqs = []

    # Define as condições de fronteira
    for i in eachindex(μ)
        if 1 in Tuple(i) || (n + 1) in Tuple(i)
            push!(eqs, μ[i] ~ 0)
        end
    end

    # Define as equações não triviais
    # EDF  ->  μ[i+1,j]*p + μ[i-1,j]*q + μ[i,j+1]*r + μ[i,j-1]*s + 1 ~ μ[i,j]
    for i in 2:n
        for j in 2:n
            push!(eqs, μ[i + 1, j] * p + μ[i - 1, j] * q + μ[i, j + 1] * r + μ[i, j - 1] * s + 1 ~ μ[i, j])
        end
    end

    # Resolver o sistema para μ em termos de p
    sol = symbolic_linear_solve(eqs, μ)
    println("p: $p q: $q r:$r s:$s")
    return reshape(μ, n + 1, n + 1), reshape(round.(sol, digits = 2), n + 1, n + 1), eqs

end

n = 10

p = 0.4
q = 0.5 - p
r = p
s = q

probs = (p, q, r, s)

(mus, teoricos, eqs) = main(n, probs)

myArray = NamedArray(reverse(teoricos, dims = 1), (0:n, 0:n), ("i", "j"))
show(stdout, "text/plain", myArray)

j = Int(ceil(n / 20))
heatmap(
    teoricos, title = "Esperanças dos Tempos",
    xticks = (1:j:(n + 1), 0:j:n),
    yticks = (1:j:(n + 1), 0:j:n),
    guidefontfamily = "times",
    tickfontfamily = "times",
    legendfontfamily = "times",
)
savefig("./heatmap.pdf")
