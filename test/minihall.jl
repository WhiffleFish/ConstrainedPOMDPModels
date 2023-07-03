@testset "minihall" begin
    pomdp = MiniHallCPOMDP()
    @test has_consistent_distributions(pomdp)
    @test has_consistent_cost(pomdp)
end