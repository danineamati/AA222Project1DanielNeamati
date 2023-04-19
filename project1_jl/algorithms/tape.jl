#= 
    tape

    `tape` is a struct which will record the optimization run in an object oriented fashion
=#

mutable struct Tape
    xHistory # The history of states
    fHistory # The history of function evaluations
    textHistory # The history of evaluation types
    hyperparams # The hyperparameters used in this run
end

function initialize_Tape()
    return Tape([], [], [], nothing)
end

function record_params!(tape::Tape, params)
    tape.hyperparams = params
end

function record_x_state!(tape::Tape, x)
    push!(tape.xHistory, x)
end

function get_x_index!(tape::Tape)
    return length(tape.xHistory)
end

function record_f_history!(tape::Tape, f_eval)
    x_index = get_x_index(tape)
    push!(tape.fHistory, (x_index, f_eval))
end

function record_text!(tape::Tape, text)
    push!(tape.textHistory, text)
end

function print_tape(tape::Tape)
    println("Printing Tape:")
    println("Hyperparameters: $(tape.hyperparams)\n")
    println("X History: $(tape.xHistory)\n")
    println("f History: $(tape.fHistory)\n")
    println("text History: $(tape.textHistory)")
end

