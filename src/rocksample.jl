RockSampleCPOMDP(ĉ=[0.5]; kwargs...) = Constrain(
    RockSamplePOMDP(;kwargs...), ĉ
)

const RockSampleCPOMDP_type = typeof(RockSampleCPOMDP())

function ConstrainedPOMDPs.cost(p::RockSampleCPOMDP_type, s, a)
    return reward(p, s, a) < 0. ? [1.0] : [0.0]
end

# function ConstrainedPOMDPs.cost(p::RockSampleCPOMDP_type, s, a)
#     c = 0.0
#     if a > RockSample.N_BASIC_ACTIONS # using sensor
#         c += 1.0
#     elseif a == RockSample.BASIC_ACTIONS_DICT[:sample] && in(s.pos, p.rocks_positions) # sample 
#         rock_ind = findfirst(isequal(s.pos), p.rocks_positions) # slow ?

#         !s.rocks[rock_ind] && (c += 1.0)
#     end
#     return c
# end
