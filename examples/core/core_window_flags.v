/*******************************************************************************************
*
*   raylib [core] example - window flags
*
*   Example originally created with raylib 3.5, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2020-2023 Ramon Santamaria (@raysan5)
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
    //---------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    // Possible window flags
    /*
        rl.flag_vsync_hint
        rl.flag_fullscreen_mode    -> not working properly -> wrong scaling!
        rl.flag_window_resizable
        rl.flag_window_undecorated
        rl.flag_window_transparent
        rl.flag_window_hidden
        rl.flag_window_minimized   -> Not supported on window creation
        rl.flag_window_maximized   -> Not supported on window creation
        rl.flag_window_unfocused
        rl.flag_window_topmost
        rl.flag_window_highdpi     -> errors after minimize-resize, fb size is recalculated
        rl.flag_window_always_run
        l.flag_msaa_4x_hint
    */

    // Set configuration flags for window creation
    //SetConfigFlags(rl.flag_vsync_hint | rl.flag_msaa_4x_hint | rl.flag_window_highdpi)
    rl.init_window(screen_width, screen_height, "raylib [core] example - window flags")
    // De-Initialization
    //---------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //----------------------------------------------------------

    mut ball_position := rl.Vector2 { f32(rl.get_screen_width()) / 2.0, f32(rl.get_screen_height()) / 2.0 }
    mut ball_speed    := rl.Vector2 { 5.0, 4.0 }
    mut ball_radius   := 20

    mut frames_counter := 0

    //SetTargetFPS(60)               // Set our game to run at 60 frames-per-second
    //----------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //-----------------------------------------------------
        if rl.is_key_pressed(rl.key_f) {
            rl.toggle_fullscreen()  // modifies window size when scaling!
        }

        if rl.is_key_pressed(rl.key_r) {
            if rl.is_window_state(rl.flag_window_resizable) {
                rl.clear_window_state(rl.flag_window_resizable)
            } else {
                rl.set_window_state(rl.flag_window_resizable)
            }
        }

        if rl.is_key_pressed(rl.key_d) {
            if rl.is_window_state(rl.flag_window_undecorated) {
                rl.clear_window_state(rl.flag_window_undecorated)
            } else {
                rl.set_window_state(rl.flag_window_undecorated)
            }
        }

        if rl.is_key_pressed(rl.key_h) {
            if !rl.is_window_state(rl.flag_window_hidden) {
                rl.set_window_state(rl.flag_window_hidden)
            }
            frames_counter = 0
        }

        if rl.is_window_state(rl.flag_window_hidden) {
            frames_counter++
            if frames_counter >= 240 {
                rl.clear_window_state(rl.flag_window_hidden) // Show window after 3 seconds
            }
        }

        if rl.is_key_pressed(rl.key_n) {
            if !rl.is_window_state(rl.flag_window_minimized) {
                rl.minimize_window()
            }
            frames_counter = 0
        }

        if rl.is_window_state(rl.flag_window_minimized) {
            frames_counter++
            if frames_counter >= 240 {
                rl.restore_window() // Restore window after 3 seconds
            }
        }

        if rl.is_key_pressed(rl.key_m) {
            // NOTE: Requires rl.flag_window_resizable enabled!
            if rl.is_window_state(rl.flag_window_maximized) {
                rl.restore_window()
            } else {
                rl.maximize_window()
            }
        }

        if rl.is_key_pressed(rl.key_u) {
            if rl.is_window_state(rl.flag_window_unfocused) {
                rl.clear_window_state(rl.flag_window_unfocused)
            } else {
                rl.set_window_state(rl.flag_window_unfocused)
            }
        }

        if rl.is_key_pressed(rl.key_t) {
            if rl.is_window_state(rl.flag_window_topmost) {
                rl.clear_window_state(rl.flag_window_topmost)
            } else {
                rl.set_window_state(rl.flag_window_topmost)
            }
        }

        if rl.is_key_pressed(rl.key_a) {
            if rl.is_window_state(rl.flag_window_always_run) {
                rl.clear_window_state(rl.flag_window_always_run)
            } else {
                rl.set_window_state(rl.flag_window_always_run)
            }
        }

        if rl.is_key_pressed(rl.key_v) {
            if rl.is_window_state(rl.flag_vsync_hint) {
                rl.clear_window_state(rl.flag_vsync_hint)
            } else {
                rl.set_window_state(rl.flag_vsync_hint)
            }
        }

        // Bouncing ball logic
        ball_position.x += ball_speed.x
        ball_position.y += ball_speed.y

        if (ball_position.x >= (rl.get_screen_width()  - ball_radius)) || (ball_position.x <= ball_radius) { ball_speed.x *= -1.0 }
        if (ball_position.y >= (rl.get_screen_height() - ball_radius)) || (ball_position.y <= ball_radius) { ball_speed.y *= -1.0 }
        //-----------------------------------------------------

        // Draw
        //-----------------------------------------------------
        rl.begin_drawing()

        if rl.is_window_state(rl.flag_window_transparent) {
            rl.clear_background(rl.blank)
        } else {
            rl.clear_background(rl.raywhite)
        }

        rl.draw_circle_v(ball_position, ball_radius, rl.maroon)
        rl.draw_rectangle_lines_ex(rl.Rectangle { 0, 0, f32(rl.get_screen_width()), f32(rl.get_screen_height()) }, 4, rl.raywhite)

        rl.draw_circle_v(rl.get_mouse_position(), 10, rl.darkblue)

        rl.draw_fps(10, 10)

        rl.draw_text("Screen Size: [${rl.get_screen_width()}, ${rl.get_screen_height()}]", 10, 40, 10, rl.green)

        // Draw window state info
        rl.draw_text("Following flags can be set after window creation:", 10, 60, 10, rl.gray)

        if rl.is_window_state(rl.flag_fullscreen_mode) {
            rl.draw_text("[F] rl.flag_fullscreen_mode: on", 10, 80, 10, rl.lime)
        } else {
            rl.draw_text("[F] rl.flag_fullscreen_mode: off", 10, 80, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_resizable) {
            rl.draw_text("[R] rl.flag_window_resizable: on", 10, 100, 10, rl.lime)
        } else {
            rl.draw_text("[R] rl.flag_window_resizable: off", 10, 100, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_undecorated) {
            rl.draw_text("[D] rl.flag_window_undecorated: on", 10, 120, 10, rl.lime)
        } else {
            rl.draw_text("[D] rl.flag_window_undecorated: off", 10, 120, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_hidden) {
            rl.draw_text("[H] rl.flag_window_hidden: on", 10, 140, 10, rl.lime)
        } else {
            rl.draw_text("[H] rl.flag_window_hidden: off", 10, 140, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_minimized) {
            rl.draw_text("[N] rl.flag_window_minimized: on", 10, 160, 10, rl.lime)
        } else {
            rl.draw_text("[N] rl.flag_window_minimized: off", 10, 160, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_maximized) {
            rl.draw_text("[M] rl.flag_window_maximized: on", 10, 180, 10, rl.lime)
        } else {
            rl.draw_text("[M] rl.flag_window_maximized: off", 10, 180, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_unfocused) {
            rl.draw_text("[G] rl.flag_window_unfocused: on", 10, 200, 10, rl.lime)
        } else {
            rl.draw_text("[U] rl.flag_window_unfocused: off", 10, 200, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_topmost) {
            rl.draw_text("[T] rl.flag_window_topmost: on", 10, 220, 10, rl.lime)
        } else {
            rl.draw_text("[T] rl.flag_window_topmost: off", 10, 220, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_always_run) {
            rl.draw_text("[A] rl.flag_window_always_run: on", 10, 240, 10, rl.lime)
        } else {
            rl.draw_text("[A] rl.flag_window_always_run: off", 10, 240, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_vsync_hint) {
            rl.draw_text("[V] rl.flag_vsync_hint: on", 10, 260, 10, rl.lime)
        } else {
            rl.draw_text("[V] rl.flag_vsync_hint: off", 10, 260, 10, rl.maroon)
        }

        rl.draw_text("Following flags can only be set before window creation:", 10, 300, 10, rl.gray)
        
        if rl.is_window_state(rl.flag_window_highdpi) {
            rl.draw_text("rl.flag_window_highdpi: on", 10, 320, 10, rl.lime)
        } else {
            rl.draw_text("rl.flag_window_highdpi: off", 10, 320, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_window_transparent) {
            rl.draw_text("rl.flag_window_transparent: on", 10, 340, 10, rl.lime)
        } else {
            rl.draw_text("rl.flag_window_transparent: off", 10, 340, 10, rl.maroon)
        }
        
        if rl.is_window_state(rl.flag_msaa_4x_hint) {
            rl.draw_text("rl.flag_msaa_4x_hint: on", 10, 360, 10, rl.lime)
        } else {
            rl.draw_text("rl.flag_msaa_4x_hint: off", 10, 360, 10, rl.maroon)
        }

        rl.end_drawing()
        //-----------------------------------------------------
    }
}
