/*******************************************************************************************
*
*   raylib [shapes] example - splines drawing
*
*   Example originally created with raylib 5.0, last time updated with raylib 5.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024 Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl
import raylib.gui


const max_spline_points = 32


// Cubic Bezier spline control_points points
// NOTE: Every segment has two control_points points 
struct ControlPoint {
mut:
    start rl.Vector2
    end   rl.Vector2
} 

enum SplineType as int {
    spline_linear     = 0 // Linear
    spline_bspline    = 1 // B-Spline
    spline_catmullrom = 2 // Catmull-Rom
    spline_bezier     = 3 // Cubic Bezier
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint)
    rl.init_window(screen_width, screen_height, 'raylib [shapes] example - splines drawing')
    defer { rl.close_window() }       // Close window and OpenGL context

    mut points := []rl.Vector2{ len: max_spline_points }
    points[0] = rl.Vector2 {  50.0, 400.0 }
    points[1] = rl.Vector2 { 160.0, 220.0 }
    points[2] = rl.Vector2 { 340.0, 380.0 }
    points[3] = rl.Vector2 { 520.0,  60.0 }
    points[4] = rl.Vector2 { 710.0, 260.0 }
    
    mut circle_radius  := f32(8.0)
    
    mut point_count    := int(5)
    mut selected_point := int(-1)
    mut focused_point  := int(-1)

    mut selected_control_point := &rl.Vector2(0)
    mut focused_control_point  := &rl.Vector2(0)
    
    // Cubic Bezier control_points points initialization
    mut control_points := []ControlPoint{ len: max_spline_points }
    for i in 0..point_count-1 {
        p0 := points[i+0]
        p1 := points[i+1]
        control_points[i].start = rl.Vector2 { p0.x + 50, p0.y }
        control_points[i].end   = rl.Vector2 { p1.x - 50, p1.y }
    }

    // Spline config variables
    mut spline_thickness := f32(8.0)
    
    // 0-Linear, 1-BSpline, 2-CatmullRom, 3-Bezier
    mut spline_type_active    := SplineType.spline_linear
    mut spline_type_edit_mode := false
    mut spline_helpers_active := true
    
    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Spline points creation logic (at the end of spline)
        if rl.is_mouse_button_pressed(rl.mouse_right_button) &&
           (point_count < max_spline_points)
        {
            if point_count < max_spline_points {
                new_point := rl.get_mouse_position()

                points[point_count] = new_point
                
                preview_point := points[point_count-1]
                control_points[point_count-1].start = rl.Vector2 { preview_point.x + 50, preview_point.y }
                control_points[point_count  ].end   = rl.Vector2 { new_point.x     - 50, new_point.y     }

                point_count++
            }
        }

        // Spline point focus and selection logic
        for i in 0..point_count {
            if rl.check_collision_point_circle(rl.get_mouse_position(), points[i], circle_radius+4) {
                focused_point = i
                if rl.is_mouse_button_down(rl.mouse_left_button) {
                    selected_point = focused_point 
                }
                break
            } else {
                focused_point = -1
            }
        }
        
        // Spline point movement logic
        if selected_point >= 0 {
            points[selected_point] = rl.get_mouse_position()
            if rl.is_mouse_button_released(rl.mouse_left_button) {
               selected_point = -1
            }
        }
        
        // Cubic Bezier spline control_points points logic
        if (spline_type_active == .spline_bezier) && (focused_point == -1) && spline_helpers_active {
            // Spline control_points point focus and selection logic
            for i in 0..point_count {
                if rl.check_collision_point_circle(rl.get_mouse_position(), control_points[i].start, circle_radius) {
                    focused_control_point = &control_points[i].start
                    if rl.is_mouse_button_down(rl.mouse_left_button) {
                        selected_control_point = &control_points[i].start 
                    }
                    break
                } else if rl.check_collision_point_circle(rl.get_mouse_position(), control_points[i].end, circle_radius) {
                    focused_control_point = &control_points[i].end
                    if rl.is_mouse_button_down(rl.mouse_left_button) {
                        selected_control_point = &control_points[i].end 
                    }
                    break
                } else {
                    focused_control_point = voidptr(0)
                }
            }
            
            // Spline control_points point movement logic
            if selected_control_point != voidptr(0) {
                unsafe { *selected_control_point = rl.get_mouse_position() }
                if rl.is_mouse_button_released(rl.mouse_left_button) {
                    selected_control_point = voidptr(0)
                }
            }
        }
        
        // Spline selection logic
        if      rl.is_key_pressed(rl.key_one)   { spline_type_active = .spline_linear     }
        else if rl.is_key_pressed(rl.key_two)   { spline_type_active = .spline_bspline    }
        else if rl.is_key_pressed(rl.key_three) { spline_type_active = .spline_catmullrom }
        else if rl.is_key_pressed(rl.key_four)  { spline_type_active = .spline_bezier     }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)
        
            if spline_type_active == .spline_linear {
                // Draw spline: spline_linear
                rl.draw_spline_linear(points.data, point_count, spline_thickness, rl.red)
            } else if spline_type_active == .spline_bspline {
                // Draw spline: spline_bspline
                rl.draw_spline_basis(points.data, point_count, spline_thickness, rl.red)  // Provide connected points array

                for i in 0..point_count-3 {
                    // Drawing individual segments, not considering thickness connection compensation
                    rl.draw_spline_segment_basis(points[i], points[i + 1], points[i + 2], points[i + 3], spline_thickness, rl.maroon)
                }
            } else if spline_type_active == .spline_catmullrom {
                // Draw spline: catmull-rom
                rl.draw_spline_catmull_rom(points.data, point_count, spline_thickness, rl.red) // Provide connected points array
                
                // for i in 0..point_count-3 {
                //     // Drawing individual segments, not considering thickness connection compensation
                //     rl.draw_spline_segment_catmull_rom(points[i], points[i + 1], points[i + 2], points[i + 3], spline_thickness, rl.maroon)
                // }
            } else if spline_type_active == .spline_bezier {
                    // Draw spline: cubic-spline_bezier (with control_points points)
                for i in 0..point_count-1 {
                // Drawing individual segments, not considering thickness connection compensation
                rl.draw_spline_segment_bezier_cubic(points[i], control_points[i].start, control_points[i].end, points[i + 1], spline_thickness, rl.red)

                    if spline_helpers_active {
                        // Every cubic spline_bezier point should have two control_points points
                        start_pos := control_points[i].start
                        end_pos   := control_points[i].end
                        
                        rl.draw_text('start', int(start_pos.x)-10, int(start_pos.y)-20, 10, rl.black)
                        rl.draw_circle_v(start_pos, 6, rl.gold)
                        rl.draw_text('end', int(end_pos.x)-10, int(end_pos.y)-20, 10, rl.black)
                        rl.draw_circle_v(end_pos,   6, rl.gold)

                        if focused_control_point != voidptr(0) {
                            if focused_control_point == &control_points[i].start {
                                rl.draw_circle_v(control_points[i].start, 8, rl.green)
                            } else if focused_control_point == &control_points[i].end {
                                rl.draw_circle_v(control_points[i].end, 8, rl.green)
                            }
                        }
                        rl.draw_line_ex(points[i+0], control_points[i].start, 1.0, rl.lightgray)
                        rl.draw_line_ex(points[i+1], control_points[i].end,   1.0, rl.lightgray)

                        // Draw spline control_points lines
                        rl.draw_line_v(points[i], control_points[i].start, rl.gray)
                        //rl.draw_line_v(control_points[i].start, control_points[i].end, rl.lightgray)
                        rl.draw_line_v(control_points[i].end, points[i + 1], rl.gray)
                    }
                }
            }

            if spline_helpers_active {
                // Draw spline point helpers
                for i in 0..point_count {
                    rl.draw_circle_lines_v(
                        points[i],
                        if focused_point == i { circle_radius+4 } else { circle_radius },
                        if focused_point == i { rl.blue } else { rl.darkblue }
                    )
                    if (spline_type_active != .spline_linear) &&
                       (spline_type_active != .spline_bezier) &&
                       (i < point_count - 1)
                    {
                        rl.draw_line_v(points[i], points[i + 1], rl.gray)
                    }

                    rl.draw_text('[${points[i].x}, ${points[i].y}]', int(points[i].x), int(points[i].y) + 10, 10, rl.black)
                }
            }

            // Check all possible UI states that require control_points lock
            if spline_type_edit_mode { gui.lock() }
            
            {
                mut offset := int(60)
                // Draw spline config
                if spline_helpers_active {
                    gui.label(rl.Rectangle { 12, offset, 140, 24 }, 'Spline thickness: ${int(spline_thickness)}'.str)
                    offset += 20
                    gui.slider_bar(rl.Rectangle { 12, offset, 140, 16 }, voidptr(0), voidptr(0), &spline_thickness, 1.0, 40.0)
                    offset += 20
                    gui.label(rl.Rectangle{ 12, offset, 140, 24 }, 'Spline points radius: ${circle_radius}'.str)
                    offset += 20
                    gui.slider_bar(rl.Rectangle { 12, offset, 140, 16 }, voidptr(0), voidptr(0), &circle_radius, 8.0, 40.0)
                }
                offset += 20
                gui.check_box(rl.Rectangle { 12, offset, 20, 20 }, c'Show point helpers', &spline_helpers_active)
            }

            gui.label(rl.Rectangle { 12, 10, 140, 24 }, c'Spline type:')
            if gui.dropdown_box(
                rl.Rectangle { 12, 30, 140, 30 },
                    c'LINEAR;BSPLINE;CATMULLROM;BEZIER',
                    unsafe { &int(&spline_type_active) },
                    spline_type_edit_mode
            ) != 0 {
                spline_type_edit_mode = !spline_type_edit_mode
            }
        
            gui.unlock()

        rl.end_drawing()
    }
}
