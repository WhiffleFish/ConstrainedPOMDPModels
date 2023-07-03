#Building on https://github.com/JuliaPOMDP/POMDPModels.jl/blob/master/src/MiniHallway.jl
#Similar to MiniHallway in https://jair.org/index.php/jair/article/view/11216/26427

struct MiniHallCPOMDP{V<:AbstractVector} <: CPOMDP{Int,Int,Int}
    m::MiniHallway
    constraints::V
end

POMDPs.actions(p::MiniHallway) = 1:4
POMDPs.actionindex(p::MiniHallway, a::Int)::Int = a

function POMDPs.transition(p::MiniHallway, ss::Int, a::Int)
    if a == 1 || ss == 13
        return p.T[ss]
    else
        if a == 2
            return ss % 4 == 0 ? Deterministic(ss - 3) : Deterministic(ss + 1)
        elseif a == 3
            return (ss - 1) % 4 == 0 ? Deterministic(ss + 3) : Deterministic(ss - 1)
        else 
            return Deterministic(ss)
        end
    end
end

POMDPs.reward(m::MiniHallway, ss::Int, a::Int, sp::Int) = float(ss != sp && sp == 13)*1000.0
POMDPs.discount(m::MiniHallway) = 0.95

@POMDP_forward MiniHallCPOMDP.m

MiniHallCPOMDP(ĉ=[1.0]; kwargs...) = MiniHallCPOMDP(MiniHallway(;kwargs...),ĉ)

ConstrainedPOMDPs.constraints(p::MiniHallCPOMDP) = p.constraints

function ConstrainedPOMDPs.costs(p::MiniHallCPOMDP, s, a)
    if a < 4
        c = 1.0
    else
        c = 0.0
    end
    return c
end