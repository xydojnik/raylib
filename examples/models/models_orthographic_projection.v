/*******************************************************************************************
*
*   raylib [models] example - Show the difference between perspective and orthographic projection
*
*   Example originally created with raylib 2.0, last time updated with raylib 3.7
*
*   Example contributed by Max Danielsson (@autious) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2018-2023 Max Danielsson   (@autious) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const fovy_perspective    = 45.0
const width_orthographic  = 10.0

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [models] example - geometric shapes')
    defer { rl.close_window() }       // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        rl.Vector3 { 0.0, 10.0, 10.0 },
        rl.Vector3 { 0.0,  0.0,  0.0 },
        rl.Vector3 { 0.0,  1.0,  0.0 },
        fovy_perspective,
        rl.camera_perspective
    }

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_space) {
            if camera.projection == rl.camera_perspective {
                camera.fovy       = width_orthographic
                camera.projection = rl.camera_orthographic
            } else {
                camera.fovy       = fovy_perspective
                camera.projection = rl.camera_perspective
            }
        }

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

                rl.draw_grid(10, 1.0)        // Draw a grid

            rl.end_mode_3d()

            rl.draw_text('Press Spacebar to switch camera type', 10, rl.get_screen_height() - 30, 20, rl.darkgray)

            if camera.projection == rl.camera_orthographic {
                rl.draw_text('ORTHOGRAPHIC', 10, 40, 20, rl.black)
            } else if camera.projection == rl.camera_perspective {
                rl.draw_text('PERSPECTIVE', 10, 40, 20, rl.black)
            }

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
