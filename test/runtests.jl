using Pkg
Pkg.add(url="https://github.com/qhho/ConstrainedPOMDPs.jl")

using ConstrainedPOMDPModels
using ConstrainedPOMDPs
using POMDPTools
using POMDPs
using Test

include("gridworld.jl")
include("trivial.jl")
include("rocksample.jl")
include("minihall.jl")