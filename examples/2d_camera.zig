//!*******************************************************************************************
//!*
//!*   raylib [core] example - 2d camera
//!*
//!*   Example originally created with raylib 1.5, last time updated with raylib 3.0
//!*   Adapted for zig with raylib 4.5
//!*
//!*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!*   BSD-like license that allows static linking with closed source software
//!*
//!*   Copyright (c) 2016-2023 Ramon Santamaria (@raysan5)
//!*
//!********************************************************************************************/

const raylib = @import("zray");
const Rectangle = raylib.Rectangle;
const getRandomValue = raylib.getRandomValue;

const max_buildings = 100;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    raylib.initWindow(screen_width, screen_height, "raylib [core] example - 2d camera");

    // De-Initialization is deferred
    defer raylib.closeWindow(); // Close window and OpenGL context

    var player: Rectangle = .{ .x = 400, .y = 280, .width = 40, .height = 40 };
    var buildings: [max_buildings]Rectangle = undefined;
    var buildColors: [max_buildings]raylib.Color = undefined;

    var spacing: f32 = 0;

    for (0..max_buildings) |i| {
        buildings[i].width = @intToFloat(f32, getRandomValue(50, 200));
        buildings[i].height = @intToFloat(f32, getRandomValue(100, 800));
        buildings[i].y = @intToFloat(f32, screen_height) - 130 - buildings[i].height;
        buildings[i].x = -6000.0 + spacing;

        spacing += buildings[i].width;

        buildColors[i] = .{ .r = @intCast(u8, getRandomValue(200, 240)), .g = @intCast(u8, getRandomValue(200, 240)), .b = @intCast(u8, getRandomValue(200, 250)), .a = 255 };
    }

    var camera: raylib.Camera2D = undefined;
    camera.target = .{ .x = player.x + 20, .y = player.y + 20 };
    camera.offset = .{ .x = screen_width / 2, .y = screen_height / 2 };
    camera.rotation = 0;
    camera.zoom = 1;

    raylib.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!raylib.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // Player movement
        if (raylib.isKeyDown(raylib.Key.right)) {
            player.x += 2;
        } else if (raylib.isKeyDown(raylib.Key.left)) {
            player.x -= 2;
        }

        // Camera target follows player
        camera.target = .{ .x = player.x + 20, .y = player.y + 20 };

        // Camera rotation controls
        if (raylib.isKeyDown(raylib.Key.a)) {
            camera.rotation -= 1;
        } else if (raylib.isKeyDown(raylib.Key.s)) {
            camera.rotation += 1;
        }

        // Limit camera rotation to 80 degrees (-40 to 40)
        if (camera.rotation > 40) {
            camera.rotation = 40;
        } else if (camera.rotation < -40) {
            camera.rotation = -40;
        }

        // Camera zoom controls
        camera.zoom += (raylib.getMouseWheelMove() * 0.05);

        if (camera.zoom > 3) {
            camera.zoom = 3;
        } else if (camera.zoom < 0.1) {
            camera.zoom = 0.1;
        }

        // Camera reset (zoom and rotation)
        if (raylib.isKeyPressed(raylib.Key.r)) {
            camera.zoom = 1;
            camera.rotation = 0;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(raylib.Color.ray_white);

        {
            raylib.beginMode2D(camera);
            defer raylib.endMode2D();

            raylib.drawRectangle(-6000, 320, 13000, 8000, raylib.Color.dark_gray);

            for (0..max_buildings) |i| {
                raylib.drawRectangleRec(buildings[i], buildColors[i]);
            }

            raylib.drawRectangleRec(player, raylib.Color.red);

            raylib.drawLine(@floatToInt(i32, camera.target.x), -screen_height * 10, @floatToInt(i32, camera.target.x), screen_height * 10, raylib.Color.green);
            raylib.drawLine(-screen_width * 10, @floatToInt(i32, camera.target.y), screen_width * 10, @floatToInt(i32, camera.target.y), raylib.Color.green);
        }

        raylib.drawText("SCREEN AREA", 640, 10, 20, raylib.Color.red);

        raylib.drawRectangle(0, 0, screen_width, 5, raylib.Color.red);
        raylib.drawRectangle(0, 5, 5, screen_height - 10, raylib.Color.red);
        raylib.drawRectangle(screen_width - 5, 5, 5, screen_height - 10, raylib.Color.red);
        raylib.drawRectangle(0, screen_height - 5, screen_width, 5, raylib.Color.red);

        raylib.drawRectangle(10, 10, 250, 113, raylib.fade(raylib.Color.sky_blue, 0.5));
        raylib.drawRectangleLines(10, 10, 250, 113, raylib.Color.blue);

        raylib.drawText("Free 2d camera controls:", 20, 20, 10, raylib.Color.black);
        raylib.drawText("- Right/Left to move Offset", 40, 40, 10, raylib.Color.dark_gray);
        raylib.drawText("- Mouse Wheel to Zoom in-out", 40, 60, 10, raylib.Color.dark_gray);
        raylib.drawText("- A / S to Rotate", 40, 80, 10, raylib.Color.dark_gray);
        raylib.drawText("- R to reset Zoom and Rotation", 40, 100, 10, raylib.Color.dark_gray);

        //----------------------------------------------------------------------------------
    }
}
