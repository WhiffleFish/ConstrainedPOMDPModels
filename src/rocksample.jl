struct RockSampleCPOMDP{K,V<:AbstractVector} <: CPOMDP{RSState{K},Int,Int}
    m::RockSamplePOMDP{K}
    constraints::V
end

@POMDP_forward RockSampleCPOMDP.m

RockSampleCPOMDP(ĉ=[0.5]; kwargs...) = RockSampleCPOMDP(RockSamplePOMDP(;kwargs...),ĉ)

ConstrainedPOMDPs.constraints(p::RockSampleCPOMDP) = p.constraints

function ConstrainedPOMDPs.costs(p::RockSampleCPOMDP, s, a)
    pomdp = p.m
    c = 0.0
    if a > RockSample.N_BASIC_ACTIONS # using sensor
        c += 1.0
    elseif a == RockSample.BASIC_ACTIONS_DICT[:sample] && in(s.pos, pomdp.rocks_positions) # sample 
        rock_ind = findfirst(isequal(s.pos), pomdp.rocks_positions) # slow ?
        !s.rocks[rock_ind] && (c += 1.0) # bad rock sampled
    end
    return c
end
