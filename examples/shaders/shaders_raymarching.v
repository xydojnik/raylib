/*******************************************************************************************
*
*   raylib [shaders] example - Raymarching shapes generation
*
*   NOTE: This example requires raylib OpenGL 3.3 for shaders support and only #version 330
*         is currently supported. OpenGL ES 2.0 platforms are not supported at the moment.
*
*   Example originally created with raylib 2.0, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2018-2023 Ramon Santamaria  (@raysan5)
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

    rl.set_config_flags(rl.flag_window_resizable)
    rl.init_window(screen_width, screen_height, "raylib [shaders] example - raymarching shapes")
    defer { rl.close_window() }          // Close window and OpenGL context

    mut camera := rl.Camera {
        position:    rl.Vector3 { 2.5, 2.5, 3.0 } // Camera position
        target:      rl.Vector3 { 0.0, 0.0, 0.7 } // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:        65.0                         // Camera field-of-view Y
        projection:  rl.camera_perspective        // Camera projection type
    }

    // Load raymarching shader
    // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
    shader := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/raymarching.fs".str)
    defer { rl.unload_shader(shader) }   // Unload shader

    // Get shader locations for required uniforms
    view_eye_loc    := rl.get_shader_location(shader, "viewEye")
    view_center_loc := rl.get_shader_location(shader, "viewCenter")
    run_time_loc    := rl.get_shader_location(shader, "runTime")
    resolution_loc  := rl.get_shader_location(shader, "resolution")

    mut resolution := [ f32(screen_width), f32(screen_height) ]
    rl.set_shader_value(shader, resolution_loc, resolution.data, rl.shader_uniform_vec2)

    mut run_time := f32(0.0)

    rl.disable_cursor()                  // Limit cursor to relative movement inside the window
    rl.set_target_fps(60)                // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_first_person)

        camera_pos    := [ f32(camera.position.x), camera.position.y, camera.position.z ]
        camera_target := [ f32(camera.target.x),   camera.target.y,   camera.target.z ]

        delta_time := f32(rl.get_frame_time())
        run_time   += delta_time

        // Set shader required uniform values
        rl.set_shader_value(shader, view_eye_loc,    camera_pos.data,    rl.shader_uniform_vec3)
        rl.set_shader_value(shader, view_center_loc, camera_target.data, rl.shader_uniform_vec3)
        rl.set_shader_value(shader, run_time_loc,    &run_time,          rl.shader_uniform_float)

        // Check if screen is resized
        if rl.is_window_resized() {
            resolution[0] = f32(rl.get_screen_width())
            resolution[1] = f32(rl.get_screen_height())
            rl.set_shader_value(shader, resolution_loc, resolution.data, rl.shader_uniform_vec2)
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // We only draw a white full-screen rectangle,
            // frame is generated in shader using raymarching
            rl.begin_shader_mode(shader)
                rl.draw_rectangle(0, 0, rl.get_screen_width(), rl.get_screen_height(), rl.white)
            rl.end_shader_mode()

            rl.draw_text("(c) Raymarching shader by Iñigo Quilez. MIT License.", rl.get_screen_width() - 280, rl.get_screen_height() - 20, 10, rl.black)

        rl.end_drawing()
    }
}
