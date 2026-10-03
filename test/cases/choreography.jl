# SPDX-License-Identifier: MPL-2.0
# Copyright (c) 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>

@testset "choreography and hub_ceiling" begin
    lossy = EchoResidue(collapsing_transfer(:f32_to_f16), "mantissa fibre")
    lossless = EchoResidue(injective_transfer(:copy), "identity")
    grade = ResourceGrade(1024, 100, 0.0)
    plan = launch_plan(
        :matmul,
        [Endpoint(HostRole(), CPUKind()), Endpoint(DeviceRole(), GPUKind())],
        grade,
        lossy,
    )
    dev = project(plan, DeviceRole())
    @test length(dev.endpoints) == 1
    @test dev.kcut === :open
    @test dev.grade_eq === false
    @test projected_grade(plan, DeviceRole()) == grade
    inj = launch_plan(:copy, [Endpoint(HostRole(), CPUKind())], grade, lossless)
    @test project(inj, HostRole()).grade_eq === true
    @test_throws HubCeilingRefusal universal_hub_allowed()
    @test_throws ArgumentError launch_plan(:empty, Endpoint[], grade, lossless)
end
