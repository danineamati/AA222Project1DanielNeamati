include("../algorithms/tape.jl")

tape = initialize_Tape()
println(tape)

f(x, y) = sin(x) + exp(y)
get_xy() = (randn(), randn())

for _ in range(1, 10)
    xi, yi = get_xy()
    record_x_only!(tape, [xi, yi], "rand X (1/2)")

    xi, yi = get_xy()
    record_x_only!(tape, [xi, yi], "rand X (2/2)")

    fi = f(xi, yi)
    record_history!(tape, [xi, yi], fi, "Evaluate f")
end

tape_print(tape)
