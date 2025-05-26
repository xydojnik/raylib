/*******************************************************************************************
*
*   raylib [text] example - Rectangle bounds
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2018-2023 Vlad Adrian       (@demizdor) and Ramon Santamaria (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [text] example - draw text inside a rectangle")
    defer { rl.close_window() }      // Close window and OpenGL context

    text := "Text cannot escape\tthis container\t...word wrap also works when active so here's \
a long text for testing.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod \
tempor incididunt ut labore et dolore magna aliqua. Nec ullamcorper sit amet risus nullam eget felis eget."

    mut resizing  := false
    mut word_wrap := true

    mut container := rl.Rectangle { 25.0, 25.0, f32(screen_width) - 50.0, f32(screen_height) - 250.0 }
    mut resizer   := rl.Rectangle { container.x + container.width - 17, container.y + container.height - 17, 14, 14 }

    // Minimum width and heigh for the container rectangle
    min_width  := 60
    min_height := 60
    max_width  := f32(screen_width)  - 50.0
    max_height := f32(screen_height) - 160.0

    mut last_mouse   := rl.Vector2 {}         // Stores last mouse coordinates
    mut border_color := rl.maroon             // Container border color
    mut font         := rl.get_font_default() // Get default system font

    rl.set_target_fps(60)                     // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_space) {
            word_wrap = !word_wrap
        }

        mouse := rl.get_mouse_position()

        // Check if the mouse is inside the container and toggle border color
        if rl.check_collision_point_rec(mouse, container) {
            border_color = rl.Color.fade(rl.maroon, 0.4)
        } else if !resizing {
            border_color = rl.maroon
        }

        // Container resizing logic
        if resizing {
            if rl.is_mouse_button_released(rl.mouse_button_left) {
                resizing = false
            }

            width := container.width + (mouse.x - last_mouse.x)
            container.width = if width > min_width {
                if width < max_width {width} else {max_width}
            } else {
                min_width
            }

            height := container.height + (mouse.y - last_mouse.y)
            container.height = if height > min_height {
                if height < max_height { height } else { max_height }
            } else {
                min_height
            }
        } else {
            // Check if we're resizing
            if rl.is_mouse_button_down(rl.mouse_button_left) &&
               rl.check_collision_point_rec(mouse, resizer)
            {
                resizing = true
            }
        }

        // Move resizer rectangle properly
        resizer.x = container.x + container.width  - 17
        resizer.y = container.y + container.height - 17

        last_mouse = mouse // Update mouse
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_rectangle_lines_ex(container, 3, border_color)    // Draw container border

            // Draw text in container (add some padding)
            draw_text_boxed(font, text.str, rl.Rectangle { container.x + 4, container.y + 4, container.width - 4, container.height - 4 }, 20.0, 2.0, word_wrap, rl.gray)

            rl.draw_rectangle_rec(resizer, border_color)             // Draw the resize box

            // Draw bottom info
            rl.draw_rectangle(0, screen_height - 54, screen_width, 54, rl.gray)
            rl.draw_rectangle_rec(rl.Rectangle { 382.0, f32(screen_height) - 34.0, 12.0, 12.0 }, rl.maroon)

            rl.draw_text("Word Wrap: ", 313, screen_height-115, 20, rl.black)
            rl.draw_text(
                if word_wrap { "ON" } else { "OFF" }, 447,
                screen_height - 115, 20,
                if word_wrap { rl.red } else { rl.black }
            )
            rl.draw_text("Press [SPACE] to toggle word wrap", 218, screen_height - 86, 20, rl.gray)
            rl.draw_text("Click hold & drag the    to resize the container", 155, screen_height - 38, 20, rl.raywhite)

        rl.end_drawing()
    }
}

//--------------------------------------------------------------------------------------
// Module functions definition
//--------------------------------------------------------------------------------------

// Draw text using font inside rectangle limits
fn draw_text_boxed(font rl.Font, text &u8, rec rl.Rectangle, font_size f32, spacing f32, word_wrap bool, tint rl.Color) {
    draw_text_boxed_selectable(font, text, rec, font_size, spacing, word_wrap, tint, 0, 0, rl.white, rl.white)
}

// Draw text using font inside rectangle limits with support for text selection
fn draw_text_boxed_selectable(
    font rl.Font, text &u8, rec rl.Rectangle, font_size f32, spacing f32,
    word_wrap bool, tint rl.Color, sel_start int, select_length int,
    select_tint rl.Color, select_back_tint rl.Color
) {
    length := rl.text_length(text) // Total length in bytes of the text, scanned by codepoints in loop
    mut select_start := sel_start

    mut text_offset_y := f32(0)    // Offset between lines (on line break '\n')
    mut text_offset_x := f32(0)    // Offset X to next character to draw

    scale_factor := font_size/f32(font.baseSize)     // Character rectangle scaling factor

    mut state := word_wrap

    mut start_line := int(-1) // Index where to begin drawing (where a line begins)
    mut end_line   := int(-1) // Index where to stop drawing (where a line ends)
    mut lastk      := int(-1) // Holds last value of the character position

    // for (int i = 0, k = 0 i < length i++, k++)
    mut k := int(0)
    for i:=int(0); i < length; i++, k++ {
        // Get next codepoint from byte string and glyph index in font
        mut codepoint_byte_count := int(0)
        mut codepoint            := rl.get_codepoint(unsafe { &text[i] }, &codepoint_byte_count)
        mut index                := rl.get_glyph_index(font, codepoint)

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if codepoint == 0x3 {
            codepoint_byte_count = 1
        }
        i += codepoint_byte_count - 1

        mut glyph_width := f32(0)
        if codepoint != `\n` {
            glyph_width = unsafe { if font.glyphs[index].advanceX == 0 {
                    font.recs[index].width*scale_factor
                } else {
                    font.glyphs[index].advanceX*scale_factor
                }
            }

            if i + 1 < length {
                glyph_width = glyph_width + spacing
            }
        }

        // NOTE: When word_wrap is ON we first measure how much of the text we can draw before going outside of the rec container
        // We store this info in start_line and end_line, then we change states, draw the text between those two variables
        // and change states again and again recursively until the end of the text (or until we get outside of the container).
        // When word_wrap is OFF we don't need the measure state so we go to the drawing state immediately
        // and begin drawing on the next line before we can get outside the container.
        // if state == measure_state {
        if state {
            // TODO: There are multiple types of spaces in UNICODE, maybe it's a good idea to add support for more
            // Ref: http://jkorpela.fi/chars/spaces.html
            if (codepoint == ` `) || (codepoint == `\t`) || (codepoint == `\n`) {
                end_line = i
            }

            if (text_offset_x + glyph_width) > rec.width {
                end_line = if end_line < 1 { i } else {  end_line }
                
                if i == end_line {
                    end_line -= codepoint_byte_count
                }
                if (start_line + codepoint_byte_count) == end_line {
                    end_line = (i - codepoint_byte_count)
                }

                state = !state
            } else if (i + 1) == length {
                end_line = i
                state    = !state
            } else if codepoint == `\n` {
                state = !state
            }

            if !state {
                text_offset_x = 0
                i             = start_line
                glyph_width   = 0

                lastk, k = k-1, lastk
            }
        } else {
            if codepoint == `\n` {
                if !word_wrap {
                    text_offset_y += (font.baseSize + font.baseSize/2)*scale_factor
                    text_offset_x = 0
                }
            } else {
                if !word_wrap && ((text_offset_x + glyph_width) > rec.width) {
                    text_offset_y += (font.baseSize + font.baseSize/2)*scale_factor
                    text_offset_x = 0
                }

                // When text overflows rectangle height limit, just stop drawing
                if (text_offset_y + font.baseSize*scale_factor) > rec.height { break }
                
                // Draw selection background
                mut is_glyph_selected := false
                if (select_start >= 0)  &&
                   (k >= select_start)  &&
                   (k < (select_start + select_length))
                {
                    rl.draw_rectangle_rec(
                        rl.Rectangle {
                            rec.x + text_offset_x - 1,
                            rec.y + text_offset_y,
                            glyph_width,
                            f32(font.baseSize)*scale_factor
                        }, select_back_tint
                    )
                    is_glyph_selected = true
                }

                // Draw current character glyph
                if (codepoint != ` `) && (codepoint != `\t`) {
                    rl.draw_text_codepoint(font, codepoint,
                        rl.Vector2 {
                            rec.x + text_offset_x,
                            rec.y + text_offset_y
                        }, font_size,
                        if is_glyph_selected { select_tint } else { tint }
                    )
                }
            }

            if word_wrap && (i == end_line) {
                text_offset_y += (font.baseSize + font.baseSize/2)*scale_factor
                text_offset_x  = 0
                start_line     = end_line
                end_line       = -1
                glyph_width    = 0
                select_start  += lastk - k
                k              = lastk

                state          = !state
            }
        }

        if (text_offset_x != 0) || (codepoint != ` `) {
            text_offset_x += glyph_width  // avoid leading spaces
        }
    }
}
