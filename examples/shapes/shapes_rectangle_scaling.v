/*******************************************************************************************
*
*   raylib [shapes] example - rectangle scaling by mouse
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2018-2023 Vlad Adrian       (@demizdor) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const mouse_scale_mark_size = 12


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - rectangle scaling mouse")
    defer { rl.close_window() }       // Close window and OpenGL context

    mut rec := rl.Rectangle  { 100, 100, 200, 80 }

    mut mouse_position := rl.Vector2 {}

    mut mouse_scale_ready := false
    mut mouse_scale_mode  := false

    rl.set_target_fps(60)             // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {   // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mouse_position = rl.get_mouse_position()

        if rl.check_collision_point_rec(
            mouse_position,
            rl.Rectangle {
                rec.x + rec.width - mouse_scale_mark_size,
                rec.y + rec.height - mouse_scale_mark_size,
                mouse_scale_mark_size,
                mouse_scale_mark_size
            }
        ) {
            mouse_scale_ready = true
            mouse_scale_mode  = rl.is_mouse_button_pressed(rl.mouse_button_left)
        } else {
            mouse_scale_ready = false
        }

        if mouse_scale_mode {
            mouse_scale_ready = true

            rec.width  = (mouse_position.x - rec.x)
            rec.height = (mouse_position.y - rec.y)

            // Check minimum rec size
            if rec.width  < mouse_scale_mark_size { rec.width  = mouse_scale_mark_size }
            if rec.height < mouse_scale_mark_size { rec.height = mouse_scale_mark_size }
            
            // Check maximum rec size
            if rec.width  > (rl.get_screen_width() - rec.x) {
                rec.width = rl.get_screen_width() - rec.x
            }
            if rec.height > (rl.get_screen_height() - rec.y) {
                rec.height = rl.get_screen_height() - rec.y
            }

            if rl.is_mouse_button_released(rl.mouse_button_left) {
                mouse_scale_mode = false
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("Scale rectangle dragging from bottom-right corner!", 10, 10, 20, rl.gray)

            rl.draw_rectangle_rec(rec, rl.Color.fade(rl.green, 0.5))

            if mouse_scale_ready {
                rl.draw_rectangle_lines_ex(rec, 1, rl.red)
                rl.draw_triangle(
                    rl.Vector2 { rec.x + rec.width - mouse_scale_mark_size, rec.y + rec.height },
                    rl.Vector2 { rec.x + rec.width, rec.y + rec.height },
                    rl.Vector2 { rec.x + rec.width, rec.y + rec.height - mouse_scale_mark_size }, rl.red
                )
            }

        rl.end_drawing()
    }
}
