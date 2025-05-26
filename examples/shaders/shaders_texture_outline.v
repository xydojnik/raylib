/*******************************************************************************************
*
*   raylib [shaders] example - Apply an shdr_outline to a texture
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   Example originally created with raylib 4.0, last time updated with raylib 4.0
*
*   Example contributed by Samuel Skiff (@GoldenThumbs) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Samuel SKiff      (@GoldenThumbs) and Ramon Santamaria (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - Apply an outline to a texture")
    defer { rl.close_window() }      // Close window and OpenGL context

    texture      := rl.load_texture("resources/fudesumi.png")
    shdr_outline := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/outline.fs".str)

    defer {
        rl.unload_texture(texture)
        rl.unload_shader(shdr_outline)
    }

    
    mut outline_size := f32(2.0)
    outline_color    := [ f32(1.0), 0.0, 0.0, 1.0 ]     // Normalized RED color
    texture_size     := [ f32(texture.width), f32(texture.height) ]

    // Get shader locations
    outline_size_loc  := rl.get_shader_location(shdr_outline, "outlineSize")
    outline_color_loc := rl.get_shader_location(shdr_outline, "outlineColor")
    texture_size_loc  := rl.get_shader_location(shdr_outline, "textureSize")

    // Set shader values (they can be changed later)
    rl.set_shader_value(shdr_outline, outline_size_loc,  &outline_size,      rl.shader_uniform_float)
    rl.set_shader_value(shdr_outline, outline_color_loc, outline_color.data, rl.shader_uniform_vec4)
    rl.set_shader_value(shdr_outline, texture_size_loc,  texture_size.data,  rl.shader_uniform_vec2)

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        outline_size += rl.get_mouse_wheel_move()
        if outline_size < 1.0 { outline_size = 1.0 }

        rl.set_shader_value(shdr_outline, outline_size_loc, &outline_size, rl.shader_uniform_float)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_shader_mode(shdr_outline)

                rl.draw_texture(texture, rl.get_screen_width()/2 - texture.width/2, -30, rl.white)

            rl.end_shader_mode()

            rl.draw_text("Shader-based\ntexture\noutline",             10, 10 , 20, rl.gray)
            rl.draw_text("Scroll mouse wheel to\nchange outline size", 10, 72 , 20, rl.gray)
            rl.draw_text("Outline size: ${int(outline_size)} px",      10, 120, 20, rl.maroon)

            rl.draw_fps(710, 10)

        rl.end_drawing()
    }
}
