struct GridWorldPOMDP <: POMDP{GWPos,Symbol,GWPos}
    mdp::SimpleGridWorld
    obs_prob::Float64
end

function GridWorldPOMDP(;obs_prob=0.9, kwargs...)
    GridWorldPOMDP(SimpleGridWorld(;kwargs...),obs_prob)
end

@MDP_forward GridWorldPOMDP.mdp

const NEAR = [SA[i,j] for i ∈ (-1,0,1), j ∈ (-1,0,1)]

function POMDPs.observation(m::GridWorldPOMDP,a,sp)
    isterminal(m, sp) && return Deterministic(sp)
    S = sizehint!(GWPos[], 9)
    P = sizehint!(Float64[], 9)
    for move ∈ NEAR
        near_state = sp + move
        if all(SA[1,1] .≤ near_state .≤ m.mdp.size)
            push!(S, near_state)
            p = move == SA[0,0] ? m.obs_prob : 1 - m.obs_prob
            push!(P,p)
        end
    end
    P ./= sum(P)
    return SparseCat(S,P)
end

POMDPs.observations(m::GridWorldPOMDP) = states(m)
POMDPs.obsindex(m::GridWorldPOMDP, o) = stateindex(m,o)

struct GridWorldCPOMDP{V<:AbstractVector} <: CPOMDP{GWPos, Symbol, GWPos}
    pomdp::GridWorldPOMDP
    costs::Dict{GWPos, SVector{1,Float64}}
    constraints::V
end

@POMDP_forward GridWorldCPOMDP.pomdp

function GridWorldCPOMDP(ĉ=SA[1.0]; costs=Dict{GWPos,SVector{1,Float64}}(), kwargs...)
    return GridWorldCPOMDP(GridWorldPOMDP(;kwargs...), costs, ĉ)
end

const ConstrainedGridWorldPOMDP = GridWorldCPOMDP

function ConstrainedPOMDPs.cost(constrained::GridWorldCPOMDP, s, a)
    pomdp = constrained.pomdp
    mdp = pomdp.mdp
    return if 1 ∈ s || mdp.size[1] ∈ s
        SA[1.0]
    else
        get(constrained.costs, s, SA[0.0])
    end
end

ConstrainedPOMDPs.constraints(m::GridWorldCPOMDP) = m.constraints

function POMDPTools.ModelTools.render(c_pomdp::GridWorldCPOMDP, step)
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
