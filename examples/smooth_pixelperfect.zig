///*******************************************************************************************
//*
//*   raylib [core] example - smooth pixel-perfect camera
//*
//*   Example originally created with raylib 3.7, last time updated with raylib 4.0
//*
//*   Example contributed by Giancamillo Alessandroni (@NotManyIdeasDev) and
//*   reviewed by Ramon Santamaria (@raysan5)
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2021-2023 Giancamillo Alessandroni (@NotManyIdeasDev) and Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const raylib = @import("zray");
const RenderTexture2D = raylib.RenderTexture2D;
const Color = raylib.Color;
const Rectangle = raylib.Rectangle;
const Vector2 = raylib.Vector2;
const std = @import("std");
const sin = std.math.sin;
const cos = std.math.cos;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    const virtualScreenWidth = 160;
    const virtualScreenHeight = 90;

    const virtualRatio = screenWidth / virtualScreenWidth;

    raylib.initWindow(screenWidth, screenHeight, "raylib [core] example - smooth pixel-perfect camera");

    var worldSpaceCamera: raylib.Camera2D = undefined; // Game world camera
    worldSpaceCamera.zoom = 1;

    var screenSpaceCamera: raylib.Camera2D = undefined; // Smoothing camera
    screenSpaceCamera.zoom = 1;

    var target = try RenderTexture2D.init(virtualScreenWidth, virtualScreenHeight); // This is where we'll draw all our objects.

    var rec01: Rectangle = .{ .x = 70, .y = 35, .width = 20, .height = 20 };
    var rec02: Rectangle = .{ .x = 90, .y = 55, .width = 30, .height = 10 };
    var rec03: Rectangle = .{ .x = 80, .y = 65, .width = 15, .height = 25 };

    // The target's height is flipped (in the source Rectangle), due to OpenGL reasons
    var sourceRec: Rectangle = .{ .x = 0, .y = 0, .width = @intToFloat(f32, target.texture.width), .height = @intToFloat(f32, -target.texture.height) };
    var destRec: Rectangle = .{ .x = -virtualRatio, .y = -virtualRatio, .width = screenWidth + (virtualRatio * 2), .height = screenHeight + (virtualRatio * 2) };

    var origin: Vector2 = .{ .x = 0, .y = 0 };

    var rotation: f32 = 0;

    var cameraX: f32 = 0;
    var cameraY: f32 = 0;

    raylib.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!raylib.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        rotation += 60 * raylib.getFrameTime(); // Rotate the rectangles, 60 degrees per second

        // Make the camera move to demonstrate the effect
        cameraX = @floatCast(f32, (sin(raylib.getTime()) * 50) - 10);
        cameraY = @floatCast(f32, cos(raylib.getTime()) * 30);

        // Set the camera's target to the values computed above
        screenSpaceCamera.target = .{ .x = cameraX, .y = cameraY };

        // Round worldSpace coordinates, keep decimals into screenSpace coordinates
        worldSpaceCamera.target.x = screenSpaceCamera.target.x;
        screenSpaceCamera.target.x -= worldSpaceCamera.target.x;
        screenSpaceCamera.target.x *= virtualRatio;

        worldSpaceCamera.target.y = screenSpaceCamera.target.y;
        screenSpaceCamera.target.y -= worldSpaceCamera.target.y;
        screenSpaceCamera.target.y *= virtualRatio;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            raylib.beginTextureMode(target);
            defer raylib.endTextureMode();

            raylib.clearBackground(Color.ray_white);
            {
                raylib.beginMode2D(worldSpaceCamera);
                defer raylib.endMode2D();
                rec01.drawPro(origin, rotation, Color.black);
                rec02.drawPro(origin, -rotation, Color.red);
                rec03.drawPro(origin, rotation + 45, Color.blue);
            }
        }

        {
            raylib.beginDrawing();
            defer raylib.endDrawing();
            raylib.clearBackground(Color.red);

            raylib.beginMode2D(screenSpaceCamera);
            target.texture.drawPro(sourceRec, destRec, origin, 0, Color.white);
            raylib.endMode2D();

            var text: [128]u8 = undefined;
            _ = try std.fmt.bufPrintZ(&text, "Screen Resolution: {d}x{d}", .{ screenWidth, screenHeight });
            raylib.drawText(&text, 10, 10, 20, Color.dark_blue);
            _ = try std.fmt.bufPrintZ(&text, "World resolution: {d}x{d}", .{ virtualScreenWidth, virtualScreenHeight });
            raylib.drawText(&text, 10, 40, 20, Color.dark_green);
            raylib.drawFPS(raylib.getScreenWidth() - 95, 10);
        }
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    target.deinit();

    raylib.closeWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
