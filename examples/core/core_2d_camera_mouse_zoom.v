/*******************************************************************************************
*   raylib [core] example - 2d camera mouse zoom
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2022-2023 Jeffery Myers    (@JeffM2501)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const screen_width  = 800
const screen_height = 450


// Program main entry point
fn main () {
    // Initialization

    rl.init_window(screen_width, screen_height, "raylib [core] example - 2d camera")
    // De-Initialization
    defer { rl.close_window() }     // Close window and OpenGL context

    mut camera := rl.Camera2D { zoom: 1.0 }

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        // Translate based on mouse right click
        if rl.is_mouse_button_down(rl.mouse_button_right) {
            delta := rl.Vector2.scale(rl.get_mouse_delta(), -1.0/camera.zoom)
            camera.target = rl.Vector2.add(camera.target, delta)
        }

        // Zoom based on mouse wheel
        wheel := rl.get_mouse_wheel_move()
        
        if wheel != 0 {
            mouse_position  := rl.get_mouse_position()
            // Get the world point that is under the mouse
            mouse_world_pos := rl.get_screen_to_world_2d(mouse_position, camera)
            
            // Set the offset to where the mouse is
            camera.offset = mouse_position

            // Set the target to match, so that the camera maps the world space point 
            // under the cursor to the screen space point under the cursor at any zoom
            camera.target = mouse_world_pos;

            // Zoom increment
            zoom_increment := f32(0.125)

            camera.zoom += wheel*zoom_increment
            if camera.zoom < zoom_increment {
                camera.zoom = zoom_increment
            }
        }

        // Draw
        rl.begin_drawing()
            rl.clear_background(rl.black)

            rl.begin_mode_2d(camera)

                // Draw the 3d grid, rotated 90 degrees and centered around 0,0 
                // just so we have something in the XY plane
                rl.rl_push_matrix()
                    rl.rl_translatef(0, 25*50, 0)
                    rl.rl_rotatef(90, 1, 0, 0)
                    rl.draw_grid(100, 50)
                rl.rl_pop_matrix()

                // Draw a reference circle
                rl.draw_circle(100, 100, 50, rl.yellow)

            rl.end_mode_2d()

            rl.draw_text("Mouse right button drag to move, mouse wheel to zoom", 10, 10, 20, rl.white)
        
        rl.end_drawing()
    }
}
