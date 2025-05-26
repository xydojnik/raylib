module main

/*******************************************************************************************
*
*   raylib [textures] example - blend modes
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example originally created with raylib 3.5, last time updated with raylib 3.5
*
*   Example contributed by Karlo Licudine (@accidentalrebel) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2020-2023 Karlo Licudine    (@accidentalrebel)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - blend modes")
    defer { rl.close_window() }          // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    bg_image   := rl.load_image("resources/cyberpunk_street_background.png") // Loaded in CPU memory (RAM)
    bg_texture := rl.load_texture_from_image(bg_image)                       // Image converted to texture, GPU memory (VRAM)

    fg_image   := rl.load_image("resources/cyberpunk_street_foreground.png") // Loaded in CPU memory (RAM)
    fg_texture := rl.load_texture_from_image(fg_image)                       // Image converted to texture, GPU memory (VRAM)

    defer {
        rl.unload_texture(fg_texture) // Unload foreground texture
        rl.unload_texture(bg_texture) // Unload background texture
    }
    
    // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM
    rl.unload_image(bg_image)
    rl.unload_image(fg_image)

    blend_count_max := int(4)

    mut blend_mode      := int(0)

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_space) {
            if blend_mode >= (blend_count_max - 1) { blend_mode = 0 }
            else                                   { blend_mode++   }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_texture(bg_texture, screen_width/2 - bg_texture.width/2, screen_height/2 - bg_texture.height/2, rl.white)

            // Apply the blend mode and then draw the foreground texture
            rl.begin_blend_mode(blend_mode)
                rl.draw_texture(fg_texture, screen_width/2 - fg_texture.width/2, screen_height/2 - fg_texture.height/2, rl.white)
            rl.end_blend_mode()

            // Draw the texts
            rl.draw_text("Press SPACE to change blend modes.", 310, 350, 10, rl.gray)

            blend_txt := match blend_mode {
                rl.blend_alpha      { "Current: BLEND_ALPHA"      }
                rl.blend_additive   { "Current: BLEND_ADDITIVE"   } 
                rl.blend_multiplied { "Current: BLEND_MULTIPLIED" }
                rl.blend_add_colors { "Current: BLEND_ADD_COLORS" }
                else { '' }
            }

            rl.draw_text(blend_txt, screen_width/2-60, 370, 10, rl.green)

            rl.draw_text("(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screen_width - 330, screen_height - 20, 10, rl.gray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
