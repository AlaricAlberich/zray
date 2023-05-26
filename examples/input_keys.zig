const raylib = @import("zigrl");
const Vector2 = raylib.Vector2;
const Key = raylib.Key;

const ray_white = raylib.Color.ray_white;
const dark_gray = raylib.Color.dark_gray;
const maroon = raylib.Color.maroon;

pub fn main() !void {
    const screen_width = 800;
    const screen_height = 450;

    raylib.initWindow(screen_width, screen_height, "raylib [core] example - keyboard input");
    defer raylib.closeWindow();

    var ball_position: Vector2 = .{ .x = @intToFloat(f32, screen_width) / 2, .y = @intToFloat(f32, screen_height) / 2 };

    raylib.setTargetFPS(60);

    while (!raylib.windowShouldClose()) {
        if (raylib.isKeyDown(Key.right)) ball_position.x += 2;
        if (raylib.isKeyDown(Key.left)) ball_position.x -= 2;
        if (raylib.isKeyDown(Key.up)) ball_position.y -= 2;
        if (raylib.isKeyDown(Key.down)) ball_position.y += 2;

        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(ray_white);
        raylib.drawText("move the ball with arrow keys", 10, 10, 20, dark_gray);
        raylib.drawCircleV(ball_position, 50, maroon);
    }
}
