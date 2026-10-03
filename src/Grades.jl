# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# Runtime shadow of tropical-types (max-plus / sequential +). This is a
# calculator, not a Lean proof. Infinite tropical carriers are not reified;
# grades here are finite Int/Float64 and must not be confused with Echo
# residues (see tropical-types Resource.EchoBridge).

"""
    ResourceGrade(bytes, nanos, joules)

Worst-case resource bound for a launch. Sequential composition uses
[`tropical_seq`](@ref) (`+` on each axis). Alternative composition uses
[`tropical_alt`](@ref) (`max` on each axis).

`joules == 0.0` means *unstated*, not "free". Unstated energy does not
dominate a stated energy.
"""
struct ResourceGrade
    bytes::Int
    nanos::Int
    joules::Float64
    function ResourceGrade(bytes::Integer, nanos::Integer, joules::Real)
        bytes < 0 && throw(ArgumentError("bytes must be ≥ 0"))
        nanos < 0 && throw(ArgumentError("nanos must be ≥ 0"))
        joules < 0 && throw(ArgumentError("joules must be ≥ 0"))
        new(Int(bytes), Int(nanos), Float64(joules))
    end
end

"""
    tropical_seq(a, b)

Sequential (max-plus ⊗): costs add. Mirrors tropical-types sequential
composition. This is a bound, not a measurement.
"""
function tropical_seq(a::ResourceGrade, b::ResourceGrade)
    ResourceGrade(a.bytes + b.bytes, a.nanos + b.nanos, a.joules + b.joules)
end

"""
    tropical_alt(a, b)

Alternative (max-plus ⊕): worst case of the two. Mirrors tropical-types
choice. Energy treats 0 as unstated: `max` still applies, but `dominates`
will not treat unstated as cheaper.
"""
function tropical_alt(a::ResourceGrade, b::ResourceGrade)
    ResourceGrade(max(a.bytes, b.bytes), max(a.nanos, b.nanos), max(a.joules, b.joules))
end

"""
    dominates(a, b) -> Bool

True when `a` is a conservative upper bound of `b` on every *stated* axis.
Unstated energy (`0.0`) on `a` cannot dominate a positive energy on `b`.
"""
function dominates(a::ResourceGrade, b::ResourceGrade)
    bytes_ok = a.bytes >= b.bytes
    nanos_ok = a.nanos >= b.nanos
    energy_ok = if a.joules == 0.0 && b.joules > 0.0
        false
    else
        a.joules >= b.joules
    end
    bytes_ok && nanos_ok && energy_ok
end
