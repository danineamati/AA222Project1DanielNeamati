# We plot the optimization trajectory and convergence plots

include("../helpers.jl")
include("../simple.jl")
include("../algorithms/tape.jl")
include("../plotting_analysis/convergence_plots.jl")
include("../algorithms/direct_algo.jl")

function run_record_many(f, f_init, n, n_runs)
    stack_of_tapes = Vector{Tape}()

    for _ in 1:n_runs
        # Initialize
        empty!(COUNTERS) # fresh eval-count each time
        x0 = f_init()
        # S = initialize_random_nelder_mead(x0, 1)
        S = initialize_han_nelder_mead(x0, 1)

        _, tape = nelder_mead(f, S, n_budget=n)

        push!(stack_of_tapes, tape)
    end

    # Now generate plot
    plt = plot_convergence(stack_of_tapes)
    return plt
end



# Rosenbrock
plt_rosen = run_record_many(rosenbrock, rosenbrock_init, 20, 1000)
title!("Rosenbrock Convergence")
display(plt_rosen)
savefig(plt_rosen, "plots/converge_rosen.png")

# Himmelblau
plt_hblau = run_record_many(himmelblau, himmelblau_init, 40, 1000)
title!("Himmelblau Convergence")
display(plt_hblau)
savefig(plt_hblau, "plots/converge_hblau.png")

# Powell
plt_powell = run_record_many(powell, powell_init, 100, 1000)
title!("Powell Convergence")
display(plt_powell)
savefig(plt_powell, "plots/converge_powell.png")
