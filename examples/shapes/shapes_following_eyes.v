/*******************************************************************************************
*
*   raylib [shapes] example - following eyes
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2013-2023 Ramon Santamaria  (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - following eyes")
    defer { rl.close_window() }       // Close window and OpenGL context

    mut sclera_left_position  := rl.Vector2 { f32(rl.get_screen_width())/2.0 - 100.0, f32(rl.get_screen_height())/2.0 }
    mut sclera_right_position := rl.Vector2 { f32(rl.get_screen_width())/2.0 + 100.0, f32(rl.get_screen_height())/2.0 }
    mut sclera_radius         := f32(80)

    mut iris_left_position  := rl.Vector2{ f32(rl.get_screen_width())/2.0 - 100.0, f32(rl.get_screen_height())/2.0 }
    mut iris_right_position := rl.Vector2{ f32(rl.get_screen_width())/2.0 + 100.0, f32(rl.get_screen_height())/2.0 }
    mut iris_radius         := f32(24)

    mut angle := f32(0.0)
    mut dx    := f32(0.0)
    mut dy    := f32(0.0)
    mut dxx   := f32(0.0)
    mut dyy   := f32(0.0)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        iris_left_position  = rl.get_mouse_position()
        iris_right_position = rl.get_mouse_position()

        // Check not inside the left eye sclera
        if !rl.check_collision_point_circle(iris_left_position, sclera_left_position, sclera_radius - 20) {
            dx = iris_left_position.x - sclera_left_position.x
            dy = iris_left_position.y - sclera_left_position.y

            angle = rl.atan2f(dy, dx)

            dxx = (sclera_radius - iris_radius)*rl.cosf(angle)
            dyy = (sclera_radius - iris_radius)*rl.sinf(angle)

            iris_left_position.x = sclera_left_position.x + dxx
            iris_left_position.y = sclera_left_position.y + dyy
        }

        // Check not inside the right eye sclera
        if !rl.check_collision_point_circle(iris_right_position, sclera_right_position, sclera_radius - 20) {
            dx = iris_right_position.x - sclera_right_position.x
            dy = iris_right_position.y - sclera_right_position.y

            angle = rl.atan2f(dy, dx)

            dxx = (sclera_radius - iris_radius)*rl.cosf(angle)
            dyy = (sclera_radius - iris_radius)*rl.sinf(angle)

            iris_right_position.x = sclera_right_position.x + dxx
            iris_right_position.y = sclera_right_position.y + dyy
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_circle_v(sclera_left_position, sclera_radius, rl.lightgray)
            rl.draw_circle_v(iris_left_position, iris_radius, rl.brown)
            rl.draw_circle_v(iris_left_position, 10, rl.black)

            rl.draw_circle_v(sclera_right_position, sclera_radius, rl.lightgray)
            rl.draw_circle_v(iris_right_position, iris_radius, rl.darkgreen)
            rl.draw_circle_v(iris_right_position, 10, rl.black)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
