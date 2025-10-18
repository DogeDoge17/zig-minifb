const minifb = @import("root.zig");

pub fn main() !void {

    var noise:u32 = 0;
    var carry:u32 = 0;
    var seed:u32 = 0xbeef;

    var window = minifb.Window.openEx("Noise Display", 800, 600, .resizable) catch |err| {
        std.debug.print("Failed to open window: {}\n", .{err});
        return err;
    };

    const buffer: []u32 = try std.heap.page_allocator.alloc(u32, 800 * 600);
    defer std.heap.page_allocator.free(buffer);

    while (true) {
        for (0..buffer.len) |i| {
            noise = seed;
            noise >>= 3;
            noise ^= seed;
            carry = noise & 1;
            noise >>= 1;
            seed >>= 1;
            seed |= carry << 30;
            noise &= 0xFF;
            buffer[i] = (0xff << 32) | (noise << 16) | (noise << 8) | noise;
        }

        const state = window.updateEx(buffer, 800, 600);
        if (state < 0) {
            break;
        }

        if (!window.waitSync()) break;
    }
}
