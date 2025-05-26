/*******************************************************************************************
*
*   raylib [models] example - first person maze
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const asset_path = @VMODROOT+'/thirdparty/raylib/examples/models/resources/'


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [models] example - first person maze')
    defer { rl.close_window() }                // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 {   0.2, 0.4, 0.2 } // Camera position
        target:      rl.Vector3 { 0.185, 0.4, 0.0 } // Camera looking at point
        up:          rl.Vector3 {   0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                           // Camera ield-o-view Y
        projection:  rl.camera_perspective          // Camera projection type
    }
    
    // mut position := rl.Vector3 {}            // Set model position

    im_map   := rl.Image.load(asset_path+'cubicmap.png') // Load cubicmap image (RAM)
    cubicmap := rl.Texture.load_from_image(im_map)       // Convert image to texture to display (VRAM)
    defer { cubicmap.unload() }                          // Unload cubicmap texture

    mesh := rl.gen_mesh_cubicmap(im_map, rl.Vector3 { 1.0, 1.0, 1.0 })
    mut model := rl.load_model_from_mesh(mesh)
    defer { rl.unload_model(model) }                     // Unload map model
    
    // NOTE: By default each cube is mapped to one part of texture atlas
    texture := rl.Texture.load(asset_path+'cubicmap_atlas.png')                   // Load map texture
    defer  { texture.unload() }       // Unload map texture
    model.set_texture(0, rl.material_map_diffuse, texture) // Set map diffuse texture

    // Get map image data to be used for collision detection
    map_pixels := im_map.load_colors()
    defer { rl.unload_image_colors(map_pixels) }    // Unload color array
    im_map.unload()                                 // Unload image from RAM

    map_position := rl.Vector3 { -16.0, 0.0, -8.0 } // Set model position

    rl.disable_cursor()                             // Limit cursor to relative movement inside the window
    rl.set_target_fps(60)                           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        old_cam_pos := camera.position    // Store old camera position

        rl.update_camera(&camera, rl.camera_first_person)

        // Check player collision (we simplify to 2D collision detection)
        player_pos := rl.Vector2 { camera.position.x, camera.position.z }
        player_radius := f32(0.1)  // Collision radius (player is modelled as a cilinder for collision)

        mut player_cell_x := int(player_pos.x - map_position.x + 0.5)
        mut player_cell_y := int(player_pos.y - map_position.z + 0.5)

        // Out-of-limits security check
        if      player_cell_x < 0               { player_cell_x = 0                  }
        else if player_cell_x >= cubicmap.width { player_cell_x = cubicmap.width - 1 }

        if      player_cell_y < 0                { player_cell_y = 0                   }
        else if player_cell_y >= cubicmap.height { player_cell_y = cubicmap.height - 1 }

        // Check map collisions using image data and player position
        // TODO: Improvement: Just check player surrounding cells for collision
        for y in 0..cubicmap.height {
            for x in 0..cubicmap.width {
                // Collision: white pixel, only check R channel
                unsafe {
                    if (map_pixels[y*cubicmap.width + x].r == 255) &&
                        rl.check_collision_circle_rec(player_pos, player_radius,
                            rl.Rectangle { map_position.x - 0.5 + x*1.0, map_position.z - 0.5 + y*1.0, 1.0, 1.0 }
                        )
                    {
                        // Collision detected, reset camera position
                        camera.position = old_cam_pos
                    }
                }
            }
        }

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)
                rl.draw_model(model, map_position, 1.0, rl.white)                     // Draw maze map
            rl.end_mode_3d()

        rl.draw_texture_ex(cubicmap, rl.Vector2 { rl.get_screen_width() - f32(cubicmap.width)*4.0 - 20, 20.0 }, 0.0, 4.0, rl.white)
        rl.draw_rectangle_lines(rl.get_screen_width() - int(cubicmap.width)*4 - 20, 20, int(cubicmap.width)*4, int(cubicmap.height)*4, rl.green)

            // Draw player position radar
            rl.draw_rectangle(rl.get_screen_width() - cubicmap.width*4 - 20 + player_cell_x*4, 20 + player_cell_y*4, 4, 4, rl.red)

            rl.draw_fps(10, 10)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
