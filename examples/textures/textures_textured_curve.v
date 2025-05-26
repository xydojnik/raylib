module main

/*******************************************************************************************
*
*   raylib [textures] example - Draw a texture along a segmented curve
*
*   Example originally created with raylib 4.5, last time updated with raylib 4.5
*
*   Example contributed by Jeffery Myers and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2022-2023 Jeffery Myers and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024 Fedorov Alexandr                       (@xydojnik)
*
********************************************************************************************/

import raylib as rl


//----------------------------------------------------------------------------------
// Global Variables Definition
//----------------------------------------------------------------------------------
__global(
    tex_road                     = rl.Texture2D {}
    show_curve                   = false
    curve_width                  = f32(50)
    curve_segments               = int(24)
    curve_start_position         = rl.Vector2{}
    curve_start_position_tangent = rl.Vector2{}
    curve_end_position           = rl.Vector2{}
    curve_end_position_tangent   = rl.Vector2{}
    curve_selected_point         = &rl.Vector2(voidptr(0))
)

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_vsync_hint | rl.flag_msaa_4x_hint)
    rl.init_window(screen_width, screen_height, "raylib [textures] examples - textured curve")
    defer { rl.close_window() }             // Close window and OpenGL context

    // Load the road texture
    tex_road = rl.load_texture("resources/road.png")
    defer { rl.unload_texture(tex_road) }
    
    rl.set_texture_filter(tex_road, rl.texture_filter_bilinear)

    // Setup the curve
    curve_start_position         = rl.Vector2 {  80, 100 }
    curve_start_position_tangent = rl.Vector2 { 100, 300 }
    curve_end_position           = rl.Vector2 { 700, 350 }
    curve_end_position_tangent   = rl.Vector2 { 600, 100 }

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Curve config options
        if rl.is_key_pressed(rl.key_space) { show_curve   = !show_curve }
        if rl.is_key_pressed(rl.key_equal) { curve_width += 2           }
        if rl.is_key_pressed(rl.key_minus) { curve_width -= 2           }

        if curve_width < 2 { curve_width = 2 }

        // Update segments
        if rl.is_key_pressed(rl.key_left)  { curve_segments -= 2 }
        if rl.is_key_pressed(rl.key_right) { curve_segments += 2 }

        if curve_segments < 2 { curve_segments = 2 }

        // Update curve logic
        // If the mouse is not down, we are not editing the curve so clear the selection
        if !rl.is_mouse_button_down(rl.mouse_button_left) { curve_selected_point = voidptr(0) }

        // If a point was selected, move it
        if curve_selected_point != voidptr(0) {
            unsafe { *curve_selected_point = rl.Vector2.add(*curve_selected_point, rl.get_mouse_delta()) }
        }

        // The mouse is down, and nothing was selected, so see if anything was picked
        mouse := rl.get_mouse_position()
        
             if rl.check_collision_point_circle(mouse, curve_start_position,         6) { curve_selected_point = &curve_start_position         }
        else if rl.check_collision_point_circle(mouse, curve_start_position_tangent, 6) { curve_selected_point = &curve_start_position_tangent }
        else if rl.check_collision_point_circle(mouse, curve_end_position,           6) { curve_selected_point = &curve_end_position           }
        else if rl.check_collision_point_circle(mouse, curve_end_position_tangent,   6) { curve_selected_point = &curve_end_position_tangent   }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            draw_textured_curve()    // Draw a textured Spline Cubic Bezier
            
            // Draw spline for reference
            if show_curve {
                rl.draw_spline_segment_bezier_cubic(
                    curve_start_position, curve_end_position,
                    curve_start_position_tangent,
                    curve_end_position_tangent, 2, rl.blue
                )
            }

            // Draw the various control points and highlight where the mouse is
            rl.draw_line_v(curve_start_position,         curve_start_position_tangent, rl.skyblue)
            rl.draw_line_v(curve_start_position_tangent, curve_end_position_tangent,   rl.Color.fade(rl.lightgray, 0.4))
            rl.draw_line_v(curve_end_position,           curve_end_position_tangent,   rl.purple)
            
            if rl.check_collision_point_circle(mouse, curve_start_position, 6) {
                rl.draw_circle_v(curve_start_position, 7, rl.yellow)
            }
            rl.draw_circle_v(curve_start_position, 5, rl.red)

            if rl.check_collision_point_circle(mouse, curve_start_position_tangent, 6) {
                rl.draw_circle_v(curve_start_position_tangent, 7, rl.yellow)
            }
            rl.draw_circle_v(curve_start_position_tangent, 5, rl.maroon)

            if rl.check_collision_point_circle(mouse, curve_end_position, 6) {
                rl.draw_circle_v(curve_end_position, 7, rl.yellow)
            }
            rl.draw_circle_v(curve_end_position, 5, rl.green)

            if rl.check_collision_point_circle(mouse, curve_end_position_tangent, 6) {
                rl.draw_circle_v(curve_end_position_tangent, 7, rl.yellow)
            }
            rl.draw_circle_v(curve_end_position_tangent, 5, rl.darkgreen)

            // Draw usage info
            rl.draw_text("Drag points to move curve, press SPACE to show/hide base curve",   10, 10, 10, rl.darkgray)
            rl.draw_text("Curve width: ${curve_width} (Use + and - to adjust)",              10, 30, 10, rl.darkgray)
            rl.draw_text("Curve segments: ${curve_segments} (Use LEFT and RIGHT to adjust)", 10, 50, 10, rl.darkgray)
            
        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------------------
}

//----------------------------------------------------------------------------------
// Module Functions Definition
//----------------------------------------------------------------------------------
// Draw textured curve using Spline Cubic Bezier
fn draw_textured_curve() {
    step := 1.0/f32(curve_segments)

    mut previous         := curve_start_position
    mut previous_tangent := rl.Vector2 {}
    mut previous_v       := f32(0)

    // We can't compute a tangent for the first point, so we need to reuse the tangent from the first segment
    mut tangent_set := false
    mut current     := rl.Vector2 {}
    mut t           := f32(0.0)

    for i:=1; i<=curve_segments; i++ {
        t = step*f32(i)

        a := rl.powf(1.0 - t, 3)
        b := 3.0*rl.powf(1.0 - t, 2)*t
        c := 3.0*(1.0 - t)*rl.powf(t, 2)
        d := rl.powf(t, 3)

        // Compute the endpoint for this segment
        current.y = a*curve_start_position.y + b*curve_start_position_tangent.y + c*curve_end_position_tangent.y + d*curve_end_position.y
        current.x = a*curve_start_position.x + b*curve_start_position_tangent.x + c*curve_end_position_tangent.x + d*curve_end_position.x

        // Vector from previous to current
        delta := rl.Vector2 { current.x - previous.x, current.y - previous.y }

        // The right hand normal to the delta vector
        normal := rl.Vector2.normalize(rl.Vector2 { -delta.y, delta.x })

        // The v texture coordinate of the segment (add up the length of all the segments so far)
        v := previous_v + rl.Vector2.length(delta)

        // Make sure the start point has a normal
        if !tangent_set {
            previous_tangent = normal
            tangent_set      = true
        }

        // Extend out the normals from the previous and current points to get the quad for this segment
        prev_pos_normal    := rl.Vector2.add(previous, rl.Vector2.scale(previous_tangent,  curve_width))
        prev_neg_normal    := rl.Vector2.add(previous, rl.Vector2.scale(previous_tangent, -curve_width))
        current_pos_normal := rl.Vector2.add(current,  rl.Vector2.scale(normal,            curve_width))
        current_neg_normal := rl.Vector2.add(current,  rl.Vector2.scale(normal,           -curve_width))

        // Draw the segment as a quad
        rl.rl_set_texture(tex_road.id)
        rl.rl_begin(rl.rl_quads)
            rl.rl_color4ub(255,255,255,255)
            rl.rl_normal3f(0.0, 0.0, 1.0)

            rl.rl_tex_coord2f(0, previous_v)
            rl.rl_vertex2f(prev_neg_normal.x, prev_neg_normal.y)

            rl.rl_tex_coord2f(1, previous_v)
            rl.rl_vertex2f(prev_pos_normal.x, prev_pos_normal.y)

            rl.rl_tex_coord2f(1, v)
            rl.rl_vertex2f(current_pos_normal.x, current_pos_normal.y)

            rl.rl_tex_coord2f(0, v)
            rl.rl_vertex2f(current_neg_normal.x, current_neg_normal.y)
        rl.rl_end()

        // The current step is the start of the next step
        previous         = current
        previous_tangent = normal
        previous_v       = v
    }
}
