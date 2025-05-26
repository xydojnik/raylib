module main

/*******************************************************************************************
*
*   raylib [textures] example - Image Rotation
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

const num_textures = 3


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - texture rotation")
    defer { rl.close_window() }               // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    image45     := rl.load_image("resources/raylib_logo.png")
    image90     := rl.load_image("resources/raylib_logo.png")
    image_neg90 := rl.load_image("resources/raylib_logo.png")

    rl.image_rotate(&image45,      45)
    rl.image_rotate(&image90,      90)
    rl.image_rotate(&image_neg90, -90)

    mut textures := []rl.Texture2D { len: num_textures }
    defer { for texture in textures { rl.unload_texture(texture) } }
    
    textures[0] = rl.load_texture_from_image(image45)
    textures[1] = rl.load_texture_from_image(image90)
    textures[2] = rl.load_texture_from_image(image_neg90)
    
    mut current_texture := int(0)
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_mouse_button_pressed(rl.mouse_button_left) || rl.is_key_pressed(rl.key_right) {
            current_texture = (current_texture + 1)%num_textures // Cycle between the textures
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_texture(textures[current_texture], screen_width/2 - textures[current_texture].width/2, screen_height/2 - textures[current_texture].height/2, rl.white)

            rl.draw_text("Press LEFT MOUSE BUTTON to rotate the image clockwise", 250, 420, 10, rl.darkgray)

        rl.end_drawing()
    }
}
