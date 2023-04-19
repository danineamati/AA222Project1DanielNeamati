# We define useful functions for plotting convergence

using Plots

# Define Tape
include("../algorithms/tape.jl")

function plot_convergence(stack_of_tapes::Vector{Tape}; nx_labels=6)
    plt = plot(framestyle = :box)

    # Calculate the mean trajectory
    min_steps = minimum([length(t.fHistory) for t in stack_of_tapes])
    mean_vec = zeros(min_steps)

    num_tapes = length(stack_of_tapes)

    for tape in stack_of_tapes
        fHist = minimum.(tape.fHistory)
        plot!(plt, eachindex(fHist), fHist, linealpha=0.1, linewidth=2,
            color=:plum4, yaxis=:log, legend=false)

        # Contribute to the mean
        mean_contribute = (1/num_tapes) * fHist[1:min_steps]
        mean_vec = mean_vec .+ mean_contribute
    end

    # Fix the y ticks so that they make sense (goes by ten every ten)
    ylim_curr = ylims()
    ylim_min = floor(log10(ylim_curr[1]))
    ylim_max = ceil(log10(ylim_curr[2]))

    ylims!(10^ylim_min, 10^ylim_max)
    yticks!(10 .^(ylim_min:ylim_max))

    # Fix the x ticks so that they are integers
    # Put 6 labels
    xlim_curr = xlims()
    x_integer_spacing = ceil(xlim_curr[2] / nx_labels)
    x_max_new = x_integer_spacing * nx_labels
    x_ticks_new = 1:x_integer_spacing:x_max_new

    println("Started with $xlim_curr -> spacing = $x_integer_spacing -> max = $x_max_new")
    xlims!(1 - 0.2, x_ticks_new[end]+ 0.2)
    xticks!(x_ticks_new)

    # Plot the mean
    plot!(plt, 1:min_steps, mean_vec, color=:black, linewidth=3)
    xlabel!("Step Number")
    ylabel!("Cost Value")

    return plt
end

