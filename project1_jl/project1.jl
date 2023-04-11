#=
        project1.jl -- This is where the magic happens!

    All of your code must either live in this file, or be `include`d here.
=#

#=
    If you want to use packages, please do so up here.
    Note that you may use any packages in the julia standard library
    (i.e. ones that ship with the julia language) as well as Statistics
    (since we use it in the backend already anyway)
=#

# Example:
using LinearAlgebra

#=
    If you're going to include files, please do so up here. Note that they
    must be saved in project1_jl and you must use the relative path
    (not the absolute path) of the file in the include statement.

    [Good]  include("somefile.jl")
    [Bad]   include("/pathto/project1_jl/somefile.jl")
=#

# Example
# include("myfile.jl")


"""
    optimize(f, g, x0, n, prob)

Arguments:
    - `f`: Function to be optimized
    - `g`: Gradient function for `f`
    - `x0`: (Vector) Initial position to start from
    - `n`: (Int) Number of evaluations allowed. Remember `g` costs twice of `f`
    - `prob`: (String) Name of the problem. So you can use a different strategy for each problem. E.g. "simple1", "secret2", etc.

Returns:
    - The location of the minimum
"""
function optimize(f, g, x0, n, prob)
    optimize_extra(f, g, x0, n, prob)
end


function optimize_extra(f, g, x0, n, prob, verbose::Bool = false, learning_rate::float = 10^-2)
    x_curr = x0
    f_curr = f(x_curr)
    n = n - 1

    x_tried = [x_curr]
    f_tried = [f_curr]
    g_tried = []

    iteration_ind = 1
    
    while n > 4
        # We need 4 evaluations per loop

        # Calculate the Gradient and append it
        d_gradient = g(x_curr)
        push!(g_tried, d_gradient)
        n = n - 2 # Gradients cost 2

        # Calculate the next position based on the learning rate
        x_new = x_curr - learning_rate * d_gradient
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

        x_curr = x_curr - learning_rate * d_gradient * f_ratio
        f_curr = f(x_curr)
        n = n - 1 # Function costs 1

        push!(x_tried, x_curr)
        push!(f_tried, f_curr)

        if verbose println("Iteration $iteration_ind part 2: $x_curr with $f_curr (ratio was $f_ratio)") end
        iteration_ind += 1
    end

    # Select the point that gave the best f_tried
    best_ind = argmin(f_tried)
    x_best = x_tried[best_ind]
    f_best = f_tried[best_ind]

    if verbose println("Selected $x_best with score $f_best") end
    if verbose println("$n evaluations left") end

    return x_curr
end