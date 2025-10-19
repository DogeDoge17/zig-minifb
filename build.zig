const std = @import("std");

const BuildWHATEVER = struct {
    cfiles: []const []const u8,
    flags: []const []const u8,
};

const cPath = "external/minifb/src/";
fn getPlatformOptions(target: std.Target ) BuildWHATEVER {
    const notWindows = &.{ "-std=c11","-Wall", "-Wextra", "-Wno-switch", "-Wno-unused-function", "-Wno-unused-parameter", "-Wno-implicit-fallthrough", "-D_POSIX_C_SOURCE=199309L", "-D_XOPEN_SOURCE=600" };

    return switch (target.os.tag) {
        .windows => .{
            .cfiles = &.{ cPath ++ "windows/WinMiniFB.c", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c" },
            .flags = &.{ "-DWIN32", "-D_CRT_SECURE_NO_WARNINGS", "-D_CRT_SECURE_NO_WARNINGS", "/GS", "/Gy", "/fp:fast", },
        },
        .macos => .{
            .cfiles = &.{ cPath ++ "macos/MacMiniFB.m", cPath ++ "macos/OSXView.m", cPath ++ "macos/OSXWindow.m", cPath ++ "macos/OSXViewDelegate.m", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c"},
            .flags = notWindows,
        },
        .linux => .{ 
            .cfiles = &.{ cPath ++ "x11/X11MiniFB.c", cPath ++ "MiniFB_linux.c", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c" },
            .flags = notWindows,
        },
        else => .{
            .cfiles = &.{ cPath ++ "x11/X11MiniFB.c",  cPath ++ "MiniFB_linux.c", cPath ++ "MiniFB_common.c", cPath ++ "MiniFB_internal.c", cPath ++ "MiniFB_timer.c"},
            .flags = notWindows,
        },
    };
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const mod = b.addModule("minifb", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

    std.log.info("Current working directory: {s}", .{
        try std.fs.cwd().realpathAlloc(b.allocator, "."),
    });
    
    const exe = b.addExecutable(.{
        .name = "zig_minifb",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .imports = &.{
                .{ .name = "minifb", .module = mod },
            },
        }),
    });

    exe.linkLibC();
    exe.linkSystemLibrary("X11");

    const linkOptions = getPlatformOptions(target.result);
    
    for(linkOptions.cfiles) |cfile| {
        std.log.info("Adding C source file: {s}", .{cfile});
    }

    exe.addCSourceFiles(.{
       .files = linkOptions.cfiles,
       .flags = linkOptions.flags
    });

    // &.{ "-std=c11", "-Wall", "-Wextra", "-Wno-switch", "-Wno-unused-function", "-Wno-unused-parameter", "-Wno-implicit-fallthrough", "-D_POSIX_C_SOURCE=199309L", "-D_XOPEN_SOURCE=600"},

    exe.addIncludePath(b.path("external/minifb/include"));
    exe.addIncludePath(b.path("external/minifb/src"));

    b.installArtifact(exe);

    const run_step = b.step("run", "Run the app");

    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    const run_exe_tests = b.addRunArtifact(exe_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
}
