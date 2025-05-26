/*******************************************************************************************
*
*   raylib [shapes] example - bouncing ball
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2013-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //---------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint)
    rl.init_window(screen_width, screen_height, "raylib [shapes] example - bouncing ball")
    defer { rl.close_window() }       // Close window and OpenGL context

    mut ball_position := rl.Vector2 { f32(rl.get_screen_width())/2.0, f32(rl.get_screen_height())/2.0 }
    mut ball_speed  := rl.Vector2 { 5.0, 4.0 }
    mut ball_radius := int(20)

    mut pause          := false
    mut frames_counter := int(0)

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //----------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //-----------------------------------------------------
        if rl.is_key_pressed(rl.key_space) {
            pause = !pause
        }

        if !pause {
            ball_position.x += ball_speed.x
            ball_position.y += ball_speed.y

            // Check walls collision for bouncing
            if (ball_position.x >= (rl.get_screen_width() - ball_radius)) || (ball_position.x <= ball_radius) {
                ball_speed.x *= -1.0
            }
            if (ball_position.y >= (f32(rl.get_screen_height()) - ball_radius)) || (ball_position.y <= ball_radius) {
                ball_speed.y *= -1.0
            }
        } else {
            frames_counter++
        }
        //-----------------------------------------------------

        // Draw
        //-----------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_circle_v(ball_position, f32(ball_radius), rl.maroon)
            rl.draw_text("PRESS SPACE to PAUSE BALL MOVEMENT", 10, rl.get_screen_height() - 25, 20, rl.lightgray)

            // On pause, we draw a blinking message
            if pause && ((frames_counter/30)%2)==0 {
                rl.draw_text("PAUSED", 350, 200, 30, rl.gray)
            }

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
