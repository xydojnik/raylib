/*******************************************************************************************
*
*   raylib [shapes] example - Cubic-bezier lines
*
*   Example originally created with raylib 1.7, last time updated with raylib 1.7
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Ramon Santamaria  (@raysan5)
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

    rl.set_config_flags(rl.flag_msaa_4x_hint)
    rl.init_window(screen_width, screen_height, "raylib [shapes] example - cubic-bezier lines")
    defer { rl.close_window() }     // Close window and OpenGL context

    mut start_point      := rl.Vector2{ 30, 30 }
    mut end_point        := rl.Vector2{ f32(screen_width)-30, f32(screen_height)-30 }
    mut move_start_point := false
    mut move_end_point   := false

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mut mouse := rl.get_mouse_position()

        if rl.check_collision_point_circle(mouse, start_point, 10.0) && rl.is_mouse_button_down(rl.mouse_button_left) {
            move_start_point = true
        } else if rl.check_collision_point_circle(mouse, end_point, 10.0) && rl.is_mouse_button_down(rl.mouse_button_left) {
            move_end_point = true
        }

        if move_start_point {
            start_point = mouse
            if rl.is_mouse_button_released(rl.mouse_button_left) {
                move_start_point = false
            }
        }
        if move_end_point {
            end_point = mouse
            if rl.is_mouse_button_released(rl.mouse_button_left) {
                move_end_point = false
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("MOVE START-END POINTS WITH MOUSE", 15, 20, 20, rl.gray)

            // Draw line Cubic Bezier, in-out interpolation (easing), no control points
            rl.draw_line_bezier(start_point, end_point, 4.0, rl.blue)

            start_radius := if rl.check_collision_point_circle(mouse, start_point, 10.0) { 14 } else { 8 }
            end_radius   := if rl.check_collision_point_circle(mouse, end_point,   10.0) { 14 } else { 8 }
        
            start_color := if move_start_point { rl.red } else { rl.blue }
            end_color   := if move_end_point   { rl.red } else { rl.blue }
        
            // Draw start-end spline circles with some details
            rl.draw_circle_v(start_point, start_radius, start_color)
            rl.draw_circle_v(end_point,     end_radius, end_color)

        rl.end_drawing()
    }
}
