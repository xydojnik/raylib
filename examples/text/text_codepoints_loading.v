/*******************************************************************************************
*
*   raylib [text] example - Codepoints loading
*
*   Example originally created with raylib 4.2, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2022-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const asset_path = @VMODROOT+'/thirdparty/raylib/examples/text/resources/'


// Text to be displayed, must be UTF-8 (save this code file as UTF-8)
// NOTE: It can contain all the required text for the game,
// this text will be scanned to get all the required codepoints
const text = 'いろはにほへと　ちりぬるを\nわかよたれそ　つねならむ\nうゐのおくやま　けふこえて\nあさきゆめみし　ゑひもせす'

// Remove codepoint duplicates if requested
// WARNING: This process could be a bit slow if there text to process is very long
fn codepoint_remove_duplicates(codepoints &int, codepoint_count int, codepoints_result_count &int) &int {
    codepoints_no_dups_count := codepoint_count

    // int *codepoints_no_dups = (int *)calloc(codepoint_count, sizeof(int))
    codepoints_no_dups := &int(rl.mem_alloc(u32(codepoint_count)*sizeof(int)))
    
    unsafe { vmemcpy(codepoints_no_dups, codepoints, u32(codepoint_count)*sizeof(int)) }

    // Remove duplicates
    for i := int(0); i < codepoints_no_dups_count; i++ {
        for j := int(i) + 1; j < codepoints_no_dups_count; j++ {
            unsafe {
                if codepoints_no_dups[i] == codepoints_no_dups[j] {
                    for k := int(j); k < codepoints_no_dups_count; k++ {
                        codepoints_no_dups[k] = codepoints_no_dups[k + 1]
                    }
                    codepoints_no_dups_count--
                    j--
                }
            }
        }
    }
    // NOTE: The size of codepoints_no_dups is the same as original array but
    // only required positions are filled (codepoints_no_dups_count)

    unsafe { *codepoints_result_count = codepoints_no_dups_count }
    return codepoints_no_dups
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [text] example - codepoints loading')
    defer { rl.close_window() }      // Close window and OpenGL context

    // Get codepoints from text
    mut codepoint_count := int(0)
    codepoints          := rl.load_codepoints(text, &codepoint_count)

    // Removed duplicate codepoints to generate smaller font atlas
    mut codepoints_no_dups_count := int(0)
    codepoints_no_dups           := codepoint_remove_duplicates(codepoints, codepoint_count, &codepoints_no_dups_count)
    rl.unload_codepoints(codepoints)

    // Load font containing all the provided codepoint glyphs
    // A texture font atlas is automatically generated
    font := rl.load_font_ex(asset_path+'DotGothic16-Regular.ttf', 36, codepoints_no_dups, codepoints_no_dups_count)
    defer { rl.unload_font(font) }   // Unload font

    // Set bilinear scale filter for better font scaling
    rl.set_texture_filter(font.texture, rl.texture_filter_bilinear)

    rl.set_text_line_spacing(54)     // Set line spacing for multiline text (when line breaks are included '\n')

    // Free codepoints, atlas has already been generated
    unsafe { free(codepoints_no_dups) }

    mut show_font_atlas := false
    mut codepoint_size  := int(0)
    mut codepoint       := int(0)

    mut ptr := text.str

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_space) {
            show_font_atlas = !show_font_atlas
        }

        // Testing code: getting next and previous codepoints on provided text
        if rl.is_key_pressed(rl.key_right) {
            // Get next codepoint in string and move pointer
            codepoint = rl.get_codepoint_next(ptr, &codepoint_size)
            unsafe { ptr += codepoint_size }
        } else if rl.is_key_pressed(rl.key_left) {
            // Get previous codepoint in string and move pointer
            codepoint = rl.get_codepoint_previous(ptr, &codepoint_size)
            unsafe { ptr -= codepoint_size }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_rectangle(0, 0, rl.get_screen_width(), 70, rl.black)
            rl.draw_text('Total codepoints contained in provided text: ${codepoint_count}', 10, 10, 20, rl.green)
    rl.draw_text('Total codepoints required for font atlas (duplicates excluded): ${codepoints_no_dups_count}', 10, 40, 20, rl.green)

            if show_font_atlas {
                // Draw generated font texture atlas containing provided codepoints
                rl.draw_texture(font.texture, 150, 100, rl.black)
                rl.draw_rectangle_lines(150, 100, font.texture.width, font.texture.height, rl.black)
            } else {
                // Draw provided text with laoded font, containing all required codepoint glyphs
                rl.draw_text_ex(font, text, rl.Vector2 { 160, 110 }, 48, 5, rl.black)
            }

            rl.draw_text('Press SPACE to toggle font atlas view!', 10, rl.get_screen_height() - 30, 20, rl.gray)

        rl.end_drawing()
    }
}

