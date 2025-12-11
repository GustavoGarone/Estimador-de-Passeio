using Random

function mc1(tamanho=10, inicio=0)
  numeros::Vector{Int16} = collect(0:tamanho)
  thetas = 1 .- numeros ./ tamanho
  thetas = [thetas 1 .- thetas]
  print(thetas)
end

mc1(10, 0)
