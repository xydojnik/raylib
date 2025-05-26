/*******************************************************************************************
*
*   raylib [shaders] example - Postprocessing with custom uniform variable
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
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

const asset_path   = @VMODROOT+'/thirdparty/raylib/examples/shaders/resources/'
const glsl_version = $if PLATFORM_DESKTOP ? { 330 } $else { 100 }


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint)       // Enable Multi Sampling Anti Aliasing 4x (if available)

    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - custom uniform variable')
    defer { rl.close_window() }                     // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 8.0, 8.0, 8.0 }   // Camera position
        target:      rl.Vector3 { 0.0, 1.5, 0.0 }   // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 }   // Camera up vector (rotation towards target)
        fovy:        45.0                           // Camera field-of-view Y
        projection:  rl.camera_perspective          // Camera projection type
    }

    mut model := rl.Model.load(asset_path+'models/barracks.obj')         // Load OBJ model
    defer { model.unload() }                                            // Unload model

    texture := rl.Texture.load(asset_path+'models/barracks_diffuse.png') // Load model texture (diffuse map)
    defer { texture.unload() }                                          // Unload texture

    model.set_texture(0, rl.material_map_diffuse, texture)

    mut position := rl.Vector3 {}                   // Set model position

    // Load postprocessing shader
    // NOTE: Defining unsafe{nil} or voidptr(0) for vertex shader forces usage of internal default vertex shader
    shader := rl.Shader.load(voidptr(0), (asset_path+'shaders/glsl${glsl_version}/swirl.fs').str)!
    defer { shader.unload() }                       // Unload shader

    // Get variable (uniform) location on the shader to connect with the program
    // NOTE: If uniform variable could not be found in the shader, function returns -1
    swirl_center_loc := shader.get_loc('center')
    mut swirl_center := [ f32(screen_width/2), f32(screen_height/2) ]

    // Create a RenderTexture2D to be used for render to texture
    target := rl.RenderTexture.load(screen_width, screen_height)
    defer { target.unload() }  // Unload render texture
    
    rl.set_target_fps(60)                           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {                 // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        camera.update(rl.camera_orbital)
        
        mouse_position := rl.get_mouse_position()

        swirl_center[0] = mouse_position.x
        swirl_center[1] = screen_height - mouse_position.y

        // Send new value to the shader to be used on drawing
        shader.set_value(swirl_center_loc, swirl_center.data, rl.shader_uniform_vec2)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        // Drawing to target
        rl.begin_texture_mode(target)               // Enable drawing to texture
            rl.clear_background(rl.raywhite)        // Clear texture background

            rl.begin_mode_3d(camera)                // Begin 3d mode drawing
                model.draw(position, 0.5, rl.white) // Draw 3d model with texture
                rl.draw_grid(10, 1.0)               // Draw a grid
            rl.end_mode_3d()                        // End 3d mode drawing, returns to orthographic 2d mode

            rl.draw_text('TEXT DRAWN IN RENDER TEXTURE', 200, 10, 30, rl.red)
        rl.end_texture_mode()                       // End drawing to texture (now we have a texture available for next passes)
        // End drawing to target

        // Drawing render texture
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)        // Clear screen background

            // Enable shader using the custom uniform
            rl.begin_shader_mode(shader)
                // NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
                target.texture.draw_rec(
                    rl.Rectangle { 0, 0, f32(target.texture.width), f32(-target.texture.height) },
                    rl.Vector2 {}, rl.white
                )
            rl.end_shader_mode()

            // Draw some 2d text over drawn texture
            rl.draw_text('(c) Barracks 3D model by Alberto Cano', screen_width - 220, screen_height - 20, 10, rl.gray)
            rl.draw_fps(10, 10)
        rl.end_drawing()
        // End Drawing render texture
    }
}
