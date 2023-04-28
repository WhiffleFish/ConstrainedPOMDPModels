@testset "rocksample" begin
    pomdp = RockSampleCPOMDP()
    @test has_consistent_distributions(pomdp)
    @test has_consistent_cost(pomdp)
end
