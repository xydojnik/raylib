/*******************************************************************************************
*
*   raylib [text] example - Text formatting
*
*   Example originally created with raylib 1.1, last time updated with raylib 3.0
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

    rl.init_window(screen_width, screen_height, 'raylib [text] example - text formatting')
    defer { rl.close_window() }      // Close window and OpenGL context

    score   := int(100020)
    hiscore := int(200450)
    lives   := int(5)

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

        rl.clear_background(rl.raywhite)

            // RAYLIB TextFormt function is not working in vlang and no need to use it.
            rl.draw_text('Score: ${score}',     200, 80 , 20, rl.red)
            rl.draw_text('HiScore: ${hiscore}', 200, 120, 20, rl.green)
            rl.draw_text('Lives: ${lives}',     200, 160, 40, rl.blue)
            rl.draw_text('Elapsed Time: ${rl.get_frame_time()*1000} ms', 200, 220, 20, rl.black)

        rl.end_drawing()
    }
}
