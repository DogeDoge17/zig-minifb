const std = @import("std");

pub const c = @cImport({
    @cInclude("MiniFB.h");
});

pub fn argb(a: u32, r: u32, g: u32, b: u32) u32 {
    return ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
}

pub const UpdateState = enum(c.mfb_update_state){
    ok             = c.STATE_OK, 
    exit           = c.STATE_EXIT,
    invalid_window = c.STATE_INVALID_WINDOW,
    invalid_buffer = c.STATE_INVALID_BUFFER,
    internal_error = c.STATE_INTERNAL_ERROR,
};

pub const WindowFlags = enum(c.mfb_window_flags) {
    resizable          = c.WF_RESIZABLE,
    fullscreen         = c.WF_FULLSCREEN,
    fullscreen_desktop = c.WF_FULLSCREEN_DESKTOP,
    borderless         = c.WF_BORDERLESS,
    always_on_top      = c.WF_ALWAYS_ON_TOP,
};

pub const MouseButton = enum(c.mfb_mouse_button) {
    /// No mouse button  
    Btn0 = c.MOUSE_BTN_0,
    /// Left mouse button
    Btn1 = c.MOUSE_BTN_1,
    /// Right mouse button
    Btn2 = c.MOUSE_BTN_2,
    /// Middle mouse button
    Btn3 = c.MOUSE_BTN_3,
    Btn4 = c.MOUSE_BTN_4,
    Btn5 = c.MOUSE_BTN_5,
    Btn6 = c.MOUSE_BTN_6,
    Btn7 = c.MOUSE_BTN_7,
};
pub const Key = enum(c.mfb_key) {
    Unknown       = c.KB_KEY_UNKNOWN,
    Space         = c.KB_KEY_SPACE,
    Apostrophe    = c.KB_KEY_APOSTROPHE,
    Comma         = c.KB_KEY_COMMA,
    Minus         = c.KB_KEY_MINUS,
    Period        = c.KB_KEY_PERIOD,
    Slash         = c.KB_KEY_SLASH,
    Num0          = c.KB_KEY_0,
    Num1          = c.KB_KEY_1,
    Num2          = c.KB_KEY_2,
    Num3          = c.KB_KEY_3,
    Num4          = c.KB_KEY_4,
    Num5          = c.KB_KEY_5,
    Num6          = c.KB_KEY_6,
    Num7          = c.KB_KEY_7,
    Num8          = c.KB_KEY_8,
    Num9          = c.KB_KEY_9,
    Semicolon     = c.KB_KEY_SEMICOLON,
    Equal         = c.KB_KEY_EQUAL,
    A             = c.KB_KEY_A,
    B             = c.KB_KEY_B,
    C             = c.KB_KEY_C,
    D             = c.KB_KEY_D,
    E             = c.KB_KEY_E,
    F             = c.KB_KEY_F,
    G             = c.KB_KEY_G,
    H             = c.KB_KEY_H,
    I             = c.KB_KEY_I,
    J             = c.KB_KEY_J,
    K             = c.KB_KEY_K,
    L             = c.KB_KEY_L,
    M             = c.KB_KEY_M,
    N             = c.KB_KEY_N,
    O             = c.KB_KEY_O,
    P             = c.KB_KEY_P,
    Q             = c.KB_KEY_Q,
    R             = c.KB_KEY_R,
    S             = c.KB_KEY_S,
    T             = c.KB_KEY_T,
    U             = c.KB_KEY_U,
    V             = c.KB_KEY_V,
    W             = c.KB_KEY_W,
    X             = c.KB_KEY_X,
    Y             = c.KB_KEY_Y,
    Z             = c.KB_KEY_Z,
    LeftBracket   = c.KB_KEY_LEFT_BRACKET,
    Backslash     = c.KB_KEY_BACKSLASH,
    RightBracket  = c.KB_KEY_RIGHT_BRACKET,
    GraveAccent   = c.KB_KEY_GRAVE_ACCENT,
    World1        = c.KB_KEY_WORLD_1,
    World2        = c.KB_KEY_WORLD_2,
    Escape        = c.KB_KEY_ESCAPE,
    Enter         = c.KB_KEY_ENTER,
    Tab           = c.KB_KEY_TAB,
    Backspace     = c.KB_KEY_BACKSPACE,
    Insert        = c.KB_KEY_INSERT,
    Delete        = c.KB_KEY_DELETE,
    Right         = c.KB_KEY_RIGHT,
    Left          = c.KB_KEY_LEFT,
    Down          = c.KB_KEY_DOWN,
    Up            = c.KB_KEY_UP,
    PageUp        = c.KB_KEY_PAGE_UP,
    PageDown      = c.KB_KEY_PAGE_DOWN,
    Home          = c.KB_KEY_HOME,
    End           = c.KB_KEY_END,
    CapsLock      = c.KB_KEY_CAPS_LOCK,
    ScrollLock    = c.KB_KEY_SCROLL_LOCK,
    NumLock       = c.KB_KEY_NUM_LOCK,
    PrintScreen   = c.KB_KEY_PRINT_SCREEN,
    Pause         = c.KB_KEY_PAUSE,
    F1            = c.KB_KEY_F1,
    F2            = c.KB_KEY_F2,
    F3            = c.KB_KEY_F3,
    F4            = c.KB_KEY_F4,
    F5            = c.KB_KEY_F5,
    F6            = c.KB_KEY_F6,
    F7            = c.KB_KEY_F7,
    F8            = c.KB_KEY_F8,
    F9            = c.KB_KEY_F9,
    F10           = c.KB_KEY_F10,
    F11           = c.KB_KEY_F11,
    F12           = c.KB_KEY_F12,
    F13           = c.KB_KEY_F13,
    F14           = c.KB_KEY_F14,
    F15           = c.KB_KEY_F15,
    F16           = c.KB_KEY_F16,
    F17           = c.KB_KEY_F17,
    F18           = c.KB_KEY_F18,
    F19           = c.KB_KEY_F19,
    F20           = c.KB_KEY_F20,
    F21           = c.KB_KEY_F21,
    F22           = c.KB_KEY_F22,
    F23           = c.KB_KEY_F23,
    F24           = c.KB_KEY_F24,
    F25           = c.KB_KEY_F25,
    Kp0           = c.KB_KEY_KP_0,
    Kp1           = c.KB_KEY_KP_1,
    Kp2           = c.KB_KEY_KP_2,
    Kp3           = c.KB_KEY_KP_3,
    Kp4           = c.KB_KEY_KP_4,
    Kp5           = c.KB_KEY_KP_5,
    Kp6           = c.KB_KEY_KP_6,
    Kp7           = c.KB_KEY_KP_7,
    Kp8           = c.KB_KEY_KP_8,
    Kp9           = c.KB_KEY_KP_9,
    KpDecimal     = c.KB_KEY_KP_DECIMAL,
    KpDivide      = c.KB_KEY_KP_DIVIDE,
    KpMultiply    = c.KB_KEY_KP_MULTIPLY,
    KpSubtract    = c.KB_KEY_KP_SUBTRACT,
    KpAdd         = c.KB_KEY_KP_ADD,
    KpEnter       = c.KB_KEY_KP_ENTER,
    KpEqual       = c.KB_KEY_KP_EQUAL,
    LeftShift     = c.KB_KEY_LEFT_SHIFT,
    LeftControl   = c.KB_KEY_LEFT_CONTROL,
    LeftAlt       = c.KB_KEY_LEFT_ALT,
    LeftSuper     = c.KB_KEY_LEFT_SUPER,
    RightShift    = c.KB_KEY_RIGHT_SHIFT,
    RightControl  = c.KB_KEY_RIGHT_CONTROL,
    RightAlt      = c.KB_KEY_RIGHT_ALT,
    RightSuper    = c.KB_KEY_RIGHT_SUPER,
    Menu          = c.KB_KEY_MENU,
};
pub const KeyMod = enum(c.mfb_key_mod) { 
    Shift = c.KB_MOD_SHIFT, 
    Control = c.KB_MOD_CONTROL, 
    Alt = c.KB_MOD_ALT, 
    Super = c.KB_MOD_SUPER, 
    CapsLock = c.KB_MOD_CAPS_LOCK,
    NumLock = c.KB_MOD_NUM_LOCK,
};

pub const cWindow = c.struct_mfb_window;
pub const Window = struct {
    ptr: *c.struct_mfb_window,

    pub fn open(title: [:0]const u8, width: u32, height: u32) !Window {
        const raw = c.mfb_open(title.ptr, width, height);
        if (raw == null) return error.OpenFailed;
        return .{ .ptr = raw.? };
    }

    pub fn openEx(title: [:0]const u8, width: u32, height: u32, flags: WindowFlags) !Window {
        const raw = c.mfb_open_ex(title.ptr, width, height, @as(c_uint, @intFromEnum(flags)));
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

    const active_func = *const fn(window: *c.struct_mfb_window, is_active: bool) callconv(.c) void;
    pub fn onActive(self: *Window, cb: ?active_func) void {
        c.mfb_set_active_callback(self.ptr, @as(c.mfb_active_func, @ptrCast(@constCast(cb))));
    }

    const resize_func = *const fn(window: *c.struct_mfb_window, width: i32, height: i32) callconv(.c) void;
    pub fn onResize(self: *Window, cb: ?resize_func) void {
        c.mfb_set_resize_callback(self.ptr, @as(c.mfb_resize_func, @ptrCast(@constCast(cb))));
    }

    const close_func = *const fn(window: *c.struct_mfb_window) callconv(.c) bool;
    pub fn onClose(self: *Window, cb: ?close_func) void {
        c.mfb_set_close_callback(self.ptr, @as(c.mfb_close_func, @ptrCast(@constCast(cb))));
    }

    const keyboard_func = *const fn(window: *c.struct_mfb_window, key: Key, mod: KeyMod, pressed: c.bool) callconv(.c) void;
    pub fn onKeyboard(self: *Window, cb: ?keyboard_func) void {
        c.mfb_set_keyboard_callback(self.ptr, @as(c.mfb_keyboard_func ,@ptrCast(@constCast(cb))));
    }

    const char_input_func = *const fn(window: *c.struct_mfb_window, code: i32) callconv(.c) void;
    pub fn onCharInput(self: *Window, cb: ?char_input_func) void {
        c.mfb_set_char_input_callback(self.ptr, @as(c.mfb_char_input_func, @ptrCast(@constCast(cb))));
    }

    const mouse_button_func = *const fn(window: *c.struct_mfb_window, button: MouseButton, mod: KeyMod, is_pressed: bool) callconv(.c) void;
    pub fn onMouseButton(self: *Window, cb: ?mouse_button_func) void {
        c.mfb_set_mouse_button_callback(self.ptr, @as(c.mfb_mouse_button_func, @ptrCast(@constCast(cb))));
    }

    const mouse_move_func = *const fn(window: *c.struct_mfb_window, x: i32, y: i32) callconv(.c) void;
    pub fn onMouseMove(self: *Window, cb: ?mouse_move_func) void {
        c.mfb_set_mouse_move_callback(self.ptr, @as(c.mfb_mouse_move_func, @ptrCast(@constCast(cb))));
    }

    const mouse_scroll_func = *const fn(window: *c.struct_mfb_window, mod: KeyMod, delta_x: f32, delta_y: f32) callconv(.c) void;
    pub fn onMouseScroll(self: *Window, cb: ?mouse_scroll_func) void {
        c.mfb_set_mouse_scroll_callback(self.ptr, @as(c.mfb_mouse_scroll_func, @ptrCast(@constCast(cb))));
    }
};
