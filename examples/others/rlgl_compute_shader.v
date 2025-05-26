/*******************************************************************************************
*
*   raylib [rlgl] example - compute shader - Conways Game of Life
*
*   NOTE: This example requires raylib OpenGL 4.3 versions for compute shaders support,
*         shaders used in this example are #version 430 (OpenGL 4.3)
*
*   Example originally created with raylib 4.0, last time updated with raylib 2.5
*
*   Example contributed by Teddy Astie (@tsnake41) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Teddy Astie       (@tsnake41)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

// It does not work as it should be.
// You sould compile raylib with GRAPHICS_API_OPENGL_43 flag...

// IMPORTANT: This must match gol*.glsl gol_width constant.
// This must be a multiple of 16 (check golLogic compute dispatch).
const gol_width = 768

// Maximum amount of queued draw commands (squares draw from mouse down events).
const max_buffered_transferts = 48


// Game Of Life Update Command
struct GolUpdateCmd {
pub mut:
    x       u32  // x coordinate of the gol command
    y       u32  // y coordinate of the gol command
    w       u32  // width of the filled zone
    enabled bool // whether to enable or disable zone
}

// Game Of Life Update Commands SSBO
struct GolUpdateSSBO {
pub mut:
    count    u32
    commands [max_buffered_transferts]GolUpdateCmd
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    rl.init_window(gol_width, gol_width, "raylib [rlgl] example - compute shader - game of life")
    defer { rl.close_window() }                  // Close window and OpenGL context
    
    
    resolution := rl.Vector2 { gol_width, gol_width }
    mut brush_size := u32(8)

    // Game of Life logic compute shader
    // char *gol_logic_code = rl.load_file_text("resources/shaders/glsl430/gol.glsl")
    gol_logic_code    := rl.load_file_text("resources/shaders/glsl430/gol.glsl")
    gol_logic_shader  := rl.rl_compile_shader(gol_logic_code, rl.rl_compute_shader)
    gol_logic_program := rl.rl_load_compute_shader_program(gol_logic_shader)
    rl.unload_file_text(gol_logic_code)

    // Game of Life logic render shader
    gol_render_shader := rl.load_shader(unsafe { nil }, c"resources/shaders/glsl430/gol_render.glsl")
    defer { rl.unload_shader(gol_render_shader) } // Unload rendering fragment shader

    res_uniform_loc   := rl.get_shader_location(gol_render_shader, "resolution")

    // Game of Life transfert shader (CPU<->GPU download and upload)
    // char *gol_transfert_code = rl.load_file_text("resources/shaders/glsl430/gol_transfert.glsl")
    gol_transfert_code    := rl.load_file_text("resources/shaders/glsl430/gol_transfert.glsl")
    gol_transfert_shader  := rl.rl_compile_shader(gol_transfert_code, rl.rl_compute_shader)
    gol_transfert_program := rl.rl_load_compute_shader_program(gol_transfert_shader)
    rl.unload_file_text(gol_transfert_code)

    // Load shader storage buffer object (SSBO), id returned
    mut ssbo_a         := rl.rl_load_shader_buffer(gol_width*gol_width*sizeof(u32), unsafe {nil}, rl.rl_dynamic_copy)
    mut ssbo_b         := rl.rl_load_shader_buffer(gol_width*gol_width*sizeof(u32), unsafe {nil}, rl.rl_dynamic_copy)
    mut ssbo_transfert := rl.rl_load_shader_buffer(sizeof(GolUpdateSSBO),           unsafe {nil}, rl.rl_dynamic_copy)
    defer {
        rl.rl_unload_shader_buffer(ssbo_a)
        rl.rl_unload_shader_buffer(ssbo_b)
        rl.rl_unload_shader_buffer(ssbo_transfert)
    }

    // Unload compute shader programs
    rl.rl_unload_shader_program(gol_transfert_program)
    rl.rl_unload_shader_program(gol_logic_program)

    mut transfert_buffer := GolUpdateSSBO {}


    
    // Create a white texture of the size of the window to update
    // each pixel of the window using the fragment shader: gol_render_shader
    white_image := rl.gen_image_color(gol_width, gol_width, rl.white)
    white_tex   := rl.load_texture_from_image(white_image)
    defer { rl.unload_texture(white_tex) }      // Unload white texture
    
    rl.unload_image(white_image)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {
        // Update
        //----------------------------------------------------------------------------------
        brush_size += u32(rl.get_mouse_wheel_move())

        if (rl.is_mouse_button_down(rl.mouse_button_left)   ||
            rl.is_mouse_button_down(rl.mouse_button_right)) &&
            transfert_buffer.count < max_buffered_transferts
        {
            // Buffer a new command
            transfert_buffer.commands[transfert_buffer.count].x       = u32(rl.get_mouse_x()) - brush_size/2
            transfert_buffer.commands[transfert_buffer.count].y       = u32(rl.get_mouse_y()) - brush_size/2
            transfert_buffer.commands[transfert_buffer.count].w       = brush_size
            transfert_buffer.commands[transfert_buffer.count].enabled = rl.is_mouse_button_down(rl.mouse_button_left)
            transfert_buffer.count++
        } else if transfert_buffer.count > 0 { // Process transfert buffer
            // Send SSBO buffer to GPU
            rl.rl_update_shader_buffer(ssbo_transfert, &transfert_buffer, sizeof(GolUpdateSSBO), 0)

            // Process SSBO commands on GPU
            rl.rl_enable_shader(gol_transfert_program)
            rl.rl_bind_shader_buffer(ssbo_a, 1)
            rl.rl_bind_shader_buffer(ssbo_transfert, 3)
            rl.rl_compute_shader_dispatch(transfert_buffer.count, 1, 1) // Each GPU unit will process a command!
            rl.rl_disable_shader()

            transfert_buffer.count = 0
        } else {
            // Process game of life logic
            rl.rl_enable_shader(gol_logic_program)
            rl.rl_bind_shader_buffer(ssbo_a, 1)
            rl.rl_bind_shader_buffer(ssbo_b, 2)
            rl.rl_compute_shader_dispatch(gol_width/16, gol_width/16, 1)
            rl.rl_disable_shader()

            // ssbo_a <-> ssbo_b
            temp := ssbo_a
            ssbo_a = ssbo_b
            ssbo_b = temp
        }

        rl.rl_bind_shader_buffer(ssbo_a, 1)
        rl.set_shader_value(gol_render_shader, res_uniform_loc, &resolution, rl.shader_uniform_vec2)

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.blank)

            rl.begin_shader_mode(gol_render_shader)
                rl.draw_texture(white_tex, 0, 0, rl.white)
            rl.end_shader_mode()

            rl.draw_rectangle_lines(rl.get_mouse_x() - brush_size/2, rl.get_mouse_y() - brush_size/2, brush_size, brush_size, rl.red)

            rl.draw_text("Use Mouse wheel to increase/decrease brush size", 10, 10, 20, rl.white)
            rl.draw_fps(rl.get_screen_width() - 100, 10)

        rl.end_drawing()
    }
}
