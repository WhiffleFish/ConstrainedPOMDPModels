struct GridWorldPOMDP <: POMDP{GWPos,Symbol,GWPos}
    mdp::SimpleGridWorld
    obs_prob::Float64
    costs::Dict{GWPos, SVector{1,Float64}}
end

function GridWorldPOMDP(;obs_prob=0.9, costs=Dict{GWPos,SVector{1,Float64}}(), kwargs...)
    GridWorldPOMDP(SimpleGridWorld(;kwargs...),obs_prob, costs)
end

POMDPs.transition(m::GridWorldPOMDP,s,a) = transition(m.mdp,s,a)
POMDPs.reward(m::GridWorldPOMDP,s,a) = reward(m.mdp,s,a)
POMDPs.discount(m::GridWorldPOMDP) = discount(m.mdp)
POMDPs.actionindex(m::GridWorldPOMDP, a) = actionindex(m.mdp, a)
POMDPs.stateindex(m::GridWorldPOMDP, s) = stateindex(m.mdp, s)
POMDPs.actions(m::GridWorldPOMDP) = actions(m.mdp)
POMDPs.states(m::GridWorldPOMDP) = states(m.mdp)
POMDPs.initialstate(m::GridWorldPOMDP) = Deterministic(GWPos(2,2))
POMDPTools.ordered_states(m::GridWorldPOMDP) = ordered_states(m.mdp)
POMDPTools.ordered_actions(m::GridWorldPOMDP) = ordered_actions(m.mdp)
POMDPs.observations(w::GridWorldPOMDP) = states(w.mdp)
POMDPTools.ordered_observations(m::GridWorldPOMDP) = observations(m)
POMDPs.isterminal(m::GridWorldPOMDP,s) = POMDPs.isterminal(m.mdp,s)

const NEAR = [SA[i,j] for i ∈ (-1,0,1), j ∈ (-1,0,1)]

function POMDPs.observation(m::GridWorldPOMDP,a,sp)
    isterminal(m, sp) && return Deterministic(sp)
    S = sizehint!(GWPos[], 9)
    P = sizehint!(Float64[], 9)
    for move ∈ NEAR
        near_state = sp + move
        if all(SA[0,0] .< near_state .< m.mdp.size)
            push!(S, near_state)
            p = move == SA[0,0] ? m.obs_prob : 1 - m.obs_prob
            push!(P,p)
        end
    end
    P ./= sum(P)
    return SparseCat(S,P)
end

POMDPs.obsindex(m::GridWorldPOMDP, o) = stateindex(m,o)

const ConstrainedGridWorld = typeof(ConstrainedPOMDPs.Constrain(GridWorldPOMDP(),[0.0]))

function ConstrainedGridWorldPOMDP(d::AbstractVector=[2.0]; kwargs...)
    return ConstrainedPOMDPs.Constrain(GridWorldPOMDP(;kwargs...), d)
end

function ConstrainedPOMDPs.cost(constrained::ConstrainedGridWorld, s, a)
    pomdp = constrained.m
    mdp = pomdp.mdp
    return if 1 ∈ s || mdp.size[1] ∈ s
        SA[1.0]
    else
        get(pomdp.costs, s, SA[0.0])
    end
end

function POMDPTools.ModelTools.render(c_pomdp::ConstrainedGridWorld, step)
    pomdp = c_pomdp.m
    mdp = pomdp.mdp
    nx, ny = mdp.size
    cells = Context[]

    for x in 1:nx, y in 1:ny
        cell = cell_ctx((x,y), mdp.size)
        pos_rew = reward(c_pomdp, GWPos(x,y), step[:a]) > 0.
        color = if cost(c_pomdp, GWPos(x,y), step[:a]) == SA[1.0]
            pos_rew ? "blue" : "red"
        else
            pos_rew ? "blue" : "black"
        end
        target = compose(context(), rectangle(), fill(color), stroke("gray"))
        compose!(cell, target)
        push!(cells, cell)
    end
    grid = compose(context(), linewidth(0.5mm), cells...)
    outline = compose(context(), linewidth(1mm), rectangle(), fill("black"), stroke("gray"))

    robot = if haskey(step, :sp)
        robot_ctx = cell_ctx(step[:sp], mdp.size)
        compose(robot_ctx, circle(0.5, 0.5, 0.5), fill("green"))
    else
        nothing
    end
    sz = min(w,h)
    return compose(context((w-sz)/2, (h-sz)/2, sz, sz), robot, grid, outline)
end

function cell_ctx(xy, size)
    nx, ny = size
    x, y = xy
    return context((x-1)/nx, (ny-y)/ny, 1/nx, 1/ny)
end
