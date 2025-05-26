module main

/*******************************************************************************************
*
*   raylib [textures] example - Image loading and texture creation
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria  (@raysan5)
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
    screen_width  = 800
    screen_height = 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - image loading")
    defer { rl.close_window() }           // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    image   := rl.load_image("resources/raylib_logo.png") // Loaded in CPU memory (RAM)
    texture := rl.load_texture_from_image(image)          // Image converted to texture, GPU memory (VRAM)
    defer { rl.unload_texture(texture) }                  // Texture unloading
    rl.unload_image(image)                                // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM

    rl.set_target_fps(60)                 // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
        
            rl.clear_background(rl.raywhite)
            rl.draw_texture(texture, screen_width/2 - texture.width/2, screen_height/2 - texture.height/2, rl.white)
            rl.draw_text("this IS a texture loaded from an image!", 300, 370, 10, rl.gray)

        rl.end_drawing()
    }
}
