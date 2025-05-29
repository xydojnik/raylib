/*******************************************************************************************
*
*   raylib [textures] example - Image Rotation
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const asset_path   = @VMODROOT+'/thirdparty/raylib/examples/textures/resources/'
const num_textures = 3


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [textures] example - texture rotation')
    defer { rl.close_window() }               // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    mut image45     := rl.Image.load(asset_path+'raylib_logo.png')
    mut image90     := rl.Image.load(asset_path+'raylib_logo.png')
    mut image_neg90 := rl.Image.load(asset_path+'raylib_logo.png')

    image45.rotate(45)
    image90.rotate(90)
    image_neg90.rotate(-90)

    mut textures := []rl.Texture { len: num_textures }
    defer { textures.unload() }
    
    textures[0] = rl.Texture.load_from_image(image45)
    textures[1] = rl.Texture.load_from_image(image90)
    textures[2] = rl.Texture.load_from_image(image_neg90)
    
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

            rl.draw_text('Press LEFT MOUSE BUTTON to rotate the image clockwise', 250, 420, 10, rl.darkgray)

        rl.end_drawing()
    }
}
