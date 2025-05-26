/*******************************************************************************************
*
*   raylib [shapes] example - easings rectangle array
*
*   NOTE: This example requires 'easings.h' library, provided on raylib/src. Just copy
*   the library to same directory as example or make sure its available on include path.
*
*   Example originally created with raylib 2.0, last time updated with raylib 2.5
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


fn C.EaseCircOut(t f32, b f32, c f32, d f32) f32    // Ease: Circular Out
fn C.EaseLinearIn(t f32, b f32, c f32, d f32) f32   // Ease: Linear In


const recs_width  = int(50)
const recs_height = int(50)

const max_recs_x  = int(800/recs_width)
const max_recs_y  = int(450/recs_height)

const play_time_in_frames = int(240)                 // At 60 fps = 4 seconds)


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - easings rectangle array")
    defer { rl.close_window() }      // Close window and OpenGL context

    mut recs := []rl.Rectangle { len: (max_recs_x*max_recs_y) }
    for y in 0..max_recs_y {
        for x in 0..max_recs_x {
            recs[y*max_recs_x + x].x      = f32(recs_width) /2.0 + f32(recs_width) *x
            recs[y*max_recs_x + x].y      = f32(recs_height)/2.0 + f32(recs_height)*y
            recs[y*max_recs_x + x].width  = f32(recs_width)
            recs[y*max_recs_x + x].height = f32(recs_height)
        }
    }

    mut rotation       := f32(0.0)
    mut frames_counter := int(0)
    mut state          := int(0)     // Rectangles animation state: 0-Playing, 1-Finished

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if state == 0 {
            frames_counter++

            for mut rec in recs { 
                rec.height = C.EaseCircOut(f32(frames_counter), recs_height, -recs_height, play_time_in_frames)
                rec.width  = C.EaseCircOut(f32(frames_counter), recs_width,  -recs_width,  play_time_in_frames)

                if rec.height < 0 { rec.height = 0 }
                if rec.width  < 0 { rec.width  = 0 }

                if (rec.height == 0) && (rec.width == 0) { state = 1 } // Finish playing

                rotation = C.EaseLinearIn(f32(frames_counter), 0.0, 360.0, play_time_in_frames)
            }
            
        } else if (state == 1) && rl.is_key_pressed(rl.key_space) {
            // When animation has finished, press space to restart
            frames_counter = 0
            for mut rec in recs {
                rec.height = recs_height
                rec.width  = recs_width
            }
            state = 0
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            if state == 0 {
                for i in 0..max_recs_x*max_recs_y {
                    rl.draw_rectangle_pro(recs[i], rl.Vector2 { recs[i].width/2, recs[i].height/2 }, rotation, rl.red)
                }
            } else if state == 1 {
                rl.draw_text("PRESS [SPACE] TO PLAY AGAIN!", 240, 200, 20, rl.gray)
            }

        rl.end_drawing()
    }
}
