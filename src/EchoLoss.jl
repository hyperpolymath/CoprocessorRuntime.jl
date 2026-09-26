# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# Runtime shadow of echo-types. EchoWitness in EchoTypes.jl is the finite
# executable companion of the Agda; here we only record whether a host↔device
# map is injective/reversible and a fibre note. We do not compute fibres.

"""
    TransferMap(name, injective, reversible)

A named host↔device map. Device transfers (quantisation, tiling, reduction)
are typically non-injective. A reversible map may carry Janus-style inversion
metadata; an irreversible map must carry an [`EchoResidue`](@ref).
"""
struct TransferMap
    name::Symbol
    injective::Bool
    reversible::Bool
end

injective_transfer(name::Symbol) = TransferMap(name, true, true)
collapsing_transfer(name::Symbol) = TransferMap(name, false, false)

"""
    EchoResidue(map, fiber_note)

Recorded constraint on what was lost. This is **not** `Echo f y := Σ (x:A), f x ≡ y`.
The note is a human/machine string, not a proof-relevant fibre. Round-trips
through a collapsing map are refused as identities.
"""
struct EchoResidue
    map::TransferMap
    fiber_note::String
end

function Base.:(==)(a::TransferMap, b::TransferMap)
    a.name == b.name && a.injective == b.injective && a.reversible == b.reversible
end

function Base.:(==)(a::EchoResidue, b::EchoResidue)
    a.map == b.map && a.fiber_note == b.fiber_note
end
