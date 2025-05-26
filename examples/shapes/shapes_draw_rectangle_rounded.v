/*******************************************************************************************
*
*   raylib [shapes] example - draw rectangle rounded (with gui options)
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


#flag -DRAYGUI_IMPLEMENTATION
#include "@VMODROOT/examples/shapes/raygui.h"


fn C.GuiCheckBox(bounds rl.Rectangle, text &char, checked &bool) int 
fn C.GuiSliderBar(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int 


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - draw rectangle rounded")
    defer { rl.close_window() }       // Close window and OpenGL context

    mut roundness  := f32(0.2)
    mut width      := f32(200.0)
    mut height     := f32(100.0)
    mut segments   := f32(0.0)
    mut line_thick := f32(1.0)

    mut draw_rect          := false
    mut draw_rounded_rect  := true
    mut draw_rounded_lines := false

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mut rec := rl.Rectangle {
            (f32(rl.get_screen_width()) - width - 250)/2,
            (rl.get_screen_height() - height)/2.0,
            f32(width),
            f32(height)
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_line(560, 0, 560, rl.get_screen_height(), rl.Color.fade(rl.lightgray, 0.6))
            rl.draw_rectangle(560, 0, rl.get_screen_width() - 500, rl.get_screen_height(), rl.Color.fade(rl.lightgray, 0.3))

            if draw_rect          { rl.draw_rectangle_rec(rec, rl.Color.fade(rl.gold, 0.6)) }
        if draw_rounded_rect  { rl.draw_rectangle_rounded(rec, roundness, int(segments), rl.Color.fade(rl.maroon, 0.2)) }
        // if draw_rounded_lines { rl.draw_rectangle_rounded_lines(rec, roundness, int(segments), line_thick, rl.Color.fade(rl.maroon, 0.4)) }
        if draw_rounded_lines { rl.draw_rectangle_rounded_lines_ex(rec, roundness, int(segments), line_thick, rl.Color.fade(rl.maroon, 0.4)) }

            // Draw GUI controls
            //------------------------------------------------------------------------------
            C.GuiSliderBar(rl.Rectangle { 640, 40 , 105, 20 }, "Width".str,     "${int(width)}".str,  &width,      0, f32(rl.get_screen_width())  - 300)
            C.GuiSliderBar(rl.Rectangle { 640, 70 , 105, 20 }, "Height".str,    "${int(height)}".str, &height,     0, f32(rl.get_screen_height()) - 50)
            C.GuiSliderBar(rl.Rectangle { 640, 140, 105, 20 }, "Roundness".str, "${roundness}".str,   &roundness,  0, 1.0)
            C.GuiSliderBar(rl.Rectangle { 640, 170, 105, 20 }, "Thickness".str, "${line_thick}".str,  &line_thick, 0, 20)
            C.GuiSliderBar(rl.Rectangle { 640, 240, 105, 20 }, "Segments".str , voidptr(0),           &segments,   0, 60)

            C.GuiCheckBox(rl.Rectangle { 640, 320, 20, 20 }, "DrawRoundedRect".str , &draw_rounded_rect)
            C.GuiCheckBox(rl.Rectangle { 640, 350, 20, 20 }, "DrawRoundedLines".str, &draw_rounded_lines)
            C.GuiCheckBox(rl.Rectangle { 640, 380, 20, 20 }, "DrawRect".str,         &draw_rect)
            //------------------------------------------------------------------------------

            txt, col := if segments >= 4 { "MANUAL: [ ${int(segments)} ] seg.", rl.maroon } else { "AUTO", rl.darkgray }
            rl.draw_text("MODE: ${txt}", 640, 280, 10, col)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
