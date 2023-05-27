///*******************************************************************************************
//*
//*   raylib [textures] example - N-patch drawing
//*
//*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
//*
//*   Example originally created with raylib 2.0, last time updated with raylib 2.5
//*
//*   Example contributed by Jorge A. Gomes (@overdev) and reviewed by Ramon Santamaria (@raysan5)
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2018-2023 Jorge A. Gomes (@overdev) and Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const raylib = @import("zray");
const NPatchLayout = raylib.NPatchLayout;
const Color = raylib.Color;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    raylib.initWindow(screenWidth, screenHeight, "raylib [textures] example - N-patch drawing");

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    const nPatchTexture = try raylib.Texture2D.init("resources/ninepatch_button.png");

    var mousePosition: raylib.Vector2 = undefined;
    const origin = .{ .x = 0, .y = 0 };

    // Position and size of the n-patches
    var dstRec1: raylib.Rectangle = .{ .x = 480, .y = 160, .width = 32, .height = 32 };
    var dstRec2: raylib.Rectangle = .{ .x = 160, .y = 160, .width = 32, .height = 32 };
    var dstRecH: raylib.Rectangle = .{ .x = 160, .y = 93, .width = 32, .height = 32 };
    var dstRecV: raylib.Rectangle = .{ .x = 92, .y = 160, .width = 32, .height = 32 };

    // A 9-patch (NPATCH_NINE_PATCH) changes its sizes in both axis
    const ninePatchInfo1 = .{ .source = .{ .x = 0, .y = 0, .width = 64, .height = 64 }, .left = 12, .top = 40, .right = 12, .bottom = 12, .layout = NPatchLayout.nine_patch };
    const ninePatchInfo2 = .{ .source = .{ .x = 0, .y = 128, .width = 64, .height = 64 }, .left = 16, .top = 16, .right = 16, .bottom = 16, .layout = NPatchLayout.nine_patch };

    // A horizontal 3-patch (NPATCH_THREE_PATCH_HORIZONTAL) changes its sizes along the x axis only
    const h3PatchInfo = .{ .source = .{ .x = 0, .y = 64, .width = 64, .height = 64 }, .left = 8, .top = 8, .right = 8, .bottom = 8, .layout = NPatchLayout.three_patch_horizontal };

    // A vertical 3-patch (NPATCH_THREE_PATCH_VERTICAL) changes its sizes along the y axis only
    const v3PatchInfo = .{ .source = .{ .x = 0, .y = 192, .width = 64, .height = 64 }, .left = 6, .top = 6, .right = 6, .bottom = 6, .layout = NPatchLayout.three_patch_vertical };

    raylib.setTargetFPS(60);
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!raylib.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        mousePosition = raylib.getMousePosition();

        // Resize the n-patches based on mouse position
        dstRec1.width = mousePosition.x - dstRec1.x;
        dstRec1.height = mousePosition.y - dstRec1.y;
        dstRec2.width = mousePosition.x - dstRec2.x;
        dstRec2.height = mousePosition.y - dstRec2.y;
        dstRecH.width = mousePosition.x - dstRecH.x;
        dstRecV.height = mousePosition.y - dstRecV.y;

        // Set a minimum width and/or height
        if (dstRec1.width < 1) dstRec1.width = 1;
        if (dstRec1.width > 300) dstRec1.width = 300;
        if (dstRec1.height < 1) dstRec1.height = 1;
        if (dstRec2.width < 1) dstRec2.width = 1;
        if (dstRec2.width > 300) dstRec2.width = 300;
        if (dstRec2.height < 1) dstRec2.height = 1;
        if (dstRecH.width < 1) dstRecH.width = 1;
        if (dstRecV.height < 1) dstRecV.height = 1;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        raylib.beginDrawing();

        raylib.clearBackground(Color.ray_white);

        // Draw the n-patches
        nPatchTexture.drawNPatch(ninePatchInfo2, dstRec2, origin, 0, Color.white);
        nPatchTexture.drawNPatch(ninePatchInfo1, dstRec1, origin, 0, Color.white);
        nPatchTexture.drawNPatch(h3PatchInfo, dstRecH, origin, 0, Color.white);
        nPatchTexture.drawNPatch(v3PatchInfo, dstRecV, origin, 0, Color.white);

        // Draw the source texture
        raylib.drawRectangleLines(5, 88, 74, 266, Color.blue);
        nPatchTexture.draw(10, 93, Color.white);
        raylib.drawText("TEXTURE", 15, 360, 10, Color.dark_gray);

        raylib.drawText("Move the mouse to stretch or shrink the n-patches", 10, 20, 20, Color.dark_gray);

        raylib.endDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    nPatchTexture.deinit();

    raylib.closeWindow(); // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}
