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
using Statistics

#=
    If you're going to include files, please do so up here. Note that they
    must be saved in project1_jl and you must use the relative path
    (not the absolute path) of the file in the include statement.

    [Good]  include("somefile.jl")
    [Bad]   include("/pathto/project1_jl/somefile.jl")
=#

# Example
# include("myfile.jl")
include("algorithms/direct_algo.jl")

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
    
    S_best, _ = optimize_with_history(f, g, x0, n, prob)

    return S_best
end


function optimize_with_history(f, g, x0, n, prob)
    # S = initialize_random_nelder_mead(x0, 1)
    if prob == "simple1"
        init_scaling = 0.9
    elseif prob == "simple2"
        init_scaling = 0.75
    elseif prob == "simple3"
        init_scaling = 1
    else
        init_scaling = 1
    end

    S = initialize_han_nelder_mead(x0, init_scaling)

    n_dims = length(x0)

    # Han Nelder Mead parameters
    αHan = 1.0
    βHan = 1.0 + (2 / n_dims)
    γHan = 0.75 - (1 / (2 * n_dims))
    
    S_best, tape = nelder_mead(f, S, n_budget=n, α=αHan, β=βHan, γ=γHan)

    if count(f) > n
        tape_print(tape)
    end

    return S_best, tape
end
