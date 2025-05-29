/*******************************************************************************************
*
*   raylib [models] example - Draw some basic geometric shapes (cube, sphere, cylinder...)
*
*   Example originally created with raylib 1.0, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [models] example - geometric shapes")
    defer { rl.close_window() }      // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 0.0, 10.0, 10.0 }
        target:      rl.Vector3 { 0.0,  0.0,  0.0 }
        up:          rl.Vector3 { 0.0,  1.0,  0.0 }
        fovy:        45.0
        projection:  rl.camera_perspective
    }

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                rl.draw_cube(rl.Vector3 {-4.0, 0.0, 2.0}, 2.0, 5.0, 2.0, rl.red)
                rl.draw_cube_wires(rl.Vector3 {-4.0, 0.0, 2.0}, 2.0, 5.0, 2.0, rl.gold)
                rl.draw_cube_wires(rl.Vector3 {-4.0, 0.0, -2.0}, 3.0, 6.0, 2.0, rl.maroon)

                rl.draw_sphere(rl.Vector3 {-1.0, 0.0, -2.0}, 1.0, rl.green)
                rl.draw_sphere_wires(rl.Vector3 {1.0, 0.0, 2.0}, 2.0, 16, 16, rl.lime)

                rl.draw_cylinder(rl.Vector3 {4.0, 0.0, -2.0}, 1.0, 2.0, 3.0, 4, rl.skyblue)
                rl.draw_cylinder_wires(rl.Vector3 {4.0, 0.0, -2.0}, 1.0, 2.0, 3.0, 4, rl.darkblue)
                rl.draw_cylinder_wires(rl.Vector3 {4.5, -1.0, 2.0}, 1.0, 1.0, 2.0, 6, rl.brown)

                rl.draw_cylinder(rl.Vector3 {1.0, 0.0, -4.0}, 0.0, 1.5, 3.0, 8, rl.gold)
                rl.draw_cylinder_wires(rl.Vector3 {1.0, 0.0, -4.0}, 0.0, 1.5, 3.0, 8, rl.pink)

                rl.draw_capsule(rl.Vector3 {-3.0, 1.5, -4.0}, rl.Vector3 {-4.0, -1.0, -4.0}, 1.2, 8, 8, rl.violet)
                rl.draw_capsule_wires(rl.Vector3 {-3.0, 1.5, -4.0}, rl.Vector3 {-4.0, -1.0, -4.0}, 1.2, 8, 8, rl.purple)

                rl.draw_grid(10, 1.0)        // Draw a grid

            rl.end_mode_3d()

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
