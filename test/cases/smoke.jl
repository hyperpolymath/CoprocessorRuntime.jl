# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

@testset "smoke" begin
    s = open_session(GPUKind())
    @test s isa Session{GPUKind}
    @test isopen(s)
    @test kind_label(s.kind) === :gpu
    close_session!(s)
    @test !isopen(s)
end
