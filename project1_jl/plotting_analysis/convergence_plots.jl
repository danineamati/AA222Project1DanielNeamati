# We define useful functions for plotting convergence

using Plots

# Define Tape
include("../algorithms/tape.jl")

function fill_in_history(nHistory, fHistory)
    # We want the full history from 1 to n
    out_nHistory = 1:maximum(nHistory)
    # We initialize the function history to NaNs
    out_fHistory = fill!(zeros(size(out_nHistory)), NaN)

    # Update the f History where we know the values
    out_fHistory[nHistory] .= fHistory

    last_history_f = fHistory[end]

    # Iterate through from the back and update the history
    for hist_ind in reverse(out_nHistory)
        if isnan(out_fHistory[hist_ind])
            out_fHistory[hist_ind] = last_history_f
        else
            last_history_f = out_fHistory[hist_ind]
        end
    end

    return out_nHistory, out_fHistory
end


function plot_convergence(stack_of_tapes::Vector{Tape}; nx_labels=5)
    plt = plot(framestyle = :box)

    # Calculate the mean trajectory
    last_n_vals = [t.nHistory[end] for t in stack_of_tapes]
    max_steps = maximum(last_n_vals)
    min_steps = minimum(last_n_vals)
    mean_vec = zeros(min_steps)

    println("Max n = $max_steps. Min n = $min_steps")

    num_tapes = length(stack_of_tapes)

    for tape in stack_of_tapes
        fHist = minimum.(tape.fHistory)
        nHist = tape.nHistory

        full_nHist, full_fHist = fill_in_history(nHist, fHist)

        plot!(plt, full_nHist, full_fHist, linealpha=0.1, linewidth=2,
            color=:plum4, yaxis=:log, legend=false)

        # Contribute to the mean
        mean_contribute = (1/num_tapes) * full_fHist[1:min_steps]
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
    x_integer_spacing = floor(max_steps / nx_labels)
    x_ticks_new = 0:x_integer_spacing:max_steps

    edge_padding = max_steps * 5e-3

    xlims!(1 - edge_padding, x_ticks_new[end]+ edge_padding)
    xticks!(x_ticks_new)

    # Plot the mean
    plot!(plt, 1:min_steps, mean_vec, color=:black, linewidth=3)

    # Plot vertical line to illustrate the initialization cost
    n_dims = get_n_dims(stack_of_tapes[1])
    vline!([n_dims + 1], color=:black, linestyle=:dash)

    xlabel!("Number of Function Evaluations")
    ylabel!("Cost Value")

    return plt
end



# function plot_convergence_each_step(stack_of_tapes::Vector{Tape}; nx_labels=6)
#     plt = plot(framestyle = :box)

#     # Calculate the mean trajectory
#     min_steps = minimum([length(t.fHistory) for t in stack_of_tapes])
#     mean_vec = zeros(min_steps)

#     num_tapes = length(stack_of_tapes)

#     for tape in stack_of_tapes
#         fHist = minimum.(tape.fHistory)
#         plot!(plt, eachindex(fHist), fHist, linealpha=0.1, linewidth=2,
#             color=:plum4, yaxis=:log, legend=false)

#         # Contribute to the mean
#         mean_contribute = (1/num_tapes) * fHist[1:min_steps]
#         mean_vec = mean_vec .+ mean_contribute
#     end

#     # Fix the y ticks so that they make sense (goes by ten every ten)
#     ylim_curr = ylims()
#     ylim_min = floor(log10(ylim_curr[1]))
#     ylim_max = ceil(log10(ylim_curr[2]))

#     ylims!(10^ylim_min, 10^ylim_max)
#     yticks!(10 .^(ylim_min:ylim_max))

#     # Fix the x ticks so that they are integers
#     # Put 6 labels
#     xlim_curr = xlims()
#     x_integer_spacing = ceil(xlim_curr[2] / nx_labels)
#     x_max_new = x_integer_spacing * nx_labels
#     x_ticks_new = 1:x_integer_spacing:x_max_new

#     println("Started with $xlim_curr -> spacing = $x_integer_spacing -> max = $x_max_new")
#     xlims!(1 - 0.2, x_ticks_new[end]+ 0.2)
#     xticks!(x_ticks_new)

#     # Plot the mean
#     plot!(plt, 1:min_steps, mean_vec, color=:black, linewidth=3)
#     xlabel!("Step Number")
#     ylabel!("Cost Value")

#     return plt
# end

