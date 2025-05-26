/*******************************************************************************************
*
*   raylib [shaders] example - Mesh instancing
*
*   Example originally created with raylib 3.7, last time updated with raylib 4.2
*
*   Example contributed by @seanpringle and reviewed by Max (@moliad) and Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2020-2023 @seanpringle, Max (@moliad) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const max_instances = 10000

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - mesh instancing')
    defer { rl.close_window() }         // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { -125.0, 125.0, -125.0 } // Camera position
        target:      rl.Vector3 {}                        // Camera looking at point
        up:          rl.Vector3 { y:1.0 }                 // Camera up vector (rotation towards target)
        fovy:        45.0                                 // Camera field-of-view Y
        projection:  rl.camera_perspective                // Camera projection type
    }

    // Define mesh to be instanced
    cube := rl.gen_mesh_cube(1.0, 1.0, 1.0)

    // Define transforms to be uploaded to GPU for instances
    // mut transforms := rl.Matrix *(rl.rl_calloc(max_instances, sizeof(rl.matrix)))   // Pre-multiplied transformations passed to rlgl
    mut transforms := []rl.Matrix{ len: max_instances }   // Pre-multiplied transformations passed to rlgl

    // Translate and rotate cubes randomly
    for mut transform in transforms {
        translation := rl.Matrix.translate(
            f32(rl.get_random_value(-50, 50)),
            f32(rl.get_random_value(-50, 50)),
            f32(rl.get_random_value(-50, 50))
        )
        axis := rl.Vector3.normalize(
            rl.Vector3 {
                f32(rl.get_random_value(0, 360)),
                f32(rl.get_random_value(0, 360)),
                f32(rl.get_random_value(0, 360))
            }
        )
        angle    := rl.deg2rad(f32(rl.get_random_value(0, 10)))
        rotation := rl.Matrix.rotate(axis, angle)

        transform = rl.Matrix.multiply(rotation, translation)
    }

    // Load lighting shader
    mut shader := rl.Shader.load(
        c'resources/shaders/glsl330/lighting_instancing.vs',
        c'resources/shaders/glsl330/lighting.fs'
    )!
    
    // Get shader locations
    shader.set_loc(rl.shader_loc_matrix_mvp,  'mvp')
    shader.set_loc(rl.shader_loc_vector_view, 'viewPos')
    shader.set_loc_attrib(rl.shader_loc_matrix_model, 'instanceTransform')

    // Set shader value: ambient light level
    ambient_loc := shader.get_loc('ambient')
    shader.set_value(ambient_loc, [ f32(0.2), 0.2, 0.2, 1.0 ].data, rl.shader_uniform_vec4)

    // Create one light
    mut light := rl.Light.create(rl.light_directional, rl.Vector3 { 50.0, 50.0, 0.0 }, rl.Vector3{}, rl.white, shader, 0)
    light.enabled = true

    // NOTE: We are assigning the intancing shader to material.shader
    // to be used on mesh drawing with DrawMeshInstanced()
    // Material mat_instances = rl.load_material_default()
    mut mat_instances := rl.Material.get_default()
    mat_instances.shader = shader
    unsafe { mat_instances.maps[rl.material_map_diffuse].color = rl.red }

    // Load default material (using raylib intenral default shader) for non-instanced mesh drawing
    // WARNING: Default shader enables vertex color attribute BUT GenMeshCube() does not generate vertex colors, so,
    // when drawing the color attribute is disabled and a default color value is provided as input for thevertex attribute
    mut mat_default := rl.load_material_default()
    unsafe { mat_default.maps[rl.material_map_diffuse].color = rl.blue }

    rl.set_target_fps(60)                // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        camera.update(rl.camera_orbital)

        // Update the light shader with the camera view position
        unsafe { shader.set_value(shader.locs[rl.shader_loc_vector_view], &camera.position, rl.shader_uniform_vec3) }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                // Draw cube mesh with default material (rl.blue)
                // rl.draw_mesh(cube, mat_default, rl.Matrix.translate(-10.0, 0.0, 0.0))
                cube.draw(mat_default, rl.Matrix.translate(-10.0, 0.0, 0.0))

                // Draw meshes instanced using material containing instancing shader (rl.red + lighting),
                // transforms[] for the instances should be provided, they are dynamically
                // updated in GPU every frame, so we can animate the different mesh instances
                // rl.draw_mesh_instanced(cube, mat_instances, transforms.data, max_instances)
                cube.draw_instanced(mat_instances, transforms)

                // Draw cube mesh with default material (rl.blue)
                cube.draw(mat_default, rl.Matrix.translate(10.0, 0.0, 0.0))

            rl.end_mode_3d()

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
