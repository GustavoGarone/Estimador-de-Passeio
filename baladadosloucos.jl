using StatsBase
# using Plots
# theme(:ggplot2, alpha = 0.3)
# pgfplotsx()

function main()
    valoresX = [1, -4]
    probsX   = Weights([0.3, 0.7])
    if sum(probsX) != 1
        print("Probabilidades incorretas")
        return
    end
end