/*******************************************************************************************
*
*   raylib [core] example - Generate random values
*
*   Example originally created with raylib 1.1, last time updated with raylib 1.1
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [core] example - generate random values")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // SetRandomSeed(0xaabbccff)   // Set a custom random seed if desired, by default: "time(NULL)"

    mut rand_value := rl.get_random_value(-8, 5)   // Get a random integer number between -8 and 5 (both included)
    
    mut frames_counter := u32(0)        // Variable used to count frames
    
    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        frames_counter++

        // Every two seconds (120 frames) a new random value is generated
        if ((frames_counter/120)%2) == 1 {
            rand_value     = rl.get_random_value(-8, 5)
            frames_counter = 0
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("Every 2 seconds a new random value is generated:", 130, 100, 20, rl.maroon)

        rl.draw_text("${rand_value}", 360, 180, 80, rl.lightgray)

        rl.end_drawing()
    }
}
