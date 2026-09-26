# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

const _session_counter = Ref{UInt64}(UInt64(0))

"""
    Session{K}

An opened coprocessor session. Opening a session does not allocate device
memory and does not prove the device exists. It is a host-side handle.
"""
mutable struct Session{K <: CoprocessorKind}
    id::UInt64
    kind::K
    role::Role
    open::Bool
end

Base.isopen(s::Session) = s.open

"""
    open_session(kind; role=HostRole())

Mint a host-side session handle. `role` is this endpoint's choreographic
projection (almost always `HostRole` in Julia).
"""
function open_session(kind::K; role::Role=HostRole()) where {K <: CoprocessorKind}
    _session_counter[] += UInt64(1)
    Session{K}(_session_counter[], kind, role, true)
end

function close_session!(s::Session)
    s.open = false
    s
end

function reset_session_counter!()
    _session_counter[] = UInt64(0)
    nothing
end
