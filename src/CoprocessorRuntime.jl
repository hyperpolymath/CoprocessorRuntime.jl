# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# CoprocessorRuntime.jl — runtime *contracts* for host↔device sessions.
# This package does not execute vendor kernels and does not link CUDA/ROCm/Metal.
# Selection of a backend is AcceleratorGate.jl; this library records what a
# launch is allowed to claim after that selection.

"""
    CoprocessorRuntime

Coprocessor support base library: session lifecycle, tropical resource grades,
echo residues on non-injective transfers, epistemic receipts, and CNO/OND
*claims* (data, not proofs).

# Honest scope

* Does **not** run GPU/NPU/QPU kernels.
* Does **not** provide a universal protocol adapter (`hub_ceiling`).
* Does **not** treat a device receipt as host knowledge.
* Sibling packages (`AcceleratorGate`, `EchoTypes`, `EpistemicTypes`,
  `HardwareResilience`, `LowLevel`, `SiliconCore`) are optional wiring, not
  hard dependencies. See `docs/ecosystem/HYPERPOLYMATH-WIRING.adoc`.

# Example

```julia
using CoprocessorRuntime
s = open_session(GPUKind())
eps = [Endpoint(HostRole(), CPUKind()), Endpoint(DeviceRole(), GPUKind())]
g = ResourceGrade(1 << 20, 10_000, 0.0)
loss = EchoResidue(TransferMap(:f32_to_f16, false, false), "precision fibre")
plan = launch_plan(:matmul, eps, g, loss)
r = project(plan, DeviceRole())
close_session!(s)
```
"""
module CoprocessorRuntime

export Role, HostRole, DeviceRole,
       CoprocessorKind, CPUKind, GPUKind, NPUKind, TPUKind, FPGAKind, QPUKind,
       DSPKind, UnknownKind,
       Session, open_session, close_session!, isopen,
       ResourceGrade, tropical_alt, tropical_seq, dominates,
       TransferMap, EchoResidue, injective_transfer, collapsing_transfer,
       WarrantKind, LaunchReceipt, issue_receipt, host_may_claim,
       CNOClaim, ONDClaim, reset_session!, observe_null,
       InverseMeta, inversion_of, irreversible,
       Endpoint, LaunchPlan, launch_plan, project, projected_grade,
       universal_hub_allowed, HubCeilingRefusal,
       kind_label

include("Kinds.jl")
include("Grades.jl")
include("EchoLoss.jl")
include("Sessions.jl")
include("Receipts.jl")
include("Nullity.jl")
include("Choreography.jl")

end # module CoprocessorRuntime
