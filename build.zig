const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("znapi", .{
        .root_source_file = b.path("src/znapi.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
}
