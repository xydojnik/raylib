module main

/*******************************************************************************************
*
*   raylib [textures] example - Texture source and destination rectangles
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] examples - texture source and destination rectangles")
    defer { rl.close_window() }                       // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    scarfy := rl.load_texture("resources/scarfy.png") // Texture loading
    defer { rl.unload_texture(scarfy) }               // Texture unloading

    frame_width  := scarfy.width/6
    frame_height := scarfy.height

    // Source rectangle (part of the texture to use for drawing)
    source_rec := rl.Rectangle { 0.0, 0.0, f32(frame_width), f32(frame_height) }

    // Destination rectangle (screen rectangle where drawing part of texture)
    dest_rec := rl.Rectangle {
        f32(screen_width) /2.0,
        f32(screen_height)/2.0,
        f32(frame_width)  *2.0,
        f32(frame_height) *2.0
    }

    // Origin of the texture (rotation/scale point), it's relative to destination rectangle size
    origin := rl.Vector2 { f32(frame_width), f32(frame_height) }

    mut rotation := int(0)

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rotation++
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // NOTE: Using DrawTexturePro() we can easily rotate and scale the part of the texture we draw
            // source_rec defines the part of the texture we use for drawing
            // dest_rec defines the rectangle where our texture part will fit (scaling it to fit)
            // origin defines the point of the texture used as reference for rotation and scaling
            // rotation defines the texture rotation (using origin as rotation point)
            rl.draw_texture_pro(scarfy, source_rec, dest_rec, origin, f32(rotation), rl.white)

            rl.draw_line(int(dest_rec.x), 0, int(dest_rec.x), screen_height, rl.gray)
            rl.draw_line(0, int(dest_rec.y), screen_width, int(dest_rec.y), rl.gray)

            rl.draw_text("(c) Scarfy sprite by Eiden Marsal", screen_width - 200, screen_height - 20, 10, rl.gray)

        rl.end_drawing()
    }
}
