/*******************************************************************************************
*
*   raylib [core] examples - basic screen manager
*
*   NOTE: This example illustrates a very simple screen manager based on a states machines
*
*   Example originally created with raylib 4.0, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

//------------------------------------------------------------------------------------------
// Types and Structures Definition
//------------------------------------------------------------------------------------------
enum GameScreen {
    logo = 0
    title
    gameplay
    ending
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - basic screen manager")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut current_screen := GameScreen.logo
    // TODO: Initialize all required variables and load all required data here!
    mut frames_counter := int(0)        // Useful to count frames

    rl.set_target_fps(60)               // Set desired framerate (frames-per-second)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        match current_screen {
            .logo {
                // TODO: Update logo screen variables here!
                frames_counter++    // Count frames
                // Wait for 2 seconds (120 frames) before jumping to title screen
                if frames_counter > 120 { current_screen = .title }
            }
            .title {
                // TODO: Update title screen variables here!
                // Press enter to change to gameplay screen
                if rl.is_key_pressed(rl.key_enter) || rl.is_gesture_detected(rl.gesture_tap) {
                    current_screen = .gameplay
                }
            }
            .gameplay {
                // TODO: Update gameplay screen variables here!

                // Press enter to change to ending screen
                if rl.is_key_pressed(rl.key_enter) || rl.is_gesture_detected(rl.gesture_tap) {
                    current_screen = .ending
                }
            } 
            .ending {
                // TODO: Update ending screen variables here!
                // Press enter to return to title screen
                if rl.is_key_pressed(rl.key_enter) || rl.is_gesture_detected(rl.gesture_tap) {
                    current_screen = .title
                }
            } 
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            match current_screen {
                .logo {
                    // TODO: Draw logo screen here!
                    rl.draw_text("logo SCREEN", 20, 20, 40, rl.lightgray)
                    rl.draw_text("WAIT for 2 SECONDS...", 290, 220, 20, rl.gray)

                }
                .title {
                    // TODO: Draw title screen here!
                    rl.draw_rectangle(0, 0, screen_width, screen_height, rl.green)
                    rl.draw_text("title SCREEN", 20, 20, 40, rl.darkgreen)
                    rl.draw_text("PRESS ENTER or TAP to JUMP to gameplay SCREEN", 120, 220, 20, rl.darkgreen)

                }
                .gameplay {
                    // TODO: Draw gameplay screen here!
                    rl.draw_rectangle(0, 0, screen_width, screen_height, rl.purple)
                    rl.draw_text("gameplay SCREEN", 20, 20, 40, rl.maroon)
                    rl.draw_text("PRESS ENTER or TAP to JUMP to ending SCREEN", 130, 220, 20, rl.maroon)
                }
                .ending {
                    // TODO: Draw ending screen here!
                    rl.draw_rectangle(0, 0, screen_width, screen_height, rl.blue)
                    rl.draw_text("ending SCREEN", 20, 20, 40, rl.darkblue)
                    rl.draw_text("PRESS ENTER or TAP to RETURN to title SCREEN", 120, 220, 20, rl.darkblue)

                }
            }

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
    // TODO: Unload all loaded data (textures, fonts, audio) here!
}
