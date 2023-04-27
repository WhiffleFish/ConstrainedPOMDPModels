#=
Trivial constrained MDP/POMDP to demonstrate necessity of stochastic policies
=#

Base.@kwdef struct TrivialMDP <: MDP{Int, Symbol}
    discount::Float64 = 0.95
end

POMDPs.discount(m::TrivialMDP)          = m.discount
POMDPs.states(::TrivialMDP)             = (1,2)
POMDPs.actions(::TrivialMDP)            = (:left, :right)
POMDPs.isterminal(::TrivialMDP, s)      = s === 2
POMDPs.reward(::TrivialMDP, s, a)       = a === :right ? 1.0 : 0.0
POMDPs.transition(::TrivialMDP, s, a)   = Deterministic(2)
POMDPs.initialstate(::TrivialMDP)       = Deterministic(1)
POMDPs.stateindex(::TrivialMDP, s)      = s
POMDPs.actionindex(::TrivialMDP, a)     = a === :left ? 1 : 2

TrivialCMDP(ĉ=[0.5];kwargs...) = Constrain(TrivialMDP(;kwargs...), ĉ)
TrivialCPOMDP(ĉ=[0.5];kwargs...) = Constrain(FullyObservablePOMDP(TrivialMDP(;kwargs...)), ĉ)

const TrivialCMDP_type = typeof(TrivialCMDP([0.]))
const TrivialCPOMDP_type = typeof(TrivialCPOMDP([0.]))

# TODO: Remove once https://github.com/JuliaPOMDP/POMDPs.jl/issues/480 is merged and registered
POMDPs.obsindex(p::FullyObservablePOMDP, o) = stateindex(p,o)

ConstrainedPOMDPs.cost(::TrivialCMDP_type, s, a) = a === :right ? 1.0 : 0.0
ConstrainedPOMDPs.cost(::TrivialCPOMDP_type, s, a) = a === :right ? 1.0 : 0.0



## from https://cs.uwaterloo.ca/~ppoupart/publications/constrained-pomdps/constrained-pomdps.pdf


Base.@kwdef struct ToyPOMDP <: POMDP{Int,Int,Int}
    discount::Float64 = 0.95
end

POMDPs.discount(m::ToyPOMDP)          = m.discount
POMDPs.states(::ToyPOMDP)             = (1,2,3)
POMDPs.actions(::ToyPOMDP)            = (1, 2)
POMDPs.isterminal(::ToyPOMDP, s)      = s === 3
POMDPs.reward(::ToyPOMDP, s, a)       = (s === 2 && a === 2) ? 1.0 : 0.0
POMDPs.initialstate(::ToyPOMDP)       = Deterministic(2) # TODO: check if this is right?
POMDPs.stateindex(::ToyPOMDP, s)      = s
POMDPs.actionindex(::ToyPOMDP, a)     = a
POMDPs.obsindex(::ToyPOMDP, o)        = o
POMDPs.observations(::ToyPOMDP)       = (1,)

function POMDPs.transition(::ToyPOMDP, s, a)
    return if s === 1
        if a === 1
            Deterministic(1)
        else
            Deterministic(3)
        end
    elseif s === 2
        if a === 1
            SparseCat(SA[1,2], SA[0.1, 0.9])
        else
            Deterministic(3)
        end
    else
        Deterministic(3)
    end
end

POMDPs.observation(::ToyPOMDP, a, sp) = Deterministic(1) # FIXME: really??

ToyCPOMDP(ĉ=[0.95];kwargs...) = Constrain(ToyPOMDP(;kwargs...), ĉ)

const ToyCPOMDP_type = typeof(ToyCPOMDP([0.]))

function ConstrainedPOMDPs.cost(::ToyCPOMDP_type, s, a)
    return ((s === 1 || s === 2) && a === 2) ? 1.0 : 0.0
end
