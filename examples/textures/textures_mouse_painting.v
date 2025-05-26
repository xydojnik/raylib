module main

/*******************************************************************************************
*
*   raylib [textures] example - Mouse painting
*
*   Example originally created with raylib 3.0, last time updated with raylib 3.0
*
*   Example contributed by Chris Dill (@MysteriousSpace) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Chris Dill        (@MysteriousSpace) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

const max_colors_count = 23          // Number of colors available


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - mouse painting")
    defer { rl.close_window() }                 // Close window and OpenGL context

    // Colors to choose from
    colors := [
        rl.raywhite,  rl.yellow, rl.gold,     rl.orange, rl.pink,   rl.red,        rl.maroon, rl.green,rl.lime,     rl.darkgreen,
        rl.skyblue,   rl.blue,   rl.darkblue, rl.purple, rl.violet, rl.darkpurple, rl.beige , rl.brown,rl.darkbrown,
        rl.lightgray, rl.gray,   rl.darkgray, rl.black
    ]

    // Define colors_recs data (for every rectangle)
    // Rectangle colors_recs[max_colors_count] = { 0 }
    mut colors_recs := []rl.Rectangle {len: max_colors_count }

    // for (int i = 0 i < max_colors_count i++) {
    for i ,mut col_rec in colors_recs {
        col_rec.x      = 10 + 30.0*f32(i) + 2*f32(i)
        col_rec.y      = 10
        col_rec.width  = 30
        col_rec.height = 30
    }

    mut color_selected      := int(0)
    mut color_selected_prev := int(color_selected)
    mut color_mouse_hover   := int(0)
    mut brush_size          := f32(20.0)
    mut mouse_was_pressed   := false

    btn_save_rec := rl.Rectangle { 750, 10, 40, 30 }
    
    mut btn_save_mouse_hover := false
    mut show_save_message    := false
    mut save_message_counter := int(0)

    // Create a RenderTexture2D to use as a canvas
    target := rl.load_render_texture(screen_width, screen_height)
    defer { rl.unload_render_texture(target) }  // Unload render texture

    // Clear render texture before entering the game loop
    rl.begin_texture_mode(target)
    rl.clear_background(colors[0])
    rl.end_texture_mode()

    rl.set_target_fps(120)              // Set our game to run at 120 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mouse_pos := rl.get_mouse_position()

        // Move between colors with keys
        if      rl.is_key_pressed(rl.key_right) { color_selected++ }
        else if rl.is_key_pressed(rl.key_left)  { color_selected-- }

        if color_selected >= max_colors_count {
            color_selected = max_colors_count - 1
        } else if color_selected < 0 {
            color_selected = 0
        }

        // Choose color with mouse
        for i, col_recs in colors_recs {
            if rl.check_collision_point_rec(mouse_pos, col_recs) {
                color_mouse_hover = i
                break
            } else {
                color_mouse_hover = -1
            }
        }

        if (color_mouse_hover >= 0) && rl.is_mouse_button_pressed(rl.mouse_button_left) {
            color_selected      = color_mouse_hover
            color_selected_prev = color_selected
        }

        // Change brush size
        brush_size += rl.get_mouse_wheel_move()*5
        if brush_size < 2  { brush_size = 2  }
        if brush_size > 50 { brush_size = 50 }

        if rl.is_key_pressed(rl.key_c) {
            // Clear render texture to clear color
            rl.begin_texture_mode(target)
            rl.clear_background(colors[0])
            rl.end_texture_mode()
        }

        if rl.is_mouse_button_down(rl.mouse_button_left) || (rl.get_gesture_detected() == rl.gesture_drag) {
            // Paint circle into render texture
            // NOTE: To avoid discontinuous circles, we could store
            // previous-next mouse points and just draw a line using brush size
            rl.begin_texture_mode(target)
            if mouse_pos.y > 50 {
                rl.draw_circle(int(mouse_pos.x), int(mouse_pos.y), brush_size, colors[color_selected])
            }
            rl.end_texture_mode()
        }

        if rl.is_mouse_button_down(rl.mouse_button_right) {
            if !mouse_was_pressed {
                color_selected_prev = color_selected
                color_selected      = 0
            }

            mouse_was_pressed = true

            // Erase circle from render texture
            rl.begin_texture_mode(target)
            if mouse_pos.y > 50 {
                rl.draw_circle(int(mouse_pos.x), int(mouse_pos.y), brush_size, colors[0])
            }
            rl.end_texture_mode()
        } else if rl.is_mouse_button_released(rl.mouse_button_right) && mouse_was_pressed {
            color_selected    = color_selected_prev
            mouse_was_pressed = false
        }

        // Check mouse hover save button
        btn_save_mouse_hover = rl.check_collision_point_rec(mouse_pos, btn_save_rec)

        // Image saving logic
        // NOTE: Saving painted texture to a default named image
        if btn_save_mouse_hover && (rl.is_mouse_button_released(rl.mouse_button_left) || rl.is_key_pressed(rl.key_s)) {
            image := rl.load_image_from_texture(target.texture)
            rl.image_flip_vertical(&image)
            rl.export_image(image, "my_amazing_texture_painting.png")
            rl.unload_image(image)
            show_save_message = true
        }

        if show_save_message {
            // On saving, show a full screen message for 2 seconds
            save_message_counter++
            if save_message_counter > 240 {
                show_save_message    = false
                save_message_counter = 0
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

        rl.clear_background(rl.raywhite)

        // NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
        rl.draw_texture_rec(
            target.texture,
            rl.Rectangle { 0, 0, f32(target.texture.width), f32(-target.texture.height) },
            rl.Vector2 {}, rl.white
        )

        // Draw drawing circle for reference
        if mouse_pos.y > 50 {
            if rl.is_mouse_button_down(rl.mouse_button_right) {
                rl.draw_circle_lines(int(mouse_pos.x), int(mouse_pos.y), brush_size, rl.gray)
            }
            else {
                rl.draw_circle(rl.get_mouse_x(), rl.get_mouse_y(), brush_size, colors[color_selected])
            }
        }

        // Draw top panel
        rl.draw_rectangle(0, 0, rl.get_screen_width(), 50, rl.raywhite)
        rl.draw_line(0, 50, rl.get_screen_width(), 50, rl.lightgray)

        // Draw color selection rectangles
        for i in 0..max_colors_count {
            rl.draw_rectangle_rec(colors_recs[i], colors[i])
        }
        rl.draw_rectangle_lines(10, 10, 30, 30, rl.lightgray)

        if color_mouse_hover >= 0 {
            rl.draw_rectangle_rec(colors_recs[color_mouse_hover], rl.Color.fade(rl.white, 0.6))
        }

        rl.draw_rectangle_lines_ex(
            rl.Rectangle {
                colors_recs[color_selected].x     - 2, colors_recs[color_selected].y      - 2,
                colors_recs[color_selected].width + 4, colors_recs[color_selected].height + 4
            }, 2, rl.black
        )
        
        // Draw brush circle
        rl.draw_circle_lines(int(mouse_pos.x), int(mouse_pos.y), brush_size, rl.red)

        {
            btn_color := if btn_save_mouse_hover { rl.red } else { rl.black }
            // Draw save image button
            rl.draw_rectangle_lines_ex(btn_save_rec, 2, btn_color)
            rl.draw_text("SAVE!", 755, 20, 10, btn_color)
        }

        // Draw save image message
        if show_save_message {
            rl.draw_rectangle(0, 0, rl.get_screen_width(), rl.get_screen_height(), rl.Color.fade(rl.raywhite, 0.8))
            rl.draw_rectangle(0, 150, rl.get_screen_width(), 80, rl.black)
            rl.draw_text("IMAGE SAVED:  my_amazing_texture_painting.png", 150, 180, 20, rl.raywhite)
        }

        rl.end_drawing()
    }
}
