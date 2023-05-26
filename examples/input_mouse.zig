const raylib = @import("zray");
const Vector2 = raylib.Vector2;
const ray_white = raylib.Color.ray_white;
const MouseButton = raylib.MouseButton;
const isMouseButtonPressed = raylib.isMouseButtonPressed;

pub fn main() !void {
    const screen_width = 800;
    const screen_height = 450;

    raylib.initWindow(screen_width, screen_height, "raylib [core] example - mouse input");
    defer raylib.closeWindow();

    var ball_position: Vector2 = .{ .x = -100, .y = 100 };
    var ball_color: raylib.Color = raylib.Color.dark_blue;

    raylib.setTargetFPS(60);

    while (!raylib.windowShouldClose()) {
        ball_position = raylib.getMousePosition();

        if (isMouseButtonPressed(MouseButton.left)) {
            ball_color = raylib.Color.maroon;
        } else if (isMouseButtonPressed(MouseButton.middle)) {
            ball_color = raylib.Color.lime;
        } else if (isMouseButtonPressed(MouseButton.right)) {
            ball_color = raylib.Color.dark_blue;
        } else if (isMouseButtonPressed(MouseButton.side)) {
            ball_color = raylib.Color.purple;
        } else if (isMouseButtonPressed(MouseButton.extra)) {
            ball_color = raylib.Color.yellow;
        } else if (isMouseButtonPressed(MouseButton.forward)) {
            ball_color = raylib.Color.orange;
        } else if (isMouseButtonPressed(MouseButton.back)) {
            ball_color = raylib.Color.beige;
        }

        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(ray_white);
        raylib.drawCircleV(ball_position, 40, ball_color);
    }
}
