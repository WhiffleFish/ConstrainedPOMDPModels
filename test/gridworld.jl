@testset "gridworld" begin
    pomdp = ConstrainedGridWorldPOMDP()
    @test has_consistent_distributions(pomdp)
    
    pomdp = ConstrainedGridWorldPOMDP(obs_prob = 1.0)
    @test has_consistent_distributions(pomdp)
end
