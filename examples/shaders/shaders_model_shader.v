/*******************************************************************************************
*
*   raylib [shaders] example - Model shader
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.7
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
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

    rl.set_config_flags(rl.flag_msaa_4x_hint)      // Enable Multi Sampling Anti Aliasing 4x (if available)

    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - model shader')
    defer { rl.close_window() }             // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 4.0, 4.0,  4.0 } // Camera position
        target:      rl.Vector3 { 0.0, 1.0, -1.0 } // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                          // Camera field-of-view Y
        projection:  rl.camera_perspective         // Camera projection type

    }

    mut model := rl.Model.load('resources/models/watermill.obj')         // Load OBJ model
    defer { model.unload() }        // Unload model

    texture := rl.Texture.load('resources/models/watermill_diffuse.png') // Load model texture
    defer { texture.unload() }      // Unload texture

    // Load shader for model
    // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
    shader := rl.Shader.load(voidptr(0), c'resources/shaders/glsl330/grayscale.fs')!
    defer { shader.unload() }       // Unload shader

    model.set_shader(0, shader)                            // Set shader effect to 3d model
    model.set_texture(0, rl.material_map_diffuse, texture) // Bind texture to model

    mut position := rl.Vector3 {} // Set model position

    rl.disable_cursor()           // Limit cursor to relative movement inside the window
    rl.set_target_fps(60)         // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        camera.update(rl.camera_first_person)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                model.draw(position, 0.2, rl.white)   // Draw 3d model with texture

                rl.draw_grid(10, 1.0)     // Draw a grid

            rl.end_mode_3d()

            rl.draw_text('(c) Watermill 3D model by Alberto Cano', screen_width - 210, screen_height - 20, 10, rl.gray)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
