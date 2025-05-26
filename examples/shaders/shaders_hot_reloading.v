/*******************************************************************************************
*
*   raylib [shaders] example - Hot reloading
*
*   NOTE: This example requires raylib OpenGL 3.3 for shaders support and only #version 330
*         is currently supported. OpenGL ES 2.0 platforms are not supported at the moment.
*
*   Example originally created with raylib 3.0, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2020-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2025      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const asset_path = @VMODROOT+'/thirdparty/raylib/examples/shaders/resources/'

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - hot reloading')
    defer { rl.close_window() }                 // Close window and OpenGL context

    frag_shader_file_name := (asset_path+'shaders/glsl330/reload.fs').str
    mut frag_shader_file_mod_time := rl.get_file_mod_time(frag_shader_file_name)

    // Load raymarching shader
    // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
    mut shader := rl.Shader.load(voidptr(0), frag_shader_file_name)!
    defer { rl.unload_shader(shader) }          // Unload shader

    // Get shader locations for required uniforms
    mut resolution_loc := shader.get_loc('resolution')
    mut mouse_loc      := shader.get_loc('mouse')
    mut time_loc       := shader.get_loc('time')

    resolution := [ f32(screen_width), f32(screen_height) ]
    rl.set_shader_value(shader, resolution_loc, resolution.data, rl.shader_uniform_vec2)

    mut total_time            := f32(0.0)
    mut shader_auto_reloading := false

    rl.set_target_fps(60)                       // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {             // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        total_time += f32(rl.get_frame_time())
        mouse := rl.get_mouse_position()

        // Set shader required uniform values
        shader.set_value(time_loc,  &total_time, rl.shader_uniform_float)
        shader.set_value(mouse_loc, &mouse,      rl.shader_uniform_vec2)

        // Hot shader reloading
        if shader_auto_reloading || rl.is_mouse_button_pressed(rl.mouse_button_left) {
            current_frag_shader_mod_time := rl.get_file_mod_time(frag_shader_file_name)

            // Check if shader file has been modified
            if current_frag_shader_mod_time != frag_shader_file_mod_time {
                // Try reloading updated shader
                updated_shader := rl.Shader.load(voidptr(0), frag_shader_file_name)!

                if updated_shader.id != rl.rl_get_shader_id_default() { // It was correctly loaded
                    shader.unload()
                    shader = updated_shader

                    // Get shader locations for required uniforms
                    resolution_loc = shader.get_loc('resolution')
                    mouse_loc      = shader.get_loc('mouse')
                    time_loc       = shader.get_loc('time')

                    // Reset required uniforms
                    shader.set_value(resolution_loc, resolution.data, rl.shader_uniform_vec2)
                }
                frag_shader_file_mod_time = current_frag_shader_mod_time
            }
        }

        if rl.is_key_pressed(rl.key_a) {
            shader_auto_reloading = !shader_auto_reloading
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // We only draw a white full-screen rectangle, frame is generated in shader
            rl.begin_shader_mode(shader)
                rl.draw_rectangle(0, 0, screen_width, screen_height, rl.white)
            rl.end_shader_mode()
        
        txt, col := if shader_auto_reloading { 'AUTO', rl.red } else { 'MANUAL', rl.black }
        rl.draw_text('PRESS [A] to TOGGLE SHADER AUTOLOADING: ${txt}', 10, 10, 10, col)
            if !shader_auto_reloading {
                rl.draw_text('MOUSE CLICK to SHADER RE-LOADING', 10, 30, 10, rl.black)
            }
            rl.draw_text('Shader last modification: ${frag_shader_file_mod_time}', 10, 430, 10, rl.black)

        rl.end_drawing()
    }
}
