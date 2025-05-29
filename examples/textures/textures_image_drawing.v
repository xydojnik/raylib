/*******************************************************************************************
*
*   raylib [textures] example - Image loading and drawing on it
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example originally created with raylib 1.4, last time updated with raylib 1.4
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2016-2023 Ramon Santamaria (@raysan5)
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

    rl.init_window(screen_width, screen_height, 'raylib [textures] example - image drawing')
    defer { rl.close_window() }              // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    mut cat := rl.Image.load(asset_path+'cat.png') // Load image in CPU memory (RAM)
    cat.crop(rl.Rectangle { 100, 10, 280, 380 })   // Crop an image piece
    cat.flip_horizontal()                          // Flip cropped image horizontally
    cat.resize(150, 200)                           // Resize flipped-cropped image

    mut parrots := rl.Image.load(asset_path+'parrots.png')       // Load image in CPU memory (RAM)

    // Draw one image over the other with a scaling of 1.5f
    parrots.draw(cat,
        rl.Rectangle {  0,  0, f32(cat.width),     f32(cat.height) },
        rl.Rectangle { 30, 40, f32(cat.width)*1.5, f32(cat.height)*1.5 }, rl.white
    )
    
    parrots.crop(rl.Rectangle { 0, 50, f32(parrots.width), f32(parrots.height) - 100 }) // Crop resulting image

    // Draw on the image with a few image draw methods
    parrots.draw_pixel(10, 10, rl.raywhite)
    parrots.draw_circle_lines(10, 10, 5, rl.raywhite)
    parrots.draw_rectangle(5, 20, 10, 10, rl.raywhite)

    cat.unload()       // Unload image from RAM

    // Load custom font for frawing on image
    font := rl.load_font('resources/custom_jupiter_crash.png')

    // Draw over image using custom font
    rl.image_draw_text_ex(&parrots, font, 'PARROTS & CAT', rl.Vector2 { 300, 230 }, f32(font.baseSize), -2, rl.white)

    rl.unload_font(font)                           // Unload custom font (already drawn used on image)

    texture := rl.Texture.load_from_image(parrots) // Image converted to texture, uploaded to GPU memory (VRAM)
    defer { texture.unload() }                     // Texture unloading
    parrots.unload()                               // Once image has been converted to texture and uploaded to VRAM, it can be unloaded from RAM

    rl.set_target_fps(60)
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

            rl.draw_texture(texture, screen_width/2 - texture.width/2, screen_height/2 - texture.height/2 - 40, rl.white)
            rl.draw_rectangle_lines(screen_width/2 - texture.width/2, screen_height/2 - texture.height/2 - 40, texture.width, texture.height, rl.darkgray)

            rl.draw_text('We are drawing only one texture from various images composed!', 240, 350, 10, rl.darkgray)
            rl.draw_text('Source images have been cropped, scaled, flipped and copied one over the other.', 190, 370, 10, rl.darkgray)

        rl.end_drawing()
    }
}
