/*******************************************************************************************
*
*   raylib [shaders] example - Sieve of Eratosthenes
*
*   NOTE: Sieve of Eratosthenes, the earliest known (ancient Greek) prime number sieve.
*
*       'Sift the twos and sift the threes,
*        The Sieve of Eratosthenes.
*        When the multiples sublime,
*        the numbers that are left are prime.'
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
*
*   Example contributed by ProfJski and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 ProfJski and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr             (@xydojnik)
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

    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - Sieve of Eratosthenes')
    defer { rl.close_window() }             // Close window and OpenGL context

    target := rl.RenderTexture.load(screen_width, screen_height)
    defer { target.unload() }               // Unload render texture

    // Load Eratosthenes shader
    // NOTE: Defining unsafe{nil} or voidptr(0) for vertex shader forces usage of internal default vertex shader
    shader := rl.Shader.load(voidptr(0), c'resources/shaders/glsl330/eratosthenes.fs')!
    defer { shader.unload() }               // Unload shader
    
    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {         // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Nothing to do here, everything is happening in the shader
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_texture_mode(target)       // Enable drawing to texture
            rl.clear_background(rl.black)   // Clear the render texture

            // Draw a rectangle in shader mode to be used as shader canvas
            // NOTE: Rectangle uses font white character texture coordinates,
            // so shader can not be applied here directly because input vertexTexCoord
            // do not represent full screen coordinates (space where want to apply shader)
            // rl.draw_rectangle(0, 0, rl.get_screen_width(), rl.get_screen_height(), rl.black)
            rl.draw_rectangle(0, 0, screen_width, screen_height, rl.black)
        rl.end_texture_mode()               // End drawing to texture (now we have a blank texture available for the shader)

        rl.begin_drawing()
            rl.clear_background(rl.raywhite)// Clear screen background

            rl.begin_shader_mode(shader)
                // NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
            target.texture.draw_rec(
                rl.Rectangle {
                    0, 0,
                    f32( target.texture.width),
                    f32(-target.texture.height)
                },
                rl.Vector2 {},
                rl.white
            )
            rl.end_shader_mode()
        rl.end_drawing()




    }
}
