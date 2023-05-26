const std = @import("std");
const c = @cImport({
    @cInclude("raylib.h");
});

const input = @import("input.zig");
pub const Key = input.Key;
pub const isKeyDown = input.isKeyDown;
pub const isKeyPressed = input.isKeyPressed;

pub const MouseButton = input.MouseButton;
pub const getMousePosition = input.getMousePosition;
pub const isMouseButtonPressed = input.isMouseButtonPressed;

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

pub fn initWindow(screen_width: i32, screen_height: i32, title: []const u8) void {
    const t = @ptrCast([*c]const u8, title);
    c.InitWindow(screen_width, screen_height, t);
}

pub fn closeWindow() void {
    c.CloseWindow();
}

pub fn setTargetFPS(fps: i32) void {
    c.SetTargetFPS(fps);
}

pub fn windowShouldClose() bool {
    return c.WindowShouldClose();
}

pub fn beginDrawing() void {
    c.BeginDrawing();
}

pub fn endDrawing() void {
    c.EndDrawing();
}

pub fn clearBackground(color: Color) void {
    c.ClearBackground(@bitCast(c.struct_Color, color));
}

pub fn drawText(text: []const u8, x: i32, y: i32, font_size: i32, color: Color) void {
    c.DrawText(@ptrCast([*c]const u8, text), x, y, font_size, @bitCast(c.struct_Color, color));
}

pub fn drawCircleV(position: Vector2, radius: f32, color: Color) void {
    c.DrawCircleV(@bitCast(c.struct_Vector2, position), radius, @bitCast(c.struct_Color, color));
}

pub fn getRandomValue(min: i32, max: i32) i32 {
    return c.GetRandomValue(min, max);
}

pub const Camera2D = packed struct {
    offset: Vector2,
    target: Vector2,
    rotation: f32,
    zoom: f32,
};

pub fn getMouseWheelMove() f32 {
    return c.GetMouseWheelMove();
}

pub fn beginMode2D(camera: Camera2D) void {
    c.BeginMode2D(@bitCast(c.struct_Camera2D, camera));
}

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

pub fn endMode2D() void {
    c.EndMode2D();
}

pub fn fade(color: Color, alpha: f32) Color {
    const converted_input = @bitCast(c.struct_Color, color);
    const c_result = c.Fade(converted_input, alpha);
    return @bitCast(Color, c_result);
}

pub fn getFrameTime() f32 {
    return c.GetFrameTime();
}

pub fn getWorldToScreen2D(position: Vector2, camera: Camera2D) Vector2 {
    const converted_position = @bitCast(c.struct_Vector2, position);
    const converted_camera = @bitCast(c.struct_Camera2D, camera);
    return @bitCast(Vector2, c.GetWorldToScreen2D(converted_position, converted_camera));
}

pub fn getScreenToWorld2D(position: Vector2, camera: Camera2D) Vector2 {
    const converted_position = @bitCast(c.struct_Vector2, position);
    const converted_camera = @bitCast(c.struct_Camera2D, camera);
    return @bitCast(Vector2, c.GetScreenToWorld2D(converted_position, converted_camera));
}
