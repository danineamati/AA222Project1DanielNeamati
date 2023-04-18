#=
        function_plots.jl -- This is where we will plot contours

    This is only for function plotting and has no optimization alone
=#

# Use Plots.jl for plotting
using Plots
using LaTeXStrings

# Import the simple.jl file to have access to the main functions 
include("helpers.jl")
include("simple.jl")

function calc_contours(f, lowercorner::Vector, uppercorner::Vector, 
    n_x::Integer=100, n_y::Integer=80)

    # Convert corners to range
    x_range = range(lowercorner[1], uppercorner[1], length=n_x)
    y_range = range(lowercorner[2], uppercorner[2], length=n_y)

    # Preallocate the array with zeros
    z_vals_out = zeros(n_x, n_y)

    # Iterate with the right most axis first
    for (y_ind, y_val) in enumerate(y_range)
        for (x_ind, x_val) in enumerate(x_range)
            # Run the computation
            xy_vec = [x_val, y_val]
            z = f(xy_vec)

            # Save the value
            z_vals_out[x_ind, y_ind] = z
        end
    end

    return x_range, y_range, z_vals_out
end


# ROSENBROCK

rosen_lower = [-4, -2]
rosen_upper = [4, 6]

rosen_xs, rosen_ys, rosen_zs = calc_contours(rosenbrock, rosen_lower, rosen_upper, 600, 400)

c_rosen_base = contour(rosen_xs, rosen_ys, rosen_zs', 
    color=cgrad(:turbo, rev = true), clabels=true, 
    framestyle = :box, grid=true, 
    xlabel=L"x", ylabel=L"y", title="Rosenbrock Contours",
    dpi=400)
display(c_rosen_base)
savefig(c_rosen_base, "plots/c_rosen_base.png")

tv = -3:0.5:4
tl = [L"10^{%$i}" for i in tv]
rosen_zs_log10_clamped = clamp.(log10.(rosen_zs'), tv[1], tv[end]);

c_rosen_log10 = contour(rosen_xs, rosen_ys, rosen_zs_log10_clamped, 
    color=cgrad(:turbo, rev = true), clabels=true, 
    levels=length(tv)-2, colorbar_ticks=(tv, tl), 
    framestyle = :box, grid=true, gridalpha=0.5,
    xlabel=L"x", ylabel=L"y", title="Log10 of Rosenbrock Contours",
    dpi=400)
display(c_rosen_log10)
savefig(c_rosen_log10, "plots/c_rosen_log10.png")

## HIMMELBLAU

hblau_lower = [-5, -6]
hblau_upper = [6, 6]

hblau_xs, hblau_ys, hblau_zs = calc_contours(himmelblau, hblau_lower, hblau_upper, 600, 400)

c_hblau_base = contour(hblau_xs, hblau_ys, hblau_zs', 
    color=cgrad(:turbo, rev = true), clabels=true, 
    framestyle = :box, grid=true, 
    xlabel=L"x", ylabel=L"y", title="Himmelblau Contours",
    dpi=400)
display(c_hblau_base)
savefig(c_hblau_base, "plots/c_hblau_base.png")

tv = -2.5:0.5:3
tl = [L"10^{%$i}" for i in tv]
hblau_zs_log10_clamped = clamp.(log10.(hblau_zs'), tv[1], tv[end]);

c_hblau_log10 = contour(hblau_xs, hblau_ys, hblau_zs_log10_clamped, 
    color=cgrad(:turbo, rev = true), clabels=true, 
    levels=length(tv)-2, colorbar_ticks=(tv, tl), 
    framestyle = :box, grid=true, gridalpha=0.5,
    xlabel=L"x", ylabel=L"y", title="Log10 of Himmelblau Contours",
    dpi=400)
display(c_hblau_log10)
savefig(c_hblau_log10, "plots/c_hblau_log10.png")
