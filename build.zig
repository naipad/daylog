const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const httpz = b.dependency("httpz", .{
        .target = target,
        .optimize = optimize,
    });

    const root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    root_module.addImport("httpz", httpz.module("httpz"));

    const exe = b.addExecutable(.{
        .name = "daylog",
        .root_module = root_module,
    });
    b.installArtifact(exe);
    const run = b.addRunArtifact(exe);
    b.step("run", "Run daylog").dependOn(&run.step);
    const tests = b.addTest(.{ .root_module = root_module });
    b.step("test", "Run unit tests").dependOn(&b.addRunArtifact(tests).step);
}
