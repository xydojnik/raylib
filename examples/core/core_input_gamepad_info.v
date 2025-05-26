/*******************************************************************************************
*
*   raylib [core] example - Gamepad information
*
*   NOTE: This example requires a Gamepad connected to the system
*         Check raylib.h for buttons configuration
*
*   Example originally created with raylib 4.6, last time updated with raylib 4.6
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2013-2023 Ramon Santamaria  (@raysan5)
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

    rl.set_config_flags(rl.flag_msaa_4x_hint)  // Set MSAA 4X hint before windows creation

    rl.init_window(screen_width, screen_height, "raylib [core] example - gamepad information")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }      // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

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

            mut y := int(10)
            for i in 0..4 {   // MAX_GAMEPADS = 4
                if rl.is_gamepad_available(i) {
                    rl.draw_text("Gamepad name: ${rl.get_gamepad_name(i)}", 10, y, 20, rl.black)
                    y += 30
                    rl.draw_text("\tAxis count:   ${rl.get_gamepad_axis_count(i)}", 10, y, 20, rl.black)
                    y += 30

                    for axis in 0..rl.get_gamepad_axis_count(i) {
                        rl.draw_text("\tAxis ${axis} = ${rl.get_gamepad_axis_movement(i, axis)}", 10, y, 20, rl.black)
                        y += 30
                    }

                    for button in 0..32 {
                        rl.draw_text("\tButton ${button} = ${rl.is_gamepad_button_down(i, button)}", 10, y, 20, rl.black)
                        y += 30
                    }
                }
            }

            rl.draw_fps(rl.get_screen_width() - 100, 100)

        rl.end_drawing()
    }
}
