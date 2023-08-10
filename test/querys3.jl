@testset "querys3" begin
    pomdp = QueryS3CPOMDP()
    @test has_consistent_distributions(pomdp)
    @test has_consistent_cost(pomdp)
end