const std = @import("std");

const BuildWHATEVER = struct {
    cfiles: []const []const u8,
    flags: []const []const u8,
};

const cPath = "src/";
fn getPlatformOptions(target: std.Target, wayland: bool) BuildWHATEVER {
    const notWindows = &.{ "-std=c11", "-Wall", "-Wextra", "-Wno-switch", "-Wno-unused-function", "-Wno-unused-parameter", "-Wno-implicit-fallthrough", "-D_POSIX_C_SOURCE=199309L", "-D_XOPEN_SOURCE=600" };

    return switch (target.os.tag) {
        .windows => .{
            .cfiles = &.{ cPath ++ "windows/WinMiniFB.c", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c" },
            .flags = &.{ "-std=c11", "-Wall", "-Wextra", "-Wno-switch", "-Wno-unused-function", "-Wno-unused-parameter", "-Wno-implicit-fallthrough", "-DWIN32", "-D_CRT_SECURE_NO_WARNINGS", "-D_CRT_SECURE_NO_WARNINGS" },
        },
        .macos => .{
            .cfiles = &.{ cPath ++ "macos/MacMiniFB.m", cPath ++ "macos/OSXView.m", cPath ++ "macos/OSXWindow.m", cPath ++ "macos/OSXViewDelegate.m", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c" },
            .flags = notWindows,
        },
        .linux => .{
            .cfiles = if (!wayland) &.{ cPath ++ "x11/X11MiniFB.c", cPath ++ "MiniFB_linux.c", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c" } else &.{ cPath ++ "wayland/generated/xdg-shell-protocol.c", cPath ++ "wayland/WaylandMiniFB.c", cPath ++ "MiniFB_linux.c", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c" },
            .flags = notWindows,
        },
        else => .{
            .cfiles = &.{ cPath ++ "x11/X11MiniFB.c", cPath ++ "MiniFB_linux.c", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c" },
            .flags = notWindows,
        },
    };
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const minifb_mod = b.addModule("minifb", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    minifb_mod.addIncludePath(b.path("src/include"));
    minifb_mod.addIncludePath(b.path("src"));

    const lib = b.addLibrary(.{
        .name = "minifb",
        .root_module = minifb_mod,
        .linkage = .static,
    });

    const wayland = b.option(bool, "wayland", "Build for Wayland instead of X11") orelse false;
    const linkOptions = getPlatformOptions(target.result, wayland);

    lib.root_module.addCSourceFiles(.{ .files = linkOptions.cfiles, .flags = linkOptions.flags });
    lib.root_module.addIncludePath(b.path("src/include"));
    lib.root_module.addIncludePath(b.path("src"));
    lib.root_module.link_libc = true;

    switch (target.result.os.tag) {
        .linux => {
            if (wayland) {
                lib.root_module.linkSystemLibrary("wayland-client", .{});
                lib.root_module.linkSystemLibrary("wayland-cursor", .{});
                lib.root_module.linkSystemLibrary("wayland-egl", .{});
            } else lib.root_module.linkSystemLibrary("X11", .{});
        },
        .windows => {
            lib.root_module.linkSystemLibrary("gdi32", .{});
            lib.root_module.linkSystemLibrary("user32", .{});
            lib.root_module.linkSystemLibrary("winmm", .{});
        },
        .macos => {
            lib.root_module.linkFramework("Cocoa", .{});
            lib.root_module.linkFramework("QuartzCore", .{});
            lib.root_module.linkFramework("OpenGL", .{});
        },
        else => {},
    }

    b.installArtifact(lib);

    const exe = b.addExecutable(.{
        .name = "zig_minifb",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .imports = &.{.{ .name = "minifb", .module = minifb_mod }},
        }),
    });
    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| run_cmd.addArgs(args);

    const mod_tests = b.addTest(.{ .root_module = minifb_mod });
    const run_mod_tests = b.addRunArtifact(mod_tests);
    const exe_tests = b.addTest(.{ .root_module = exe.root_module });
    const run_exe_tests = b.addRunArtifact(exe_tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
