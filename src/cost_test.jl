function has_consistent_cost(pomdp::Union{CMDP, CPOMDP})
    consistent = true
    for s ∈ states(pomdp)
        for a ∈ actions(pomdp)
            c = cost(pomdp, s, a)
            if any(c .< 0.0)
                @warn("""
                Negative Cost
                    s = $s
                    a = $a
                    c = $c
                """)
                consistent = false
            end
        end
    end
    return consistent
end
