include("../algorithms/direct_algo.jl")

include("../helpers.jl")
include("../simple.jl")


function test_nm_simplex(f, f_init)
    s1 = f_init() * 3
    s2 = f_init() * 3
    s3 = f_init() * 3

    S = [s1, s2, s3]

    S_best, tape = nelder_mead(f, S, n_budget=20)
    f_best = f(S_best)

    return S_best, f_best, tape
end

# Try for rosenbrock
S_rosen, f_rosen, tape_rosen = test_nm_simplex(rosenbrock, rosenbrock_init)
println("Optimized Rosenbrock  to f=$f_rosen at S=$S_rosen")

tape_print(tape_rosen)

# Try for himmelblau
S_hblau, f_hblau, tape_hblau = test_nm_simplex(himmelblau, himmelblau_init)
println("Optimized Himmelblau  to f=$f_hblau at S=$S_hblau")

tape_print(tape_hblau)

# Try for powell
S_powell, f_powell, tape_powell = test_nm_simplex(powell, powell_init)
println("Optimized Powell      to f=$f_powell at S=$S_powell")

tape_print(tape_powell)

