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

    # AcceleratorGate is not in General, so the extension is tested in its own
    # environment (test/ext) that fetches it by URL through [sources], which
    # needs Julia 1.11. It runs in a subprocess so the main test environment
    # stays resolvable on older Julia. A run that cannot happen is recorded as
    # a visible Broken test, never dropped silently.
    @testset "AcceleratorGateExt" begin
        ext_dir = joinpath(@__DIR__, "ext")
        if get(ENV, "COPROCESSORRUNTIME_SKIP_EXT_TESTS", "") == "1"
            @info "AcceleratorGateExt tests skipped: COPROCESSORRUNTIME_SKIP_EXT_TESTS=1"
            @test_skip false
        elseif VERSION < v"1.11"
            @info "AcceleratorGateExt tests need Julia 1.11 ([sources]); running Julia $VERSION"
            @test_skip false
        else
            script = "import Pkg; Pkg.instantiate(); include(joinpath(\"$ext_dir\", \"runtests.jl\"))"
            cmd = `$(Base.julia_cmd()) --startup-file=no --project=$ext_dir -e $script`
            # Pkg.test sets JULIA_LOAD_PATH for the sandbox it makes; the
            # subprocess must resolve its own environment, not inherit that one.
            @test success(
                pipeline(
                    addenv(cmd, "JULIA_LOAD_PATH" => nothing);
                    stdout = stdout,
                    stderr = stderr,
                ),
            )
        end
    end
end
