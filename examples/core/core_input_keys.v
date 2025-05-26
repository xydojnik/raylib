/*******************************************************************************************
*
*   raylib [core] example - Keyboard input
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
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

    rl.init_window(screen_width, screen_height, "raylib [core] example - keyboard input")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut ball_position := rl.Vector2 { f32(screen_width)/2, f32(screen_height)/2 }

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_down(rl.key_right) { ball_position.x += 2.0 }
        if rl.is_key_down(rl.key_left)  { ball_position.x -= 2.0 }
        if rl.is_key_down(rl.key_up)    { ball_position.y -= 2.0 }
        if rl.is_key_down(rl.key_down)  { ball_position.y += 2.0 }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)
            rl.draw_text("move the ball with arrow keys", 10, 10, 20, rl.darkgray)
            rl.draw_circle_v(ball_position, 50, rl.maroon)

        rl.end_drawing()
    }
}
