# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

"""
    Role

Choreographic endpoint role. A global launch plan is *projected* onto a
`HostRole` or a `DeviceRole`. This is a runtime shadow of choreographic-types,
not a proof of K-CUT.
"""
abstract type Role end
struct HostRole <: Role end
struct DeviceRole <: Role end

"""
    CoprocessorKind

Family of coprocessor. Availability and selection live in AcceleratorGate.jl;
this type only names the kind a session is opened against.
"""
abstract type CoprocessorKind end
struct CPUKind <: CoprocessorKind end
struct GPUKind <: CoprocessorKind end
struct NPUKind <: CoprocessorKind end
struct TPUKind <: CoprocessorKind end
struct FPGAKind <: CoprocessorKind end
struct QPUKind <: CoprocessorKind end
struct DSPKind <: CoprocessorKind end
struct UnknownKind <: CoprocessorKind end

kind_label(::CPUKind) = :cpu
kind_label(::GPUKind) = :gpu
kind_label(::NPUKind) = :npu
kind_label(::TPUKind) = :tpu
kind_label(::FPGAKind) = :fpga
kind_label(::QPUKind) = :qpu
kind_label(::DSPKind) = :dsp
kind_label(::UnknownKind) = :unknown
kind_label(::CoprocessorKind) = :unknown
