# Try to optimize the scaling parameter for the simple cases

include("../helpers.jl")
include("../simple.jl")
include("../algorithms/direct_algo.jl")

using Plots

function run_many_at_scaling(f, f_init, n, n_runs, init_scaling)
    f_results = Vector{Float64}()
    
    for _ in 1:n_runs
        # Initialize
        empty!(COUNTERS) # fresh eval-count each time
        x0 = f_init()

        S = initialize_han_nelder_mead(x0, init_scaling)

        n_dims = length(x0)

        # Han Nelder Mead parameters
        αHan = 1.0
        βHan = 1.0 + (2 / n_dims)
        γHan = 0.75 - (1 / (2 * n_dims))
        
        S_best, _ = nelder_mead(f, S, n_budget=n, α=αHan, β=βHan, γ=γHan)

        empty!(COUNTERS)
        f_best = f(S_best)
        empty!(COUNTERS)
        push!(f_results, f_best)
    end

    return f_results
end


rosen_package = (rosenbrock, rosenbrock_init, 20, "Rosenbrock", "rosen")
hblau_package = (himmelblau, himmelblau_init, 40, "Himmelblau", "hblau")
powell_package = (powell, powell_init, 100, "Powell", "powell")

n_runs = 1000
scaling_step = 0.025
scaling_vals = 0.1:scaling_step:2
num_scaling = length(scaling_vals)
best_threshold = 0.1

for (f, f_init, n, fname, savename) in [rosen_package, hblau_package, powell_package]

    f_arr_at_scaling = zeros(num_scaling, n_runs)

    for (sc_ind, scaling) in enumerate(scaling_vals)
        f_out = run_many_at_scaling(f, f_init, n, n_runs, scaling)
        f_arr_at_scaling[sc_ind, :] .= f_out
    end

    f_arr_at_scaling_log10 = log10.(f_arr_at_scaling)

    plt = plot(framestyle = :box, dpi=400)
    for (sc_ind, scaling) in enumerate(scaling_vals)
        sc_plot = scaling * ones(n_runs) + (scaling_step/10) * randn(n_runs)
        scatter!(sc_plot, f_arr_at_scaling_log10[sc_ind, :], legend=false, markersize=2, markeralpha=0.15)
    end

    mean_f_at_scaling_log10 = mean(f_arr_at_scaling_log10, dims=2)
    quant_25_f_at_scaling_log10 = [quantile(f_arr_at_scaling_log10[sc_ind, :], 0.25) for sc_ind in eachindex(scaling_vals)]
    quant_75_f_at_scaling_log10 = [quantile(f_arr_at_scaling_log10[sc_ind, :], 0.75) for sc_ind in eachindex(scaling_vals)]

    plot!(scaling_vals, mean_f_at_scaling_log10, color=:black, linewidth=3)
    plot!(scaling_vals, quant_25_f_at_scaling_log10, color=:black, linewidth=3, linestyle=:dash)
    plot!(scaling_vals, quant_75_f_at_scaling_log10, color=:black, linewidth=3, linestyle=:dash)

    
    best_ind = argmin(mean_f_at_scaling_log10)
    best_scaling = scaling_vals[best_ind]
    best_mean = mean_f_at_scaling_log10[best_ind]
    println("Best choice is $best_ind -> s = $best_scaling -> E[f] = $best_mean")
    better_scaling_ind = mean_f_at_scaling_log10 .< best_mean + best_threshold
    better_means = mean_f_at_scaling_log10[better_scaling_ind]

    better_scaling = Array(scaling_vals)[vec(better_scaling_ind)]

    scatter!(better_scaling, better_means, markersize=8, marker=:star5, color=:orange)
    scatter!([best_scaling], [best_mean], markersize=8, marker=:star5, color=:red)

    xlabel!("Scaling parameter")
    ylabel!("Log 10 of Optimal")
    title!(fname * " Perfomance across Scaling Parameter")
    display(plt)

    savefig(plt, "plots/scaling_" * savename * ".png")
end
