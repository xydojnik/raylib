/*******************************************************************************************
*
*   raylib [shapes] example - draw ring (with gui options)
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2018-2023 Vlad Adrian      (@demizdor) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2025      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl
import raylib.gui


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - draw ring")
    defer { rl.close_window() }       // Close window and OpenGL context

    mut center := rl.Vector2 {f32(rl.get_screen_width() - 300)/2.0, f32(rl.get_screen_height())/2.0 }

    mut inner_radius := f32(80.0)
    mut outer_radius := f32(190.0)

    mut start_angle := f32(0.0)
    mut end_angle   := f32(360.0)
    mut segments    := f32(0.0)

    mut draw_ring         := true
    mut draw_ring_lines   := false
    mut draw_circle_lines := false

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // NOTE: All variables update happens inside GUI control functions
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_line(500, 0, 500, rl.get_screen_height(), rl.Color.fade(rl.lightgray, 0.6))
            rl.draw_rectangle(500, 0, rl.get_screen_width() - 500, rl.get_screen_height(), rl.Color.fade(rl.lightgray, 0.3))

            if draw_ring {
                rl.draw_ring(center, inner_radius, outer_radius, start_angle, end_angle, int(segments), rl.Color.fade(rl.maroon, 0.3))
            }
            if draw_ring_lines {
                rl.draw_ring_lines(center, inner_radius, outer_radius, start_angle, end_angle, int(segments), rl.Color.fade(rl.black, 0.4))
            }
            if draw_circle_lines {
                rl.draw_circle_sector_lines(center, outer_radius, start_angle, end_angle, int(segments), rl.Color.fade(rl.black, 0.4))
            }

            // Draw GUI controls
            //------------------------------------------------------------------------------
            gui.slider_bar(rl.Rectangle { 600, 40, 120, 20 }, "StartAngle".str, "[ ${start_angle} ] deg.".str, &start_angle, -450, 450)
            gui.slider_bar(rl.Rectangle { 600, 70, 120, 20 }, "EndAngle".str,   "[ ${end_angle} ] deg.".str,   &end_angle,   -450, 450)

            gui.slider_bar(rl.Rectangle { 600, 140, 120, 20 }, "InnerRadius".str, "[ ${int(inner_radius)} ]".str, &inner_radius, 0, 100)
            gui.slider_bar(rl.Rectangle { 600, 170, 120, 20 }, "OuterRadius".str, "[ ${int(outer_radius)} ]".str, &outer_radius, 0, 200)
            gui.slider_bar(rl.Rectangle { 600, 240, 120, 20 }, "Segments".str, voidptr(0), &segments, 0, 100)

            gui.check_box(rl.Rectangle { 600, 320, 20, 20 }, "Draw Ring".str,        &draw_ring)
            gui.check_box(rl.Rectangle { 600, 350, 20, 20 }, "Draw RingLines".str,   &draw_ring_lines)
            gui.check_box(rl.Rectangle { 600, 380, 20, 20 }, "Draw CircleLines".str, &draw_circle_lines)
            //------------------------------------------------------------------------------

            min_segments := int(rl.ceilf((end_angle - start_angle)/90))

            txt, col := if segments >= min_segments { "MANUAL: [ ${int(segments)} ] seg.", rl.maroon } else { "AUTO", rl.darkgray }

            rl.draw_text("MODE: ${txt}", 600, 270, 10, col)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
