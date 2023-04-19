include("tape.jl")

tape = initialize_Tape()
println(tape)

f(x, y) = sin(x) + exp(y)
get_xy() = (randn(), randn())

for _ in range(1, 10)
    xi, yi = get_xy()
    record_x_state!(tape, [xi, yi])
    record_text!(tape, "Sample X")

    xi, yi = get_xy()
    record_x_state!(tape, [xi, yi])
    record_text!(tape, "Sample X")

    fi = f(xi, yi)
    record_f_history!(tape, fi)
    record_text!(tape, "Evaluate f")
end

print_tape(tape)
