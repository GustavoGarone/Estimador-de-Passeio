from sympy import solve
from sympy.abc import a, b, c, f, g, l, t

# Forma simples, lambda = 1, gamma = 0
solve([-2 * f**2 + 2 * t * g + 1, t * f**2 - t * g], [f, g], dict=True)

# Forma complicada com alpha, beta, lambda e gamma

solve(
    [-2 * a * f**2 + 2 * t * b * g + l, a * t * f**2 - b * t * g + c], [f, g], dict=True
)
