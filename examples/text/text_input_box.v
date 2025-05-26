/*******************************************************************************************
*
*   raylib [text] example - Input Box
*
*   Example originally created with raylib 1.7, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const max_input_chars = 9

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [text] example - input box")
    defer { rl.close_window() }       // Close window and OpenGL context

    // NOTE: One extra space required for null terminator char '\0'
    // char name[max_input_chars + 1] = "\0"
    mut name := []u8 { len: max_input_chars+1, init: `\0` }

    text_box := rl.Rectangle { f32(screen_width)/2.0 - 100, 180, 225, 50 }
    
    mut letter_count   := int(0)
    mut mouse_on_text  := false
    mut frames_counter := int(0)

    rl.set_target_fps(10)               // Set our game to run at 10 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mouse_on_text = rl.check_collision_point_rec(rl.get_mouse_position(), text_box)

        if mouse_on_text {
            // Set the window's cursor to the I-Beam
            rl.set_mouse_cursor(rl.mouse_cursor_ibeam)

            // Get char pressed (unicode character) on the queue
            mut key := rl.get_char_pressed()

            // Check if more characters have been pressed on the same frame
            for key > 0 {
                // NOTE: Only allow keys in range [32..125]
                if (key >= 32) && (key <= 125) && (letter_count < max_input_chars) {
                    name[letter_count]   = u8(key)
                    name[letter_count+1] = `\0` // Add null terminator at the end of the string.
                    letter_count++
                }
                key = rl.get_char_pressed()  // Check next character in the queue
            }

            if rl.is_key_pressed(rl.key_backspace) {
                letter_count--
                if letter_count < 0 { letter_count = 0 }
                name[letter_count] = `\0`
            }
        } else {
            rl.set_mouse_cursor(rl.mouse_cursor_default)
        }

        frames_counter = if mouse_on_text { frames_counter+1 } else { 0 }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("PLACE MOUSE OVER INPUT BOX!", 240, 140, 20, rl.gray)
            rl.draw_rectangle_rec(text_box, rl.lightgray)
        
            rl.draw_rectangle_lines(
                int(text_box.x), int(text_box.y), int(text_box.width), int(text_box.height),
                if mouse_on_text { rl.red } else { rl.darkgray }
            )

            rl.draw_text(name.bytestr(), int(text_box.x)+5, int(text_box.y)+8, 40, rl.maroon)
            rl.draw_text("INPUT CHARS: ${letter_count} ${max_input_chars}", 315, 250, 20, rl.darkgray)

            if mouse_on_text {
                if letter_count < max_input_chars {
                    // Draw blinking underscore char
                    if ((frames_counter/20)%2) == 0 {
                        rl.draw_text("_", int(text_box.x) + 8 + rl.measure_text(name.data, 40), int(text_box.y) + 12, 40, rl.maroon)
                    }
                } else {
                    rl.draw_text("Press BACKSPACE to delete chars...", 230, 300, 20, rl.gray)
                }
            }

        rl.end_drawing()
    }
}

// Check if any key is pressed
// NOTE: We limit keys check to keys between 32 (KEY_SPACE) and 126
fn is_any_key_pressed() bool {
    mut key_pressed := false
    key := rl.get_key_pressed()
    if (key >= 32) && (key <= 126) {
        key_pressed = true
    }
    return key_pressed
}
