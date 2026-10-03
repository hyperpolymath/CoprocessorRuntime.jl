# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

@testset "sessions and nullity" begin
    CoprocessorRuntime.reset_session_counter!()
    s = open_session(CPUKind())
    @test s.id == UInt64(1)
    cno = reset_session!(s)
    @test cno isa CNOClaim
    @test cno.operation === :reset
    @test cno.status === :model_checked
    @test isopen(s)
    close_session!(s)
    @test_throws ArgumentError reset_session!(s)
    ond = observe_null(:weights, :host; residue=[:thermal, :em_sidechannel])
    @test ond.status === :unproved
    @test ond.residue == [:thermal, :em_sidechannel]
    @test irreversible(:reduce).inverse === nothing
    @test inversion_of(:copy, :copy_back).inverse === :copy_back
end
