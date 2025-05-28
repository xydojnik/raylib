/*******************************************************************************************
*
*   raylib [text] example - Text Writing Animation
*
*   Example originally created with raylib 1.4, last time updated with raylib 1.4
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2016-2023 Ramon Santamaria  (@raysan5)
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

    rl.init_window(screen_width, screen_height, 'raylib [text] example - text writing anim')
    defer { rl.close_window() }         // Close window and OpenGL context

    message := 'This sample illustrates a text writing\nanimation effect! Check it out! )'
    
    mut frames_counter := int(0)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_down(rl.key_space)    { frames_counter += 8 }
        else                               { frames_counter++    }

        if rl.is_key_pressed(rl.key_enter) { frames_counter = 0  }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text(message[0..(frames_counter/10)%message.len], 210, 160, 20, rl.maroon)
            rl.draw_text('PRESS [ENTER] to RESTART!',  240, 260, 20, rl.lightgray)
            rl.draw_text('PRESS [SPACE] to SPEED UP!', 239, 300, 20, rl.lightgray)

        rl.end_drawing()
    }
}
