const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
});

const core = @import("core.zig");
pub const initWindow = core.initWindow;
pub const windowShouldClose = core.windowShouldClose;
pub const closeWindow = core.closeWindow;

pub const clearBackground = core.clearBackground;
pub const beginDrawing = core.beginDrawing;
pub const endDrawing = core.endDrawing;
pub const beginMode2D = core.beginMode2D;
pub const endMode2D = core.endMode2D;

pub const getScreenToWorld2D = core.getScreenToWorld2D;
pub const getWorldToScreen2D = core.getWorldToScreen2D;

pub const setTargetFPS = core.setTargetFPS;
pub const getFrameTime = core.getFrameTime;

pub const getRandomValue = core.getRandomValue;

pub const isKeyPressed = core.isKeyPressed;
pub const isKeyDown = core.isKeyDown;

pub const isMouseButtonPressed = core.isMouseButtonPressed;
pub const getMousePosition = core.getMousePosition;
pub const getMouseWheelMove = core.getMouseWheelMove;

const textures = @import("textures.zig");
pub const NPatchLayout = textures.NPatchLayout;
pub const PixelFormat = textures.PixelFormat;
pub const Texture = textures.Texture;
pub const Texture2D = Texture;

//-----------------
// Structs
//-----------------
pub const Color = packed struct {
    pub const light_gray = .{ .r = 200, .g = 200, .b = 200, .a = 255 };
    pub const gray = .{ .r = 130, .g = 130, .b = 130, .a = 255 };
    pub const dark_gray = .{ .r = 80, .g = 80, .b = 80, .a = 255 };
    pub const yellow = .{ .r = 253, .g = 249, .b = 0, .a = 255 };
    pub const gold = .{ .r = 255, .g = 203, .b = 0, .a = 255 };
    pub const orange = .{ .r = 255, .g = 161, .b = 0, .a = 255 };
    pub const pink = .{ .r = 255, .g = 109, .b = 194, .a = 255 };
    pub const red = .{ .r = 230, .g = 41, .b = 55, .a = 255 };
    pub const maroon = .{ .r = 190, .g = 33, .b = 55, .a = 255 };
    pub const green = .{ .r = 0, .g = 228, .b = 48, .a = 255 };
    pub const lime = .{ .r = 0, .g = 158, .b = 47, .a = 255 };
    pub const darkgreen = .{ .r = 0, .g = 117, .b = 44, .a = 255 };
    pub const sky_blue = .{ .r = 102, .g = 191, .b = 255, .a = 255 };
    pub const blue = .{ .r = 0, .g = 121, .b = 241, .a = 255 };
    pub const dark_blue = .{ .r = 0, .g = 82, .b = 172, .a = 255 };
    pub const purple = .{ .r = 200, .g = 122, .b = 255, .a = 255 };
    pub const violet = .{ .r = 135, .g = 60, .b = 190, .a = 255 };
    pub const dark_purple = .{ .r = 112, .g = 31, .b = 126, .a = 255 };
    pub const beige = .{ .r = 211, .g = 176, .b = 131, .a = 255 };
    pub const brown = .{ .r = 127, .g = 106, .b = 79, .a = 255 };
    pub const dark_brown = .{ .r = 76, .g = 63, .b = 47, .a = 255 };

    pub const white = .{ .r = 255, .g = 255, .b = 255, .a = 255 };
    pub const black = .{ .r = 0, .g = 0, .b = 0, .a = 255 };
    /// Blank (Transparent)
    pub const blank = .{ .r = 0, .g = 0, .b = 0, .a = 0 };
    pub const magenta = .{ .r = 255, .g = 0, .b = 255, .a = 255 };
    /// My own White (raylib logo)
    pub const ray_white = .{ .r = 245, .g = 245, .b = 245, .a = 255 };

    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

pub const Rectangle = packed struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,
};

pub const Vector2 = packed struct {
    x: f32,
    y: f32,

    pub fn add(self: Vector2, other: Vector2) Vector2 {
        return .{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn subtract(self: Vector2, other: Vector2) Vector2 {
        return .{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn scale(self: Vector2, scalar: f32) Vector2 {
        return .{ .x = self.x * scalar, .y = self.y * scalar };
    }

    pub fn length(self: Vector2) f32 {
        return std.math.sqrt(self.lengthSqr());
    }

    pub fn lengthSqr(self: Vector2) f32 {
        return self.x * self.x + self.y * self.y;
    }
};

pub fn drawText(text: []const u8, x: i32, y: i32, font_size: i32, color: Color) void {
    c.DrawText(@ptrCast([*c]const u8, text), x, y, font_size, @bitCast(c.struct_Color, color));
}

pub fn drawCircleV(position: Vector2, radius: f32, color: Color) void {
    c.DrawCircleV(@bitCast(c.struct_Vector2, position), radius, @bitCast(c.struct_Color, color));
}

pub const Camera2D = packed struct {
    offset: Vector2,
    target: Vector2,
    rotation: f32,
    zoom: f32,
};

pub fn drawRectangle(x: i32, y: i32, width: i32, height: i32, color: Color) void {
    const converted_color = @bitCast(c.struct_Color, color);
    c.DrawRectangle(x, y, width, height, converted_color);
}

pub fn drawRectangleLines(x: i32, y: i32, width: i32, height: i32, color: Color) void {
    const converted_color = @bitCast(c.struct_Color, color);
    c.DrawRectangleLines(x, y, width, height, converted_color);
}

pub fn drawRectangleRec(rec: Rectangle, color: Color) void {
    const converted_color = @bitCast(c.struct_Color, color);
    const converted_rec = @bitCast(c.struct_Rectangle, rec);
    c.DrawRectangleRec(converted_rec, converted_color);
}

pub fn drawLine(start_pos_x: i32, start_pos_y: i32, end_pos_x: i32, end_pos_y: i32, color: Color) void {
    const converted_color = @bitCast(c.struct_Color, color);
    c.DrawLine(start_pos_x, start_pos_y, end_pos_x, end_pos_y, converted_color);
}

pub fn fade(color: Color, alpha: f32) Color {
    const converted_input = @bitCast(c.struct_Color, color);
    const c_result = c.Fade(converted_input, alpha);
    return @bitCast(Color, c_result);
}

pub const Key = enum(i32) {
    // Alphanumeric keys
    /// Key: '
    apostrophe = 39,
    /// Key: ,
    comma = 44,
    /// Key: -
    minus = 45,
    /// Key: .
    period = 46,
    /// Key: /
    slash = 47,
    /// Key: 0
    zero = 48,
    /// Key: 1
    one = 49,
    /// Key: 2
    two = 50,
    /// Key: 3
    three = 51,
    /// Key: 4
    four = 52,
    /// Key: 5
    five = 53,
    /// Key: 6
    six = 54,
    /// Key: 7
    seven = 55,
    /// Key: 8
    eight = 56,
    /// Key: 9
    nine = 57,
    /// Key: ;
    semicolon = 59,
    /// Key: =
    equal = 61,
    /// Key: A | a
    a = 65,
    /// Key: B | b
    b = 66,
    /// Key: C | c
    c = 67,
    /// Key: D | d
    d = 68,
    /// Key: E | e
    e = 69,
    /// Key: F | f
    f = 70,
    /// Key: G | g
    g = 71,
    /// Key: H | h
    h = 72,
    /// Key: I | i
    i = 73,
    /// Key: J | j
    j = 74,
    /// Key: K | k
    k = 75,
    /// Key: L | l
    l = 76,
    /// Key: M | m
    m = 77,
    /// Key: N | n
    n = 78,
    /// Key: O | o
    o = 79,
    /// Key: P | p
    p = 80,
    /// Key: Q | q
    q = 81,
    /// Key: R | r
    r = 82,
    /// Key: S | s
    s = 83,
    /// Key: T | t
    t = 84,
    /// Key: U | u
    u = 85,
    /// Key: V | v
    v = 86,
    /// Key: W | w
    w = 87,
    /// Key: X | x
    x = 88,
    /// Key: Y | y
    y = 89,
    /// Key: Z | z
    z = 90,
    /// Key: [
    left_bracket = 91,
    /// Key: '\'
    backslash = 92,
    /// Key: ]
    right_bracket = 93,
    /// Key: `
    grave = 96,
    // Function keys
    /// Key: Space
    space = 32,
    /// Key: Esc
    escape = 256,
    /// Key: Enter
    enter = 257,
    /// Key: Tab
    tab = 258,
    /// Key: Backspace
    backspace = 259,
    /// Key: Ins
    insert = 260,
    /// Key: Del
    delete = 261,
    /// Key: Cursor right
    right = 262,
    /// Key: Cursor left
    left = 263,
    /// Key: Cursor down
    down = 264,
    /// Key: Cursor up
    up = 265,
    /// Key: Page up
    page_up = 266,
    /// Key: Page down
    page_down = 267,
    /// Key: Home
    home = 268,
    /// Key: End
    end = 269,
    /// Key: Caps lock
    caps_lock = 280,
    /// Key: Scroll down
    scroll_lock = 281,
    /// Key: Num lock
    num_lock = 282,
    /// Key: Print screen
    print_screen = 283,
    /// Key: Pause
    pause = 284,
    /// Key: F1
    f1 = 290,
    /// Key: F2
    f2 = 291,
    /// Key: F3
    f3 = 292,
    /// Key: F4
    f4 = 293,
    /// Key: F5
    f5 = 294,
    /// Key: F6
    f6 = 295,
    /// Key: F7
    f7 = 296,
    /// Key: F8
    f8 = 297,
    /// Key: F9
    f9 = 298,
    /// Key: F10
    f10 = 299,
    /// Key: F11
    f11 = 300,
    /// Key: F12
    f12 = 301,
    /// Key: Shift left
    left_shift = 340,
    /// Key: Control left
    left_control = 341,
    /// Key: Alt left
    left_alt = 342,
    /// Key: Super left
    left_super = 343,
    /// Key: Shift right
    right_shift = 344,
    /// Key: Control right
    right_control = 345,
    /// Key: Alt right
    right_alt = 346,
    /// Key: Super right
    right_super = 347,
    /// Key: KB menu
    kb_menu = 348,
    // Keypad keys
    /// Key: Keypad 0
    kp_0 = 320,
    /// Key: Keypad 1
    kp_1 = 321,
    /// Key: Keypad 2
    kp_2 = 322,
    /// Key: Keypad 3
    kp_3 = 323,
    /// Key: Keypad 4
    kp_4 = 324,
    /// Key: Keypad 5
    kp_5 = 325,
    /// Key: Keypad 6
    kp_6 = 326,
    /// Key: Keypad 7
    kp_7 = 327,
    /// Key: Keypad 8
    kp_8 = 328,
    /// Key: Keypad 9
    kp_9 = 329,
    /// Key: Keypad .
    kp_decimal = 330,
    /// Key: Keypad /
    kp_divide = 331,
    /// Key: Keypad *
    kp_multiply = 332,
    /// Key: Keypad -
    kp_subtract = 333,
    /// Key: Keypad +
    kp_add = 334,
    /// Key: Keypad Enter
    kp_enter = 335,
    /// Key: Keypad =
    kp_equal = 336,
    // Android key buttons
    /// Key: Android back button
    const back = @intToEnum(Key, 4);
    /// Key: Android menu button
    const menu = @intToEnum(Key, 82);
    /// Key: Android volume up button
    const volume_up = @intToEnum(Key, 24);
    /// Key: Android volume down button
    const volume_down = @intToEnum(Key, 25);
};

pub const MouseButton = enum(i32) {
    /// Mouse button left
    left = 0,
    /// Mouse button right
    right = 1,
    /// Mouse button middle (pressed wheel)
    middle = 2,
    /// Mouse button side (advanced mouse device)
    side = 3,
    /// Mouse button extra (advanced mouse device)
    extra = 4,
    /// Mouse button forward (advanced mouse device)
    forward = 5,
    /// Mouse button back (advanced mouse device)
    back = 6,
};
