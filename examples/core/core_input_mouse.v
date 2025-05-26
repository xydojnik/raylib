/*******************************************************************************************
*
*   raylib [core] example - Mouse input
*
*   Example originally created with raylib 1.0, last time updated with raylib 4.0
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

    rl.init_window(screen_width, screen_height, "raylib [core] example - mouse input")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut ball_position := rl.Vector2 { -100.0, -100.0 }
    mut ball_color    := rl.darkblue

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        ball_position = rl.get_mouse_position()

        if      rl.is_mouse_button_pressed(rl.mouse_button_left)    { ball_color = rl.maroon   }
        else if rl.is_mouse_button_pressed(rl.mouse_button_middle)  { ball_color = rl.lime     }
        else if rl.is_mouse_button_pressed(rl.mouse_button_right)   { ball_color = rl.darkblue }
        else if rl.is_mouse_button_pressed(rl.mouse_button_side)    { ball_color = rl.purple   }
        else if rl.is_mouse_button_pressed(rl.mouse_button_extra)   { ball_color = rl.yellow   }
        else if rl.is_mouse_button_pressed(rl.mouse_button_forward) { ball_color = rl.orange   }
        else if rl.is_mouse_button_pressed(rl.mouse_button_back)    { ball_color = rl.beige    }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)
            rl.draw_circle_v(ball_position, 40, ball_color)
            rl.draw_text("move ball with mouse and click mouse button to change color", 10, 10, 20, rl.darkgray)

        rl.end_drawing()
    }
}
