#= 
    tape

    `tape` is a struct which will record the optimization run in an object oriented fashion
=#

mutable struct Tape
    # The history arrays have the same length
    # When information is not available, we put NaN or 
    xHistory # The history of states
    fHistory # The history of function evaluations
    textHistory # The history of evaluation types
    hyperparams # The hyperparameters used in this run
    budget # The budget remaining
end

function initialize_Tape()
    return Tape([], [], [], nothing, Inf)
end

function record_params!(tape::Tape, params)
    tape.hyperparams = params
end

function set_budget!(tape::Tape, budget::Integer)
    tape.budget = budget
end

function has_enough(tape, counts, cost)
    if (tape.budget - counts) >= cost
        return true
    end
    return false
end

function has_enough_for_f_eval(tape, counts; f_cost=1)
    return has_enough(tape, counts, f_cost)
end

function has_enough_for_g_eval(tape, counts; g_cost=2)
    return has_enough(tape, counts, g_cost)
end

function check_valid_history(tape::Tape)
    if length(tape.xHistory) != length(tape.fHistory)
        return false
    elseif length(tape.xHistory) != length(tape.textHistory)
        return false
    end
    return true
end

function assert_valid_history(tape::Tape)
    if !check_valid_history(tape)
        xlen = length(tape.xHistory)
        flen = length(tape.fHistory)
        tlen = length(tape.textHistory)
        throw(DomainError(
            "History is not valid. " *
            "   xHistory has length = $xlen" *
            "   fHistory has length = $flen" * 
            "   textHistory has length = $tlen"))
    end
end

function get_history_length!(tape::Tape)
    assert_valid_history(tape)
    return length(tape.xHistory)
end

function record_history!(tape::Tape, x, f_eval, txt)
    push!(tape.xHistory, x)
    push!(tape.fHistory, f_eval)
    push!(tape.textHistory, txt)
end

function record_x_only!(tape::Tape, x, txt)
    record_history!(tape, x, NaN, txt)
end

# function record_f_history!(tape::Tape, f_eval)
#     push!(tape.fHistory, f_eval)
# end

# function record_text!(tape::Tape, text)
#     push!(tape.textHistory, text)
# end

function zip_history(tape::Tape)
    return zip(tape.xHistory, tape.fHistory, tape.textHistory)
end

function tape_print(tape::Tape; tlen=24, fdigits=5, restrict_tot_len=200)
    println("Printing Tape:")
    println("Hyperparameters: $(tape.hyperparams)\n")
    assert_valid_history(tape)
    for (ind, (x, f, t)) in enumerate(zip_history(tape))
        # Format the index
        ind_format = lpad(ind, 3, " ")

        # Format the text
        if length(t) >= tlen
            txt_format = t[1:tlen]
        else
            txt_format = lpad(t, tlen, " ")
        end


        f_format_len = fdigits*2 + 2    # +2 for decimal and sign
        if all(isfinite.(f))
            f_format = lpad(round.(f, digits=fdigits), f_format_len)
        else
            f_format = lpad(f, f_format_len, " ")
        end

        # Format the function evaluation
        row_text = "$ind_format | $txt_format | $f_format | $x"
        if length(row_text) > restrict_tot_len
            row_text = row_text[1:restrict_tot_len]
        end

        println(row_text)
    end
end

