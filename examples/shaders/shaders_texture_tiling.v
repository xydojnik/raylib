/*******************************************************************************************
*
*   raylib [shaders] example - texture tiling
*
*   Example demonstrates how to tile a texture on a 3D model using raylib.
*
*   Example contributed by Luis Almeida (@luis605) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2023 Luis Almeida      (@luis605)
*   Translated&Modified (c) 2024 Fedorov Alexandr (@xydojnik)
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

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - texture tiling")
    defer { rl.close_window() }             // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera3D  {
        position:    rl.Vector3 { 4.0, 4.0, 4.0 } // Camera position
        target:      rl.Vector3 { 0.0, 0.5, 0.0 } // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                         // Camera field-of-view Y
        projection:  rl.camera_perspective        // Camera projection type
    }

    // Load a cube model
    mut cube  := rl.gen_mesh_cube(1.0, 1.0, 1.0)
    mut model := rl.load_model_from_mesh(cube)
    
    // Load a texture and assign to cube model
    texture := rl.load_texture("resources/cubicmap_atlas.png")
    unsafe { model.materials[0].maps[rl.material_map_diffuse].texture = texture }

    // Set the texture tiling using a shader
    tiling := [ f32(3.0), 3.0 ]
    shader := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/tiling.fs".str)
    rl.set_shader_value(shader, rl.get_shader_location(shader, "tiling"), tiling.data, rl.shader_uniform_vec2)
    unsafe { model.materials[0].shader = shader }

    defer {
        rl.unload_model(model)      // Unload model
        rl.unload_shader(shader)    // Unload shader
        rl.unload_texture(texture)  // Unload texture
    }
    
    rl.disable_cursor()             // Limit cursor to relative movement inside the window

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

                                    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_free)

        if rl.is_key_pressed(rl.key_z) {
            camera.target = rl.Vector3 { 0.0, 0.5, 0.0 }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
        
            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)
            
                rl.begin_shader_mode(shader)
                    rl.draw_model(model, rl.Vector3 {}, 2.0, rl.white)
                rl.end_shader_mode()

                rl.draw_grid(10, 1.0)
                
            rl.end_mode_3d()

            rl.draw_text("Use mouse to rotate the camera", 10, 10, 20, rl.darkgray)

        rl.end_drawing()
    }
}
