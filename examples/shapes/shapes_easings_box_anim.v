/*******************************************************************************************
*
*   raylib [shapes] example - easings box anim
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


#include "@VMODROOT/examples/shapes/reasings.h"


fn C.EaseBounceOut(t f32, b f32, c f32, d f32) f32  // Ease: Bounce Out
fn C.EaseElasticOut(t f32, b f32, c f32, d f32) f32 // Ease: Elastic Out
fn C.EaseCircOut(t f32, b f32, c f32, d f32) f32    // Ease: Circular Out
fn C.EaseQuadOut(t f32, b f32, c f32, d f32) f32    // Ease: Quadratic Out
fn C.EaseSineOut(t f32, b f32, c f32, d f32) f32    // Ease: Sine Out


const anim_types = [
    "[ EaseBounceOut ]"  // Ease: Bounce Out
    "[ EaseElasticOut ]" // Ease: Elastic Out
    "[ EaseCircOut ]"    // Ease: Circular Out
    "[ EaseQuadOut ]"    // Ease: Quadratic Out
    "[ EaseSineOut ]"    // Ease: Sine Out
]!


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - easings box anim")
    defer { rl.close_window() }       // Close window and OpenGL context

    // Box variables to be animated with easings
    mut rec := rl.Rectangle { f32(rl.get_screen_width())/2.0, -100, 100, 100 }
    mut rotation := f32(0.0)
    mut alpha    := f32(1.0)

    mut state          := int(0)
    mut frames_counter := int(0)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        match state {
            0 {     // Move box down to center of screen
                frames_counter++

                // NOTE: Remember that 3rd parameter of easing function refers to
                // desired value variation, do not confuse it with expected final value!
                rec.y = C.EaseElasticOut(f32(frames_counter), -100, f32(rl.get_screen_height())/2.0 + 100, 120)

                if frames_counter >= 120 {
                    frames_counter = 0
                    state          = 1
                }
            }
            1 {     // Scale box to an horizontal bar
                frames_counter++
                rec.height = C.EaseBounceOut(f32(frames_counter), 100, -90, 120)
                rec.width  = C.EaseBounceOut(f32(frames_counter), 100, f32(rl.get_screen_width()), 120)

                if frames_counter >= 120 {
                    frames_counter = 0
                    state          = 2
                }
            }
            2 {     // Rotate horizontal bar rectangle
                frames_counter++
                rotation = C.EaseQuadOut(f32(frames_counter), 0.0, 270.0, 240)

                if frames_counter >= 240 {
                    frames_counter = 0
                    state          = 3
                }
            }
            3 {     // Increase bar size to fill all screen
                frames_counter++
                rec.height = C.EaseCircOut(f32(frames_counter), 10, f32(rl.get_screen_width()), 120)

                if frames_counter >= 120 {
                    frames_counter = 0
                    state          = 4
                }
            }
            4 {     // Fade out animation
                frames_counter++
                alpha = C.EaseSineOut(f32(frames_counter), 1.0, -1.0, 160)

                if frames_counter >= 160 {
                    frames_counter = 0
                    state          = 5
                }
            }
            else {}
        }

        // Reset animation at any moment
        if rl.is_key_pressed(rl.key_space) {
            rec = rl.Rectangle { f32(rl.get_screen_width())/2.0, -100, 100, 100 }
            rotation       = 0.0
            alpha          = 1.0
            state          = 0
            frames_counter = 0
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_rectangle_pro(
                rec, rl.Vector2 { rec.width/2, rec.height/2 }, rotation, rl.Color.fade(rl.black, alpha)
            )

            {
                anim_state := state%anim_types.len
                txt        := anim_types[anim_state]
                txt_width  := rl.measure_text(txt.str, 20)

                rl.draw_text(txt, screen_width/2-txt_width/2, 25, 20, rl.lightgray)
            }
            rl.draw_text("PRESS [SPACE] TO RESET BOX ANIMATION!", 10, rl.get_screen_height() - 25, 20, rl.lightgray)

        rl.end_drawing()
    }
}
