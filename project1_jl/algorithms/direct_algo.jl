
#= 
    Nelder Mead Simplex algorithm
=#
function nelder_mead(f, S, ϵ; α=1.0, β=2.0, γ=0.5)
    Δ, y_arr = Inf, f.(S)
    while Δ > ϵ
        p = sortperm(y_arr) # sort lowest to highest
        S, y_arr = S[p], y_arr[p]
        xl, yl = S[1], y_arr[1] # lowest
        xh, yh = S[end], y_arr[end] # highest
        xs, ys = S[end-1], y_arr[end-1] # second-highest
        xm = mean(S[1:end-1]) # centroid
        xr = xm + α * (xm - xh) # reflection point
        yr = f(xr)
        if yr < yl
            xe = xm + β * (xr - xm) # expansion point
            ye = f(xe)
            S[end], y_arr[end] = ye < yr ? (xe, ye) : (xr, yr)
        elseif yr ≥ ys
            if yr < yh
                xh, yh, S[end], y_arr[end] = xr, yr, xr, yr
            end
            xc = xm + γ * (xh - xm) # contraction point
            yc = f(xc)
            if yc > yh
                for i in 2:length(y_arr)
                    S[i] = (S[i] + xl) / 2
                    y_arr[i] = f(S[i])
                end
            else
                S[end], y_arr[end] = xc, yc
            end
        else
            S[end], y_arr[end] = xr, yr
        end
        Δ = std(y_arr, corrected=false)
    end
    return S[argmin(y_arr)]
end