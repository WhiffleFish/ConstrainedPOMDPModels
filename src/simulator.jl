Base.@kwdef struct ConstrainedDisplaySimulator{RNG<:AbstractRNG}
    max_steps::Int = 100
    max_fps::Float64 = 10.
    verbose::Bool = true
    rng::RNG = Random.default_rng()
end

sleep_until(t) = sleep(max(t-time(), 0.0))

function POMDPs.simulate(
        sim::ConstrainedDisplaySimulator,
        pomdp::ConstrainedPOMDPWrapper,
        policy,
        bu=DiscreteUpdater(pomdp)
    )
    s = rand(initialstate(pomdp))
    r_total = 0
    γ = 1.0
    d = pomdp.constraints
    b = initialize_belief(bu, initialstate(pomdp))
    dt = inv(sim.max_fps)
    display(render(pomdp, (sp=s, bp=b, a=first(actions(pomdp)))))
    cost_tot = zeros(constraint_size(pomdp))
    tm = time()

    for i in 1:sim.max_steps
        isterminal(pomdp,s) && break

        a = action(policy, b, d)
        prevs = s
        c = cost(pomdp,s,a)
        s, o, r = @gen(:sp,:o,:r)(pomdp.m, s, a, sim.rng)
        sim.verbose && println("step: $i -- s: $prevs, a: $a, sp: $s")
        r_total += γ*r
        cost_tot += γ*c
        γ *= discount(pomdp)
        d = (d-c)/discount(pomdp)

        b = update(bu, b, a, o)
        display(render(pomdp, (sp=s, bp=b, a=a)))
        sleep_until(tm+dt)
        tm = time()
    end
    sim.verbose && println("discounted cost: $cost_tot")
end
