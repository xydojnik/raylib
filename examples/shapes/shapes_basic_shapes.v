/*******************************************************************************************
*
*   raylib [shapes] example - Draw basic shapes 2d (rectangle, circle, line...)
*
*   Example originally created with raylib 1.0, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - basic shapes drawing")
    defer { rl.close_window() }      // Close window and OpenGL context

    mut rotation := f32(0.0)

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rotation += 0.2
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("some basic shapes available on raylib", 20, 20, 20, rl.darkgray)

            // Circle shapes and lines
            rl.draw_circle(screen_width/5, 120, 35, rl.darkblue)
            rl.draw_circle_gradient(screen_width/5, 220, 60, rl.green, rl.skyblue)
            rl.draw_circle_lines(screen_width/5, 340, 80, rl.darkblue)

            // Rectangle shapes and lines
            rl.draw_rectangle(screen_width/4*2 - 60, 100, 120, 60, rl.red)
            rl.draw_rectangle_gradient_h(screen_width/4*2 - 90, 170, 180, 130, rl.maroon, rl.gold)
            rl.draw_rectangle_lines(screen_width/4*2 - 40, 320, 80, 60, rl.orange)  // NOTE: Uses QUADS internally, not lines

            // Triangle shapes and lines
            rl.draw_triangle(
                rl.Vector2 { f32(screen_width)/4.0 *3.0, 80.0 },
                rl.Vector2 { f32(screen_width)/4.0 *3.0 - 60.0, 150.0 },
                rl.Vector2 { f32(screen_width)/4.0 *3.0 + 60.0, 150.0 },
                rl.violet
            )

            rl.draw_triangle_lines(
                rl.Vector2 { f32(screen_width)/4.0*3.0, 160.0 },
                rl.Vector2 { f32(screen_width)/4.0*3.0 - 20.0, 230.0 },
                rl.Vector2 { f32(screen_width)/4.0*3.0 + 20.0, 230.0 },
                rl.darkblue
            )

            // Polygon shapes and lines
            rl.draw_poly(rl.Vector2 { f32(screen_width)/4.0*3, 330 }, 6, 80, rotation, rl.brown)
            rl.draw_poly_lines(rl.Vector2 { f32(screen_width)/4.0*3, 330 }, 6, 90, rotation, rl.brown)
            rl.draw_poly_lines_ex(rl.Vector2 { f32(screen_width)/4.0*3, 330 }, 6, 85, rotation, 6, rl.beige)

            // NOTE: We draw all LINES based shapes together to optimize internal drawing,
            // this way, all LINES are rendered in a single draw pass
            rl.draw_line(18, 42, screen_width - 18, 42, rl.black)
        rl.end_drawing()
    }
}
