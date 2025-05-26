module main

/*******************************************************************************************
*
*   raylib [textures] example - Retrieve image data from texture: LoadImageFromTexture()
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
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
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - texture to image")
    defer { rl.close_window() }                               // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    mut image   := rl.load_image("resources/raylib_logo.png") // Load image data into CPU memory (RAM)
    mut texture := rl.load_texture_from_image(image)          // Image converted to texture, GPU memory (RAM -> VRAM)
    rl.unload_image(image)                                    // Unload image data from CPU memory (RAM)

    image = rl.load_image_from_texture(texture)               // Load image from GPU texture (VRAM -> RAM)
    rl.unload_texture(texture)                                // Unload texture from GPU memory (VRAM)

    texture = rl.load_texture_from_image(image)               // Recreate texture from retrieved image data (RAM -> VRAM)
    rl.unload_image(image)                                    // Unload retrieved image data from CPU memory (RAM)
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
        //----------------------------------------------------------------------------------
    }
    rl.unload_texture(texture)   // Texture unloading
}
