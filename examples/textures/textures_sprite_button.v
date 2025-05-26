module main

/*******************************************************************************************
*
*   raylib [textures] example - sprite button
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl


const num_frames = 3       // Number of frames (rectangles) for the button sprite texture


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - sprite button")
    defer { rl.close_window() }       // Close window and OpenGL context

    rl.init_audio_device()            // Initialize audio device
    defer { rl.close_audio_device() } // Close audio device

    fx_button := rl.load_sound("resources/buttonfx.wav") // Load button sound
    button    := rl.load_texture("resources/button.png") // Load button texture

    defer {
        rl.unload_texture(button)  // Unload button texture
        rl.unload_sound(fx_button) // Unload sound
    }
    
    // Define frame rectangle for drawing
    frame_height := f32(button.height/num_frames)

    mut source_rec := rl.Rectangle { 0, 0, f32(button.width), f32(frame_height) }

    // Define button bounds on screen
    btn_bounds := rl.Rectangle {
        f32(screen_width) /2.0 - f32(button.width)/2.0,
        f32(screen_height)/2.0 - f32(button.height)/f32(num_frames)/2.0,
        f32(button.width),
        frame_height
    }

    mut btn_state  := int(0)    // Button state: 0-NORMAL, 1-MOUSE_HOVER, 2-PRESSED
    mut btn_action := false     // Button action should be activated

    mut mouse_point := rl.Vector2 {}

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mouse_point = rl.get_mouse_position()
        btn_action  = false

        // Check button state
        if rl.check_collision_point_rec(mouse_point, btn_bounds) {
            btn_state = if rl.is_mouse_button_down(rl.mouse_button_left) {2} else {1}

            if rl.is_mouse_button_released(rl.mouse_button_left) {
                btn_action = true
            }
        } else {
            btn_state = 0
        }

        if btn_action {
            rl.play_sound(fx_button)
            // TODO: Any desired action
        }

        // Calculate button frame rectangle to draw depending on button state
        source_rec.y = btn_state*frame_height
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_texture_rec(button, source_rec, rl.Vector2 { btn_bounds.x, btn_bounds.y }, rl.white) // Draw button frame

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
