# Plot fractals

using Plots
using LaTeXStrings
using LinearAlgebra

function generate_fractal(optimizer, xrange, yrange; s_ref=nothing)
    x_num = length(xrange)
    y_num = length(yrange)

    fractal_out = zeros(y_num, x_num)

    for (x_ind, x) in enumerate(xrange)
        for (y_ind, y) in enumerate(yrange)
            empty!(COUNTERS) # fresh eval-count each time
            x0 = float([x, y])
            S_best, tape = optimizer(x0)

            if isnothing(s_ref)
                opt_val = minimum(tape.fHistory[end])
            else
                opt_val = norm(S_best - s_ref)
            end

            fractal_out[y_ind, x_ind] = opt_val
        end
    end

    return fractal_out
end


function plot_fractal(fractal, xrange, yrange; f_clim=nothing)
    if isnothing(f_clim)
        return heatmap(xrange, yrange, fractal,
            xlabel=L"x", ylabel=L"y", dpi=500, 
            framestyle = :box, grid=true)
    end
    heatmap(xrange, yrange, fractal,
            xlabel=L"x", ylabel=L"y", 
            dpi=500, 
            framestyle = :box, grid=true,
            clim=f_clim)
end
