/*******************************************************************************************
*
*   raylib [textures] example - Procedural images generation
*
*   Example originally created with raylib 1.8, last time updated with raylib 1.8
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2O17-2023 Wilhem Barbier   (@nounoursheureux) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const num_textures = 9      // Currently we have 8 generation algorithms but some are have multiple purposes (Linear and Square Gradients)

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [textures] example - procedural images generation')
    defer { rl.close_window() }              // Close window and OpenGL context

    vertical_gradient   := rl.Image.gen_gradient_linear(screen_width, screen_height,  0, rl.red, rl.blue)
    horizontal_gradient := rl.Image.gen_gradient_linear(screen_width, screen_height, 90, rl.red, rl.blue)
    diagonal_gradient   := rl.Image.gen_gradient_linear(screen_width, screen_height, 45, rl.red, rl.blue)
    radial_gradient     := rl.Image.gen_gradient_radial(screen_width, screen_height, 0.0, rl.white, rl.black)
    square_gradient     := rl.Image.gen_gradient_square(screen_width, screen_height, 0.0, rl.white, rl.black)
    checked             := rl.Image.gen_checked(screen_width, screen_height, 32, 32, rl.red, rl.blue)
    white_noise         := rl.Image.gen_white_noise(screen_width, screen_height, 0.5)
    perlin_noise        := rl.Image.gen_perlin_noise(screen_width, screen_height, 50, 50, 4.0)
    cellular            := rl.Image.gen_cellular(screen_width, screen_height, 32)

    gen_textures := [
        'VERTICAL GRADIENT',
        'HORIZONTAL GRADIENT',
        'DIAGONAL GRADIENT',
        'RADIAL GRADIENT',
        'SQUARE GRADIENT',
        'CHECKED',
        'rl.white NOISE',
        'PERLIN NOISE',
        'CELLULAR',
    ]!
    
    // Texture2D textures[num_textures] = { 0 }
    mut textures := []rl.Texture { len: num_textures }
    textures[0] = rl.Texture.load_from_image(vertical_gradient)
    textures[1] = rl.Texture.load_from_image(horizontal_gradient)
    textures[2] = rl.Texture.load_from_image(diagonal_gradient)
    textures[3] = rl.Texture.load_from_image(radial_gradient)
    textures[4] = rl.Texture.load_from_image(square_gradient)
    textures[5] = rl.Texture.load_from_image(checked)
    textures[6] = rl.Texture.load_from_image(white_noise)
    textures[7] = rl.Texture.load_from_image(perlin_noise)
    textures[8] = rl.Texture.load_from_image(cellular)

    // Unload image data (CPU RAM)
    vertical_gradient.unload()
    horizontal_gradient.unload()
    diagonal_gradient.unload()
    radial_gradient.unload()
    square_gradient.unload()
    checked.unload()
    white_noise.unload()
    perlin_noise.unload()
    cellular.unload()

    // Unload textures data (GPU VRAM)
    // defer { for texture in textures { texture.unload() } }
    defer { textures.unload() }

    mut current_texture := int(0)

    rl.set_target_fps(60)
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {
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

            rl.draw_texture(textures[current_texture], 0, 0, rl.white)

            rl.draw_rectangle(30, 400, 325, 30, rl.Color.fade(rl.skyblue, 0.5))
            rl.draw_rectangle_lines(30, 400, 325, 30, rl.Color.fade(rl.white, 0.5))
            rl.draw_text('MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES', 40, 410, 10, rl.white)

            rl.draw_text_with_background(gen_textures[current_texture], rl.Vector2{10, 10}, 20, 5, rl.raywhite, rl.black)

        rl.end_drawing()
    }
}
