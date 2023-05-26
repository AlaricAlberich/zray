const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    _ = target;
    const optimize = b.standardOptimizeOption(.{});
    _ = optimize;
}
