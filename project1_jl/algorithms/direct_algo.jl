include("tape.jl")

# Initialize Nelder Mead
function initialize_random_nelder_mead(x0, scaling)
    S = [x0]
    n_dims = length(x0)
    for _ in 1:n_dims
        push!(S, x0 + scaling * randn(n_dims))
    end

    return S
end


function initialize_han_nelder_mead(x0, scaling)
    S = []
    n_dims = length(x0)

    for dim_ind in 1:n_dims
        x_new = float(copy(x0))
        x_new[dim_ind] += scaling
        push!(S, x_new)
    end

    dimlast_factor = (1 - sqrt(n_dims + 1)) / n_dims
    xlast = x0 + dimlast_factor * scaling * ones(n_dims)
    push!(S, xlast)
    return S
end

initialize_han_nelder_mead([3, 4], 0.5)

#= 
    Nelder Mead Simplex algorithm
=#
function nelder_mead(f, S; n_budget=Inf, α=1.0, β=2.0, γ=0.5)
    # Initialize the tape
    tape = initialize_Tape()
    record_params!(tape, [α, β, γ])

    # Use the count function. Relative to start count (i.e., 0)
    start_count = count(f)
    set_budget!(tape, start_count + n_budget)

    # Initialize the cost values
    y_arr = f.(S)
    # COST: NUM_DIMS = length(S)

    # Record the initial point
    record_history!(tape, S, y_arr, "Init Simplex ($(count(f)))")

    # While we have not used up our budget
    # We will need a max of 3 counts per iteration
    while has_enough_for_f_eval(tape, count(f))

        p = sortperm(y_arr) # sort lowest to highest
        S, y_arr = S[p], y_arr[p]
        xl, yl = S[1], y_arr[1] # lowest
        xh, yh = S[end], y_arr[end] # highest
        _, ys = S[end-1], y_arr[end-1] # second-highest
        xm = mean(S[1:end-1]) # centroid
        xr = xm + α * (xm - xh) # reflection point

        yr = f(xr)
        # COST: 1

        if (yr < yl) && (has_enough_for_f_eval(tape, count(f)))
            # MAX COST = 1

            xe = xm + β * (xr - xm) # expansion point
            ye = f(xe)
            # COST: 1

            S[end], y_arr[end] = ye < yr ? (xe, ye) : (xr, yr)

            # Record the new state and evaluations
            record_history!(tape, S, y_arr, "Expanded ($(count(f)))")

        elseif (yr ≥ ys) && (has_enough_for_f_eval(tape, count(f)))
            # MAX COST = 2

            if yr < yh
                xh, yh, S[end], y_arr[end] = xr, yr, xr, yr
            end
            xc = xm + γ * (xh - xm) # contraction point
            yc = f(xc)
            # COST: 1

            if yc > yh
                for i in eachindex(y_arr)
                    if i != 1
                        # Skip first since it is fine
                        
                        S[i] = (S[i] + xl) / 2

                        if has_enough_for_f_eval(tape, count(f))
                            y_arr[i] = f(S[i])
                            # COST: 1
                        end
                    end
                end
            else
                S[end], y_arr[end] = xc, yc
            end

            # Record the new state and evaluations
            record_history!(tape, S, y_arr, "Contraction ($(count(f)))")
        else
            S[end], y_arr[end] = xr, yr

            # Record the new state and evaluations
            record_history!(tape, S, y_arr, "Reflection ($(count(f)))")
        end
        # Δ = std(y_arr, corrected=false)
    end
    return S[argmin(y_arr)], tape
end