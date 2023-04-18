# Here we will use the previous functions to plot the relevant contours
# NO Optimization computation

include("../function_plots.jl")

## ROSENBROCK
rosen_lower = [-4, -2]
rosen_upper = [4, 6]

c_rosen_base = plot_rosenbrock_contours(false)
display(c_rosen_base)
savefig(c_rosen_base, "plots/c_rosen_base.png")

c_rosen_log10 = plot_rosenbrock_contours(true)
display(c_rosen_log10)
savefig(c_rosen_log10, "plots/c_rosen_log10.png")

## HIMMELBLAU

hblau_lower = [-5, -6]
hblau_upper = [6, 6]

c_hblau_base = plot_himmelblau_contours(false)
display(c_hblau_base)
savefig(c_hblau_base, "plots/c_hblau_base.png")


c_hblau_log10 = plot_himmelblau_contours(true)
display(c_hblau_log10)
savefig(c_hblau_log10, "plots/c_hblau_log10.png")
