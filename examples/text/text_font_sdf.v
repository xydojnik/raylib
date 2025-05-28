/*******************************************************************************************
*
*   raylib [text] example - Font SDF loading
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
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


const glsl_version = 330


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [text] example - SDF fonts')
    defer { rl.close_window() }     // Close window and OpenGL context

    // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

    msg := 'Signed Distance Fields'

    // Loading file to memory
    mut file_size := int(0)
    file_data     := rl.load_file_data(asset_path+'anonymous_pro_bold.ttf', &file_size)

    // Default font generation from TTF font
    mut font_default := rl.Font {}
    font_default.baseSize   = 16
    font_default.glyphCount = 95

    // Loading font data from memory data
    // Parameters > font size: 16, no glyphs array provided (0), glyphs count: 95 (autogenerate chars array)
    font_default.glyphs = rl.load_font_data(file_data, file_size, 16, voidptr(0), 95, rl.font_default)
    // Parameters > glyphs count: 95, font size: 16, glyphs padding in image: 4 px, pack method: 0 (default)
    mut atlas := rl.gen_image_font_atlas(font_default.glyphs, &font_default.recs, 95, 16, 4, 0)
    font_default.texture = rl.load_texture_from_image(atlas)
    rl.unload_image(atlas)

    // SDF font generation from TTF font
    mut font_sdf := rl.Font {}
    font_sdf.baseSize   = 16
    font_sdf.glyphCount = 95
    // Parameters > font size: 16, no glyphs array provided (0), glyphs count: 0 (defaults to 95)
    font_sdf.glyphs = rl.load_font_data(file_data, file_size, 16, voidptr(0), 0, rl.font_sdf)
    // Parameters > glyphs count: 95, font size: 16, glyphs padding in image: 0 px, pack method: 1 (Skyline algorythm)
    atlas = rl.gen_image_font_atlas(font_sdf.glyphs, &font_sdf.recs, 95, 16, 0, 1)
    font_sdf.texture = rl.load_texture_from_image(atlas)
    rl.unload_image(atlas)

    rl.unload_file_data(file_data)      // Free memory from loaded file

    defer {
        rl.unload_font(font_default)    // Default font unloading
        rl.unload_font(font_sdf)        // SDF font unloading
    }

    
    // Load SDF required shader (we use default vertex shader)
    shader := rl.Shader.load(voidptr(0), (asset_path+'shaders/glsl${glsl_version}/sdf.fs').str)!
    defer { shader.unload() }           // Unload SDF shader
    rl.set_texture_filter(font_sdf.texture, rl.texture_filter_bilinear)    // Required for SDF font

    mut font_position := rl.Vector2 { 40, f32(screen_height)/2.0 - 50 }
    mut text_size     := rl.Vector2 {}
    mut font_size     := f32(16.0)
    mut current_font  := int(0)         // 0 - font_default, 1 - font_sdf

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        font_size += rl.get_mouse_wheel_move()*8.0

        if font_size < 6 { font_size = 6 }

        current_font = int(rl.is_key_down(rl.key_space))

        text_size = if current_font == 0 {
            rl.measure_text_ex(font_default, msg, font_size, 0)
        } else {
            rl.measure_text_ex(font_sdf, msg, font_size, 0)
        }

        font_position.x = rl.get_screen_width()/2  - text_size.x/2
        font_position.y = rl.get_screen_height()/2 - text_size.y/2 + 80
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            if current_font == 1 {
                // NOTE: SDF fonts require a custom SDf shader to compute fragment color
                rl.begin_shader_mode(shader)    // Activate SDF font shader
                    rl.draw_text_ex(font_sdf, msg, font_position, font_size, 0, rl.black)
                rl.end_shader_mode()            // Activate our default shader for next drawings

                rl.draw_texture(font_sdf.texture, 10, 10, rl.black)
            } else {
                rl.draw_text_ex(font_default, msg, font_position, font_size, 0, rl.black)
                rl.draw_texture(font_default.texture, 10, 10, rl.black)
            }

            if current_font == 1 {
                rl.draw_text('SDF!', 320, 20, 80, rl.red)
            } else {
                rl.draw_text('default font', 315, 40, 30, rl.gray)
            }

            scr_width  := rl.get_screen_width()
            scr_height := rl.get_screen_height()

            rl.draw_text('FONT SIZE: 16.0', scr_width - 240, 20, 20, rl.darkgray)
            rl.draw_text('RENDER SIZE: ${font_size}', scr_width - 240, 50, 20, rl.darkgray)
            rl.draw_text('Use MOUSE WHEEL to SCALE TEXT!', scr_width - 240, 90, 10, rl.darkgray)

            rl.draw_text('HOLD SPACE to USE SDF FONT VERSION!', 340, scr_height - 30, 20, rl.maroon)

        rl.end_drawing()
    }
}
