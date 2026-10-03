# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# Runtime *claims* corresponding to absolute-zero's two pillars:
#   CNO — Certified Null Effect (state conserved)
#   OND — Observational Null Disclosure (secret→observable channel conserved)
# Neither constructor produces a proof. Status is :unproved or :model_checked.
# JanusKey-shaped inversion metadata is the engineering cousin of CNO.

"""
    CNOClaim

Claim that an operation left session-visible state identical. Conserved
quantity: state. `status` is `:unproved` unless a model check ran in this
process (never a Coq/Lean/Agda proof).
"""
struct CNOClaim
    operation::Symbol
    session_id::UInt64
    status::Symbol
end

"""
    ONDClaim

Claim that a declared observer's trace is constant over a secret region.
Conserved quantity: the secret-to-observable channel. `residue` lists
out-of-scope observables — the honest boundary between the claim and the
physical metal (OND's residue list).
"""
struct ONDClaim
    secret_region::Symbol
    observer::Symbol
    residue::Vector{Symbol}
    status::Symbol
end

"""
    InverseMeta

Janus-shaped inversion metadata. `inverse === nothing` means the operation
is irreversible and must be paired with an [`EchoResidue`](@ref).
"""
struct InverseMeta
    op::Symbol
    inverse::Union{Symbol,Nothing}
end

inversion_of(op::Symbol, inverse::Symbol) = InverseMeta(op, inverse)
irreversible(op::Symbol) = InverseMeta(op, nothing)

"""
    reset_session!(session) -> CNOClaim

Host-side reset of the session handle. The model check is: the handle is
still the same id and is marked closed-then-reopened logically by flipping
`open` false then true. This is **not** a device reset and not a CNO proof.
"""
function reset_session!(s::Session)
    id = s.id
    s.open || throw(ArgumentError("cannot reset a closed session"))
    s.open = false
    s.open = true
    status = (s.id == id && s.open) ? :model_checked : :unproved
    CNOClaim(:reset, s.id, status)
end

"""
    observe_null(secret, observer; residue=Symbol[], status=:unproved)

Construct an OND claim. Callers must list out-of-scope observables in
`residue`. Default status is `:unproved`.
"""
function observe_null(
    secret::Symbol,
    observer::Symbol;
    residue::Vector{Symbol}=Symbol[],
    status::Symbol=:unproved,
)
    status in (:unproved, :model_checked) ||
        throw(ArgumentError("OND status must be :unproved or :model_checked, got $status"))
    ONDClaim(secret, observer, copy(residue), status)
end
