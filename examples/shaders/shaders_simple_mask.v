/*******************************************************************************************
*
*   raylib [shaders] example - Simple shader mask
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.7
*
*   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Chris Camacho     (@chriscamacho) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************
*
*   After a model is loaded it has a default material, this material can be
*   modified in place rather than creating one from scratch...
*   While all of the maps have particular names, they can be used for any purpose
*   except for three maps that are applied as cubic maps (see below)
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

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - simple shader mask")
    defer { rl.close_window() }                     // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 0.0, 1.0, 2.0 }   // Camera position
        target:      rl.Vector3 { 0.0, 0.0, 0.0 }   // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 }   // Camera up vector (rotation towards target)
        fovy:        45.0                           // Camera field-of-view Y
        projection:  rl.camera_perspective          // Camera projection type
    }

    // Define our three models to show the shader on
    torus := rl.gen_mesh_torus(0.3, 1, 16, 32)
    cube := rl.gen_mesh_cube(0.8,0.8,0.8)
    // Generate model to be shaded just to see the gaps in the other two
    sphere := rl.gen_mesh_sphere(1, 16, 16)
    
    mut model1 := rl.load_model_from_mesh(torus)
    mut model2 := rl.load_model_from_mesh(cube)
    mut model3 := rl.load_model_from_mesh(sphere)

    defer {
        rl.unload_model(model1)
        rl.unload_model(model2)
        rl.unload_model(model3)
    }

    // Load the shader
    shader := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/mask.fs".str)
    defer { rl.unload_shader(shader) }              // Unload shader

    // Frame is incremented each frame to animate the shader
    shader_frame := rl.get_shader_location(shader, "frame")
    
    // Load and apply the diffuse texture (colour map)
    tex_diffuse := rl.load_texture("resources/plasma.png")
    // Using rl.material_map_emission as a spare slot to use for 2nd texture
    // NOTE: Don't use MATERIAL_MAP_IRRADIANCE, MATERIAL_MAP_PREFILTER or  MATERIAL_MAP_CUBEMAP as they are bound as cube maps
    tex_mask := rl.load_texture("resources/mask.png")

    defer {
        rl.unload_texture(tex_diffuse)              // Unload default diffuse texture
        rl.unload_texture(tex_mask)                 // Unload texture mask
    }

    unsafe {
        model1.materials[0].maps[rl.material_map_diffuse].texture = tex_diffuse
        model2.materials[0].maps[rl.material_map_diffuse].texture = tex_diffuse

        model1.materials[0].maps[rl.material_map_emission].texture = tex_mask
        model2.materials[0].maps[rl.material_map_emission].texture = tex_mask
        
        shader.locs[rl.shader_loc_map_emission] = rl.get_shader_location(shader, "mask")

        // Apply the shader to the two models
        model1.materials[0].shader = shader
        model2.materials[0].shader = shader
    }

    mut frames_counter := int(0)
    mut rotation       := rl.Vector3 {}             // Model rotation angles

    rl.disable_cursor()                             // Limit cursor to relative movement inside the window
    rl.set_target_fps(60)                           // Set  to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {                 // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_first_person)
        
        frames_counter++
        rotation.x += 0.01
        rotation.y += 0.005
        rotation.z -= 0.0025

        // Send frames counter to shader for animation
        rl.set_shader_value(shader, shader_frame, &frames_counter, rl.shader_uniform_int)

        // Rotate one of the models
        model1.transform = rl.Matrix.rotate_xyz(rotation)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.darkblue)

            rl.begin_mode_3d(camera)

                rl.draw_model(model1, rl.Vector3 { 0.5, 0.0, 0.0 }, 1, rl.white)
                rl.draw_model_ex(model2, rl.Vector3 { -0.5, 0.0, 0.0 }, rl.Vector3 { 1.0, 1.0, 0.0 }, 50, rl.Vector3 { 1.0, 1.0, 1.0 }, rl.white)
                rl.draw_model(model3,rl.Vector3 { 0.0, 0.0, -1.5 }, 1, rl.white)
                rl.draw_grid(10, 1.0)        // Draw a grid

            rl.end_mode_3d()

            rl.draw_rectangle(
                16, 698, rl.measure_text("Frame: ${frames_counter}".str, 20) + 8, 42, rl.blue
            )
            rl.draw_text("Frame: ${frames_counter}", 20, 700, 20, rl.white)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
