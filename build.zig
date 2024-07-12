const std = @import("std");
const builtin = @import("builtin");
const path = std.fs.path;
const isWindows = builtin.os.tag == .windows;

// const imgui_build = @import("zig-imgui/imgui_build.zig");

const glslc_command = if (builtin.os.tag == .windows) "tools/win/glslc.exe" else "glslc";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // imgui_build.addTestStep(b, "test", optimize, target);

    const test_exe = b.addTest(.{
        .root_source_file = b.path("zig-imgui/imgui.zig"),
        .target = target,
        .optimize = optimize,
    });

    const runExeTests = b.addRunArtifact(test_exe);
    const testStep = b.step("test", "Run exe tests");
    testStep.dependOn(&runExeTests.step);

    {
        const exe = exampleExe(b, "example_glfw_vulkan", optimize, target);
        linkGlfw(exe, target);
        linkVulkan(exe);
    }
    {
        const exe = exampleExe(b, "example_glfw_opengl3", optimize, target);
        exe.linkLibC();
        linkGlfw(exe, target);
        linkGlad(exe, b);
    }
}

fn exampleExe(b: *std.Build, comptime name: []const u8, optimize: std.builtin.Mode, target: std.Build.ResolvedTarget) *std.Build.Step.Compile {
    // const exe = b.addExecutable(name, "examples/" ++ name ++ ".zig");
    const exe = b.addExecutable(.{
        .name = "example " ++ name,
        .root_source_file = b.path("examples/" ++ name ++ ".zig"),
        .target = target,
        .optimize = optimize,
    });
    // exe.setTarget(target);
    // imgui_build.link(exe);
    // exe.install();
    b.installArtifact(exe);

    const run_step = b.step(name, "Run " ++ name);
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    return exe;
}

fn linkGlad(exe: *std.Build.Step.Compile, b: *std.Build) void {
    const flags = [_][]const u8{"-std=c99"};
    exe.addIncludePath(b.path("examples/include/c_include"));
    exe.addCSourceFile(.{ .file = b.path("examples/c_src/glad.c"), .flags = &flags });
    // exe.addLibraryPath(b.path(b.path("/run/opengl-driver/lib").cwd_relative));
    // exe.addLibraryPath(.{ .cwd_relative = "/run/opengl-driver/lib" });
    exe.linkSystemLibrary("OpenGL");
}

fn linkGlfw(exe: *std.Build.Step.Compile, target: std.Build.ResolvedTarget) void {
    if (isWindows) {
        exe.addObjectFile(if (target.getAbi() == .msvc) "examples/lib/win/glfw3.lib" else "examples/lib/win/libglfw3.a");
        exe.linkSystemLibrary("gdi32");
        exe.linkSystemLibrary("shell32");
    } else {
        exe.linkSystemLibrary("glfw");
    }
}

fn linkVulkan(exe: *std.Build.Step.Compile) void {
    if (isWindows) {
        exe.addObjectFile("examples/lib/win/vulkan-1.lib");
    } else {
        exe.linkSystemLibrary("vulkan");
    }
}
