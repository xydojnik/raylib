/*******************************************************************************************
*
*   raylib [models] example - Load models vox (MagicaVoxel)
*
*   Example originally created with raylib 4.0, last time updated with raylib 4.0
*
*   Example contributed by Johann Nadalutti (@procfxgen) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Johann Nadalutti  (@procfxgen) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

// const max_vox_files = 3

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    vox_file_names := [
        "resources/models/vox/chr_knight.vox",
        "resources/models/vox/chr_sword.vox",
        "resources/models/vox/monu9.vox"
    ]!

    mut load_times := [3]f32{}

    rl.init_window(screen_width, screen_height, "raylib [models] example - magicavoxel loading")
    defer { rl.close_window()  }        // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 10.0, 10.0, 10.0 }    // Camera position
        target:      rl.Vector3 {  0.0,  0.0,  0.0 }    // Camera looking at point
        up:          rl.Vector3 {  0.0,  1.0,  0.0 }    // Camera up vector (rotation towards target)
        fovy:        45.0                               // Camera field-of-view Y
        projection:  rl.camera_perspective              // Camera projection type
    }

    // Load MagicaVoxel files
    mut models := []rl.Model { len: vox_file_names.len }
    // Unload models data (GPU VRAM)
    defer { for model in models { rl.unload_model(model) } }

    // load Models
    for i, mut model in models {
        // Load VOX file and measure time
        file_name := vox_file_names[i]
        
        t0 := rl.get_time()*1000.0
            model = rl.load_model(file_name)
        t1 := rl.get_time()*1000.0

        load_time := t1-t0
        load_times[i] = f32(load_time)

        // TraceLog(LOG_WARNING, TextFormat("[%s] File loaded in %.3f ms", vox_file_names[i], t1 - t0))
        println("[$[file_name]] File loaded in ${load_time} ms")

        // Compute model translation matrix to center model on draw position (0, 0 , 0)
        bb := rl.get_model_bounding_box(models[i])
        center := rl.Vector3 {
            bb.min.x  + ((bb.max.x - bb.min.x)/2),
            0,
            bb.min.z  + ((bb.max.z - bb.min.z)/2)
        }

        mat_translate := rl.Matrix.translate(-center.x, 0, -center.z)
        model.transform = mat_translate
    }

    mut current_model := int(0)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_orbital)

        // Cycle between models on mouse click
        if rl.is_mouse_button_pressed(rl.mouse_button_left) {
            current_model = (current_model + 1)%vox_file_names.len
        }

        // Cycle between models on key pressed
        if rl.is_key_pressed(rl.key_right) {
            current_model++
            if current_model >= vox_file_names.len {
                current_model = 0
            }
        } else if rl.is_key_pressed(rl.key_left) {
            current_model--
            if current_model < 0 {
                current_model = vox_file_names.len - 1
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // Draw 3D model
            rl.begin_mode_3d(camera)

                rl.draw_model(models[current_model], rl.Vector3 { 0, 0, 0 }, 1.0, rl.white)
                rl.draw_grid(10, 1.0)

            rl.end_mode_3d()

            // Display info
            rl.draw_rectangle(10, 400, 310, 30, rl.Color.fade(rl.skyblue, 0.5))
            rl.draw_rectangle_lines(10, 400, 310, 30, rl.Color.fade(rl.darkblue, 0.5))
            rl.draw_text("MOUSE LEFT BUTTON to CYCLE VOX MODELS", 40, 410, 10, rl.blue)
            rl.draw_text("File: ${rl.get_file_name(vox_file_names[current_model])}, loaded: ${load_times[current_model]} ms", 10, 10, 20, rl.gray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
