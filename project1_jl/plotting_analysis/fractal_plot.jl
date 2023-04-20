# Plot fractals

using Plots
using LaTeXStrings

function generate_fractal(optimizer, xrange, yrange)
    x_num = length(xrange)
    y_num = length(yrange)

    fractal_out = zeros(x_num, y_num)

    for (y_ind, y) in enumerate(yrange)
        for (x_ind, x) in enumerate(xrange)
            empty!(COUNTERS) # fresh eval-count each time
            _, tape = optimizer([x, y])
            opt_val = minimum(tape.fHistory[end])
            fractal_out[x_ind, y_ind] = opt_val
        end
    end

    return fractal_out
end


function plot_fractal(fractal, xrange, yrange)
    return heatmap(xrange, yrange, fractal,
        xlabel=L"x", ylabel=L"y", dpi=500, 
        framestyle = :box, grid=true)
end
