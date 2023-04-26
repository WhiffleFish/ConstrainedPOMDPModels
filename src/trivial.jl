#=
Trivial constrained MDP/POMDP to demonstrate necessity of stochastic policies
=#

struct TrivialMDP <: MDP{Int, Symbol} end

POMDPs.states(::TrivialMDP)             = (1,2)
POMDPs.actions(::TrivialMDP)            = (:left, :right)
POMDPs.isterminal(::TrivialMDP, s)      = s === 2
POMDPs.reward(::TrivialMDP, s, a)       = a === :right ? 1.0 : 0.0
POMDPs.transition(::TrivialMDP, s, a)   = Deterministic(2)

TrivialCMDP(ĉ=[0.5]) = ConstrainedPOMDPs.Constrain(TrivialMDP(), ĉ)
TrivialCPOMDP(ĉ=[0.5]) = ConstrainedPOMDPs.Constrain(FullyObservablePOMDP(TrivialMDP()), ĉ)

const TrivialCMDP_type = typeof(TrivialCMDP([0.]))
const TrivialCPOMDP_type = typeof(TrivialCPOMDP([0.]))

ConstrainedPOMDPs.cost(::TrivialCMDP_type, s, a) = a === :right ? 1.0 : 0.0
ConstrainedPOMDPs.cost(::TrivialCPOMDP_type, s, a) = a === :right ? 1.0 : 0.0
