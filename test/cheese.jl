@testset "cheese" begin
    pomdp = CheeseMazeCPOMDP()
    @test has_consistent_distributions(pomdp)
    @test has_consistent_cost(pomdp)
end