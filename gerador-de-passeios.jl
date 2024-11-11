using DataFrames, Random, CSV

# Pode ser legal não salvar a duração, mas pareceio meio complicado :)

function main(default=false)
    if default
        numPasseios = 10000
        p = 0.6
        barSuperior = 200
        inicios = [10, 30, 50, 70, 90, 150]
        Random.seed!(1)
        pathfile = "dadosPasseio.csv"
    else
        println("\nBem vindo ao gerador de passeios!\n")
        println("=====================================\n")
        println("Insira a semente aleatória (Natural):")
        Random.seed!(parse(Int, readline()))
        println("Insira o número de passeios por valor (Int):")
        numPasseios = parse(Int, readline())
        println("\nInsira a probabilidade (0.0<p<1.0) de sucesso:")
        p = parse(Float16, readline())
        println("\nInsira o teto de parada (Int):")
        barSuperior = parse(Int, readline())
        println("\nInsira agora  inícios que você quer simular. 0 para parar.")
        inicios = Int[]
        println("Insira o primeiro início:")
        while (j = parse(Int, readline())) != 0
            println("Insira o próximo início, 0 para parar:")
            append!(inicios, j)
        end
        println("\nInsira o nome do arquivo (ou caminho) que será salvo como csv:")
        pathfile = readline()
        if !occursin(".csv", pathfile)
            pathfile *= ".csv"
        end
    end
    println("\n=====================================\n")
    println("SIMULANDO")
    println("\n=====================================\n")

    function simulaPasseio(a)
        # duracaoMaxima = 10^6
        # duracao = 0
        posicao = a
        passeio = [a]

        # Probabilísticamente, é improvável que um jogo dure muito.
        # Pode ser mais eficiente para o algoritmo ignorar uma "duração máxima"
        while posicao > 0 && posicao < barSuperior # && duracao < duracaoMaxima
            probabilidade = rand()
            if probabilidade <= p
                posicao += 1
            else
                posicao -= 1
            end
            # duracao += 1
            append!(passeio, posicao)
        end
        popfirst!(passeio)
        return passeio

    end

    function geraPasseios()

        dfpasseios = DataFrame(
            :Caminho => Array[],
            :Inicio => Int16[],
            :Teto => Int16[],
            :Probabilidade => Float16[],
            :Duracao => Int16[],
        )

        for a in inicios
            for i in 1:numPasseios
                passeio = simulaPasseio(a)
                push!(dfpasseios,
                    [passeio, a, barSuperior, p, length(passeio)])
            end
        end

        return dfpasseios
    end

    dfpasseios = geraPasseios()

    CSV.write(pathfile, dfpasseios)
    println("CSV salvo.")
    dfpasseios
end

main(true)