#Cheese maze from http://pomdp.org/examples/cheese.95.POMDP, modified with wait action
struct CheeseMazePOMDP{Int,Int,Int}
    T::Vector{Matrix{Float64}}
    O::Matrix{Float64}
    action_order::NTuple{4, Symbol}
end


function CheeseMazePOMDP()
    T_1 = [1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0;
    1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0;
    0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.0]
    T_2 = [0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0;
    0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0;
    0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.0]
    T_3 = [0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0;
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0;
    0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.0] 
    T_4 = [1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0;
    0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 
    0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 
    0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0; 
    0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0 0.0; 
    0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 0.0; 
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0; 
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0 0.0; 
    0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 1.0 0.0; 
    0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.100000 0.0]
    T_5 = Matrix(Diagonal(ones(11)))
    O = [1.0 0.0 0.0 0.0 0.0 0.0 0.0;
        0.0 1.0 0.0 0.0 0.0 0.0 0.0; 
        0.0 0.0 1.0 0.0 0.0 0.0 0.0; 
        0.0 1.0 0.0 0.0 0.0 0.0 0.0; 
        0.0 0.0 0.0 1.0 0.0 0.0 0.0; 
        0.0 0.0 0.0 0.0 1.0 0.0 0.0; 
        0.0 0.0 0.0 0.0 1.0 0.0 0.0; 
        0.0 0.0 0.0 0.0 1.0 0.0 0.0; 
        0.0 0.0 0.0 0.0 0.0 1.0 0.0; 
        0.0 0.0 0.0 0.0 0.0 1.0 0.0; 
        0.0 0.0 0.0 0.0 0.0 0.0 1.0]
    return CheeseMazePOMDP([T_1,T_2,T_3,T_4,T_5],O,(:N,:S,:E,:W))
end

POMDPs.states(m::CheeseMazePOMDP) = 1:11
POMDPs.stateindex(m::CheeseMazePOMDP,s::Int) = s 
POMDPs.actions(m::CheeseMazePOMDP) = 1:5
POMDPs.actionindex(m::CheeseMazePOMDP,a::Int) = a

function POMDPs.transition(m::CheeseMazePOMDP, a::Int, s::Int)
    return SparseCat(1:11,m.T[a][s,:])
end

function POMDPs.reward(m::CheeseMazePOMDP,s::Int,a::Int)
    if s==10
        return 1000.0
    else
        return 0.0
    end
end
POMDPs.reward(m::CheeseMazePOMDP,s::Int,a::Int,sp::Int) = POMDPs.reward(m::CheeseMazePOMDP,s::Int,a::Int)

function POMDPs.observation(m::CheeseMazePOMDP, a::Int, sp::Int)
    return SparseCat(1:7,m.O[sp,:])
end
POMDPs.observations(m::CheeseMazePOMDP) = 1:7
POMDPs.obsindex(m::CheeseMazePOMDP,o::Int) = o


POMDPs.initialstate(m::CheeseMazePOMDP) = SparseCat(1:11,append!(fill(1/10,10),0.)) #From MiniHallway.jl
POMDPs.isterminal(m::CheeseMazePOMDP,s::Int) = s==11
POMDPs.discount(m::CheeseMazePOMDP) = 0.95

##Constrained
struct CheeseMazeCPOMDP{V<:AbstractVector} <: CPOMDP{Int,Int,Int}
    m::CheeseMazePOMDP
    constraints::V
end

@POMDP_forward CheeseMazeCPOMDP.m

CheeseMazeCPOMDP(ĉ=[1.0]; kwargs...) = CheeseMazeCPOMDP(CheeseMazePOMDP(;kwargs...),ĉ)

ConstrainedPOMDPs.constraints(p::CheeseMazeCPOMDP) = p.constraints

function ConstrainedPOMDPs.costs(p::CheeseMazeCPOMDP, s, a)
    if a < 5
        c = 1.0
    else
        c = 0.0
    end
    return c
end