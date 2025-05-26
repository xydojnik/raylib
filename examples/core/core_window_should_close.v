/*******************************************************************************************
*
*   raylib [core] example - Window should close
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2013-2023 Ramon Santamaria (@raysan5)
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
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - window should close")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
    
    rl.set_exit_key(rl.key_null)       // Disable KEY_ESCAPE to close window, X-button still works
    
    mut exit_window_requested := false // Flag to request window to exit
    mut exit_window           := false // Flag to set window to exit

    rl.set_target_fps(60)              // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !exit_window {
        // Update
        //----------------------------------------------------------------------------------
        // Detect if X-button or KEY_ESCAPE have been pressed to close window
        if rl.window_should_close() || rl.is_key_pressed(rl.key_escape) {
            exit_window_requested = true;
        }
        
        if exit_window_requested {
            // A request for close window has been issued, we can save data before closing
            // or just show a message asking for confirmation
            
            if      rl.is_key_pressed(rl.key_y) { exit_window           = true }
            else if rl.is_key_pressed(rl.key_n) { exit_window_requested = false }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing();

            rl.clear_background(rl.raywhite);

            if exit_window_requested {
                rl.draw_rectangle(0, 100, screen_width, 200, rl.black)
                rl.draw_text("Are you sure you want to exit program? [Y/N]", 40, 180, 30, rl.white)
            } else {
                rl.draw_text("Try to close the window to get confirmation message!", 120, 200, 20, rl.lightgray)
            }

        rl.end_drawing()
    }
}
