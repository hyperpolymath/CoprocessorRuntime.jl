# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

using Test
using Aqua
using CoprocessorRuntime

@testset "CoprocessorRuntime" begin
    @testset "Aqua" begin
        Aqua.test_all(CoprocessorRuntime)
    end
    include(joinpath(@__DIR__, "cases", "smoke.jl"))
    include(joinpath(@__DIR__, "cases", "grades.jl"))
    include(joinpath(@__DIR__, "cases", "sessions.jl"))
    include(joinpath(@__DIR__, "cases", "receipts.jl"))
    include(joinpath(@__DIR__, "cases", "choreography.jl"))
end
