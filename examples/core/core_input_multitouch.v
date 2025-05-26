/*******************************************************************************************
*
*   raylib [core] example - Input multitouch
*
*   Example originally created with raylib 2.1, last time updated with raylib 2.5
*
*   Example contributed by Berni (@Berni8k) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Berni            (@Berni8k) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl
// WARNING: INPUT: Required touch point out of range (Max touch points: 8)
const max_touch_points = 8

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - input multitouch")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut touch_positions := []rl.Vector2 { len: max_touch_points }

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Get the touch point count ( how many fingers are touching the screen )
        mut t_count := rl.get_touch_point_count()
        // Clamp touch points available ( set the maximum touch points allowed )
        if t_count > max_touch_points { t_count = max_touch_points }
        // Get touch points positions
        for i, mut touch_position in touch_positions {
            touch_position = rl.get_touch_position(i)
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)
            
            for i, touch_position in touch_positions {
                // Make sure point is not (0, 0) as this means there is no touch for it
                if (touch_position.x > 0) && (touch_position.y > 0) {
                    // Draw circle and touch index number
                    rl.draw_circle_v(touch_position, 34, rl.orange)
                    rl.draw_text("${i}", int(touch_positions[i].x) - 10, int(touch_positions[i].y) - 70, 40, rl.black)
                }
            }

            rl.draw_text("touch the screen at multiple locations to get multiple balls", 10, 10, 20, rl.darkgray)

        rl.end_drawing()
    }
}
