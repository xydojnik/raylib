/*******************************************************************************************
*
*   raylib [core] example - Input Gestures for Web
*
*   Example originally created with raylib 4.6-dev, last time updated with raylib 4.6-dev
*
*   Example contributed by ubkp (@ubkp) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2023 ubkp             (@ubkp)
*   Translated&Modified (c) 2024 Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

// Common variables definitions
//--------------------------------------------------------------------------------------
const screen_height         = 450
const gesture_log_size      = 20
const max_touch_count       = 32
const screen_width          = int(800)                  // update depending on web canvas
const message_position      = rl.Vector2 { 160, 7 }
const last_gesture_position = rl.Vector2 { 165, 130 }
const protractor_position   = rl.Vector2 { 266.0, 315.0 }

const colors = {
    0   : rl.black   
    1   : rl.blue    
    2   : rl.skyblue  
    4   : rl.black      
    8   : rl.lime        
    16  : rl.red          
    32  : rl.red          
    64  : rl.red          
    128 : rl.red          
    256 : rl.violet    
    512 : rl.orange    
}
const gestures = {
    0   : 'None        '
    1   : 'Tap         '
    2   : 'Double Tap  '
    4   : 'Hold        '
    8   : 'Drag        '
    16  : 'Swipe Right '
    32  : 'Swipe Left  '
    64  : 'Swipe Up    '
    128 : 'Swipe Down  '
    256 : 'Pinch In    '
    512 : 'Pinch Out   '
}


__global (
    // Last gesture variables definitions
    //--------------------------------------------------------------------------------------
    last_gesture          = int(0)

// Gesture log variables definitions and functions declarations
//--------------------------------------------------------------------------------------
    gesture_log       = []string{ len: gesture_log_size }
    gesture_log_index = gesture_log_size         // The index for the inverted circular queue (moving from last to first direction, then looping around)
    previous_gesture = 0


    log_mode = 1 // Log mode values: 0 shows repeated events 1 hides repeated events 2 shows repeated events but hide hold events 3 hides repeated events and hide hold events

    gesture_color        = rl.Color     { 0,   0, 0,  255 }
    log_button1          = rl.Rectangle { 53,  7, 48, 26  }
    log_button2          = rl.Rectangle { 108, 7, 36, 26  }
    gesture_log_position = rl.Vector2   { 10,  10 }

// Protractor variables definitions
//--------------------------------------------------------------------------------------
    angle_length          = f32(90.0)
    current_angle_degrees = f32(0.0)
    final_vector          = rl.Vector2 { 0.0, 0.0 }
    touch_position        = []rl.Vector2 { len: max_touch_count }
    mouse_position        = rl.Vector2 {0, 0}
)

// Update
//--------------------------------------------------------------------------------------
fn update() {
    // Handle common
    //--------------------------------------------------------------------------------------

    current_gesture       := int(rl.get_gesture_detected())
    current_drag_degrees  := f32(rl.get_gesture_drag_angle())
    current_pitch_degrees := f32(rl.get_gesture_pinch_angle())
    touch_count           := int(rl.get_touch_point_count())

    // Handle last gesture
    //--------------------------------------------------------------------------------------
    if (current_gesture != 0) &&
       (current_gesture != 4) &&
       (current_gesture != previous_gesture)
    {
        last_gesture = current_gesture // Filter the meaningful gestures (1, 2, 8 to 512) for the display
    }

    // Handle gesture log
    //--------------------------------------------------------------------------------------
    if rl.is_mouse_button_released(rl.mouse_button_left) {
        if rl.check_collision_point_rec(rl.get_mouse_position(), log_button1) {
            log_mode = match log_mode {
                3 { 2 } 2 { 3 } 1 { 0 }
                else { 1 }
            }
        } else if rl.check_collision_point_rec(rl.get_mouse_position(), log_button2) {
            log_mode = match log_mode {
                3 { 1 } 2 { 0 } 1 { 3 }
                else { 2 }
            }
        }
    }

    mut fill_log := false // Gate variable to be used to allow or not the gesture log to be filled
    if current_gesture !=0 {
        if log_mode == 3 { // 3 hides repeated events and hide hold events
            if ((current_gesture != 4) && (current_gesture != previous_gesture)) || (current_gesture < 3) {
                fill_log = true
            }
        } else if log_mode == 2 { // 2 shows repeated events but hide hold events
            if current_gesture != 4 { fill_log = true }
        } else if log_mode == 1 { // 1 hides repeated events
            if current_gesture != previous_gesture {
                fill_log = true
            }
        } else { // 0 shows repeated events
            fill_log = true
        }
    }

    if fill_log { // If one of the conditions from log_mode was met, fill the gesture log
        previous_gesture = current_gesture
        // gesture_color    = get_gesture_color(current_gesture)
        gesture_color = colors[ current_gesture ]
        if gesture_log_index <= 0 {
            gesture_log_index = gesture_log_size
        }
        gesture_log_index--

        // Copy the gesture respective name to the gesture log array
        // rl.text_copy(&gesture_log[gesture_log_index][0], &get_gesture_name(current_gesture)[0])
        // rl.text_copy(&gesture_log[gesture_log_index][0], &gestures[ current_gesture ])
        gesture_log[gesture_log_index] = gestures[current_gesture]
    }

    // Handle protractor
    //--------------------------------------------------------------------------------------
    if current_gesture > 255 { // aka Pinch In and Pinch Out
        current_angle_degrees = current_pitch_degrees
    } else if current_gesture > 15 { // aka Swipe Right, Swipe Left, Swipe Up and Swipe Down
        current_angle_degrees = current_drag_degrees
    } else if current_gesture > 0 { // aka Tap, Doubletap, Hold and Grab
        current_angle_degrees = 0.0
    }

    // current_angle_radians = (current_angle_degrees +90.0)*rl.pi/180 // Convert the current angle to Radians
    current_angle_radians := rl.deg2rad(current_angle_degrees +90.0) // Convert the current angle to Radians
    final_vector = rl.Vector2 {
        (angle_length*rl.sinf(current_angle_radians)) + protractor_position.x,
        (angle_length*rl.cosf(current_angle_radians)) + protractor_position.y
    } // Calculate the final vector for display

    // Handle touch and mouse pointer points
    //--------------------------------------------------------------------------------------
    if current_gesture != 0 {
        if touch_count != 0 {
            for i, mut touch_pos in touch_position {
                touch_pos = rl.get_touch_position(i) // Fill the touch positions
            }
        } else {
            mouse_position = rl.get_mouse_position()
        }
    }

    // Draw
    //--------------------------------------------------------------------------------------
    rl.begin_drawing()

        rl.clear_background(rl.raywhite)

        // Draw common
        //--------------------------------------------------------------------------------------
        rl.draw_text("*", int(message_position.x) + 5, int(message_position.y) + 5, 10, rl.black)
        rl.draw_text("Example optimized for Web/HTML5\non Smartphones with Touch Screen.", int(message_position.x) + 15, int(message_position.y) + 5, 10, rl.black)
        rl.draw_text("*", int(message_position.x) + 5, int(message_position.y) + 35, 10, rl.black)
        rl.draw_text("While running on Desktop Web Browsers,\ninspect and turn on Touch Emulation.", int(message_position.x) + 15,  int(message_position.y) + 35, 10, rl.black)

        // Draw last gesture
        //--------------------------------------------------------------------------------------
        rl.draw_text("Last gesture",                         int(last_gesture_position.x) + 33, int(last_gesture_position.y) - 47, 20, rl.black)
        rl.draw_text("Swipe         Tap       Pinch  Touch", int(last_gesture_position.x) + 17, int(last_gesture_position.y) - 18, 10, rl.black)

        rl.draw_rectangle(int(last_gesture_position.x) + 20, int(last_gesture_position.y)     , 20, 20, if last_gesture == rl.gesture_swipe_up    { rl.red } else { rl.lightgray })
        rl.draw_rectangle(int(last_gesture_position.x),      int(last_gesture_position.y) + 20, 20, 20, if last_gesture == rl.gesture_swipe_left  { rl.red } else { rl.lightgray })
        rl.draw_rectangle(int(last_gesture_position.x) + 40, int(last_gesture_position.y) + 20, 20, 20, if last_gesture == rl.gesture_swipe_right { rl.red } else { rl.lightgray })
        rl.draw_rectangle(int(last_gesture_position.x) + 20, int(last_gesture_position.y) + 40, 20, 20, if last_gesture == rl.gesture_swipe_down  { rl.red } else { rl.lightgray })

        rl.draw_ring( rl.Vector2 {last_gesture_position.x + 103, last_gesture_position.y + 16}, 6.0, 11.0, 0.0, 360.0, 0, if last_gesture == rl.gesture_drag { rl.lime  } else { rl.lightgray })

        rl.draw_circle(int(last_gesture_position.x) + 80,  int(last_gesture_position.y) + 16, 10, if last_gesture == rl.gesture_tap       { rl.blue    } else { rl.lightgray })
        rl.draw_circle(int(last_gesture_position.x) + 80,  int(last_gesture_position.y) + 43, 10, if last_gesture == rl.gesture_doubletap { rl.skyblue } else { rl.lightgray })
        rl.draw_circle(int(last_gesture_position.x) + 103, int(last_gesture_position.y) + 43, 10, if last_gesture == rl.gesture_doubletap { rl.skyblue } else { rl.lightgray })

        rl.draw_triangle(
            rl.Vector2 { int(last_gesture_position.x) + 122, int(last_gesture_position.y) + 16 },
            rl.Vector2 { int(last_gesture_position.x) + 137, int(last_gesture_position.y) + 26 },
            rl.Vector2 { int(last_gesture_position.x) + 137, int(last_gesture_position.y) + 6  },
            if last_gesture == rl.gesture_pinch_out { rl.orange } else { rl.lightgray }
        )
        rl.draw_triangle(
            rl.Vector2 { int(last_gesture_position.x) + 147, int(last_gesture_position.y) + 6 },
            rl.Vector2 { int(last_gesture_position.x) + 147, int(last_gesture_position.y) + 26 },
            rl.Vector2 { int(last_gesture_position.x) + 162, int(last_gesture_position.y) + 16 },
            if last_gesture == rl.gesture_pinch_out { rl.orange } else { rl.lightgray }
        )
        rl.draw_triangle(
            rl.Vector2 { int(last_gesture_position.x) + 125, int(last_gesture_position.y) + 33 },
            rl.Vector2 { int(last_gesture_position.x) + 125, int(last_gesture_position.y) + 53 },
            rl.Vector2 { int(last_gesture_position.x) + 140, int(last_gesture_position.y) + 43 },
            if last_gesture == rl.gesture_pinch_in { rl.violet } else { rl.lightgray }
        )
        rl.draw_triangle(
            rl.Vector2 { int(last_gesture_position.x) + 144, int(last_gesture_position.y) + 43 },
            rl.Vector2 { int(last_gesture_position.x) + 159, int(last_gesture_position.y) + 53 },
            rl.Vector2 { int(last_gesture_position.x) + 159, int(last_gesture_position.y) + 33 },
            if last_gesture == rl.gesture_pinch_in { rl.violet } else { rl.lightgray }
        )

        for i in 0..4 {
            rl.draw_circle(
                int(last_gesture_position.x) + 180,
                int(last_gesture_position.y) + 7 + i*15, 5,
                if touch_count <= i { rl.lightgray } else { gesture_color }
            )
        }

        // Draw gesture log
        //--------------------------------------------------------------------------------------
        rl.draw_text("Log", int(gesture_log_position.x), int(gesture_log_position.y), 20, rl.black)

        // Loop in both directions to print the gesture log array in the inverted order (and looping around if the index started somewhere in the middle)
        mut ii := int(0) // Iterators that will be reused by all for loops
        for i in 0..gesture_log_size {
            unsafe {
                rl.draw_text(
                    gesture_log[ii],
                    int(gesture_log_position.x),
                    int(gesture_log_position.y) + 410 - i*20, 20,
                    if i == 0 { gesture_color } else { rl.lightgray }
                )
            }
            
            ii = (ii + 1) % gesture_log_size
        }
    
        mut log_button1_color := rl.Color{}
        mut log_button2_color := rl.Color{}
    
        match log_mode {
            3    { log_button1_color = rl.maroon log_button2_color=rl.maroon }
            2    { log_button1_color = rl.gray   log_button2_color=rl.maroon }
            1    { log_button1_color = rl.maroon log_button2_color=rl.gray   }
            else { log_button1_color = rl.gray   log_button2_color=rl.gray   }
        }

        rl.draw_rectangle_rec(log_button1, log_button1_color)
        rl.draw_rectangle_rec(log_button2, log_button2_color)
    
        rl.draw_text("Hide",   int(log_button1.x) +  7, int(log_button1.y) +  3, 10, rl.white)
        rl.draw_text("Repeat", int(log_button1.x) +  7, int(log_button1.y) + 13, 10, rl.white)
        rl.draw_text("Hide",   int(log_button1.x) + 62, int(log_button1.y) +  3, 10, rl.white)
        rl.draw_text("Hold",   int(log_button1.x) + 62, int(log_button1.y) + 13, 10, rl.white)

        // Draw protractor
        //--------------------------------------------------------------------------------------
        rl.draw_text("Angle", int(protractor_position.x) + 55, int(protractor_position.y) + 76, 10, rl.black)

        // const char* angle_string      := TextFormat("%f", current_angle_degrees)
        // const int angle_string_dot    := TextFindIndex(angle_string, ".")
        // const char* angle_string_trim := TextSubtext(angle_string, 0, angle_string_dot + 3)
        angle_string := current_angle_degrees.str()
    
        rl.draw_text(angle_string, int(protractor_position.x) + 55, int(protractor_position.y) + 92, 20, gesture_color)
        rl.draw_circle(int(protractor_position.x), int(protractor_position.y), 80.0, rl.white)

        rl.draw_line_ex(
            rl.Vector2 { int(protractor_position.x) - 90, int(protractor_position.y) },
            rl.Vector2 { int(protractor_position.x) + 90, int(protractor_position.y) },
            3.0, rl.lightgray
        )
        rl.draw_line_ex(
            rl.Vector2 { int(protractor_position.x), int(protractor_position.y) - 90 },
            rl.Vector2 { int(protractor_position.x), int(protractor_position.y) + 90 },
            3.0, rl.lightgray
        )
        rl.draw_line_ex(
            rl.Vector2 { int(protractor_position.x) - 80, int(protractor_position.y) - 45 },
            rl.Vector2 { int(protractor_position.x) + 80, int(protractor_position.y) + 45 },
            3.0, rl.green
        )
        rl.draw_line_ex(
            rl.Vector2 { int(protractor_position.x) - 80, int(protractor_position.y) + 45 },
            rl.Vector2 { int(protractor_position.x) + 80, int(protractor_position.y) - 45 },
            3.0, rl.green
        )

        rl.draw_text(  "0", int(protractor_position.x) +  96, int(protractor_position.y) -   9, 20, rl.black)
        rl.draw_text( "30", int(protractor_position.x) +  74, int(protractor_position.y) -  68, 20, rl.black)
        rl.draw_text( "90", int(protractor_position.x) -  11, int(protractor_position.y) - 110, 20, rl.black)
        rl.draw_text("150", int(protractor_position.x) - 100, int(protractor_position.y) -  68, 20, rl.black)
        rl.draw_text("180", int(protractor_position.x) - 124, int(protractor_position.y) -   9, 20, rl.black)
        rl.draw_text("210", int(protractor_position.x) - 100, int(protractor_position.y) +  50, 20, rl.black)
        rl.draw_text("270", int(protractor_position.x) -  18, int(protractor_position.y) +  92, 20, rl.black)
        rl.draw_text("330", int(protractor_position.x) +  72, int(protractor_position.y) +  50, 20, rl.black)
    
        if current_angle_degrees != 0.0 {
            rl.draw_line_ex(protractor_position, final_vector, 3.0, gesture_color)
        }

        // Draw touch and mouse pointer points
        //--------------------------------------------------------------------------------------
        if current_gesture != 0 {
            if touch_count != 0 {
                // for i = 0; i < touch_count; i++ {
                for i in 0..touch_count {
                    rl.draw_circle_v(touch_position[i], 50.0, rl.Color.fade(gesture_color, 0.5))
                    rl.draw_circle_v(touch_position[i],  5.0, gesture_color)
                }

                if touch_count == 2 {
                    rl.draw_line_ex(
                        touch_position[0], touch_position[1],
                        if current_gesture == 512 { 8 } else { 12 },
                        gesture_color
                    )
                }
            } else {
                rl.draw_circle_v(mouse_position, 35.0, rl.Color.fade(gesture_color, 0.5))
                rl.draw_circle_v(mouse_position,  5.0, gesture_color)
            }
        }

    rl.end_drawing()
    //--------------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    rl.init_window(screen_width, screen_height, "raylib [core] example - input gestures web")
    //--------------------------------------------------------------------------------------
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() } // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Main game loop
    //--------------------------------------------------------------------------------------
    $if PLATFORM_WEB ? {
        emscripten_set_main_loop(update, 0, 1)
    } $else {
        rl.set_target_fps(60)
        for !rl.window_should_close() {
            update() // Detect window close button or ESC key
        }
    }
    //--------------------------------------------------------------------------------------
}
