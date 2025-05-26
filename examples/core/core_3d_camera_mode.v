/*******************************************************************************************
*
*   raylib [core] example - Initialize 3d camera mode
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
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

    rl.init_window(screen_width, screen_height, "raylib [core] example - 3d camera mode")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }      // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Define the camera to look into our 3d world
    mut camera := rl.Camera3D {
        position:    rl.Vector3 { 0.0, 10.0, 10.0 } // Camera position
        target:      rl.Vector3 { 0.0,  0.0,  0.0 } // Camera looking at point
        up:          rl.Vector3 { 0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                           // Camera field-of-view Y
        projection:  rl.camera_perspective          // Camera mode type
    }

    cube_position := rl.Vector3 {}

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
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

                rl.draw_cube(cube_position, 2.0, 2.0, 2.0, rl.red)
                rl.draw_cube_wires(cube_position, 2.0, 2.0, 2.0, rl.maroon)

                rl.draw_grid(10, 1.0)

            rl.end_mode_3d()

            rl.draw_text("Welcome to the third dimension!", 10, 40, 20, rl.darkgray)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
