/*******************************************************************************************
*
*   raylib [shapes] example - draw circle sector (with gui options)
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
import raylib.gui as _
// import raylib.raymath

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [shapes] example - draw circle sector')
    defer { rl.close_window() }         // Close window and OpenGL context

    mut center := rl.Vector2 {f32(rl.get_screen_width() - 300)/2.0, f32(rl.get_screen_height())/2.0 }

    mut outer_radius := f32(180.0)
    mut start_angle  := f32(0.0)
    mut end_angle    := f32(180.0)
    mut segments     := f32(10.0)
    mut min_segments := f32(4)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
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

        rl.draw_circle_sector(center, outer_radius, start_angle, end_angle, int(segments), rl.Color.fade(rl.maroon, 0.3))
        rl.draw_circle_sector_lines(center, outer_radius, start_angle, end_angle, int(segments), rl.Color.fade(rl.maroon, 0.6))

            // Draw GUI controls
            //------------------------------------------------------------------------------
            C.GuiSliderBar(rl.Rectangle { 600,  40, 120, 20 }, 'StartAngle'.str, voidptr(0), &start_angle,  0, 720)
            C.GuiSliderBar(rl.Rectangle { 600,  70, 120, 20 }, 'EndAngle'.str,   voidptr(0), &end_angle,    0, 70)

            C.GuiSliderBar(rl.Rectangle { 600, 140, 120, 20 }, 'Radius'.str,     voidptr(0), &outer_radius, 0, 200)
            C.GuiSliderBar(rl.Rectangle { 600, 170, 120, 20 }, 'Segments'.str,   voidptr(0), &segments,     0, 100)
            //------------------------------------------------------------------------------

            // min_segments = C.truncf(rl.ceilf((end_angle - start_angle) / 90))
            min_segments = rl.ceilf((end_angle - start_angle) / 90)
            txt, col := if segments >= min_segments { 'MANUAL', rl.maroon  } else { 'AUTO', rl.darkgray }
            rl.draw_text('MODE: ${txt}', 600, 200, 10, col)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
