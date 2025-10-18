const std = @import("std");

const Application = struct {
            
};

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const mod = b.addModule("minifb", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });

    const default_backend: []const u8 = switch (target.result.os.tag) {
        .windows => "windows",
        .macos => "macos",
        .linux => "x11",
        else => "x11",
    };
    const minifb_src_dir = "external/minifb/src";
    var cFiles: std.ArrayList([]const u8) = .{};
    try collectFiles(b.allocator, &cFiles, minifb_src_dir, default_backend);
    defer cFiles.deinit(b.allocator);
    
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
    
    exe.addCSourceFiles(.{
       .files = cFiles.items,
       .flags = &.{ "-std=c11", "-Wall", "-Wextra", "-Wno-switch", "-Wno-unused-function", "-Wno-unused-parameter", "-Wno-implicit-fallthrough", "-D_POSIX_C_SOURCE=199309L", "-D_XOPEN_SOURCE=600"},
    });
    
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

fn collectFiles(allocator: std.mem.Allocator, endBuffer:*std.ArrayList([]const u8), path: []const u8, whitelist: []const u8) !void {
     var iterable_dir = std.fs.cwd().openDir(path, .{
        .iterate = true,
        .access_sub_paths = true,
    }) catch @panic("failed to open dir");
    defer iterable_dir.close();

    var it = iterable_dir.iterate();
    while (try it.next()) |entry| {
        const extendedPath = try std.fs.path.join(allocator, &.{path, entry.name});
        if(entry.kind == .file and (std.mem.endsWith(u8, entry.name, ".c") )) {
            try endBuffer.append(allocator, extendedPath);
        } else if (entry.kind == .directory and std.mem.endsWith(u8, entry.name, whitelist)) {
            try collectFiles(allocator, endBuffer, extendedPath, whitelist); 
        }
    }
}
