///*******************************************************************************************
//*
//*   raylib [core] example - Windows drop files
//*
//*   NOTE: This example only works on platforms that support drag & drop (Windows, Linux, OSX, Html5?)
//*
//*   Example originally created with raylib 1.3, last time updated with raylib 4.2
//*
//*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//*   BSD-like license that allows static linking with closed source software
//*
//*   Copyright (c) 2015-2023 Ramon Santamaria (@raysan5)
//*
//********************************************************************************************/

const raylib = @import("zray");
const std = @import("std");

const max_filepath_recorded = 4096;
const max_filepath_size = 2048;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    raylib.initWindow(screen_width, screen_height, "raylib [core] example - drop files");
    defer raylib.closeWindow();

    var file_path_counter: usize = 0;
    var file_paths: [max_filepath_recorded][]u8 = undefined; // We will register a maximum of filepaths

    // Allocate space for the required file paths
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    for (0..max_filepath_recorded) |i| {
        file_paths[i] = try allocator.alloc(u8, max_filepath_size);
    }
    defer arena.deinit();

    raylib.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!raylib.windowShouldClose()) // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (raylib.isFileDropped()) {
            const dropped_files = raylib.loadDroppedFiles();
            defer raylib.unloadDroppedFiles(dropped_files); // Unload filepaths from memory

            var offset = file_path_counter;
            for (0..dropped_files.count) |i| {
                if (file_path_counter < (max_filepath_recorded - 1)) {
                    @memcpy(file_paths[offset + i], dropped_files.paths[i]);
                    file_path_counter += 1;
                }
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        raylib.beginDrawing();
        defer raylib.endDrawing();

        raylib.clearBackground(raylib.Color.ray_white);

        if (file_path_counter == 0) {
            raylib.drawText("Drop your files to this window!", 100, 40, 20, raylib.Color.dark_gray);
        } else {
            raylib.drawText("Dropped files:", 100, 40, 20, raylib.Color.dark_gray);

            for (0..file_path_counter) |i| {
                if (i % 2 == 0) {
                    raylib.drawRectangle(0, 85 + 40 * @intCast(i32, i), screen_width, 40, raylib.fade(raylib.Color.light_gray, 0.5));
                } else {
                    raylib.drawRectangle(0, 85 + 40 * @intCast(i32, i), screen_width, 40, raylib.fade(raylib.Color.light_gray, 0.3));
                }

                raylib.drawText(file_paths[i], 120, 100 + 40 * @intCast(i32, i), 10, raylib.Color.gray);
            }

            raylib.drawText("Drop new files...", 100, 110 + 40 * @intCast(i32, file_path_counter), 20, raylib.Color.dark_gray);
        }

        //----------------------------------------------------------------------------------
    }
}
