/*******************************************************************************************
*
*   raylib [models] example - Drawing billboards
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.5
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

    rl.init_window(screen_width, screen_height, "raylib [models] example - drawing billboards")
    defer { rl.close_window() }     // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position: rl.Vector3 { 5.0, 4.0, 5.0 } // Camera position
        target:   rl.Vector3 { 0.0, 2.0, 0.0 } // Camera looking at point
        up:       rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                      // Camera field-of-view Y
        projection:  rl.camera_perspective     // Camera projection type
    }

    bill := rl.load_texture("resources/billboard.png") // Our billboard texture
    defer { bill.unload(bill) }                        // Unload texture
    
    bill_position_static   := rl.Vector3 { 0.0, 2.0, 0.0 } // Position of static billboard
    bill_position_rotating := rl.Vector3 { 1.0, 2.0, 1.0 } // Position of rotating billboard

    // Entire billboard texture, source is used to take a segment from a larger texture.
    source := rl.Rectangle { 0.0, 0.0, f32(bill.width), f32(bill.height) }

    // NOTE: Billboard locked on axis-Y
    bill_up := rl.Vector3 { 0.0, 1.0, 0.0 }

    // Rotate around origin
    // Here we choose to rotate around the image center
    // NOTE: (-1, 1) is the range where origin.x, origin.y is inside the texture
    mut rotate_origin := rl.Vector2 {}

    // Distance is needed for the correct billboard draw order
    // Larger distance (further away from the camera) should be drawn prior to smaller distance.
    mut distance_static   := f32(0)
    mut distance_rotating := f32(0)
    mut rotation          := f32(0)

    rl.set_target_fps(60)                // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_orbital)

        rotation         += 0.4
        distance_static   = rl.Vector3.distance(camera.position, bill_position_static)
        distance_rotating = rl.Vector3.distance(camera.position, bill_position_rotating)

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                rl.draw_grid(10, 1.0)        // Draw a grid

                // Draw order matters!
                if distance_static > distance_rotating {
                    rl.draw_billboard(camera, bill, bill_position_static, 2.0, rl.white)
                    rl.draw_billboard_pro(camera, bill, source, bill_position_rotating, bill_up, rl.Vector2 {1.0, 1.0}, rotate_origin, rotation, rl.white)
                } else {
                    rl.draw_billboard_pro(camera, bill, source, bill_position_rotating, bill_up, rl.Vector2 {1.0, 1.0}, rotate_origin, rotation, rl.white)
                    rl.draw_billboard(camera, bill, bill_position_static, 2.0, rl.white)
                }
                
            rl.end_mode_3d()

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
