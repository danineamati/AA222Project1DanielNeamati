
include("../helpers.jl")
include("../simple.jl")
include("../project1.jl")
include("../plotting_analysis/fractal_plot.jl")

rosen_lower = [-4, -2]
rosen_upper = [4, 6]
rosen_clim = (-7, 3)

hblau_lower = [-5, -6]
hblau_upper = [6, 6]
hblau_clim = (-7, 2)

n_x = 800
n_y = 600

rosen_package = [rosenbrock, "simple1", 20, rosen_lower, rosen_upper, rosen_clim, "Rosenbrock", "rosen"]
hblau_package = [himmelblau, "simple2", 40, hblau_lower, hblau_upper, hblau_clim, "Himmelblau", "hblau"]

for (f, prob, n, lowercorner, uppercorner, f_clim, fname, savename) in (rosen_package, hblau_package)

    x_range = range(lowercorner[1], uppercorner[1], length=n_x)
    y_range = range(lowercorner[2], uppercorner[2], length=n_y)

    optimizer(x0) = optimize_with_history(f, nothing, x0, n, prob)
    println("Finished Initialization")
    fractal_out = generate_fractal(optimizer, x_range, y_range)
    println("Finished Fractal Generation")

    plt_fractal = plot_fractal(log10.(fractal_out), x_range, y_range, f_clim=f_clim)
    title!("Nelder-Mead " * fname * " Fractal (Log10 of Optimum)")
    println("Finished Plot Generation")
    display(plt_fractal)
    println("Finished Plot Display")
    savefig(plt_fractal, "plots/" * savename * "_fractal_" * string(n_x) * "_" * string(n_y) * ".png")

end

