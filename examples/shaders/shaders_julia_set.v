/*******************************************************************************************
*   raylib [shaders] example - Julia sets
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
*
*   Example contributed by Josh Colclough (@joshcol9232) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Josh Colclough    (@joshcol9232) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2025      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


// A few good julia sets
const points_of_interest := [
    [ f32(-0.348827),  0.607167 ],
    [ f32(-0.786268),  0.169728 ],
    [ f32(     -0.8),     0.156 ],
    [ f32(    0.285),       0.0 ],
    [ f32(   -0.835),   -0.2321 ],
    [ f32( -0.70176),   -0.3842 ],
]

const screen_width     := int(800)
const screen_height    := int(450)
const zoom_speed       := f32(1.01)
const offset_speed_mul := f32(2.0)
const starting_zoom    := f32(0.75)


// Program main entry point
fn main() {
    // Initialization
    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - julia sets')
    defer { rl.close_window() }             // Close window and OpenGL context

    // Load julia set shader
    // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
    shader := rl.Shader.load(voidptr(0), c'resources/shaders/glsl330/julia_set.fs')!
    defer { shader.unload() } // Unload shader

    // Create a RenderTexture2D to be used for render to texture
    target := rl.RenderTexture.load(rl.get_screen_width(), rl.get_screen_height())
    defer { target.unload() }// Unload render texture

    // c constant to use in z^2 + c
    mut c := [ points_of_interest[0][0], points_of_interest[0][1] ]

    // Offset and zoom to draw the julia set at. (centered on screen and default size)
    mut offset := [ f32(0.0), 0.0 ]
    mut zoom   := starting_zoom

    // Get variable (uniform) locations on the shader to connect with the program
    // NOTE: If uniform variable could not be found in the shader, function returns -1
    c_loc      := shader.get_loc('c')
    zoom_loc   := shader.get_loc('zoom')
    offset_loc := shader.get_loc('offset')

    // Upload the shader uniform values!
    shader.set_value(c_loc,      c.data,      rl.shader_uniform_vec2)
    shader.set_value(zoom_loc,   &zoom,       rl.shader_uniform_float)
    shader.set_value(offset_loc, offset.data, rl.shader_uniform_vec2)

    mut increment_speed := int(0)   // Multiplier of speed to change c value
    mut show_controls   := true     // Show controls

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        // Press [1 - 6] to reset c to a point of interest
        if rl.is_key_pressed(rl.key_one)   || rl.is_key_pressed(rl.key_two)   ||
           rl.is_key_pressed(rl.key_three) || rl.is_key_pressed(rl.key_four)  ||
           rl.is_key_pressed(rl.key_five)  || rl.is_key_pressed(rl.key_six)
        {
            if      rl.is_key_pressed(rl.key_one)   { c[0] = points_of_interest[0][0] c[1] = points_of_interest[0][1] }
            else if rl.is_key_pressed(rl.key_two)   { c[0] = points_of_interest[1][0] c[1] = points_of_interest[1][1] }
            else if rl.is_key_pressed(rl.key_three) { c[0] = points_of_interest[2][0] c[1] = points_of_interest[2][1] }
            else if rl.is_key_pressed(rl.key_four)  { c[0] = points_of_interest[3][0] c[1] = points_of_interest[3][1] }
            else if rl.is_key_pressed(rl.key_five)  { c[0] = points_of_interest[4][0] c[1] = points_of_interest[4][1] }
            else if rl.is_key_pressed(rl.key_six)   { c[0] = points_of_interest[5][0] c[1] = points_of_interest[5][1] }

            shader.set_value(c_loc, c.data, rl.shader_uniform_vec2)
        }

        // If 'R' is pressed, reset zoom and offset.
        if rl.is_key_pressed(rl.key_r) {
            zoom      = starting_zoom
            offset[0] = 0.0
            offset[1] = 0.0
            
            shader.set_value(zoom_loc,   &zoom,       rl.shader_uniform_float)
            shader.set_value(offset_loc, offset.data, rl.shader_uniform_vec2)
        }

        if rl.is_key_pressed(rl.key_space) { increment_speed = 0              } // Pause animation (c change)
        if rl.is_key_pressed(rl.key_f1)    { show_controls   = !show_controls } // Toggle whether or not to show controls

        if      rl.is_key_pressed(rl.key_right) { increment_speed++ }
        else if rl.is_key_pressed(rl.key_left)  { increment_speed-- }

        // If either left or right button is pressed, zoom in/out.
        if rl.is_mouse_button_down(rl.mouse_button_left) || rl.is_mouse_button_down(rl.mouse_button_right) {
            // Change zoom. If Mouse left -> zoom in. Mouse right -> zoom out.
            zoom *= if rl.is_mouse_button_down(rl.mouse_button_left) { zoom_speed } else { 1.0/zoom_speed }

            mouse_pos           := rl.get_mouse_position()
            mut offset_velocity := rl.Vector2{}
            // Find the velocity at which to change the camera. Take the distance of the mouse
            // from the center of the screen as the direction, and adjust magnitude based on
            // the current zoom.
            offset_velocity.x = (mouse_pos.x/f32(screen_width)  - 0.5)*offset_speed_mul/zoom
            offset_velocity.y = (mouse_pos.y/f32(screen_height) - 0.5)*offset_speed_mul/zoom

            // Apply move velocity to camera
            offset[0] += rl.get_frame_time()*offset_velocity.x
            offset[1] += rl.get_frame_time()*offset_velocity.y

            // Update the shader uniform values!
            rl.set_shader_value(shader, zoom_loc,   &zoom,       rl.shader_uniform_float)
            rl.set_shader_value(shader, offset_loc, offset.data, rl.shader_uniform_vec2)
        }

        // Increment c value with time
        dc := rl.get_frame_time()*f32(increment_speed)*0.0005
        c[0] += dc
        c[1] += dc
        shader.set_value(c_loc, c.data, rl.shader_uniform_vec2)

        // Draw
        // Using a render texture to draw Julia set
        rl.begin_texture_mode(target)     // Enable drawing to texture
            rl.clear_background(rl.black) // Clear the render texture

            // Draw a rectangle in shader mode to be used as shader canvas
            // NOTE: Rectangle uses font white character texture coordinates,
            // so shader can not be applied here directly because input vertexTexCoord
            // do not represent full screen coordinates (space where want to apply shader)
            rl.draw_rectangle(0, 0, rl.get_screen_width(), rl.get_screen_height(), rl.black)
        rl.end_texture_mode()
            
        rl.begin_drawing()
            rl.clear_background(rl.black)     // Clear screen background

            // Draw the saved texture and rendered julia set with shader
            // NOTE: We do not invert texture on Y, already considered inside shader
            rl.begin_shader_mode(shader)
                // WARNING: If FLAG_WINDOW_HIGHDPI is enabled, HighDPI monitor scaling should be considered
                // when rendering the RenderTexture2D to fit in the HighDPI scaled Window
                target.texture.draw_ex(rl.Vector2 {}, 0.0, 1.0, rl.white)
            rl.end_shader_mode()

            if show_controls {
                rl.draw_rectangle(
                    5, 10, 310, 95, rl.Color.fade(rl.black, 0.5)
                )
        
                rl.draw_text('Press Mouse buttons right/left to zoom in/out and move', 10, 15, 10, rl.raywhite)
                rl.draw_text('Press KEY_F1 to toggle these controls',                  10, 30, 10, rl.raywhite)
                rl.draw_text('Press KEYS [1 - 6] to change point of interest',         10, 45, 10, rl.raywhite)
                rl.draw_text('Press KEY_LEFT | KEY_RIGHT to change speed',             10, 60, 10, rl.raywhite)
                rl.draw_text('Press KEY_SPACE to stop movement animation',             10, 75, 10, rl.raywhite)
                rl.draw_text('Press KEY_R to recenter the camera',                     10, 90, 10, rl.raywhite)
            }
        rl.end_drawing()
    }
}
