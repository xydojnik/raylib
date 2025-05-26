/*******************************************************************************************
*
*   raylib [core] example - Input Gestures Detection
*
*   Example originally created with raylib 1.4, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2016-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const max_gesture_strings = 20
// const gesture_none        = 0

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - input gestures")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    touch_area := rl.Rectangle { 220, 10, f32(screen_width) - 230.0, f32(screen_height) - 20.0 }

    mut touch_position  := rl.Vector2{ 0, 0 }
    mut gesture_strings := []string{ len: max_gesture_strings }
    mut current_gesture := 0
    mut last_gesture    := 0

    //SetGesturesEnabled(0b0000000000001001)   // Enable only some gestures to be detected

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        last_gesture    = current_gesture
        current_gesture = rl.get_gesture_detected()
        touch_position  = rl.get_touch_position(0)

        if rl.check_collision_point_rec(touch_position, touch_area) &&
           current_gesture != rl.gesture_none
        {
            if current_gesture != last_gesture {
                // Reset gestures strings
                if gesture_strings.len + 1 >= max_gesture_strings {
                    gesture_strings.clear()
                }
                
                // Store gesture string
                gesture_strings << match current_gesture {
                    rl.gesture_tap         { "GESTURE TAP"         }
                    rl.gesture_doubletap   { "GESTURE DOUBLETAP"   }
                    rl.gesture_hold        { "GESTURE HOLD"        }
                    rl.gesture_drag        { "GESTURE DRAG"        }
                    rl.gesture_swipe_right { "GESTURE SWIPE RIGHT" }
                    rl.gesture_swipe_left  { "GESTURE SWIPE LEFT"  }
                    rl.gesture_swipe_up    { "GESTURE SWIPE UP"    }
                    rl.gesture_swipe_down  { "GESTURE SWIPE DOWN"  }
                    rl.gesture_pinch_in    { "GESTURE PINCH IN"    }
                    rl.gesture_pinch_out   { "GESTURE PINCH OUT"   }
                    else { '' }
                }
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_rectangle_rec(touch_area, rl.gray)
            rl.draw_rectangle(225, 15, screen_width - 240, screen_height - 30, rl.raywhite)

            rl.draw_text("GESTURES TEST AREA", screen_width - 270, screen_height - 40, 20, rl.Color.fade(rl.gray, 0.5))

            for i, gesture_str in gesture_strings {
                if i%2 == 0 {
                    rl.draw_rectangle(10, 30 + 20*i, 200, 20, rl.Color.fade(rl.lightgray, 0.5))
                } else {
                    rl.draw_rectangle(10, 30 + 20*i, 200, 20, rl.Color.fade(rl.lightgray, 0.3))
                }

                if i < gesture_strings.len-1 {
                    rl.draw_text(gesture_str, 35, 36 + 20*i, 10, rl.darkgray)
                } else {
                    rl.draw_text(gesture_str, 35, 36 + 20*i, 10, rl.maroon)
                }
            }

            rl.draw_rectangle_lines(10, 29, 200, screen_height - 50, rl.gray)
            rl.draw_text("DETECTED GESTURES", 50, 15, 10, rl.gray)

            if current_gesture != rl.gesture_none {
                rl.draw_circle_v(touch_position, 30, rl.maroon)
            }

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
