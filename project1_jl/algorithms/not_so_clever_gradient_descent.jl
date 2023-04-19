
# I thought I was clever with a heuristic line search. I was actually not so clever :(
# if prob == "simple1"
#     lr = 3 * 10^-3
#     rand_factor = 100
#     max_movement_len = 100 / lr
# elseif prob == "simple2"
#     lr = 10^-2
#     rand_factor = 5
#     max_movement_len = 10 / lr
# elseif prob == "simple3"
#     lr = 10^-3
#     rand_factor = 0.1
#     max_movement_len = 10 / lr
# elseif prob == "secret1"
#     lr = 3 * 10^-4
#     rand_factor = 1
#     max_movement_len = 100 / lr
# else
#     lr = 10^-2
#     rand_factor = 30
#     max_movement_len = 90 / lr
# end
#
# optimize_gradient_descent(f, g, x0, n, lr, rand_factor, max_movement_len)

function optimize_gradient_descent(f, g, x0, n, learning_rate = 10^-2, rand_factor = 1, max_movement_len = 10, verbose::Bool = false)
    if verbose 
        println("    START")
        println("Counter Check: #f=$(count(f)) & #g=$(count(g))")
    end
    
    x_curr = x0
    f_curr = f(x_curr)
    n = n - 1

    # Dimensionality
    n_dim = length(x0)

    x_tried = [x_curr]
    f_tried = [f_curr]
    g_tried = []

    iteration_ind = 1

    if n >= 30
        spare = 4
    else
        spare = 2
    end
    
    while n > 4 + spare
        # We need 4 evaluations per loop
        if verbose println("Counter Check: #f=$(count(f)) & #g=$(count(g))") end

        # Calculate the Gradient and append it
        d_gradient = g(x_curr)
        d_len = norm(d_gradient)
        push!(g_tried, d_gradient)
        n = n - 2 # Gradients cost 2

        # Calculate the next position based on the learning rate
        # max_movement_len acts as a trust region of sorts
        if learning_rate * d_len > max_movement_len
            x_new = x_curr - max_movement_len * d_gradient / d_len
            if verbose println("Too Large") end
        else
            x_new = x_curr - learning_rate * d_gradient
        end
        f_new = f(x_new)
        n = n - 1 # Function costs 1

        push!(x_tried, x_new)
        push!(f_tried, f_new)
        
        if verbose println("Iteration $iteration_ind part 1: $x_new with $f_new") end

        # Possible options are:
        # f_new < f_curr: optimal is somewhere closer to f_new
        #     ratio > 1 so we should go further
        # f_curr < f_new: optimal is somewhere closer to f_best
        #     ratio < 1 so we should stay closer
        f_ratio = f_curr / f_new

        if learning_rate * d_len > max_movement_len
            x_new_2 = x_curr - f_ratio * max_movement_len * d_gradient / d_len
            if verbose println("Too Large") end
        else
            x_new_2 = x_curr - learning_rate * d_gradient * f_ratio
        end

        x_new_2 = x_curr - learning_rate * d_gradient * f_ratio
        f_new_2 = f(x_new_2)
        n = n - 1 # Function costs 1

        push!(x_tried, x_new_2)
        push!(f_tried, f_new_2)

        # Chose the one with lower value
        if f_new < f_new_2
            x_curr = x_new + rand_factor * learning_rate * rand(n_dim)
        else
            x_curr = x_new_2 + rand_factor * learning_rate * rand(n_dim)
        end

        if verbose println("Iteration $iteration_ind part 2: $x_new_2 with $f_new_2 (ratio was $f_ratio)") end
        iteration_ind += 1
    end

    while n > 0
        # Select the point that gave the best f_tried
        # best_ind = argmin(f_tried)
        # x_best = x_tried[best_ind]
        # f_best = f_tried[best_ind]

        ind_f_tried = hcat(f_tried, 1:length(f_tried))
        ind_f_sorted = sortslices(ind_f_tried, dims = 1)

        # Select the best n points
        n_best = 3
        ind_sorted_n_best = Int.(ind_f_sorted[1:n_best, 2])
        f_sorted_n_best = ind_f_sorted[1:n_best, 1]
        xf_sorted_n_best = x_tried[ind_sorted_n_best, :]

        # Take the weighted average
        f_scores = maximum(f_sorted_n_best) ./ f_sorted_n_best
        weights = f_scores ./ sum(f_scores)
        x_curr = sum(weights .* xf_sorted_n_best)

        # Evaluate the new point
        f_curr = f(x_curr)
        n = n - 1

        push!(x_tried, x_curr)
        push!(f_tried, f_curr)
    end

    if verbose println("Selected $x_best with score $f_best") end
    if verbose println("$n evaluations left") end

    if verbose println("Counter Check: #f=$(count(f)) & #g=$(count(g))") end

    return x_curr
end