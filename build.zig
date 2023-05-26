const std = @import("std");
const CompileStep = std.Build.CompileStep;
const Build = std.Build;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib = buildRaylib(b, target, optimize);
    const zigrl = b.createModule(.{ .source_file = .{ .path = "src/lib.zig" } });

    const tests = b.addTest(.{ .root_source_file = .{ .path = "src/lib.zig" } });
    tests.linkLibC();
    tests.linkLibrary(raylib);

    const run_unit_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run zigrl tests");
    test_step.dependOn(&run_unit_tests.step);

    // Examples
    {
        const example = b.addExecutable(.{ .name = "basic_window", .root_source_file = .{ .path = "examples/basic_window.zig" }, .target = target, .optimize = optimize });
        example.linkLibC();
        example.linkLibrary(raylib);
        example.addModule("zigrl", zigrl);
        const run_example = b.addRunArtifact(example);
        const run_step = b.step("basic_window", "Core Window Example");
        run_step.dependOn(&run_example.step);
    }

    {
        const example = b.addExecutable(.{ .name = "input_keys", .root_source_file = .{ .path = "examples/input_keys.zig" }, .target = target, .optimize = optimize });
        example.linkLibC();
        example.linkLibrary(raylib);
        example.addModule("zigrl", zigrl);
        const run_example = b.addRunArtifact(example);
        const run_step = b.step("input_keys", "Input Keys Example");
        run_step.dependOn(&run_example.step);
    }
}

fn buildRaylib(b: *std.Build, target: std.zig.CrossTarget, optimize: std.builtin.Mode) *CompileStep {
    const raylib = b.addStaticLibrary(.{ .name = "raylib", .target = target, .optimize = optimize });
    raylib.linkLibC();
    raylib.addIncludePath("raylib/src");

    const dir = std.fs.path.dirname(@src().file) orelse ".";
    const glfw_include = std.fs.path.join(b.allocator, &.{ dir, "raylib/src/external/glfw/include" }) catch unreachable;
    raylib.addIncludePath(glfw_include);

    for (raylib_source_files) |file| {
        const path = std.fs.path.join(b.allocator, &.{ dir, "raylib/src", file }) catch unreachable;
        raylib.addCSourceFile(path, raylib_flags);
    }

    switch (target.getOsTag()) {
        .linux => {
            raylib.addCSourceFile(std.fs.path.join(b.allocator, &.{ dir, "raylib/src/rglfw.c" }) catch unreachable, raylib_flags);
            raylib.linkSystemLibrary("GL");
            raylib.linkSystemLibrary("rt");
            raylib.linkSystemLibrary("dl");
            raylib.linkSystemLibrary("m");
            raylib.linkSystemLibrary("X11");
            raylib.linkSystemLibrary("Xrandr");
            raylib.linkSystemLibrary("Xinerama");
            raylib.linkSystemLibrary("Xi");
            raylib.linkSystemLibrary("Xxf86vm");
            raylib.linkSystemLibrary("Xcursor");

            raylib.defineCMacro("PLATFORM_DESKTOP", null);
        },
        else => {
            @panic("Unsupported OS");
        },
    }

    return raylib;
}

const raylib_flags = &[_][]const u8{
    "-std=gnu99",
    "-D_GNU_SOURCE",
    "-DGL_SILENCE_DEPRECATION=199309L",
    "-fno-sanitize=undefined", // https://github.com/raysan5/raylib/issues/1891
};

const raylib_source_files = [_][]const u8{
    "raudio.c",
    "rcore.c",
    "rmodels.c",
    "rshapes.c",
    "rtext.c",
    "rtextures.c",
    "utils.c",
};
