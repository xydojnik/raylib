/*******************************************************************************************
*
*   raylib [text] example - Font filters
*
*   NOTE: After font loading, font texture atlas filter could be configured for a softer
*   display of the font when scaling it to different sizes, that way, its not required
*   to generate multiple fonts at multiple sizes (as long as the scaling is not very different)
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const asset_path = @VMODROOT+'/thirdparty/raylib/examples/text/resources/'

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [text] example - font filters')
    defer { rl.close_window() }             // Close window and OpenGL context

    msg := 'Loaded Font'
    // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

    // TTF Font loading with custom generation parameters
    mut font := rl.load_font_ex(asset_path+'KAISG.ttf', 96, voidptr(0), 0)
    defer { rl.unload_font(font) }         // Font unloading

    // Generate mipmap levels to use trilinear filtering
    // NOTE: On 2D drawing it won't be noticeable, it looks like FILTER_BILINEAR
    rl.gen_texture_mipmaps(&font.texture)

    mut font_size     := f32(font.baseSize)
    mut font_position := rl.Vector2 { 40.0, f32(screen_height)/2.0 - 80.0 }
    mut text_size     := rl.Vector2 {}

    // Setup texture scaling filter
    rl.set_texture_filter(font.texture, rl.texture_filter_point)
    mut current_font_filter := int(0) // rl.texture_filter_point

    rl.set_target_fps(60)             // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {   // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        font_size += rl.get_mouse_wheel_move()*4.0

        // Choose font texture filter method
        if rl.is_key_pressed(rl.key_one) {
            rl.set_texture_filter(font.texture, rl.texture_filter_point)
            current_font_filter = 0
        } else if rl.is_key_pressed(rl.key_two) {
            rl.set_texture_filter(font.texture, rl.texture_filter_bilinear)
            current_font_filter = 1
        } else if rl.is_key_pressed(rl.key_three) {
            // NOTE: Trilinear filter won't be noticed on 2D drawing
            rl.set_texture_filter(font.texture, rl.texture_filter_trilinear)
            current_font_filter = 2
        }

        text_size = rl.measure_text_ex(font, msg, font_size, 0)

        if rl.is_key_down(rl.key_left) {
            font_position.x -= 10
        } else if rl.is_key_down(rl.key_right) {
            font_position.x += 10
        }

        // Load a dropped TTF file dynamically (at current font_size)
        if rl.is_file_dropped() {
            dropped_files := rl.load_dropped_files()

            dropped_file := unsafe { dropped_files.paths[0].vstring() }
            // NOTE: We only support first ttf file dropped
            if rl.is_file_extension(dropped_file, '.ttf') {
                rl.unload_font(font)
                font = rl.load_font_ex(dropped_file, int(font_size), voidptr(0), 0)
            }
            
            rl.unload_dropped_files(dropped_files)    // Unload filepaths from memory
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text('Use mouse wheel to change font size', 20, 20, 10, rl.gray)
            rl.draw_text('Use KEY_RIGHT and KEY_LEFT to move text', 20, 40, 10, rl.gray)
            rl.draw_text('Use 1, 2, 3 to change texture filter', 20, 60, 10, rl.gray)
            rl.draw_text('Drop a new TTF font for dynamic loading', 20, 80, 10, rl.darkgray)

            rl.draw_text_ex(font, msg, font_position, font_size, 0, rl.black)

            // TODO: It seems texSize measurement is not accurate due to chars offsets...
            //DrawRectangleLines(font_position.x, font_position.y, text_size.x, text_size.y, RED)

            rl.draw_rectangle(0, screen_height - 80, screen_width, 80, rl.lightgray)
            rl.draw_text('Font size: ${font_size}', 20, screen_height - 50, 10, rl.darkgray)
            rl.draw_text('Text size: [${text_size.x}, ${text_size.y}]', 20, screen_height - 30, 10, rl.darkgray)
            rl.draw_text('CURRENT TEXTURE FILTER:', 250, 400, 20, rl.gray)

            if current_font_filter == 0 {
                rl.draw_text('POINT', 570, 400, 20, rl.black)
            } else if current_font_filter == 1 {
                rl.draw_text('BILINEAR', 570, 400, 20, rl.black)
            } else if current_font_filter == 2 {
                rl.draw_text('TRILINEAR', 570, 400, 20, rl.black)
            }

        rl.end_drawing()
    }
}
