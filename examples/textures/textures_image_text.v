/*******************************************************************************************
*
*   raylib [texture] example - Image text drawing using TTF generated font
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const asset_path  = @VMODROOT+'/thirdparty/raylib/examples/textures/resources/'

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [texture] example - image text drawing')
    defer { rl.close_window() }                        // Close window and OpenGL context

    parrots := rl.Image.load(asset_path+'parrots.png') // Load image in CPU memory (RAM)
                                                       // TTF Font loading with custom generation parameters
    font := rl.load_font_ex(asset_path+'KAISG.ttf', 64, voidptr(0), 0)
    defer { rl.unload_font(font) }                     // Unload custom font

                                                       // Draw over image using custom font
    rl.image_draw_text_ex(&parrots, font, '[Parrots font drawing]', rl.Vector2 { 20.0, 20.0 }, f32(font.baseSize), 0.0, rl.red)

    texture := rl.load_texture_from_image(parrots)     // Image converted to texture, uploaded to GPU memory (VRAM)
    parrots.unload()                                   // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM
    defer { texture.unload() }                         // Texture unloading

    position := rl.Vector2 {
        f32(screen_width /2 - texture.width /2),
        f32(screen_height/2 - texture.height/2 - 20)
    }

    mut show_font := false

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        show_font = rl.is_key_down(rl.key_space)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            if !show_font {
                // Draw texture with text already drawn inside
                rl.draw_texture_v(texture, position, rl.white)

                // Draw text directly using sprite font
                rl.draw_text_ex(
                    font, '[Parrots font drawing]',
                    rl.Vector2 { position.x + 20,
                    position.y + 20 + 280 },
                    f32(font.baseSize), 0.0, rl.white)
            } else {
                rl.draw_texture(font.texture, screen_width/2 - font.texture.width/2, 50, rl.black)
            }

            rl.draw_text('PRESS SPACE to SHOW FONT ATLAS USED', 290, 420, 10, rl.darkgray)

        rl.end_drawing()
    }
}
