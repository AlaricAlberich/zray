//!/*******************************************************************************************
//!*
//!*   raylib [core] example - 2d camera platformer
//!*
//!*   Example originally created with raylib 2.5, last time updated with raylib 3.0
//!*
//!*   Example contributed by arvyy (@arvyy) and reviewed by Ramon Santamaria (@raysan5)
//!*
//!*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
//!*   BSD-like license that allows static linking with closed source software
//!*
//!*   Copyright (c) 2019-2023 arvyy (@arvyy)
//!*
//!********************************************************************************************/

const std = @import("std");
const raylib = @import("zray");
const Vector2 = raylib.Vector2;
const Rectangle = raylib.Rectangle;
const Color = raylib.Color;
const Camera2D = raylib.Camera2D;
const Key = raylib.Key;

const g = 400;
const player_jump_spd = 350;
const player_hor_spd = 200;

const Player = struct {
    position: Vector2,
    speed: f32,
    can_jump: bool,
};

const EnvItem = struct {
    rect: Rectangle,
    blocking: bool,
    color: Color,
};

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
pub fn main() void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screen_width = 800;
    const screen_height = 450;

    raylib.initWindow(screen_width, screen_height, "raylib [core] example - 2d camera");
    defer raylib.closeWindow();

    var player: Player = undefined;
    player.position = .{ .x = 400, .y = 280 };
    player.speed = 0;
    player.can_jump = false;
    const env_items = [_]EnvItem{
        //
        .{ .rect = .{ .x = 0, .y = 0, .width = 1000, .height = 400 }, .blocking = false, .color = Color.light_gray },
        .{ .rect = .{ .x = 0, .y = 400, .width = 1000, .height = 200 }, .blocking = true, .color = Color.gray },
        .{ .rect = .{ .x = 300, .y = 200, .width = 400, .height = 10 }, .blocking = true, .color = Color.gray },
        .{ .rect = .{ .x = 250, .y = 300, .width = 100, .height = 10 }, .blocking = true, .color = Color.gray },
        .{ .rect = .{ .x = 650, .y = 300, .width = 100, .height = 10 }, .blocking = true, .color = Color.gray },
    };

    var camera: Camera2D = undefined;
    camera.target = player.position;
    camera.offset = .{ .x = screen_width / 2, .y = screen_height / 2 };
    camera.rotation = 0;
    camera.zoom = 1;

    // Store pointers to the multiple update camera functions
    const CameraUpdater = comptime *const fn (*Camera2D, *Player, []const EnvItem, f32, f32, f32) void;
    const camera_updaters = [_]CameraUpdater{ updateCameraCenter, updateCameraCenterInsideMap, updateCameraCenterSmoothFollow, updateCameraEvenOutOnLanding, updateCameraPlayerBoundsPush };

    var camera_option: usize = 0;

    const camera_descriptions = [_][]const u8{ "Follow player center", "Follow player center, but clamp to map edges", "Follow player center; smoothed", "Follow player center horizontally; update player center vertically after landing", "Player push camera on getting too close to screen edge" };

    raylib.setTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!raylib.windowShouldClose()) {
        // Update
        //----------------------------------------------------------------------------------
        const deltaTime = raylib.getFrameTime();

        updatePlayer(&player, &env_items, deltaTime);

        camera.zoom += (raylib.getMouseWheelMove() * 0.05);

        if (camera.zoom > 3) {
            camera.zoom = 3;
        } else if (camera.zoom < 0.25) {
            camera.zoom = 0.25;
        }

        if (raylib.isKeyPressed(Key.r)) {
            camera.zoom = 1;
            player.position = .{ .x = 400, .y = 280 };
        }

        if (raylib.isKeyPressed(Key.c)) {
            camera_option = (camera_option + 1) % camera_updaters.len;
        }

        // Call update camera function by its pointer
        camera_updaters[camera_option](&camera, &player, &env_items, deltaTime, screen_width, screen_height);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        {
            raylib.beginDrawing();
            defer raylib.endDrawing();

            raylib.clearBackground(Color.light_gray);

            {
                raylib.beginMode2D(camera);
                defer raylib.endMode2D();

                for (env_items) |env_item| {
                    raylib.drawRectangleRec(env_item.rect, env_item.color);
                }

                const player_rect = .{ .x = player.position.x - 20, .y = player.position.y - 40, .width = 40, .height = 40 };
                raylib.drawRectangleRec(player_rect, Color.red);
            }

            raylib.drawText("Controls:", 20, 20, 10, Color.black);
            raylib.drawText("- Right/Left to move", 40, 40, 10, Color.dark_gray);
            raylib.drawText("- Space to jump", 40, 60, 10, Color.dark_gray);
            raylib.drawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, Color.dark_gray);
            raylib.drawText("- C to change camera mode", 40, 100, 10, Color.dark_gray);
            raylib.drawText("Current camera mode:", 20, 120, 10, Color.black);
            raylib.drawText(camera_descriptions[camera_option], 40, 140, 10, Color.dark_gray);
        }
        //----------------------------------------------------------------------------------
    }
}

fn updatePlayer(player: *Player, env_items: []const EnvItem, delta: f32) void {
    if (raylib.isKeyDown(Key.left)) {
        player.position.x -= player_hor_spd * delta;
    }
    if (raylib.isKeyDown(Key.right)) player.position.x += player_hor_spd * delta;
    if (raylib.isKeyDown(Key.space) and player.can_jump) {
        player.speed = -player_jump_spd;
        player.can_jump = false;
    }

    var hitObstacle: bool = false;
    for (env_items) |ei| {
        const p = &player.position;
        if (ei.blocking and
            ei.rect.x <= p.x and
            ei.rect.x + ei.rect.width >= p.x and
            ei.rect.y >= p.y and
            ei.rect.y <= p.y + player.speed * delta)
        {
            hitObstacle = true;
            player.speed = 0;
            p.y = ei.rect.y;
        }
    }

    if (!hitObstacle) {
        player.position.y += player.speed * delta;
        player.speed += g * delta;
        player.can_jump = false;
    } else player.can_jump = true;
}

fn updateCameraCenter(camera: *Camera2D, player: *Player, env_items: []const EnvItem, delta: f32, width: f32, height: f32) void {
    _ = env_items;
    _ = delta;
    camera.offset = .{ .x = width / 2, .y = height / 2 };
    camera.target = player.position;
}

fn updateCameraCenterInsideMap(camera: *Camera2D, player: *Player, env_items: []const EnvItem, delta: f32, width: f32, height: f32) void {
    _ = delta;
    camera.target = player.position;
    camera.offset = .{ .x = width / 2, .y = height / 2 };
    var min_x: f32 = 1000;
    var min_y: f32 = 1000;
    var max_x: f32 = -1000;
    var max_y: f32 = -1000;

    for (env_items) |ei| {
        min_x = std.math.min(ei.rect.x, min_x);
        min_y = std.math.max(ei.rect.x + ei.rect.width, max_x);
        max_x = std.math.min(ei.rect.y, min_y);
        max_y = std.math.max(ei.rect.y + ei.rect.height, max_y);
    }

    const max = raylib.getWorldToScreen2D(.{ .x = max_x, .y = max_y }, camera.*);
    const min = raylib.getWorldToScreen2D(.{ .x = min_x, .y = min_y }, camera.*);

    if (max.x < width) camera.offset.x = width - (max.x - width / 2);
    if (max.y < height) camera.offset.y = height - (max.y - height / 2);
    if (min.x > 0) camera.offset.x = width / 2 - min.x;
    if (min.y > 0) camera.offset.y = height / 2 - min.y;
}

fn updateCameraCenterSmoothFollow(camera: *Camera2D, player: *Player, env_items: []const EnvItem, delta: f32, width: f32, height: f32) void {
    _ = env_items;
    const min_speed = 30;
    const min_effect_length = 10;
    const fraction_speed = 0.8;

    camera.offset = .{ .x = width / 2, .y = height / 2 };
    const diff = player.position.subtract(camera.target);
    const length = diff.length();

    if (length > min_effect_length) {
        const speed = std.math.max(fraction_speed * length, min_speed);
        camera.target = camera.target.add(diff.scale(speed * delta / length));
    }
}

fn updateCameraEvenOutOnLanding(camera: *Camera2D, player: *Player, env_items: []const EnvItem, delta: f32, width: f32, height: f32) void {
    _ = env_items;
    // Static variables are created by placing them in a local struct.
    const S = struct {
        var even_out_speed: f32 = 700;
        var evening_out: bool = false;
        var even_out_target: f32 = undefined;
    };

    camera.offset = .{ .x = width / 2, .y = height / 2 };
    camera.target.x = player.position.x;

    if (S.evening_out) {
        if (S.even_out_target > camera.target.y) {
            camera.target.y += S.even_out_speed * delta;

            if (camera.target.y > S.even_out_target) {
                camera.target.y = S.even_out_target;
                S.evening_out = false;
            }
        } else {
            camera.target.y -= S.even_out_speed * delta;

            if (camera.target.y < S.even_out_target) {
                camera.target.y = S.even_out_target;
                S.evening_out = false;
            }
        }
    } else {
        if (player.can_jump and (player.speed == 0) and (player.position.y != camera.target.y)) {
            S.evening_out = true;
            S.even_out_target = player.position.y;
        }
    }
}

fn updateCameraPlayerBoundsPush(camera: *Camera2D, player: *Player, env_items: []const EnvItem, delta: f32, width: f32, height: f32) void {
    _ = env_items;
    _ = delta;
    const bbox = .{ .x = 0.2, .y = 0.2 };

    const bboxWorldMin = raylib.getScreenToWorld2D(.{ .x = (1 - bbox.x) * 0.5 * width, .y = (1 - bbox.y) * 0.5 * height }, camera.*);
    const bboxWorldMax = raylib.getScreenToWorld2D(.{ .x = (1 + bbox.x) * 0.5 * width, .y = (1 + bbox.y) * 0.5 * height }, camera.*);
    camera.offset = .{ .x = (1 - bbox.x) * 0.5 * width, .y = (1 - bbox.y) * 0.5 * height };

    if (player.position.x < bboxWorldMin.x) camera.target.x = player.position.x;
    if (player.position.y < bboxWorldMin.y) camera.target.y = player.position.y;
    if (player.position.x > bboxWorldMax.x) camera.target.x = bboxWorldMin.x + (player.position.x - bboxWorldMax.x);
    if (player.position.y > bboxWorldMax.y) camera.target.y = bboxWorldMin.y + (player.position.y - bboxWorldMax.y);
}
