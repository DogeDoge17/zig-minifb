const std = @import("std");

const c = @cImport({
    @cInclude("MiniFB.h");
});

pub const WindowFlags = enum(u8) {
    resizable          = 0x01,
    fullscreen         = 0x02,
    fullscreen_desktop = 0x04,
    borderless         = 0x08,
    always_on_top      = 0x10,
};

pub const Window = struct {
    ptr: *c.struct_mfb_window,

    pub fn open(title: [:0]const u8, width: u32, height: u32) !Window {
        const raw = c.mfb_open_ex(title.ptr, width, height, 0);
        if (raw == null) return error.OpenFailed;
        return .{ .ptr = raw.? };
    }

    pub fn update(self: *Window, pixels: []const u32) c.mfb_update_state {
        return c.mfb_update(self.ptr, pixels.ptr);
    }

    pub fn updateEvents(self: *Window) void {
        _ = c.mfb_update_events(self.ptr);
    }

    pub fn close(self: *Window) void {
        _ = c.mfb_close(self.ptr);
    }

    pub fn setUserData(self: *Window, data: ?*anyopaque) void {
        c.mfb_set_user_data(self.ptr, data);
    }

    pub fn getUserData(self: *Window) ?*anyopaque {
        return c.mfb_get_user_data(self.ptr);
    }
    pub fn updateEx(self: *Window, pixels: []const u32, width: u32, height: u32) c.mfb_update_state {
        return c.mfb_update_ex(self.ptr, @as(?*anyopaque, @ptrCast(@constCast(pixels.ptr))), width, height);
    }

    pub fn setViewport(self: *Window, offset_x: u32, offset_y: u32, width: u32, height: u32) bool {
        return c.mfb_set_viewport(self.ptr, offset_x, offset_y, width, height);
    }

    pub fn setViewportBestFit(self: *Window, old_width: u32, old_height: u32) bool {
        return c.mfb_set_viewport_best_fit(self.ptr, old_width, old_height);
    }

    pub fn getMonitorScale(self: *Window) struct { x: f32, y: f32 } {
        var sx: f32 = 0;
        var sy: f32 = 0;
        c.mfb_get_monitor_scale(self.ptr, &sx, &sy);
        return .{ .x = sx, .y = sy };
    }

    pub fn isActive(self: *Window) bool {
        return c.mfb_is_window_active(self.ptr);
    }

    pub fn getWidth(self: *Window) u32 {
        return c.mfb_get_window_width(self.ptr);
    }

    pub fn getHeight(self: *Window) u32 {
        return c.mfb_get_window_height(self.ptr);
    }

    pub fn getMouseX(self: *Window) i32 {
        return c.mfb_get_mouse_x(self.ptr);
    }

    pub fn getMouseY(self: *Window) i32 {
        return c.mfb_get_mouse_y(self.ptr);
    }

    pub fn getMouseScrollX(self: *Window) f32 {
        return c.mfb_get_mouse_scroll_x(self.ptr);
    }

    pub fn getMouseScrollY(self: *Window) f32 {
        return c.mfb_get_mouse_scroll_y(self.ptr);
    }

    pub fn getMouseButtonBuffer(self: *Window) ?[*c]const u8 {
        return c.mfb_get_mouse_button_buffer(self.ptr);
    }

    pub fn getKeyBuffer(self: *Window) ?[*c]const u8 {
        return c.mfb_get_key_buffer(self.ptr);
    }

    pub fn waitSync(self: *Window) bool {
        return c.mfb_wait_sync(self.ptr);
    }

    pub fn onActive(self: *Window, cb: ?c.mfb_active_func) void {
        c.mfb_set_active_callback(self.ptr, cb);
    }

    pub fn onResize(self: *Window, cb: ?c.mfb_resize_func) void {
        c.mfb_set_resize_callback(self.ptr, cb);
    }

    pub fn onClose(self: *Window, cb: ?c.mfb_close_func) void {
        c.mfb_set_close_callback(self.ptr, cb);
    }

    pub fn onKeyboard(self: *Window, cb: ?c.mfb_keyboard_func) void {
        c.mfb_set_keyboard_callback(self.ptr, cb);
    }

    pub fn onCharInput(self: *Window, cb: ?c.mfb_char_input_func) void {
        c.mfb_set_char_input_callback(self.ptr, cb);
    }

    pub fn onMouseButton(self: *Window, cb: ?c.mfb_mouse_button_func) void {
        c.mfb_set_mouse_button_callback(self.ptr, cb);
    }

    pub fn onMouseMove(self: *Window, cb: ?c.mfb_mouse_move_func) void {
        c.mfb_set_mouse_move_callback(self.ptr, cb);
    }

    pub fn onMouseScroll(self: *Window, cb: ?c.mfb_mouse_scroll_func) void {
        c.mfb_set_mouse_scroll_callback(self.ptr, cb);
    }
};

