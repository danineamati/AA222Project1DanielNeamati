# We plot the optimization trajectory and convergence plots

include("../helpers.jl")
include("../simple.jl")
include("../plotting_analysis/convergence_plots.jl")
include("../project1.jl")

function run_record_many(f, f_init, n, n_runs, prob)
    stack_of_tapes = Vector{Tape}()

    for _ in 1:n_runs
        # Initialize
        empty!(COUNTERS) # fresh eval-count each time
        x0 = f_init()

        _, tape = optimize_with_history(f, nothing, x0, n, prob)

        push!(stack_of_tapes, tape)
    end

    # Now generate plot
    plt = plot_convergence(stack_of_tapes)
    return plt
end

# Test the optimization and tape
println("Running test optimization")
_, tapeTest = optimize_with_history(rosenbrock, nothing, rosenbrock_init(), 20, "simple1")
tape_print(tapeTest)

_, tapeTest = optimize_with_history(powell, nothing, powell_init(), 20, "simple1")
tape_print(tapeTest)

# Rosenbrock
plt_rosen = run_record_many(rosenbrock, rosenbrock_init, 20, 1000, "simple1")
title!("Rosenbrock Convergence")
display(plt_rosen)
savefig(plt_rosen, "plots/converge_rosen.png")

# Himmelblau
plt_hblau = run_record_many(himmelblau, himmelblau_init, 40, 1000, "simple2")
title!("Himmelblau Convergence")
display(plt_hblau)
savefig(plt_hblau, "plots/converge_hblau.png")

# Powell
plt_powell = run_record_many(powell, powell_init, 100, 1000, "simple3")
title!("Powell Convergence")
display(plt_powell)
savefig(plt_powell, "plots/converge_powell.png")
