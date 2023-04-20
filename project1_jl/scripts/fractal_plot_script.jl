
include("../helpers.jl")
include("../simple.jl")
include("../project1.jl")
include("../plotting_analysis/fractal_plot.jl")

lowercorner=[-4, -2]
uppercorner=[4, 6]

n_x = 800
n_y = 600

x_range = range(lowercorner[1], uppercorner[1], length=n_x)
y_range = range(lowercorner[2], uppercorner[2], length=n_y)

optimizer(x0) = optimize_with_history(rosenbrock, nothing, x0, 20, "simple1")
println("Finished Initialization")
fractal_out = generate_fractal(optimizer, x_range, y_range)
println("Finished Fractal Generation")

plt_fractal = plot_fractal(log10.(fractal_out), x_range, y_range)
title!("Nelder-Mead Rosenbrock Fractal (Log10 of Optimum)")
println("Finished Plot Generation")
display(plt_fractal)
println("Finished Plot Display")
savefig(plt_fractal, "plots/rosen_fractal.png")

