/*******************************************************************************************
*
*   raylib [core] example - 3d camera first person
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
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

const max_columns = 20

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - 3d camera first person")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }      // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Define the camera to look into our 3d world (position, target, up vector)
    mut camera := rl.Camera {
        position:    rl.Vector3 { 0.0, 2.0, 4.0 } // Camera position
        target:      rl.Vector3 { 0.0, 2.0, 0.0 } // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:        60.0                         // Camera field-of-view Y
        projection:  rl.camera_perspective        // Camera projection type
    }

    mut camera_mode := rl.camera_first_person

    // Generates some random columns
    mut heights   := []f32        { len: max_columns }
    mut positions := []rl.Vector3 { len: max_columns }
    mut colors    := []rl.Color   { len: max_columns }

    for i in 0..max_columns {
        heights[i]   = f32(rl.get_random_value(1, 12))
        positions[i] = rl.Vector3 { f32(rl.get_random_value(-15, 15)), heights[i]/2.0, f32(rl.get_random_value(-15, 15)) }
        colors[i]    = rl.Color { u8(rl.get_random_value(20, 255)), u8(rl.get_random_value(10, 55)), u8(30), u8(255) }
    }

    rl.disable_cursor()   // Limit cursor to relative movement inside the window

    rl.set_target_fps(60) // Set our game to run at 60 frames-per-second
//--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Switch camera mode
        if rl.is_key_pressed(rl.key_one) {
            camera_mode = rl.camera_free
            camera.up   = rl.Vector3 { 0.0, 1.0, 0.0 } // Reset roll
        }

        if rl.is_key_pressed(rl.key_two) {
            camera_mode = rl.camera_first_person
            camera.up   = rl.Vector3 { 0.0, 1.0, 0.0 } // Reset roll
        }

        if rl.is_key_pressed(rl.key_three) {
            camera_mode = rl.camera_third_person
            camera.up   = rl.Vector3 { 0.0, 1.0, 0.0 } // Reset roll
        }

        if rl.is_key_pressed(rl.key_four) {
            camera_mode = rl.camera_orbital
            camera.up   = rl.Vector3 { 0.0, 1.0, 0.0 } // Reset roll
        }

        // Switch camera projection
        if rl.is_key_pressed(rl.key_p) {
            if camera.projection == rl.camera_perspective {
                // Create isometric view
                camera_mode = rl.camera_third_person
                // Note: The target distance is related to the render distance in the orthographic projection
                camera.position   = rl.Vector3 { 0.0, 2.0, -100.0 }
                camera.target     = rl.Vector3 { 0.0, 2.0,    0.0 }
                camera.up         = rl.Vector3 { 0.0, 1.0,    0.0 }
                camera.projection = rl.camera_orthographic
                camera.fovy       = 20.0 // near plane width in rl.camera_orthographic

                rl.camera_yaw(mut camera,   rl.deg2rad(-135), true)
                rl.camera_pitch(mut camera, rl.deg2rad(-45), true, true, false)
                
            } else if camera.projection == rl.camera_orthographic {
                // Reset to default view
                camera_mode       = rl.camera_third_person
                camera.position   = rl.Vector3 { 0.0, 2.0, 10.0 }
                camera.target     = rl.Vector3 { 0.0, 2.0,  0.0 }
                camera.up         = rl.Vector3 { 0.0, 1.0,  0.0 }
                camera.projection = rl.camera_perspective
                camera.fovy       = 60.0
            }
        }

        // Update camera computes movement internally depending on the camera mode
        // Some default standard keyboard/mouse inputs are hardcoded to simplify use
        // For advance camera controls, it's reecommended to compute camera movement manually
        rl.update_camera(&camera, camera_mode)                  // Update camera

/*
        // Camera PRO usage example (EXPERIMENTAL)
        // This new camera function allows custom movement/rotation values to be directly provided
        // as input parameters, with this approach, rcamera module is internally independent of raylib inputs
        rl.update_camera_pro(&camera,
            rl.Vector3 {
                rl.is_key_down(rl.key_w) || rl.is_key_down(rl.key_up))   *0.1 - // Move forward-backward
                rl.is_key_down(rl.key_s) || rl.is_key_down(rl.key_down)) *0.1,    
                rl.is_key_down(rl.key_d) || rl.is_key_down(rl.key_right))*0.1 - // Move right-left
                rl.is_key_down(rl.key_a) || rl.is_key_down(rl.key_left)) *0.1,
                0.0                                                             // Move up-down
            },
            rl.Vector3 {
                rl.get_mouse_delta().x*0.05, // Rotation: yaw
                rl.get_mouse_delta().y*0.05, // Rotation: pitch
                0.0                          // Rotation: roll
            },
            rl.get_mouse_wheel_move()*2.0)        // Move to target (zoom)
*/
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.white)

                rl.begin_mode_3d(rl.Camera3D(camera))

                rl.draw_plane(rl.Vector3 { 0.0, 0.0, 0.0 }, rl.Vector2 { 32.0, 32.0 }, rl.lightgray) // Draw ground
                rl.draw_cube(rl.Vector3  { -16.0, 2.5, 0.0 }, 1.0, 5.0, 32.0, rl.blue)     // Draw a blue wall
                rl.draw_cube(rl.Vector3  { 16.0, 2.5, 0.0 }, 1.0, 5.0, 32.0, rl.lime)      // Draw a green wall
                rl.draw_cube(rl.Vector3  { 0.0, 2.5, 16.0 }, 32.0, 5.0, 1.0, rl.gold)      // Draw a yellow wall

                // Draw some cubes around
                for i in 0..max_columns {
                    rl.draw_cube(positions[i], 2.0, heights[i], 2.0, colors[i])
                    rl.draw_cube_wires(positions[i], 2.0, heights[i], 2.0, rl.maroon)
                }

                // Draw player cube
                if camera_mode == rl.camera_third_person {
                    rl.draw_cube(camera.target, 0.5, 0.5, 0.5, rl.purple)
                    rl.draw_cube_wires(camera.target, 0.5, 0.5, 0.5, rl.darkpurple)
                }

            rl.end_mode_3d()

            // Draw info boxes
            rl.draw_rectangle(5, 5, 330, 100, rl.Color.fade(rl.skyblue, 0.5))
            rl.draw_rectangle_lines(5, 5, 330, 100, rl.blue)

            rl.draw_text("Camera controls:", 15, 15, 10, rl.black)
            rl.draw_text("- Move keys: W, A, S, D, Space, Left-Ctrl", 15, 30, 10, rl.black)
            rl.draw_text("- Look around: arrow keys or mouse", 15, 45, 10, rl.black)
            rl.draw_text("- Camera mode keys: 1, 2, 3, 4", 15, 60, 10, rl.black)
            rl.draw_text("- Zoom keys: num-plus, num-minus or mouse scroll", 15, 75, 10, rl.black)
            rl.draw_text("- Camera projection key: P", 15, 90, 10, rl.black)

            rl.draw_rectangle(600, 5, 195, 100, rl.Color.fade(rl.skyblue, 0.5))
            rl.draw_rectangle_lines(600, 5, 195, 100, rl.blue)

            rl.draw_text("Camera status:", 610, 15, 10, rl.black)

            cammod_str := if camera_mode == rl.camera_free     { "FREE"         }
                 else if camera_mode == rl.camera_first_person { "FIRST_PERSON" }
                 else if camera_mode == rl.camera_third_person { "THIRD_PERSON" }
                 else if camera_mode == rl.camera_orbital      { "ORBITAL"      }
                 else                                          { "CUSTOM"       }

            camproj_str := if camera.projection == rl.camera_perspective { "PERSPECTIVE"  }
                  else if camera.projection == rl.camera_orthographic    { "ORTHOGRAPHIC" }
                  else                                                   { "CUSTOM"       }

            rl.draw_text("- Mode: ${cammod_str}",        610, 30, 10, rl.black)
            rl.draw_text("- Projection: ${camproj_str}", 610, 45, 10, rl.black)

            rl.draw_text("- Position: (${camera.position.x}, ${camera.position.y}, ${camera.position.z})", 610, 60, 10, rl.black)
            rl.draw_text("- Target: (${camera.target.x}, ${camera.target.y}, ${camera.target.z})",         610, 75, 10, rl.black)
            rl.draw_text("- Up: (${camera.up.x},  ${camera.up.y},  ${camera.up.z})",                       610, 90, 10, rl.black)

        rl.end_drawing()
    }
}
