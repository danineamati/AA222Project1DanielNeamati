
include("../helpers.jl")
include("../simple.jl")
include("../project1.jl")
include("../plotting_analysis/fractal_plot.jl")

rosen_lower = [-4.0, -2.0]
rosen_upper = [4.0, 6.0]
rosen_clim = (-4.0, 5.0)
# rosen_clim = (0.0, 10.0)

hblau_lower = [-5.0, -6.0]
hblau_upper = [6.0, 6.0]
hblau_clim = (-5.0, 3.0)
# hblau_clim = (0.0, 10.0)

n_x = 80
n_y = 30

rosen_package = [rosenbrock, "simple1", 20, rosen_lower, rosen_upper, rosen_clim, "Rosenbrock", "rosen"]
hblau_package = [himmelblau, "simple2", 40, hblau_lower, hblau_upper, hblau_clim, "Himmelblau", "hblau"]

# (rosen_package, hblau_package)
fractal_out_check = nothing
x_range_check = nothing
y_range_check = nothing

for (f, prob, n, lowercorner, uppercorner, f_clim, fname, savename) in (rosen_package, hblau_package)

    x_range = range(lowercorner[1], uppercorner[1], length=n_x)
    y_range = range(lowercorner[2], uppercorner[2], length=n_y)

    optimizer(x0) = optimize_with_history(f, nothing, x0, n, prob)
    println("Finished Initialization")
    # [3, 2]
    # [-2.805, 3.131]
    # [-3.779, -3.283]
    # [3.584, -1.848]
    fractal_out = generate_fractal(optimizer, x_range, y_range) #, s_ref = [-2.805, 3.131])
    println("Finished Fractal Generation")

    plt_fractal = plot_fractal(log10.(fractal_out), x_range, y_range, f_clim=f_clim)
    # plt_fractal = plot_fractal(fractal_out, x_range, y_range, f_clim=f_clim)
    title!("Nelder-Mead " * fname * " Fractal (Log10 of Optimal)")
    println("Finished Plot Generation")
    display(plt_fractal)
    println("Finished Plot Display")
    savefig(plt_fractal, "plots/" * savename * "_fractal_" * string(n_x) * "_" * string(n_y) * ".png")

end

