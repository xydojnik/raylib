/*******************************************************************************************
*
*   raylib [models] example - loading gltf with animations
*
*   LIMITATIONS:
*     - Only supports 1 armature per file, and skips loading it if there are multiple armatures
*     - Only supports linear interpolation (default method in Blender when checked
*       'Always Sample Animations' when exporting a GLTF file)
*     - Only supports translation/rotation/scale animation channel.path,
*       weights not considered (i.e. morph targets)
*
*   Example originally created with raylib 3.7, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2020-2023 Ramon Santamaria  (@raysan5)
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

    rl.init_window(screen_width, screen_height, 'raylib [models] example - loading gltf')
    defer { rl.close_window() }

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 5.0, 5.0, 5.0 } // Camera position
        target:      rl.Vector3 { 0.0, 2.0, 0.0 } // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                         // Camera field-of-view Y
        projection:  rl.camera_perspective        // Camera projection type
    }

    // Load gltf model
    mut model := rl.Model.load('resources/models/gltf/robot.glb')
    defer { model.unload() }

    println('MESH COUNT: ${model.meshCount}')

    // Load gltf model animations
    mut anim_index         := u32(0)
    mut anim_current_frame := u32(0)

    model_animations := rl.ModelAnimation.load('resources/models/gltf/robot.glb')
    anims_count      := u32(model_animations.len)
    defer { model_animations.unload() }

    position := rl.Vector3 {}   // Set model position

    rl.disable_cursor()         // Limit cursor to relative movement inside the window
    rl.set_target_fps(60)       // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    mut anim := model_animations[anim_index]
    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_third_person)
        // Select current animation
        if rl.is_mouse_button_pressed(rl.mouse_button_right) {
            anim_index = (anim_index+1)%anims_count
            anim       = unsafe { model_animations[anim_index] }
        } else if rl.is_mouse_button_pressed(rl.mouse_button_left) {
            anim_index = (anim_index+anims_count-1)%anims_count
            anim       = unsafe { model_animations[anim_index] }
        }

        // Update model animation
        // anim := unsafe { model_animations[anim_index] }
        anim_current_frame = u32((anim_current_frame + 1)%u32(anim.frameCount))
        rl.update_model_animation(model, anim, int(anim_current_frame))

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                rl.draw_model(model, position, 1.0, rl.white)    // Draw animated model
                rl.draw_grid(10, 1.0)

            rl.end_mode_3d()

            rl.draw_text('Use the LEFT/RIGHT mouse buttons to switch animation', 10, 10, 20, rl.gray)
            rl.draw_text('Animation: ${anim.name}', 10, rl.get_screen_height() - 20, 10, rl.darkgray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
