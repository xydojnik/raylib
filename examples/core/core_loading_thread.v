/*******************************************************************************************
*
*   raylib [core] example - loading thread
*
*   NOTE: This example requires linking with pthreads library on MinGW, 
*   it can be accomplished passing -static parameter to compiler
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*
*   Copyright           (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

import time

const max_data_progress_value = 500


fn load_data_thread(data_loaded &bool, data_progress &int) {
    unsafe {
        for *data_progress < max_data_progress_value {
            rand_value := rl.get_random_value(10, 1000)
            time.sleep(rand_value*time.millisecond)
            *data_progress += rand_value/10
        }
        *data_loaded = true 
    }
}


enum State {
    state_waiting
    state_loading
    state_finished
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - loading thread")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut frames_counter := int(0)
    mut state          := State.state_waiting
    mut data_loaded    := false         // Data Loaded completion indicator
    mut data_progress  := int(0)        // Data progress accumulator
    
    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        match state {
            .state_waiting {
                if rl.is_key_pressed(rl.key_enter) {
                    state = .state_loading
                    go load_data_thread(&data_loaded, &data_progress)
                }
            }
            .state_loading {
                frames_counter++
                if data_loaded {
                    state = .state_finished
                }
            }
            .state_finished {
                if rl.is_key_pressed(rl.key_enter) {
                    // Reset everything to launch again
                    data_progress = 0
                    data_loaded   = false
                    state         = .state_waiting
                }
            } 
        }
        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)

            match state {
                .state_waiting { rl.draw_text("PRESS ENTER to START LOADING DATA", 150, 170, 20, rl.darkgray) }
                .state_loading {
                    rl.draw_rectangle(150, 200, data_progress, 60, rl.skyblue)
                    if (frames_counter/15)%2 == 0 {
                        rl.draw_text("LOADING DATA...", 240, 210, 40, rl.darkblue)
                    }

                }
                .state_finished {
                    rl.draw_rectangle(150, 200, 500, 60, rl.lime)
                    rl.draw_text("DATA LOADED!", 250, 210, 40, rl.green)

                }
            }

            rl.draw_rectangle_lines(150, 200, 500, 60, rl.darkgray)

        rl.end_drawing()
    }
}
