/*******************************************************************************************
*
*   raylib [shaders] example - Texture Waves
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.7
*
*   Example contributed by Anata (@anatagawa) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Anata             (@anatagawa) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const glsl_version = $if PLATFORM_DESKTOP ? { 330 } $else { 100 }


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - texture waves")
    defer { rl.close_window() }          // Close window and OpenGL context

    // Load texture texture to apply shaders
    texture := rl.load_texture("resources/space.png")

    // Load shader and setup location points and values
    shader := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/wave.fs".str)

    defer {
        rl.unload_shader(shader)         // Unload shader
        rl.unload_texture(texture)       // Unload texture
    }
    
    seconds_loc := rl.get_shader_location(shader, "seconds")
    freq_x_loc  := rl.get_shader_location(shader, "freqX")
    freq_y_loc  := rl.get_shader_location(shader, "freqY")
    amp_x_loc   := rl.get_shader_location(shader, "ampX")
    amp_y_loc   := rl.get_shader_location(shader, "ampY")
    speed_x_loc := rl.get_shader_location(shader, "speedX")
    speed_y_loc := rl.get_shader_location(shader, "speedY")

    // Shader uniform values that can be updated at any time
    freq_x  := f32(25.0)
    freq_y  := f32(25.0)
    amp_x   := f32(5.0)
    amp_y   := f32(5.0)
    speed_x := f32(8.0)
    speed_y := f32(8.0)

    screen_size := [ f32(rl.get_screen_width()), f32(rl.get_screen_height()) ]
    rl.set_shader_value(shader, rl.get_shader_location(shader, "size"), screen_size.data, rl.shader_uniform_vec2)
    rl.set_shader_value(shader, freq_x_loc , &freq_x,  rl.shader_uniform_float)
    rl.set_shader_value(shader, freq_y_loc , &freq_y,  rl.shader_uniform_float)
    rl.set_shader_value(shader, amp_x_loc  , &amp_x,   rl.shader_uniform_float)
    rl.set_shader_value(shader, amp_y_loc  , &amp_y,   rl.shader_uniform_float)
    rl.set_shader_value(shader, speed_x_loc, &speed_x, rl.shader_uniform_float)
    rl.set_shader_value(shader, speed_y_loc, &speed_y, rl.shader_uniform_float)

    mut seconds := f32(0.0)

    rl.set_target_fps(60)             // Set our game to run at 60 frames-per-second
    // -------------------------------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        seconds += rl.get_frame_time()

        rl.set_shader_value(shader, seconds_loc, &seconds, rl.shader_uniform_float)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_shader_mode(shader)

                rl.draw_texture(texture, 0, 0, rl.white)
                rl.draw_texture(texture, texture.width, 0, rl.white)

            rl.end_shader_mode()

        rl.end_drawing()
    }
}
