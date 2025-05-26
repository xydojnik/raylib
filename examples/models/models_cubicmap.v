/*******************************************************************************************
*
*   raylib [models] example - Cubicmap loading and drawing
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

    rl.init_window(screen_width, screen_height, 'raylib [models] example - cubesmap loading and drawing')
    defer { rl.close_window() }            // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 16.0, 14.0, 16.0 } // Camera position
        target:      rl.Vector3 {  0.0,  0.0,  0.0 } // Camera looking at point
        up:          rl.Vector3 {  0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                            // Camera field-of-view Y
        projection:  rl.camera_perspective           // Camera projection type
    }

    image    := rl.load_image('resources/cubicmap.png') // Load cubicmap image (RAM)
    cubicmap := rl.load_texture_from_image(image)       // Convert image to texture to display (VRAM)
    defer { rl.unload_texture(cubicmap) }               // Unload cubicmap texture

    mesh := rl.Mesh.gen_cubicmap(image, rl.Vector3 { 1.0, 1.0, 1.0 })
    mut model := rl.Model.load_from_mesh(mesh)
    defer { model.unload() } // Unload map model
    image.unload()           // Unload cubesmap image from RAM, already uploaded to VRAM

    // NOTE: By default each cube is mapped to one part of texture atlas
    texture := rl.Texture.load('resources/cubicmap_atlas.png') // Load map texture
    defer { rl.unload_texture(texture) }                       // Unload map texture
    model.set_texture(0, rl.material_map_diffuse, texture)     // Set map diffuse texture

    map_position := rl.Vector3 { -16.0, 0.0, -8.0 }            // Set model position

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_orbital)

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                rl.draw_model(model, map_position, 1.0, rl.white)

            rl.end_mode_3d()

            rl.draw_texture_ex(cubicmap, rl.Vector2 { screen_width - f32(cubicmap.width)*4.0 - 20, 20.0 }, 0.0, 4.0, rl.white)
            rl.draw_rectangle_lines(screen_width - cubicmap.width*4 - 20, 20, cubicmap.width*4, int(cubicmap.height)*4, rl.green)

            rl.draw_text('cubicmap image used to', 658, 90, 10, rl.gray)
            rl.draw_text('generate map 3d model', 658, 104, 10, rl.gray)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
