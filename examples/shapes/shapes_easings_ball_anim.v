/*******************************************************************************************
*
*   raylib [shapes] example - easings ball anim
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


#include "@VMODROOT/examples/shapes/reasings.h"     // Required for easing functions

fn C.EaseElasticOut(t f32, b f32, c f32, d f32) f32 // Ease: Elastic Out
fn C.EaseElasticIn(t f32, b f32, c f32, d f32)  f32 // Ease: Elastic In Out
fn C.EaseCubicOut(t f32, b f32, c f32, d f32)   f32 // Ease: Cubic Out


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - easings ball anim")
    defer { rl.close_window() }       // Close window and OpenGL context

    // Ball variable value to be animated with easings
    mut ball_position_x := int(-100)
    mut ball_radius     := int(20)
    mut ball_alpha      := f32(0.0)

    mut state          := int(0)
    mut frames_counter := int(0)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if state == 0 {           // Move ball position X with easing
            frames_counter++
            ball_position_x = int(C.EaseElasticOut(f32(frames_counter), -100, f32(screen_width)/2.0 + 100, 120))

            if frames_counter >= 120 {
                frames_counter = 0
                state          = 1
            }
        } else if state == 1 {      // Increase ball radius with easing
            frames_counter++
            ball_radius = int(C.EaseElasticIn(f32(frames_counter), 20, 500, 200))

            if frames_counter >= 200 {
                frames_counter = 0
                state          = 2
            }
        } else if state == 2 {      // Change ball alpha with easing (background color blending)
            frames_counter++
            ball_alpha = C.EaseCubicOut(f32(frames_counter), 0.0, 1.0, 200)

            if frames_counter >= 200 {
                frames_counter = 0
                state          = 3
            }
        } else if state == 3 {      // Reset state to play again
            if rl.is_key_pressed(rl.key_enter) {
                // Reset required variables to play again
                ball_position_x = -100
                ball_radius     = 20
                ball_alpha      = 0.0
                state           = 0
            }
        }

        if rl.is_key_pressed(rl.key_r) { frames_counter = 0 }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            if state >= 2 {
                rl.draw_rectangle(0, 0, screen_width, screen_height, rl.green)
            }
        rl.draw_circle(ball_position_x, 200, f32(ball_radius), rl.Color.fade(rl.red, 1.0 - ball_alpha))

            if state == 3 {
                rl.draw_text("PRESS [ENTER] TO PLAY AGAIN!", 240, 200, 20, rl.black)
            }

        rl.end_drawing()
    }
}
