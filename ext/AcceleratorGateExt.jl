# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

"""
    AcceleratorGateExt

Package extension: maps an AcceleratorGate.jl `AbstractBackend` onto the
`CoprocessorKind` a CoprocessorRuntime session is opened against.

It records which *kind* a backend is. It does not select a backend, check that
a device exists, or run anything: AcceleratorGate's backends are env-flag
selections, and this mapping claims no more than that.

Four AcceleratorGate backends have no kind in CoprocessorRuntime and map to
`UnknownKind`: `PPUBackend`, `MathBackend`, `VPUBackend`, `CryptoBackend`.
Adding a kind for one of them is an API change to CoprocessorRuntime, not a
guess to make here.
"""
module AcceleratorGateExt

import CoprocessorRuntime:
    coprocessor_kind,
    CPUKind,
    GPUKind,
    NPUKind,
    TPUKind,
    FPGAKind,
    QPUKind,
    DSPKind,
    UnknownKind
import AcceleratorGate:
    AbstractBackend,
    JuliaBackend,
    RustBackend,
    ZigBackend,
    CUDABackend,
    ROCmBackend,
    MetalBackend,
    TPUBackend,
    NPUBackend,
    DSPBackend,
    FPGABackend,
    QPUBackend,
    PPUBackend,
    MathBackend,
    VPUBackend,
    CryptoBackend

# Host-language implementations run on the CPU.
coprocessor_kind(::JuliaBackend) = CPUKind()
coprocessor_kind(::RustBackend) = CPUKind()
coprocessor_kind(::ZigBackend) = CPUKind()

# GPU vendors.
coprocessor_kind(::CUDABackend) = GPUKind()
coprocessor_kind(::ROCmBackend) = GPUKind()
coprocessor_kind(::MetalBackend) = GPUKind()

# Coprocessor families CoprocessorRuntime has a kind for.
coprocessor_kind(::TPUBackend) = TPUKind()
coprocessor_kind(::NPUBackend) = NPUKind()
coprocessor_kind(::FPGABackend) = FPGAKind()
coprocessor_kind(::QPUBackend) = QPUKind()
coprocessor_kind(::DSPBackend) = DSPKind()

# Coprocessor families CoprocessorRuntime has no kind for: named, not guessed.
coprocessor_kind(::PPUBackend) = UnknownKind()
coprocessor_kind(::MathBackend) = UnknownKind()
coprocessor_kind(::VPUBackend) = UnknownKind()
coprocessor_kind(::CryptoBackend) = UnknownKind()

# A backend type AcceleratorGate adds later: total, and honest about it. The
# extension's tests fail when a backend subtype is missing from the table
# above, so a new backend gets a mapping decision instead of this default.
coprocessor_kind(::AbstractBackend) = UnknownKind()

end # module AcceleratorGateExt
