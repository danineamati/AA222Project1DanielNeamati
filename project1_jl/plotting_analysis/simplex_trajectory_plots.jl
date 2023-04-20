# Functions for plotting the Nelder Mead Simplex


function plot_single_trajectory(tape::Tape, x0, S_best; cgrad_vals=[:plum1, :purple])
    hist_length = get_history_length!(tape::Tape)
    color_vals = cgrad(cgrad_vals, 0:(1/hist_length):1)

    # Plot the initial point
    scatter!([x0[1]], [x0[2]], markershape=:star5, color=:black, legend=false)

    for (ind, simplex) in enumerate(tape.xHistory)
        color_simplex = color_vals[ind]

        simplex_x = [s[1] for s in simplex]
        simplex_y = [s[2] for s in simplex]

        simplex_x_closed = append!(simplex_x, simplex_x[1])
        simplex_y_closed = append!(simplex_y, simplex_y[1])
        plot!(simplex_x_closed, simplex_y_closed, color=color_simplex)
        scatter!(simplex_x, simplex_y, legend=false, color=color_simplex)        
    end

    # Plot the final point
    scatter!([S_best[1]], [S_best[2]], markershape=:star5, color=:red, legend=false)
end
