/*******************************************************************************************
*
*   raylib [shaders] example - Vertex displacement
*
*   Example originally created with raylib 5.0, last time updated with raylib 4.5
*
*   Example contributed by <Alex ZH> (@ZzzhHe) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*  Copyright           (c) 2023 <Alex ZH>        (@ZzzhHe)
*  Translated&Modified (c) 2024 Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

// #define RLIGHTS_IMPLEMENTATION
// #include 'rlights.h'

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := int(800)
    screen_height := int(450)

    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - vertex displacement')

    // set up camera
    camera := rl.Camera {
        position:    rl.Vector3 { 20.0, 5.0, -20.0 },
        target:      rl.Vector3 {}  ,
        up:          rl.Vector3 { y: 1.0 },
        fovy:        60.0,
        projection:  rl.camera_perspective
    }

    // Load vertex and fragment shaders
    shader := rl.Shader.load(
        c'resources/shaders/glsl330/vertex_displacement.vs',
        c'resources/shaders/glsl330/vertex_displacement.fs'
    )!
    
    // Load perlin noise texture
    perlin_noise_image := rl.Image.gen_perlin_noise(512, 512, 0, 0, 1.0)
    perlin_noise_map   := rl.Texture.load_from_image(perlin_noise_image)
    perlin_noise_image.unload()

    // Set shader uniform location
    perlin_noise_map_loc := shader.get_loc('perlinNoiseMap')
    perlin_noise_map.set_slot(shader, perlin_noise_map_loc, 1)
    
    // Create a plane mesh and model
    plane_mesh  := rl.Mesh.gen_plane(50, 50, 50, 50)
    plane_model := rl.Model.load_from_mesh(plane_mesh)
    // Set plane model material
    unsafe { plane_model.materials[0].shader = shader }

    mut time := f32(0.0)

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_free) // Update camera

        time += f32(rl.get_frame_time()) // Update time variable
        shader.set_value(shader.get_loc('time'), &time, rl.shader_uniform_float) // Send time value to shader

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)
            rl.begin_mode_3d(camera)
                rl.begin_shader_mode(shader)
                    // Draw plane model
                    plane_model.draw(rl.Vector3 {}, 1.0, rl.white)
                rl.end_shader_mode()

            rl.end_mode_3d()

            rl.draw_text('Vertex displacement', 10, 10, 20, rl.darkgray)
            rl.draw_fps(10, 40)

        rl.end_drawing()
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    shader.unload()
    plane_model.unload()
    perlin_noise_map.unload()

    rl.close_window()        // Close window and OpenGL context
}
