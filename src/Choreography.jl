# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
#
# Runtime shadow of choreographic-types. K-CUT is OPEN upstream: grading and
# warrant transport commuting with endpoint projection is a conjecture, not a
# theorem. `project` returns a local view and does not claim the projected
# grade equals the global grade unless the transfer is injective.

"""
    Endpoint(role, kind)

One participant in a launch choreography.
"""
struct Endpoint
    role::Role
    kind::CoprocessorKind
end

"""
    LaunchPlan

Global description of a launch. `grade` is the declared worst-case bound.
`loss` is the echo residue of the host↔device map used on the cut.
"""
struct LaunchPlan
    global_name::Symbol
    endpoints::Vector{Endpoint}
    grade::ResourceGrade
    loss::EchoResidue
end

function launch_plan(
    name::Symbol,
    endpoints::Vector{Endpoint},
    grade::ResourceGrade,
    loss::EchoResidue,
)
    isempty(endpoints) && throw(ArgumentError("launch plan needs at least one endpoint"))
    LaunchPlan(name, endpoints, grade, loss)
end

"""
    project(plan, role) -> NamedTuple

Endpoint projection: the local view for `role`. Loss-grade equality with the
global plan is returned only when `plan.loss.map.injective` (the degenerate
base case that choreographic-types already has). Otherwise `grade_eq` is
false and `warrant_bound` is `:open` — K-CUT-WARRANT is not claimed.
"""
function project(plan::LaunchPlan, role::Role)
    local_eps = Endpoint[e for e in plan.endpoints if typeof(e.role) === typeof(role)]
    injective = plan.loss.map.injective
    (
        role=role,
        endpoints=local_eps,
        grade=plan.grade,
        loss=plan.loss,
        grade_eq=injective,
        warrant_bound=injective ? :degenerate_base : :open,
        kcut=:open,
    )
end

"""
    projected_grade(plan, role)

The grade carried by the projection. Equal to the global grade as *data*;
whether that equality is a theorem is `project(plan, role).grade_eq`.
"""
projected_grade(plan::LaunchPlan, ::Role) = plan.grade

"""
    HubCeilingRefusal

Thrown by [`universal_hub_allowed`](@ref). Mirrors tropical-types
`hub_ceiling`: there is no universal adapter from every host protocol to
every coprocessor protocol.
"""
struct HubCeilingRefusal <: Exception
    msg::String
end
Base.showerror(io::IO, e::HubCeilingRefusal) = print(io, e.msg)

"""
    universal_hub_allowed() -> Bool

Always `false`. A coprocessor runtime that pretended to speak every vendor
protocol would be the Protocol Squisher claim that `hub_ceiling` refutes.
Callers who need a backend use AcceleratorGate selection, not a hub.
"""
function universal_hub_allowed()
    throw(
        HubCeilingRefusal(
            "hub_ceiling: no universal coprocessor adapter",
        ),
    )
end
