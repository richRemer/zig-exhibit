const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const xzbt = b.dependency("xzbt", .{ .target = target }).module("xzbt");

    const mod = b.addModule("exhibit", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .imports = &.{
            .{ .name = "xzbt", .module = xzbt },
        },
    });

    const exe = b.addExecutable(.{
        .name = "exhibit",
        .root_module = b.createModule(.{
            .root_source_file = b.path("demo/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "exhibit", .module = mod },
            },
        }),
    });

    exe.linkLibC();
    exe.linkSystemLibrary("xcb");

    b.installArtifact(exe);

    const demo_step = b.step("demo", "Run the demo");
    const demo_cmd = b.addRunArtifact(exe);

    demo_step.dependOn(&demo_cmd.step);
    demo_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        demo_cmd.addArgs(args);
    }

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run tests");

    mod_tests.linkLibC();
    test_step.dependOn(&run_mod_tests.step);
}
