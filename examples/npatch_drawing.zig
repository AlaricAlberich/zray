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

const std = @import("std");
const raylib = @import("zray");
const NPatchLayout = raylib.NPatchLayout;
const Color = raylib.Color;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    raylib.initWindow(screen_width, screen_height, "raylib [textures] example - N-patch drawing");
    defer raylib.closeWindow(); // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    const exe_dir = try std.fs.selfExeDirPathAlloc(allocator);
    const path = try std.fs.path.join(allocator, &.{ exe_dir, "resources", "ninepatch_button.png" });
    const npatch_texture = try raylib.Texture2D.init(path);
    defer npatch_texture.deinit();

    var mouse_position: raylib.Vector2 = undefined;
    const origin = .{ .x = 0, .y = 0 };

    // Position and size of the n-patches
    var dst_rec_1: raylib.Rectangle = .{ .x = 480, .y = 160, .width = 32, .height = 32 };
    var dst_rec_2: raylib.Rectangle = .{ .x = 160, .y = 160, .width = 32, .height = 32 };
    var dst_rec_h: raylib.Rectangle = .{ .x = 160, .y = 93, .width = 32, .height = 32 };
    var dst_rec_v: raylib.Rectangle = .{ .x = 92, .y = 160, .width = 32, .height = 32 };

    // A 9-patch (NPATCH_NINE_PATCH) changes its sizes in both axis
    const nine_patch_info_1 = .{ .source = .{ .x = 0, .y = 0, .width = 64, .height = 64 }, .left = 12, .top = 40, .right = 12, .bottom = 12, .layout = NPatchLayout.nine_patch };
    const nine_patch_info_2 = .{ .source = .{ .x = 0, .y = 128, .width = 64, .height = 64 }, .left = 16, .top = 16, .right = 16, .bottom = 16, .layout = NPatchLayout.nine_patch };

    // A horizontal 3-patch (NPATCH_THREE_PATCH_HORIZONTAL) changes its sizes along the x axis only
    const h3_patch_info = .{ .source = .{ .x = 0, .y = 64, .width = 64, .height = 64 }, .left = 8, .top = 8, .right = 8, .bottom = 8, .layout = NPatchLayout.three_patch_horizontal };

    // A vertical 3-patch (NPATCH_THREE_PATCH_VERTICAL) changes its sizes along the y axis only
    const v3_patch_info = .{ .source = .{ .x = 0, .y = 192, .width = 64, .height = 64 }, .left = 6, .top = 6, .right = 6, .bottom = 6, .layout = NPatchLayout.three_patch_vertical };

    raylib.setTargetFPS(60);
    //---------------------------------------------------------------------------------------

    // Main game loop
    while (!raylib.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        mouse_position = raylib.getMousePosition();

        // Resize the n-patches based on mouse position
        dst_rec_1.width = mouse_position.x - dst_rec_1.x;
        dst_rec_1.height = mouse_position.y - dst_rec_1.y;
        dst_rec_2.width = mouse_position.x - dst_rec_2.x;
        dst_rec_2.height = mouse_position.y - dst_rec_2.y;
        dst_rec_h.width = mouse_position.x - dst_rec_h.x;
        dst_rec_v.height = mouse_position.y - dst_rec_v.y;

        // Set a minimum width and/or height
        if (dst_rec_1.width < 1) dst_rec_1.width = 1;
        if (dst_rec_1.width > 300) dst_rec_1.width = 300;
        if (dst_rec_1.height < 1) dst_rec_1.height = 1;
        if (dst_rec_2.width < 1) dst_rec_2.width = 1;
        if (dst_rec_2.width > 300) dst_rec_2.width = 300;
        if (dst_rec_2.height < 1) dst_rec_2.height = 1;
        if (dst_rec_h.width < 1) dst_rec_h.width = 1;
        if (dst_rec_v.height < 1) dst_rec_v.height = 1;
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(Color.ray_white);

        // Draw the n-patches
        npatch_texture.drawNPatch(nine_patch_info_2, dst_rec_2, origin, 0, Color.white);
        npatch_texture.drawNPatch(nine_patch_info_1, dst_rec_1, origin, 0, Color.white);
        npatch_texture.drawNPatch(h3_patch_info, dst_rec_h, origin, 0, Color.white);
        npatch_texture.drawNPatch(v3_patch_info, dst_rec_v, origin, 0, Color.white);

        // Draw the source texture
        raylib.drawRectangleLines(5, 88, 74, 266, Color.blue);
        npatch_texture.draw(10, 93, Color.white);
        raylib.drawText("TEXTURE", 15, 360, 10, Color.dark_gray);

        raylib.drawText("Move the mouse to stretch or shrink the n-patches", 10, 20, 20, Color.dark_gray);

        //----------------------------------------------------------------------------------
    }
}
