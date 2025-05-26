/*******************************************************************************************
*   raylib [shaders] example - fog
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
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
********************************************************************************************/

module main

import raylib as rl


// Program main entry point
fn main() {
    // Initialization
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint) // Enable Multi Sampling Anti Aliasing 4x (if available)
    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - fog')
    defer { rl.close_window() }         // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 2.0, 2.0, 6.0 }   // Camera position
        target:      rl.Vector3 { 0.0, 0.5, 0.0 }   // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 }   // Camera up vector (rotation towards target)
        fovy:        45.0                           // Camera field-of-view Y
        projection:  rl.camera_perspective          // Camera projection type
    }

    // Load models and texture
    mut model_a := rl.Model.load_from_mesh(rl.Mesh.gen_torus(0.4, 1.0, 16, 32))
    mut model_b := rl.Model.load_from_mesh(rl.Mesh.gen_cube(1.0, 1.0, 1.0))
    mut model_c := rl.Model.load_from_mesh(rl.Mesh.gen_sphere(0.5, 32, 32))
    
    texture := rl.Texture.load('resources/texel_checker.png')
    
    defer {
        rl.unload_model(model_a)        // Unload the model A
        rl.unload_model(model_b)        // Unload the model B
        rl.unload_model(model_c)        // Unload the model C
        rl.unload_texture(texture)      // Unload the texture
    }

    // Assign texture to default model material
    model_a.set_texture(0, rl.material_map_diffuse, texture)
    model_b.set_texture(0, rl.material_map_diffuse, texture)
    model_c.set_texture(0, rl.material_map_diffuse, texture)

    // Load shader and set up some uniforms
    shader := rl.Shader.load(
        c'resources/shaders/glsl330/lighting.vs',
        c'resources/shaders/glsl330/fog.fs'
    )!
    defer { shader.unload() }           // Unload shader   
    
    unsafe {
        shader.locs[rl.shader_loc_matrix_model] = shader.get_loc('matModel')
        shader.locs[rl.shader_loc_vector_view]  = shader.get_loc('viewPos')
    }

    // Ambient light level
    ambient_loc := shader.get_loc('ambient')
    shader.set_value(ambient_loc, [f32(0.2), 0.2, 0.2, 1.0].data, rl.shader_uniform_vec4)

    mut fog_density := f32(0.15)

    fog_density_loc := rl.get_shader_location(shader, 'fogDensity')
    shader.set_value(fog_density_loc, &fog_density, rl.shader_uniform_float)

    // NOTE: All models share the same shader
    model_a.set_shader(0, shader)
    model_b.set_shader(0, shader)
    model_c.set_shader(0, shader)

    // Using just 1 point lights
    rl.Light.create(
        rl.light_directional,
        rl.Vector3{ 0, 2, 6 },
        rl.Vector3{}, rl.white, shader, 0
    )

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        camera.update(rl.camera_orbital)

        if rl.is_key_down(rl.key_up) {
            fog_density += 0.001
            if fog_density > 1.0 { fog_density = 1.0 }
        } else if rl.is_key_down(rl.key_down) {
            fog_density -= 0.001
            if fog_density < 0.0 { fog_density = 0.0 }
        }

        shader.set_value(fog_density_loc, &fog_density, rl.shader_uniform_float)

        // Rotate the torus
        model_a.transform = rl.Matrix.multiply(model_a.transform, rl.Matrix.rotate_x(-0.025))
        model_a.transform = rl.Matrix.multiply(model_a.transform, rl.Matrix.rotate_z( 0.012))

        // Update the light shader with the camera view position
        unsafe {
            shader.set_value(
                shader.locs[rl.shader_loc_vector_view],
                &camera.position, rl.shader_uniform_vec3
            )
        }

        // Draw
        rl.begin_drawing()

            rl.clear_background(rl.gray)

            rl.begin_mode_3d(camera)

                // Draw the three models
                model_a.draw(rl.Vector3{},             1.0, rl.white)
                model_b.draw(rl.Vector3{ -2.6, 0, 0 }, 1.0, rl.white)
                model_c.draw(rl.Vector3{  2.6, 0, 0 }, 1.0, rl.white)

                for i := int(-20); i < 20; i += 2 {
                    model_a.draw(rl.Vector3{ f32(i), 0, 2 }, 1.0, rl.white)
                }

            rl.end_mode_3d()

            rl.draw_text('Use rl.key_up/rl.key_down to change fog density [${fog_density}]', 10, 10, 20, rl.raywhite)

        rl.end_drawing()
    }
}
