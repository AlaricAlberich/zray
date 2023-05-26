const raylib = @import("zigrl");

pub fn main() !void {
    const screen_width = 800;
    const screen_height = 450;
    raylib.initWindow(screen_width, screen_height, "raylib [core] example - basic window");
    defer raylib.closeWindow();

    raylib.setTargetFPS(60);

    while (!raylib.windowShouldClose()) {
        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(raylib.Color.ray_white);
        raylib.drawText("Congrats! You created your first window!", 190, 200, 20, raylib.Color.light_gray);
    }
}
