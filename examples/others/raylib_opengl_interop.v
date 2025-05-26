/*******************************************************************************************
*
*   raylib [shaders] example - OpenGL point particle system
*
*   Example originally created with raylib 3.8, last time updated with raylib 2.5
*
*   Example contributed by Stephan Soller (@arkanis) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Stephan Soller   (@arkanis) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************
*
*   Mixes raylib and plain OpenGL code to draw a GL_POINTS based particle system. The
*   primary point is to demonstrate raylib and OpenGL interop.
*
*   rlgl batched draw operations internally so we have to flush the current batch before
*   doing our own OpenGL work (rlDrawRenderBatchActive()).
*
*   The example also demonstrates how to get the current model view projection matrix of
*   raylib. That way raylib cameras and so on work as expected.
*
********************************************************************************************/

// ITS NOT WORKING.

module main


import raylib as rl


#include "@VMODROOT/thirdparty/raylib/src/external/glad.h"

const asset_path = @VMODROOT+'/thirdparty/raylib/examples/others/resources/'

fn C.glGenVertexArrays(int, &u32)
fn C.glBindVertexArray(u32)
fn C.glGenBuffers(int, &u32)
fn C.glBindBuffer(int, u32)
fn C.glBufferData(int, int, voidptr, int)
fn C.glVertexAttribPointer(int, int, int, int, int, voidptr)
fn C.glEnableVertexAttribArray(u32)

fn C.glDrawArrays(int, int, int)

fn C.glDeleteBuffers(int, &u32)
fn C.glDeleteVertexArrays(int, &u32)

fn C.glUseProgram(u32)
fn C.glUniform1f(int, f32)
fn C.glUniform4fv(int, int, &f32)
fn C.glUniformMatrix4fv(int, int, int, &f32)

const gl_array_buffer = C.GL_ARRAY_BUFFER
const gl_static_draw  = C.GL_STATIC_DRAW
const gl_float        = C.GL_FLOAT
const gl_false        = C.GL_FALSE
const gl_points       = C.GL_POINTS


const max_particles = 1000

// Particle type
struct Particle {
pub mut:
    x      f32
    y      f32
    period f32
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib - point particles")
    defer { rl.close_window() }         // Close window and OpenGL context

    shader := rl.Shader.load(
        (asset_path+'shaders/glsl330/point_particle.vs').str,
        (asset_path+'shaders/glsl330/point_particle.fs').str
    )!
    defer { rl.unload_shader(shader) }  // Unload shader

    current_time_loc := rl.get_shader_location(shader, "currentTime")
    color_loc        := rl.get_shader_location(shader, "color")

    // Initialize the vertex buffer for the particles and assign each particle random values
    mut particles := []Particle { len: max_particles }

    for mut particle in particles  {
        particle.x = f32(rl.get_random_value(20, screen_width  - 20))
        particle.y = f32(rl.get_random_value(50, screen_height - 20))
        
        // Give each particle a slightly different period. But don't spread it to much. 
        // This way the particles line up every so often and you get a glimps of what is going on.
        particle.period = f32(rl.get_random_value(10, 30))/10.0
    }

    // Create a plain OpenGL vertex buffer with the data and an vertex array object 
    // that feeds the data from the buffer into the vertexPosition shader attribute.
    mut vao := u32(0)
    mut vbo := u32(0)

    defer {
        C.glDeleteBuffers(1, &vbo)
        C.glDeleteVertexArrays(1, &vao)
    }
    
    C.glGenVertexArrays(1, &vao)
    C.glBindVertexArray(vao)

        C.glGenBuffers(1, &vbo)
        C.glBindBuffer(gl_array_buffer, vbo)
        C.glBufferData(gl_array_buffer, max_particles*sizeof(Particle), particles.data, gl_static_draw)
        // Note: LoadShader() automatically fetches the attribute index of "vertexPosition" and saves it in shader.locs[rl.shader_loc_vertex_position]
        C.glVertexAttribPointer(unsafe { shader.locs[rl.shader_loc_vertex_position] }, 3, gl_float, gl_false, 0, 0)
        C.glEnableVertexAttribArray(0)
        C.glBindBuffer(gl_array_buffer, 0)
    C.glBindVertexArray(0)

    // Allows the vertex shader to set the point size of each particle individually
    $if GRAPHICS_API_OPENGL_ES2 ? {
        rl.gl_enable(rl.gl_program_point_size)
    }

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.white)

            rl.draw_rectangle(10, 10, 210, 30, rl.maroon)
            rl.draw_text("${max_particles} particles in one vertex buffer", 20, 20, 10, rl.raywhite)
            
            rl.rl_draw_render_batch_active()      // Draw iternal buffers data (previous draw calls)

            // Switch to plain OpenGL
            //------------------------------------------------------------------------------
            C.glUseProgram(shader.id)
            C.glUniform1f(current_time_loc, f32(rl.get_time()))

                // color := rl.Color.normalize(rl.Color{ 255, 0, 0, 128 })
                // color := rl.Color.normalize(rl.Color{ 255, 0, 0, 128 })
                color := rl.red.normalize()
                C.glUniform4fv(color_loc, 1, unsafe { &f32(&color) })

                // Get the current modelview and projection matrix so the particle system is displayed and transformed
                model_view_projection := rl.Matrix.multiply(rl.rl_get_matrix_modelview(), rl.rl_get_matrix_projection())
                
                unsafe {
                    C.glUniformMatrix4fv(shader.locs[rl.shader_loc_matrix_mvp], 1, gl_false, &f32(&model_view_projection))
                }

                C.glBindVertexArray(vao)
                    C.glDrawArrays(gl_points, 0, max_particles)
                C.glBindVertexArray(0)
                
            C.glUseProgram(0)
            //------------------------------------------------------------------------------
            
            rl.draw_fps(screen_width - 100, 10)
            
        rl.end_drawing()
    }
}
