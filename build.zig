const std = @import("std");
const CompileStep = std.Build.CompileStep;
const Build = std.Build;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const raylib = buildRaylib(b, target, optimize);
    const zigrl = b.createModule(.{ .source_file = .{ .path = "src/raylib.zig" } });

    const tests = b.addTest(.{ .root_source_file = .{ .path = "src/raylib.zig" } });
    tests.linkLibC();
    tests.linkLibrary(raylib);

    const run_unit_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run zigrl tests");
    test_step.dependOn(&run_unit_tests.step);

    // Examples
    b.installDirectory(.{ .source_dir = "examples/resources", .install_dir = std.Build.InstallDir.bin, .install_subdir = "resources" });
    for (examples) |example| {
        const path = std.fs.path.join(b.allocator, &.{ "examples", example.path }) catch unreachable;
        var text: [64:0]u8 = undefined;
        const step_name = std.fmt.bufPrintZ(&text, "example_{s}", .{example.path}) catch unreachable;
        const exe = b.addExecutable(.{ .name = step_name, .root_source_file = .{ .path = path }, .target = target, .optimize = optimize });
        exe.linkLibC();
        exe.linkLibrary(raylib);
        exe.addModule("zray", zigrl);
        b.installArtifact(exe);

        const run_example = b.addRunArtifact(exe);
        run_example.step.dependOn(b.getInstallStep());
        const run_step = b.step(step_name, example.display_name);
        run_step.dependOn(&run_example.step);
    }

    const all_examples_step = b.step("examples", "Build All Examples");
    all_examples_step.dependOn(b.getInstallStep());
}

pub fn buildRaylib(b: *std.Build, target: std.zig.CrossTarget, optimize: std.builtin.Mode) *CompileStep {
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

const Example = struct {
    path: []const u8,
    display_name: []const u8,
};

const examples = [_]Example{
    .{ .path = "basic_window.zig", .display_name = "Core: Basic Window" },
    .{ .path = "input_keys.zig", .display_name = "Core: Input Keys" },
    .{ .path = "input_mouse.zig", .display_name = "Core: Input Mouse" },
    .{ .path = "2d_camera.zig", .display_name = "Core: 2D Camera" },
    .{ .path = "2d_camera_platformer.zig", .display_name = "Core: 2D Camera Platformer" },
    .{ .path = "smooth_pixelperfect.zig", .display_name = "Core: Smooth Pixelperfect" },
    .{ .path = "logo_raylib.zig", .display_name = "Textures: Logo Raylib" },
    .{ .path = "npatch_drawing.zig", .display_name = "Textures: NPatch Drawing" },
};
