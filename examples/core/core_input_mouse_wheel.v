/*******************************************************************************************
*
*   raylib [core] examples - Mouse wheel input
*
*   Example originally created with raylib 1.1, last time updated with raylib 1.3
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

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - input mouse wheel")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    scroll_speed   := 4            // Scrolling speed in pixels
    mut box_position_y := f32(screen_height/2 - 40)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {   // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        box_position_y -= (rl.get_mouse_wheel_move()*scroll_speed)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_rectangle(screen_width/2 - 40, int(box_position_y), 80, 80, rl.maroon)

            rl.draw_text("Use mouse wheel to move the cube up and down!", 10, 10, 20, rl.gray)
            rl.draw_text("Box position Y: ${box_position_y}", 10, 40, 20, rl.lightgray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }

}
