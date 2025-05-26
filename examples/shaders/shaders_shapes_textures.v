/*******************************************************************************************
*
*   raylib [shaders] example - Apply a shader to some shape or texture
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 1.7, last time updated with raylib 3.7
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria  (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - shapes and texture shaders")
    defer { rl.close_window() }            // Close window and OpenGL context

    fudesumi := rl.load_texture("resources/fudesumi.png")

    // Load shader to be used on some parts drawing
    // NOTE 1: Using GLSL 330 shader version, on OpenGL ES 2.0 use GLSL 100 shader version
    // NOTE 2: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
    shader := rl.load_shader(
        voidptr(0), "resources/shaders/glsl${glsl_version}/grayscale.fs".str
    )

    defer {
        rl.unload_shader(shader)        // Unload shader
        rl.unload_texture(fudesumi)     // Unload texture
    }
    
    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // Start drawing with default shader

            rl.draw_text("USING DEFAULT SHADER", 20, 40, 10, rl.red)

            rl.draw_circle(80, 120, 35, rl.darkblue)
            rl.draw_circle_gradient(80, 220, 60, rl.green, rl.skyblue)
            rl.draw_circle_lines(80, 340, 80, rl.darkblue)


            // Activate our custom shader to be applied on next shapes/textures drawings
            rl.begin_shader_mode(shader)

                rl.draw_text("USING CUSTOM SHADER", 190, 40, 10, rl.red)

                rl.draw_rectangle(250 - 60, 90, 120, 60, rl.red)
                rl.draw_rectangle_gradient_h(250 - 90, 170, 180, 130, rl.maroon, rl.gold)
                rl.draw_rectangle_lines(250 - 40, 320, 80, 60, rl.orange)

            // Activate our default shader for next drawings
            rl.end_shader_mode()

            rl.draw_text("USING DEFAULT SHADER", 370, 40, 10, rl.red)

            rl.draw_triangle(
                rl.Vector2 { 430,     80 },
                rl.Vector2 { 430-60, 150 },
                rl.Vector2 { 430+60, 150 },
                rl.violet
            )

            rl.draw_triangle_lines(
                rl.Vector2 { 430,    160 },
                rl.Vector2 { 430-20, 230 },
                rl.Vector2 { 430+20, 230 },
                rl.darkblue
            )

            rl.draw_poly(rl.Vector2 {430, 320}, 6, 80, 0, rl.brown)

            // Activate our custom shader to be applied on next shapes/textures drawings
            rl.begin_shader_mode(shader)

                rl.draw_texture(fudesumi, 500, -30, rl.white)    // Using custom shader

            // Activate our default shader for next drawings
            rl.end_shader_mode()

            rl.draw_text("(c) Fudesumi sprite by Eiden Marsal", 380, screen_height - 20, 10, rl.gray)

        rl.end_drawing()
    }
}
