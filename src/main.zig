const std = @import("std");
const minifb = @import("root.zig");

pub fn main() !void{
    var window = minifb.Window.open("my display", 800, 600) catch |err| {
        std.debug.print("Failed to open window: {}\n", .{err});
        return err;
    };

    const buffer:[]u32 = try std.heap.page_allocator.alloc(u32, 800 * 600);
    defer std.heap.page_allocator.free(buffer);
    while (true) {
        const state = window.updateEx(buffer, 800, 600);
        if (state < 0) {
            break;
        }
        
        if(!window.waitSync()) break;
    }
}
