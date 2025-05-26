/*******************************************************************************************
*
*   raylib [core] example - Picking in 3d mode
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
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
pub fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [core] example - 3d picking')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 10.0, 10.0, 10.0 } // Camera position
        target:      rl.Vector3 {  0.0,  0.0,  0.0 } // Camera looking at point
        up:          rl.Vector3 {  0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                            // Camera field-of-view Y
        projection:  rl.camera_perspective           // Camera projection type
    }

    mut cube_position := rl.Vector3 { 0.0, 1.0, 0.0 }
    mut cube_size     := rl.Vector3 { 2.0, 2.0, 2.0 }

    mut ray       := rl.Ray {}          // Picking line ray
    mut collision := rl.RayCollision {} // Ray collision hit info

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_cursor_hidden() { rl.update_camera(&camera, rl.camera_first_person) }

        // Toggle camera controls
        if rl.is_mouse_button_pressed(rl.mouse_button_right) {
            if rl.is_cursor_hidden() { rl.enable_cursor()  }
            else                     { rl.disable_cursor() }
        }

        if rl.is_mouse_button_pressed(rl.mouse_button_left) {
            if !collision.hit {
                ray = rl.get_mouse_ray(rl.get_mouse_position(), camera)

                // Check collision between ray and box
                collision = rl.get_ray_collision_box(
                    ray,

                    rl.BoundingBox {
                        rl.Vector3 { cube_position.x - cube_size.x/2, cube_position.y - cube_size.y/2, cube_position.z - cube_size.z/2 },
                        rl.Vector3 { cube_position.x + cube_size.x/2, cube_position.y + cube_size.y/2, cube_position.z + cube_size.z/2 }
                    }
                )
            } else {
                collision.hit = false
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.white)

            rl.begin_mode_3d(rl.Camera3D(camera))

                if collision.hit {
                    rl.draw_cube(cube_position, cube_size.x, cube_size.y, cube_size.z, rl.red)
                    rl.draw_cube_wires(cube_position, cube_size.x, cube_size.y, cube_size.z, rl.maroon)

                    rl.draw_cube_wires(cube_position, cube_size.x + 0.2, cube_size.y + 0.2, cube_size.z + 0.2, rl.green)
                } else {
                    rl.draw_cube(cube_position, cube_size.x, cube_size.y, cube_size.z, rl.gray)
                    rl.draw_cube_wires(cube_position, cube_size.x, cube_size.y, cube_size.z, rl.darkgray)
                }

                rl.draw_ray(ray, rl.maroon)
                rl.draw_grid(10, 1.0)

            rl.end_mode_3d()

            rl.draw_text('Try clicking on the box with your mouse!', 240, 10, 20, rl.darkgray)

            if collision.hit {
                rl.draw_text('BOX SELECTED', (screen_width - rl.measure_text(c'BOX SELECTED', 30)) / 2, int(f32(screen_height) * 0.1), 30, rl.green)
            }

            rl.draw_text('Right click mouse to toggle camera controls', 10, 430, 10, rl.gray)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
