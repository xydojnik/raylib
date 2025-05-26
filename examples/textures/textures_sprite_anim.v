module main

/*******************************************************************************************
*
*   raylib [textures] example - Sprite animation
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

const max_frame_speed = int(15)
const min_frame_speed = int(1)

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [texture] example - sprite anim")
    defer { rl.close_window() }                       // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    scarfy := rl.load_texture("resources/scarfy.png") // Texture loading
    defer { rl.unload_texture(scarfy) }               // Texture unloading

    position  := rl.Vector2 { 350.0, 280.0 }
    mut frame_rec := rl.Rectangle { 0.0, 0.0, f32(scarfy.width)/6, f32(scarfy.height) }

    mut current_frame  := int(0)
    mut frames_counter := int(0)
    mut frames_speed   := int(8)     // Number of spritesheet frames shown by second

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        frames_counter++

        if frames_counter >= (60/frames_speed) {
            frames_counter = 0
            current_frame++

            if current_frame > 5 {
                current_frame = 0
            }

            frame_rec.x = f32(current_frame)*f32(scarfy.width)/6
        }

        // Control frames speed
        if      rl.is_key_pressed(rl.key_right) { frames_speed++ }
        else if rl.is_key_pressed(rl.key_left)  { frames_speed-- }

        if      frames_speed > max_frame_speed { frames_speed = max_frame_speed }
        else if frames_speed < min_frame_speed { frames_speed = min_frame_speed }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_texture(scarfy, 15, 40, rl.white)
            rl.draw_rectangle_lines(15, 40, scarfy.width, scarfy.height, rl.lime)
        rl.draw_rectangle_lines(15 + int(frame_rec.x), 40 + int(frame_rec.y), int(frame_rec.width), int(frame_rec.height), rl.red)

            rl.draw_text("FRAME SPEED: ", 165, 210, 10, rl.darkgray)
            rl.draw_text("${frames_speed} FPS", 575, 210, 10, rl.darkgray)
            rl.draw_text("PRESS RIGHT/LEFT KEYS to CHANGE SPEED!", 290, 240, 10, rl.darkgray)

            for i in 0..max_frame_speed {
                if i < frames_speed {
                    rl.draw_rectangle(250 + 21*i, 205, 20, 20, rl.red)
                }
                rl.draw_rectangle_lines(250 + 21*i, 205, 20, 20, rl.maroon)
            }

            rl.draw_texture_rec(scarfy, frame_rec, position, rl.white)  // Draw part of the texture

            rl.draw_text("(c) Scarfy sprite by Eiden Marsal", screen_width - 200, screen_height - 20, 10, rl.gray)

        rl.end_drawing()
    }
}
