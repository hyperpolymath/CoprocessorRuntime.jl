# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

using Test
using InteractiveUtils: subtypes
using CoprocessorRuntime
using AcceleratorGate

# The mapping the extension must implement. It is written out here, in full, so
# the test is a second statement of the table and not a restatement of the code.
const EXPECTED = Dict{DataType,DataType}(
    JuliaBackend => CPUKind,
    RustBackend => CPUKind,
    ZigBackend => CPUKind,
    CUDABackend => GPUKind,
    ROCmBackend => GPUKind,
    MetalBackend => GPUKind,
    TPUBackend => TPUKind,
    NPUBackend => NPUKind,
    FPGABackend => FPGAKind,
    QPUBackend => QPUKind,
    DSPBackend => DSPKind,
    PPUBackend => UnknownKind,
    MathBackend => UnknownKind,
    VPUBackend => UnknownKind,
    CryptoBackend => UnknownKind,
)

# Backends take no argument, a library path, or a device number.
make(::Type{JuliaBackend}) = JuliaBackend()
make(T::Type{<:Union{RustBackend,ZigBackend}}) = T("")
make(T::Type{<:AbstractBackend}) = T(0)

@testset "AcceleratorGateExt" begin
    @testset "the extension is loaded" begin
        @test Base.get_extension(CoprocessorRuntime, :AcceleratorGateExt) !== nothing
        @test hasmethod(coprocessor_kind, Tuple{JuliaBackend})
    end

    @testset "the table covers every AcceleratorGate backend" begin
        # A backend AcceleratorGate adds later must get a mapping decision here,
        # not fall through to the extension's UnknownKind default unseen.
        @test Set(subtypes(AbstractBackend)) == Set(keys(EXPECTED))
    end

    @testset "each backend maps to its kind" begin
        for (backend, kind) in EXPECTED
            @test coprocessor_kind(make(backend)) isa kind
        end
    end

    @testset "kinds the runtime does not model are Unknown, not guessed" begin
        for T in (PPUBackend, MathBackend, VPUBackend, CryptoBackend)
            @test kind_label(coprocessor_kind(make(T))) === :unknown
        end
    end

    @testset "a mapped kind opens a session" begin
        s = open_session(coprocessor_kind(CUDABackend(0)))
        @test isopen(s)
        close_session!(s)
        @test !isopen(s)
    end
end
