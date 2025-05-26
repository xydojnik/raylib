/*******************************************************************************************
*
*   raylib [core] example - Initialize 3d camera free
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria  (@raysan5)
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

    rl.init_window(screen_width, screen_height, "raylib [core] example - 3d camera free")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:  rl.Vector3 { 10.0, 10.0, 10.0 } // Camera position
        target:    rl.Vector3 {  0.0,  0.0,  0.0 } // Camera looking at point
        up:        rl.Vector3 {  0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy :     45.0                            // Camera field-of-view Y
        projection : rl.camera_perspective         // Camera projection type
    }

    cube_position := rl.Vector3 { 0.0, 0.0, 0.0 }

    rl.disable_cursor()   // Limit cursor to relative movement inside the window
    rl.set_target_fps(60) // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(camera, rl.camera_free)

        if rl.is_key_pressed(rl.key_z) {
            camera.target = rl.Vector3 { 0.0, 0.0, 0.0 }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(rl.Camera3D(camera))

                rl.draw_cube(cube_position, 2.0, 2.0, 2.0, rl.red)
                rl.draw_cube_wires(cube_position, 2.0, 2.0, 2.0, rl.maroon)

                rl.draw_grid(10, 1.0)

            rl.end_mode_3d()

            rl.draw_rectangle(10, 10, 320, 93, rl.Color.fade(rl.skyblue, 0.5))
            rl.draw_rectangle_lines( 10, 10, 320, 93, rl.blue)

            rl.draw_text("Free camera default controls:", 20, 20, 10, rl.black)
            rl.draw_text("- Mouse Wheel to Zoom in-out", 40, 40, 10, rl.darkgray)
            rl.draw_text("- Mouse Wheel Pressed to Pan", 40, 60, 10, rl.darkgray)
            rl.draw_text("- Z to zoom to (0, 0, 0)", 40, 80, 10, rl.darkgray)

        rl.end_drawing()
    }
}
