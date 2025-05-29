/*******************************************************************************************
*
*   raylib [models] example - Waving cubes
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.7
*
*   Example contributed by Codecat (@codecat) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Codecat          (@codecat) and Ramon Santamaria (@raysan5)
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

    rl.init_window(screen_width, screen_height, 'raylib [models] example - waving cubes')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }      // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Initialize the camera
    mut camera := rl.Camera3D {
        position:    rl.Vector3 { 30.0, 20.0, 30.0 } // Camera position
        target:      rl.Vector3 {  0.0,  0.0,  0.0 } // Camera looking at point
        up:          rl.Vector3 {  0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        70.0                            // Camera field-of-view Y
        projection:  rl.camera_perspective           // Camera projection type
    }

    // Specify the amount of blocks in each direction
    num_blocks := 15

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {    // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        time := f32(rl.get_time())

        // Calculate time scale for cube position and size
        scale := (2.0 + rl.sinf(time))*0.7

        // Move camera around the scene
        camera_time := time*0.3

        camera.position.x = rl.cosf(camera_time)*40.0
        camera.position.z = rl.sinf(camera_time)*40.0
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(rl.Camera3D(camera))

                rl.draw_grid(10, 5.0)

                for x in 0.. num_blocks {
                    for y in 0..num_blocks {
                        for z in 0..num_blocks {
                            // Scale of the blocks depends on x/y/z positions
                            block_scale := (x + y + z)/30.0

                            // Scatter makes the waving effect by adding block_scale over time
                            scatter := rl.sinf(f32(block_scale*20.0 + time*4.0))

                            // Calculate the cube position
                            cube_pos := rl.Vector3 {
                                (x - num_blocks/2)*(scale*3.0) + scatter,
                                (y - num_blocks/2)*(scale*2.0) + scatter,
                                (z - num_blocks/2)*(scale*3.0) + scatter
                            }

                            // Pick a color with a hue depending on cube position for the rainbow color effect
                            cube_color := rl.Color.from_hsv(f32(((x + y + z)*18)%360), 0.75, 0.9)

                            // Calculate cube size
                            cube_size := f32((2.4 - scale)*block_scale)

                            // And finally, draw the cube!
                            rl.draw_cube(cube_pos, cube_size, cube_size, cube_size, cube_color)
                        }
                    }
                }

            rl.end_mode_3d()

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
