@testset "trivial" begin
    @test has_consistent_distributions(TrivialCPOMDP())
    @test has_consistent_distributions(ToyCPOMDP())
end
