#Building on https://github.com/JuliaPOMDP/POMDPModels.jl/blob/master/src/MiniHallway.jl
#Similar to MiniHallway in https://jair.org/index.php/jair/article/view/11216/26427
struct ModMiniHall <: POMDP{Int, Int, Int}
    m::MiniHallway
end

ModMiniHall() = ModMiniHall(MiniHallway())

@POMDP_forward ModMiniHall.m

POMDPs.actions(p::ModMiniHall) = 1:4
POMDPs.actionindex(p::ModMiniHall, a::Int)::Int = a

function POMDPs.transition(p::ModMiniHall, ss::Int, a::Int)
    if a == 1 || ss == 13
        return p.m.T[ss]
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

POMDPs.reward(m::ModMiniHall, ss::Int, a::Int, sp::Int) = float(ss != sp && sp == 13)*1000.0
POMDPs.discount(m::ModMiniHall) = 0.95

##Constrained
struct MiniHallCPOMDP{V<:AbstractVector} <: CPOMDP{Int,Int,Int}
    m::ModMiniHall
    constraints::V
end

@POMDP_forward MiniHallCPOMDP.m

MiniHallCPOMDP(ĉ=[1.0]; kwargs...) = MiniHallCPOMDP(ModMiniHall(;kwargs...),ĉ)

ConstrainedPOMDPs.constraints(p::MiniHallCPOMDP) = p.constraints

function ConstrainedPOMDPs.costs(p::MiniHallCPOMDP, s, a)
    if a < 4
        c = 1.0
    else
        c = 0.0
    end
    return c
end