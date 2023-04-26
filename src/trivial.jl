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
