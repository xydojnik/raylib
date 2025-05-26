/*******************************************************************************************
*
*   raylib [core] example - World to screen
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.4
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria (@raysan5)
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

    rl.init_window(screen_width, screen_height, 'raylib [core] example - core world screen')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:   rl.Vector3 { 10.0, 10.0, 10.0 }, // Camera position
        target:     rl.Vector3 {  0.0,  0.0,  0.0 }, // Camera looking at point
        up:         rl.Vector3 {  0.0,  1.0,  0.0 }, // Camera up vector (rotation towards target)
        fovy:       45.0,                            // Camera field-of-view Y
        projection: rl.camera_perspective            // Camera projection type
    }

    cube_position            := rl.Vector3 {}
    mut cube_screen_position := rl.Vector2 {}

    rl.disable_cursor()                     // Limit cursor to relative movement inside the window

    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {         // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_third_person)

        // Calculate cube screen space position (with a little offset to be in top)
        cube_screen_position = rl.get_world_to_screen(
            rl.Vector3 {
                cube_position.x,
                cube_position.y + 2.5,
                cube_position.z
            }, camera
        )
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

            rl.draw_text('Enemy: 100 / 100', int(cube_screen_position.x) - rl.measure_text(c'Enemy: 100/100', 20)/2, int(cube_screen_position.y), 20, rl.black)
            rl.draw_text('Cube position in screen space coordinates: [${int(cube_screen_position.x)}, ${int(cube_screen_position.y)}]', 10, 10, 20, rl.lime)
            rl.draw_text('Text 2d should be always on top of the cube', 10, 40, 20, rl.gray)

        rl.end_drawing()
    }
}
