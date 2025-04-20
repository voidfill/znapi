const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const test_step = b.step("test", "Run tests");

    const zn_mod = b.addModule("znapi", .{
        .root_source_file = b.path("src/znapi.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = target.result.os.tag == .windows, // need libc for windows.h
    });

    const unit_tests = b.addSharedLibrary(.{
        .name = "test_runner",
        .root_source_file = b.path("tests/module.zig"),
        .target = target,
        .optimize = optimize,
    });
    unit_tests.root_module.addImport("znapi", zn_mod);

    const test_output = b.addInstallFileWithDir(unit_tests.getEmittedBin(), .{ .custom = "test" }, "zig_module.node");
    test_step.dependOn(&test_output.step);
}
