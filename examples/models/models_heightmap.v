/*******************************************************************************************
*
*   raylib [models] example - Heightmap loading and drawing
*
*   Example originally created with raylib 1.8, last time updated with raylib 3.5
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

    rl.init_window(screen_width, screen_height, 'raylib [models] example - heightmap loading and drawing')
    defer { rl.close_window()  }                     // Close window and OpenGL context

    // Define our custom camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 18.0, 21.0, 18.0 } // Camera position
        target:      rl.Vector3 {  0.0,  0.0,  0.0 } // Camera looking at point
        up:          rl.Vector3 {  0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                            // Camera ield-o-view Y
        projection : rl.camera_perspective           // Camera projection type
    }

    image   := rl.Image.load('resources/heightmap.png')             // Load heightmap image (RAM)
    texture := rl.Texture.load_from_image(image)                    // Convert image to texture (VRAM)
    defer { texture.unload() }                                      // Unload texture

    mesh  := rl.Mesh.gen_heightmap(image, rl.Vector3 { 16, 8, 16 }) // Generate heightmap mesh (RAM and VRAM)
    image.unload()                                                  // Unload heightmap image from RAM, already uploaded to VRAM

    mut model := rl.Model.load_from_mesh(mesh)                      // Load model from generated mesh
    defer { model.unload() }                                        // Unload model

    model.set_texture(0, rl.material_map_diffuse, texture)          // Set map diffuse texture
    map_position := rl.Vector3  { -8.0, 0.0, -8.0 }                 // Define model position


    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_orbital)

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)
                model.draw(map_position, 1.0, rl.red)
                rl.draw_grid(20, 1.0)
            rl.end_mode_3d()

            texture.draw(screen_width - texture.width - 20, 20, rl.white)
            rl.draw_rectangle_lines( screen_width - texture.width - 20, 20, texture.width, texture.height, rl.green)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
