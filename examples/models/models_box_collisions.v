/*******************************************************************************************
*
*   raylib [models] example - Detect basic 3d collisions (box vs sphere vs box)
*
*   Example originally created with raylib 1.3, last time updated with raylib 3.5
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

    rl.init_window(screen_width, screen_height, 'raylib [models] example - box collisions')
    defer { rl.close_window() }       // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        rl.Vector3 { 0.0, 10.0, 10.0 },
        rl.Vector3 { 0.0,  0.0,  0.0 },
        rl.Vector3 { 0.0,  1.0,  0.0 },
        45.0, 0
    }

    mut player_position := rl.Vector3 { 0.0, 1.0, 2.0 }
    mut player_color    := rl.green

    player_size := rl.Vector3 { 1.0, 2.0, 1.0 }
    
    enemy_box_pos     := rl.Vector3 { -4.0, 1.0, 0.0 }
    enemy_box_size    := rl.Vector3 {  2.0, 2.0, 2.0 }
    enemy_sphere_pos  := rl.Vector3 { 4.0, 0.0, 0.0 }
    enemy_sphere_size := f32(1.5)

    mut collision := false

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        // Move player
        if      rl.is_key_down(rl.key_right) { player_position.x += 0.2 }
        else if rl.is_key_down(rl.key_left)  { player_position.x -= 0.2 }
        else if rl.is_key_down(rl.key_down)  { player_position.z += 0.2 }
        else if rl.is_key_down(rl.key_up)    { player_position.z -= 0.2 }

        collision = false

        if rl.check_collision_boxes(
            rl.BoundingBox {
                rl.Vector3.subtract(player_position, rl.Vector3.divide_value(player_size, 2)),
                rl.Vector3.add     (player_position, rl.Vector3.divide_value(player_size, 2)),
            },
            rl.BoundingBox {
                rl.Vector3.subtract(enemy_box_pos, rl.Vector3.divide_value(enemy_box_size, 2)),
                rl.Vector3.add     (enemy_box_pos, rl.Vector3.divide_value(enemy_box_size, 2)),
            }
        ) {
            collision = true
        }
        

        // Check collisions player vs enemy-sphere
        if rl.check_collision_box_sphere(
            rl.BoundingBox {
                rl.Vector3.subtract(player_position, rl.Vector3.divide_value(player_size, 2)),
                rl.Vector3.add     (player_position, rl.Vector3.divide_value(player_size, 2)),
            },
            enemy_sphere_pos, enemy_sphere_size
        ) {
            collision = true
        }

        player_color = if collision { rl.red } else { rl.green }

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                // Draw enemy-box
                rl.draw_cube(enemy_box_pos, enemy_box_size.x, enemy_box_size.y, enemy_box_size.z, rl.gray)
                rl.draw_cube_wires(enemy_box_pos, enemy_box_size.x, enemy_box_size.y, enemy_box_size.z, rl.darkgray)

                // Draw enemy-sphere
                rl.draw_sphere(enemy_sphere_pos, enemy_sphere_size, rl.gray)
                rl.draw_sphere_wires(enemy_sphere_pos, enemy_sphere_size, 16, 16, rl.darkgray)

                // Draw player
                rl.draw_cube_v(player_position, player_size, player_color)

                rl.draw_grid(10, 1.0)        // Draw a grid

            rl.end_mode_3d()

            rl.draw_text('Move player with cursors to collide', 220, 40, 20, rl.gray)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
