/*******************************************************************************************
*
*   raylib [shaders] example - Multiple sample2D with default batch system
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 3.5, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2020-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib - multiple sample2D')
    defer { rl.close_window() }          // Close window and OpenGL context

    im_red  := rl.gen_image_color(800, 450, rl.Color { 255, 0, 0, 255 })
    tex_red := rl.Texture.load_from_image(im_red)
    rl.unload_image(im_red)

    im_blue  := rl.gen_image_color(800, 450, rl.Color { 0, 0, 255, 255 })
    tex_blue := rl.Texture.load_from_image(im_blue)
    rl.unload_image(im_blue)

    shader := rl.Shader.load(voidptr(0), c'resources/shaders/glsl330/color_mix.fs')!
    defer {
        tex_red.unload()  // Unload texture
        tex_blue.unload() // Unload texture
        shader.unload()   // Unload shader
    }

    tex_blue_loc := shader.get_loc('texture1')

    // Get shader uniform for divider
    divider_loc := shader.get_loc('divider')
    
    mut divider_value := f32(0.5)

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if      rl.is_key_down(rl.key_right) { divider_value += 0.01 }
        else if rl.is_key_down(rl.key_left)  { divider_value -= 0.01 }

        if      divider_value < 0.0 { divider_value = 0.0 }
        else if divider_value > 1.0 { divider_value = 1.0 }

        rl.set_shader_value(shader, divider_loc, &divider_value, rl.shader_uniform_float)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_shader_mode(shader)

                // WARNING: Additional samplers are enabled for all draw calls in the batch,
                // EndShaderMode() forces batch drawing and consequently resets active textures
                // to let other sampler2D to be activated on consequent drawings (if required)
                shader.set_value_texture(tex_blue_loc, tex_blue)

                // We are drawing tex_red using default sampler2D texture0 but
                // an additional texture units is enabled for tex_blue (sampler2D texture1)
                tex_red.draw(0, 0, rl.white)

            rl.end_shader_mode()

            rl.draw_text('Use KEY_LEFT/KEY_RIGHT to move texture mixing in shader!', 80, rl.get_screen_height() - 40, 20, rl.raywhite)

        rl.end_drawing()
    }
}
