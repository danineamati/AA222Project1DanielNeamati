# Plot Nelder Mead Simplex trajectories on the contours

include("../helpers.jl")
include("../simple.jl")
include("../project1.jl")
include("../plotting_analysis/function_plots.jl")
include("../plotting_analysis/simplex_trajectory_plots.jl")

rosen_package = (rosenbrock, "Rosenbrock", "rosen")
hblau_package = (himmelblau, "Himmelblau", "hblau")

for (f, fname, savename) in [rosen_package, hblau_package]

    for show_log10 in [false, true]
        # Plot the contours
        if savename == "rosen"
            plt = plot_rosenbrock_contours(show_log10)
            x0vals = [[-3, -1], [3, 3], [-3, 4]]
        elseif savename == "hblau"
            plt = plot_himmelblau_contours(show_log10)
            x0vals = [[-2, -1.4], [-0.2, -1], [-0.1, 5]]
        end

        # [[-3, -1], [3, 3], [-3, 4]]
        # [[-2.01, -1.4], [-1.99, -1.4], [3, 3], [-3, 4]]
        
        cgrad_vals_each = [[:plum1, :purple], [:lightblue, :royalblue4], [:rosybrown1, :rosybrown4]] #, [:coral1, :coral4]]

        for (x0, cgrad_choice) in zip(x0vals, cgrad_vals_each)
            empty!(COUNTERS) # fresh eval-count each time
            S_best, tape_from_x0 = optimize_with_history(f, nothing, x0, 20, "simple1")

            # Add the simplex
            plot_single_trajectory(tape_from_x0, x0, S_best, cgrad_vals=cgrad_choice)
        end

        if show_log10
            title_text = "Log10 of "
            save_text = "log10"
        else
            title_text = " "
            save_text = "base"
        end

        title!("Trajectories on " * title_text * fname * " Contours")

        display(plt)
        savefig(plt, "plots/trajectories_" * savename * "_" * save_text * ".png")
    end

end
