///*******************************************************************************************
//*
//*   raylib [textures] example - Texture loading and drawing
//*
//*   Example originally created with raylib 1.0, last time updated with raylib 1.0
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2014-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const raylib = @import("zray");
const Texture2D = raylib.Texture2D;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    raylib.initWindow(screen_width, screen_height, "raylib [textures] example - texture loading and drawing");
    defer raylib.closeWindow(); // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    const texture = try Texture2D.init("resources/raylib_logo.png"); // Texture loading
    defer texture.deinit();
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!raylib.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            raylib.beginDrawing();
            defer raylib.endDrawing();

            raylib.clearBackground(raylib.Color.ray_white);

            texture.draw(@divFloor(screen_width, 2) - @divFloor(texture.width, 2), @divFloor(screen_height, 2) - @divFloor(texture.height, 2), raylib.Color.white);

            raylib.drawText("this IS a texture!", 360, 370, 10, raylib.Color.gray);
        }
        //----------------------------------------------------------------------------------
    }
}
