# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

@testset "epistemic receipts" begin
    s = open_session(NPUKind())
    r = issue_receipt(s; warrant=WarrantOnly, claim="kernel returned")
    @test !host_may_claim(r)
    fact = issue_receipt(
        s;
        standpoint=:host,
        warrant=Knowledge,
        claim="host saw flag",
        sound=true,
    )
    @test host_may_claim(fact)
    @test_throws ArgumentError issue_receipt(
        s;
        standpoint=:device,
        warrant=Knowledge,
        claim="smuggled",
        sound=false,
    )
    close_session!(s)
    @test_throws ArgumentError issue_receipt(s)
end
