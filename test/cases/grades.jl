# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

@testset "tropical grades" begin
    a = ResourceGrade(10, 3, 1.0)
    b = ResourceGrade(4, 8, 0.5)
    seq = tropical_seq(a, b)
    @test seq.bytes == 14
    @test seq.nanos == 11
    @test seq.joules == 1.5
    alt = tropical_alt(a, b)
    @test alt.bytes == 10
    @test alt.nanos == 8
    @test alt.joules == 1.0
    @test dominates(seq, a)
    @test !dominates(a, seq)
    unstated = ResourceGrade(10, 8, 0.0)
    stated = ResourceGrade(4, 3, 0.5)
    @test !dominates(unstated, stated)
    @test_throws ArgumentError ResourceGrade(-1, 0, 0.0)
end
