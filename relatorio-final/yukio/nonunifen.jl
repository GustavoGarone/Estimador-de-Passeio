# Considere um passeio de 0 a 100, sendo estas barreiras
# O jogador, que está no espaço i vai para i+1 com P = array[i]
# Ele vai para i-1 com P = 1-array[i]
# Ele começa em a
# Vamos modelar a molécula B : A + A <+> B
# v = 1 * [A]^2 = (1-2[B])²

using Plots

min = 0
max = 100

function CriaMeio()
    array = []

    velB(c) = kf * (1 - 2c)^2 - kr * c  # Em função da Concentação de B
    velA(c) = -2 * kr * (1 - 2c)^2 + 2 * kr * c # Em função da Concentação de B

    for i in min:max
        CA = (i - 1) / 100
        CB = 1 - 2 * CA

        va = abs(-2 * kf * CA^2 + 2 * kr * CB)
        vb = abs(kf * CA^2 - kr * CB)
        push!(array, abs(va / (va + vb)))
    end
    return (array)
end


function CriaMeio(n)
    p = zeros(n + 1)
    p[1] = 0
    p[n + 1] = 0
    for i in 2:n
        p[i] = (i - 1) / (n)
    end
    return p
end

function CriaMeio(n)
    p = zeros(n + 1)
    p[1] = 0
    p[n + 1] = 0
    for i in 2:n
        p[i] = (2 - rand()) / 10
    end
    return p
end


function CriaMeio(n)
    p = zeros(n + 1)
    p[1] = 0
    p[n + 1] = 0
    for i in 2:n
        b = 1.5
        p[i] = i^b / n^b
    end
    return p
end


n = 100
array = CriaMeio(n)

function Simula(array, a)
    pos = a + 1
    duracao = 0
    tam = length(array)
    while !(pos in [1, tam])
        duracao += 1
        #println(pos)
        if rand() < array[pos]
            pos += 1
        else
            pos -= 1
        end
    end
    return duracao
end

function MonteCarlo(array, a, MC = 10_000)
    tempos = []
    a = a - 1
    for i in 1:MC
        push!(tempos, Simula(array, a))
    end
    return sum(tempos) / MC
end

#medias = MonteCarlo.(Ref(array),slaa)


function EstimadorBaixo(array, n)
    baixo = sum(abs.(array[2:(n + 1)] .- 1) .^ (-1))
    return baixo
end

function EstimadorCima(array, n)
    cima = sum(abs.(array[(n + 1):(end - 1)]) .^ (-1))
    return cima
end

function Misto(array, n)
    return (1 - array[n]) * EstimadorBaixo(array, n) + array[n - 1] * EstimadorCima(array, n)
end

function Novo(array, m)
    n = m
    esp = []
    for i in 2:(length(array) - 1)
        push!(esp, 2 * array[i] - 1)
    end
    esp = 1 ./ esp
    replace!(esp, Inf => 51)
    sb = sum(abs.(esp[1:(n - 1)]))
    sc = sum(abs.(esp[(n - 1):end]))
    if esp[n] > 0
        return sc
    else
        return sb
    end
end

function main()
    range = 2:(n - 1)
    MC = MonteCarlo.(Ref(array), range)
    NV = Novo.(Ref(array), range)
    plot(
        MC, ylim = (0, maximum(MC) * 1.2),
        guidefontfamily = "times",
        tickfontfamily = "times",
        legendfontfamily = "times",
        label = "Simulated",
        yrotation = 60,
        xlabel = "Probability of round victory",
        ylabel = "Average duration in steps",
        legendfontsize = 13,
        xticks = ([0, 25, 50, 75, 100], [0, 0.25, 0.5, 0.75, 1])
    )
    plot!(NV, label = "Estimated")
    return savefig("estnaounifen.pdf")
end
main()
