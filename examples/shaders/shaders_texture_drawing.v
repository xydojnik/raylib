/*******************************************************************************************
*
*   raylib [textures] example - Texture drawing
*
*   NOTE: This example illustrates how to draw into a blank texture using a shader
*
*   Example originally created with raylib 2.0, last time updated with raylib 3.7
*
*   Example contributed by Michał Ciesielski and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Michał Ciesielski and Ramon Santamaria (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - texture drawing")
    defer { rl.close_window() }      // Close window and OpenGL context

    im_blank := rl.gen_image_color(1024, 1024, rl.blank)
    texture := rl.load_texture_from_image(im_blank)  // Load blank texture to fill on shader
    rl.unload_image(im_blank)

    // NOTE: Using GLSL 330 shader version, on OpenGL ES 2.0 use GLSL 100 shader version
    shader := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/cubes_panning.fs".str)
    defer { rl.unload_shader(shader) }

    mut time := f32(0.0)
    time_loc := rl.get_shader_location(shader, "uTime")
    rl.set_shader_value(shader, time_loc, &time, rl.shader_uniform_float)

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    // -------------------------------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        time = f32(rl.get_time())
        rl.set_shader_value(shader, time_loc, &time, rl.shader_uniform_float)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_shader_mode(shader)                 // Enable our custom shader for next shapes/textures drawings
                rl.draw_texture(texture, 0, 0, rl.white) // Drawing rl.blank texture, all magic happens on shader
            rl.end_shader_mode()                         // Disable our custom shader, return to default shader

            rl.draw_text("BACKGROUND is PAINTED and ANIMATED on SHADER!", 10, 10, 20, rl.maroon)

        rl.end_drawing()
    }
}
