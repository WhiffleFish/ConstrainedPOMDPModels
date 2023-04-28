@testset "trivial" begin
    @test has_consistent_distributions(TrivialCPOMDP())
    @test has_consistent_distributions(ToyCPOMDP())
    @test has_consistent_cost(TrivialCPOMDP())
    @test has_consistent_cost(ToyCPOMDP())
end
