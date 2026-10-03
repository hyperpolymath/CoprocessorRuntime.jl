# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# Runtime shadow of epistemic-types. Knowledge is factive; belief is not;
# a warrant records evidence without assuming soundness. Proof transported
# across a PCIe/trust boundary becomes a receipt. No-smuggling: a device
# standpoint cannot be rewritten as a host Knowledge claim.

@enum WarrantKind::UInt8 begin
    Knowledge = 1
    Belief = 2
    WarrantOnly = 3
    Unsound = 4
end

"""
    LaunchReceipt

What the issuing standpoint may claim after a launch. `sound == false` means
no soundness check ran — the default, and the honest one for a library that
does not talk to a device.
"""
struct LaunchReceipt
    session_id::UInt64
    standpoint::Symbol
    warrant::WarrantKind
    claim::String
    sound::Bool
end

function issue_receipt(
    session::Session;
    standpoint::Symbol=:host,
    warrant::WarrantKind=WarrantOnly,
    claim::AbstractString="",
    sound::Bool=false,
)
    isopen(session) || throw(ArgumentError("session $(session.id) is closed"))
    if standpoint === :device && warrant === Knowledge && !sound
        throw(
            ArgumentError(
                "device Knowledge without a soundness check is smuggling",
            ),
        )
    end
    LaunchReceipt(session.id, standpoint, warrant, String(claim), sound)
end

"""
    host_may_claim(receipt) -> Bool

The host may treat a receipt as a factive claim only when the standpoint is
`:host`, the warrant is `Knowledge`, and `sound` is true. Device-standpoint
receipts never qualify. This is the no-smuggling rule in runtime form.
"""
function host_may_claim(r::LaunchReceipt)
    r.standpoint === :host && r.warrant === Knowledge && r.sound
end
