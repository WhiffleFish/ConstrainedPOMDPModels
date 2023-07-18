@testset "maze" begin
    pomdp = Maze20CPOMDP()
    @test has_consistent_distributions(pomdp)
    @test has_consistent_cost(pomdp)
end