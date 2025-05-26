/*******************************************************************************************
*
*   raylib [models] example - Plane rotations (yaw, pitch, roll)
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example contributed by Berni (@Berni8k) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Berni             (@Berni8k) and Ramon Santamaria (@raysan5)
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

    //SetConfigFlags(FLAG_MSAA_4X_HINT | FLAG_WINDOW_HIGHDPI);
    rl.init_window(screen_width, screen_height, 'raylib [models] example - plane rotations (yaw, pitch, roll)')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }          // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut camera := rl.Camera {
        position:    rl.Vector3 { 0.0, 50.0, -120.0 } // Camera position perspective
        target:      rl.Vector3 { 0.0,  0.0,    0.0 } // Camera looking at point
        up:          rl.Vector3 { 0.0,  1.0,    0.0 } // Camera up vector (rotation towards target)
        fovy:        30.0                             // Camera field-of-view Y
        projection:  rl.camera_perspective            // Camera type
    }

    mut model := rl.Model.load(asset_path+'models/obj/plane.obj')           // Load model
    texture   := rl.Texture.load(asset_path+'models/obj/plane_diffuse.png') // Load model texture
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer {
        model.unload()              // Unload model data
        texture.unload()            // Unload model data
    }

    model.set_texture(0, rl.material_map_diffuse, texture) // Set map diffuse texture

    mut pitch := f32(0.0)
    mut roll  := f32(0.0)
    mut yaw   := f32(0.0)

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Plane pitch (x-axis) controls
        if      rl.is_key_down(rl.key_down) { pitch += 0.6 }
        else if rl.is_key_down(rl.key_up)   { pitch -= 0.6 }
        else {
            if      pitch >  0.3 { pitch -= 0.3 }
            else if pitch < -0.3 { pitch += 0.3 }
        }

        // Plane yaw (y-axis) controls
        if      rl.is_key_down(rl.key_s) { yaw -= 1.0 }
        else if rl.is_key_down(rl.key_a) { yaw += 1.0 }
        else {
            if      yaw > 0.0 { yaw -= 0.5 }
            else if yaw < 0.0 { yaw += 0.5 }
        }

        // Plane roll (z-axis) controls
        if      rl.is_key_down(rl.key_left)  { roll -= 1.0 }
        else if rl.is_key_down(rl.key_right) { roll += 1.0 }
        else {
            if      roll > 0.0 { roll -= 0.5 }
            else if roll < 0.0 { roll += 0.5 }
        }

        // Tranformation matrix for rotations
        model.transform = rl.Matrix.rotate_xyz(
            rl.Vector3 {
                rl.deg2rad(pitch),
                rl.deg2rad(yaw),
                rl.deg2rad(roll)})
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // Draw 3D model (recomended to draw 3D always before 2D)
            rl.begin_mode_3d(rl.Camera3D(camera))

                model.draw(rl.Vector3 { 0.0, -8.0, 0.0 }, 1.0, rl.white)   // Draw 3d model with texture
                rl.draw_grid(10, 10.0)

            rl.end_mode_3d()

        
            // Draw controls info
            rl.draw_rectangle(30,       370, 260, 70, rl.Color.fade(rl.green,     0.5))
            rl.draw_rectangle_lines(30, 370, 260, 70, rl.Color.fade(rl.darkgreen, 0.5))
        
            rl.draw_text('Pitch controlled with: KEY_UP / rl.key_down',      40, 380, 10, rl.darkgray)
            rl.draw_text('Roll controlled with: rl.key_left / rl.key_right', 40, 400, 10, rl.darkgray)
            rl.draw_text('Yaw controlled with: rl.key_a / rl.key_s',         40, 420, 10, rl.darkgray)

            rl.draw_text('(c) WWI Plane Model created by GiaHanLam', screen_width - 240, screen_height - 20, 10, rl.darkgray)
        
        rl.end_drawing()
    }
}
