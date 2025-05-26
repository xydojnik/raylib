/*******************************************************************************************
*
*   raylib [shaders] example - basic lighting
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   Example originally created with raylib 3.0, last time updated with raylib 4.2
*
*   Example contributed by Chris Camacho (@codifies) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Chris Camacho     (@codifies) and Ramon Santamaria (@raysan5)
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

    rl.set_config_flags(rl.flag_msaa_4x_hint) // Enable Multi Sampling Anti Aliasing 4x (if available)
    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - basic lighting')
    defer { rl.close_window() }                    // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 2.0, 4.0, 6.0 }  // Camera position
        target:      rl.Vector3 { 0.0, 0.5, 0.0 }  // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 }  // Camera up vector (rotation towards target)
        fovy:        45.0                          // Camera field-of-view Y
        projection : rl.camera_perspective         // Camera projection type
    }

    // Load plane model from a generated mesh
    mut model := rl.Model.load_from_mesh(rl.Mesh.gen_plane(10.0, 10.0, 3, 3))
    mut cube  := rl.Model.load_from_mesh(rl.Mesh.gen_cube(2.0, 4.0, 2.0))
    defer {
        model.unload()         // Unload the model
        cube.unload()          // Unload the model
    }

    // Load basic lighting shader
    mut shader := rl.load_shader(
        c'resources/shaders/glsl330/lighting.vs',
        c'resources/shaders/glsl330/lighting.fs'
    )
    defer { shader.unload() } // Unload shader
    
    // Get some required shader locations
    unsafe { shader.locs[rl.shader_loc_vector_view] = rl.get_shader_location(shader, 'viewPos') }
    // NOTE: "matModel" location name is automatically assigned on shader loading, 
    // no need to get the location again if using that uniform name
    // unsafe { shader.locs[rl.shader_loc_matrix_model] = rl.get_shader_location(shader, 'matModel') }
    
    // Ambient light level (some basic lighting)
    // ambient_loc := rl.get_shader_location(shader, 'ambient')
    // rl.set_shader_value(shader, ambient_loc, [ f32(0.1), 0.1, 0.1, 1.0 ].data, rl.shader_uniform_vec4)
    
    ambient_loc := shader.get_loc('ambient')
    shader.set_value(ambient_loc, [ f32(0.1), 0.1, 0.1, 1.0 ].data, rl.shader_uniform_vec4)

    // Assign out lighting shader to model
    model.set_shader(0, shader)
    cube.set_shader(0, shader)

    light_colors := [
        rl.yellow
        rl.red
        rl.green
        rl.blue
    ]!

    light_positions := [
        rl.Vector3 { -2, 1, -2 }
        rl.Vector3 {  2, 1,  2 }
        rl.Vector3 { -2, 1,  2 }
        rl.Vector3 {  2, 1, -2 }
    ]!

    // Create lights
    mut lights := []rl.Light{ cap: 4 }
    for i in 0..lights.cap {
        lights << rl.Light.create(
            rl.light_point, light_positions[i],
            rl.Vector3{},   light_colors[i],
            shader,         i
        )
    }

    // Text configs
    text_pos              := rl.Vector2{10, 40}
    text_size             := int(20)
    light_text            := 'Toggle lights keys: '
    light_text_width      := rl.measure_text(light_text.str, text_size)
    light_text_char_width := rl.measure_text('[W]'.str, text_size)
    
    rl.set_target_fps(60)                // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // rl.update_camera(&camera, rl.camera_orbital)
        camera.update(rl.camera_orbital)

        // Update the shader with the camera view vector (points towards { 0.0f, 0.0f, 0.0f })
        camera_pos := [ camera.position.x, camera.position.y, camera.position.z ]
        rl.set_shader_value(shader, unsafe { shader.locs[rl.shader_loc_vector_view] }, camera_pos.data, rl.shader_uniform_vec3)
        
        // Check key inputs to enable/disable lights
        if rl.is_key_pressed(rl.key_y) { lights[0].enabled = !lights[0].enabled }
        if rl.is_key_pressed(rl.key_r) { lights[1].enabled = !lights[1].enabled }
        if rl.is_key_pressed(rl.key_g) { lights[2].enabled = !lights[2].enabled }
        if rl.is_key_pressed(rl.key_b) { lights[3].enabled = !lights[3].enabled }
        
        // Update light values (actually, only enable/disable them)
        for light in lights { light.update_values(shader) }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                model.draw(rl.Vector3{}, 1.0, rl.white)
                cube.draw(rl.Vector3{}, 1.0, rl.white)

                // Draw spheres to show where the lights are
                for light in lights {
                    if light.enabled {
                        rl.draw_sphere_ex(light.position, 0.2, 8, 8, light.color)
                    } else {
                        rl.draw_sphere_wires(light.position, 0.2, 8, 8, rl.color_alpha(light.color, 0.3))
                    }
                }
        
                rl.draw_grid(10, 1.0)
            rl.end_mode_3d()

            rl.draw_fps(10, 10)

            yellow_color := if lights[0].enabled { rl.yellow } else { rl.darkgray }
            red_color    := if lights[1].enabled { rl.red    } else { rl.darkgray }
            green_color  := if lights[2].enabled { rl.green  } else { rl.darkgray }
            blue_color   := if lights[3].enabled { rl.blue   } else { rl.darkgray }

            rl.draw_text(light_text, int(text_pos.x), int(text_pos.y), text_size, rl.darkgray)

            rl.draw_rectangle(
                int(text_pos.x+light_text_width)-3,
                int(text_pos.y)-3,
                light_text_char_width*4+3,
                text_size+3,
                rl.black
            )
        
            rl.draw_text('[Y]', int(text_pos.x)+light_text_width+(light_text_char_width*0), int(text_pos.y), text_size, yellow_color)
            rl.draw_text('[R]', int(text_pos.x)+light_text_width+(light_text_char_width*1), int(text_pos.y), text_size, red_color)
            rl.draw_text('[G]', int(text_pos.x)+light_text_width+(light_text_char_width*2), int(text_pos.y), text_size, green_color)
            rl.draw_text('[B]', int(text_pos.x)+light_text_width+(light_text_char_width*3), int(text_pos.y), text_size, blue_color)

        rl.end_drawing()
    }
}
