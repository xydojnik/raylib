module main

/*******************************************************************************************
*
*   raylib [textures] example - sprite explosion
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Anata and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr          (@xydojnik)
*
********************************************************************************************/

import raylib as rl

const num_frames_per_line = int(5)
const num_lines           = int(5)

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - sprite explosion")
    defer { rl.close_window() }            // Close window and OpenGL context

    rl.init_audio_device()
    defer { rl.close_audio_device() }

    // Load explosion sound
    fx_boom   := rl.load_sound("resources/boom.wav")
    // Load explosion texture
    explosion := rl.load_texture("resources/explosion.png")

    defer {
        rl.unload_texture(explosion) // Unload texture
        rl.unload_sound(fx_boom)     // Unload sound
    }
    
    // Init variables for animation
    frame_width  := f32(explosion.width/num_frames_per_line) // Sprite one frame rectangle width
    frame_height := f32(explosion.height/num_lines)          // Sprite one frame rectangle height

    mut current_frame := int(0)
    mut current_line  := int(0)

    mut frame_rec := rl.Rectangle { 0, 0, frame_width, frame_height }
    mut position  := rl.Vector2 {}

    mut active         := false
    mut frames_counter := int(0)

    rl.set_target_fps(120)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        // Check for mouse button pressed and activate explosion (if not active)
        if rl.is_mouse_button_pressed(rl.mouse_button_left) && !active {
            position = rl.get_mouse_position()
            active   = true

            position.x -= frame_width /2.0
            position.y -= frame_height/2.0

            rl.play_sound(fx_boom)
        }

        // Compute explosion animation frames
        if active {
            frames_counter++

            if frames_counter > 2 {
                current_frame++

                if current_frame >= num_frames_per_line {
                    current_frame = 0
                    current_line++

                    if current_line >= num_lines {
                        current_line = 0
                        active       = false
                    }
                }

                frames_counter = 0
            }
        }

        frame_rec.x = frame_width*current_frame
        frame_rec.y = frame_height*current_line
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // Draw explosion required frame rectangle
            if active {
                rl.draw_texture_rec(explosion, frame_rec, position, rl.white)
            }

        rl.end_drawing()
    }
}
