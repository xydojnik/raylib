/*******************************************************************************************
*
*   raylib [models] example - Load models M3D
*
*   Example originally created with raylib 4.5, last time updated with raylib 4.5
*
*   Example contributed by bzt (@bztsrc) and reviewed by Ramon Santamaria (@raysan5)
*
*   NOTES:
*     - Model3D (M3D) fileformat specs: https://gitlab.com/bztsrc/model3d
*     - Bender M3D exported: https://gitlab.com/bztsrc/model3d/-/tree/master/blender
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2022-2023 bzt              (@bztsrc)
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

    rl.init_window(screen_width, screen_height, 'raylib [models] example - M3D model loading')
    defer { rl.close_window() }             // Close window and OpenGL context
    
    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 1.5, 1.5, 1.5 }   // Camera position
        target:      rl.Vector3 { 0.0, 0.4, 0.0 }   // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 }   // Camera up vector (rotation towards target)
        fovy:        45.0                           // Camera field-of-view Y
        projection:  rl.camera_perspective          // Camera projection type
    }

    mut position := rl.Vector3 {}           // Set model position

    mut model_file_name := asset_path+'models/m3d/cesium_man.m3d'
    mut draw_mesh       := true
    mut draw_skeleton   := true
    mut anim_playing    := false            // Store anim state, what to draw

    // Load model
    model := rl.load_model(model_file_name) // Load the bind-pose model mesh and basic data
    defer { rl.unload_model(model) }

    // Load animations
    mut anim_frame_counter := int(0)
    mut anim_id            := int(0)

     // Load skeletal animation data
    mut anims := rl.ModelAnimation.load(model_file_name)
    // Unload model animations data
    defer { anims.unload() }
    
    rl.disable_cursor()   // Limit cursor to relative movement inside the window

    rl.set_target_fps(60) // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_first_person)

        if anims.len > 0 {
            // Play animation when spacebar is held down (or step one frame with N)
            if rl.is_key_down(rl.key_space) || rl.is_key_pressed(rl.key_n) {
                anim_frame_counter++
                unsafe {
                    if anim_frame_counter >= anims[anim_id].frameCount {
                        anim_frame_counter = 0
                    }

                    rl.update_model_animation(model, anims[anim_id], anim_frame_counter)
                    anim_playing = true
                }
            }

            // Select animation by pressing C
            if rl.is_key_pressed(rl.key_c) {
                anim_frame_counter = 0
                anim_id++

                if anim_id >= anims.len { anim_id = 0 }
                unsafe { rl.update_model_animation(model, anims[anim_id], 0) }
                anim_playing = true
            }
        }

        // Toggle skeleton drawing
        if rl.is_key_pressed(rl.key_b) { draw_skeleton = !draw_skeleton }

        // Toggle mesh drawing
        if rl.is_key_pressed(rl.key_m) { draw_mesh = !draw_mesh }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                // Draw 3d model with texture
                if draw_mesh {
                    rl.draw_model(model, position, 1.0, rl.white)
                }

                // Draw the animated skeleton
                // if draw_skeleton {
                //     Loop to (boneCount - 1) because the last one is a special 'no bone' bone,
                //     needed to workaround buggy models
                //     without a -1, we would always draw a cube at the origin
                //     for i in 0..model.boneCount {
                //         // By default the model is loaded in bind-pose by LoadModel().
                //         // But if UpdateModelAnimation() has been called at least once
                //         // then the model is already in animation pose, so we need the animated skeleton
                //         if !anim_playing || (anims_count == 0) {
                //             // Display the bind-pose skeleton
                //             unsafe {
                //                 rl.draw_cube(model.bindPose[i].translation, 0.04, 0.04, 0.04, rl.red)

                //                 if model.bones[i].parent >= 0 {
                //                     rl.draw_line_3d(
                //                         model.bindPose[i].translation,
                //                         model.bindPose[model.bones[i].parent].translation,
                //                         rl.red
                //                     )
                //                 }
                //             }
                //         } else {
                //             // Display the frame-pose skeleton
                //             unsafe {
                //                 rl.draw_cube(
                //                     anims[anim_id].framePoses[anim_frame_counter][i].translation,
                //                     0.05, 0.05, 0.05, rl.red
                //                 )

                //                 if anims[anim_id].bones[i].parent >= 0 {
                //                     rl.draw_line_3d(
                //                         anims[anim_id].framePoses[anim_frame_counter][i].translation,
                //                         anims[anim_id].framePoses[anim_frame_counter][anims[anim_id].bones[i].parent].translation,
                //                         rl.red
                //                     )
                //                 }
                //             }
                //         }
                //     }
                // }

                rl.draw_grid(10, 1.0)         // Draw a grid

            rl.end_mode_3d()

        
            for i in 0..model.boneCount {
                if draw_skeleton {
                    unsafe {
                        if anim_playing {
                            pos_start := rl.get_world_to_screen(anims[anim_id].framePoses[anim_frame_counter][i].translation, camera)
                            rl.draw_circle_v(pos_start, 3.0, rl.red)
                            rl.draw_circle_lines_v(pos_start, 10.0, rl.red)

                            if anims[anim_id].bones[i].parent >= 0 {
                                pos_end := rl.get_world_to_screen(
                                    anims[anim_id].framePoses[anim_frame_counter][anims[anim_id].bones[i].parent].translation, camera
                                )
                                rl.draw_line_v(pos_start, pos_end, rl.red)
                            }
                        } else if model.bones[i].parent >= 0 {
                            pos_start := rl.get_world_to_screen(model.bindPose[model.bones[i].parent].translation, camera)

                            rl.draw_circle_v(pos_start, 3.0, rl.red)
                            rl.draw_circle_lines_v(pos_start, 10.0, rl.red)


                            pos_end := rl.get_world_to_screen(model.bindPose[model.bones[i].parent].translation, camera)

                            rl.draw_line_v(pos_start, pos_end, rl.red)
                        }
                    }
                }
            }
        
            rl.draw_text('PRESS SPACE to PLAY MODEL ANIMATION', 10, rl.get_screen_height() - 80, 10, rl.maroon)
            rl.draw_text('PRESS N to STEP ONE ANIMATION FRAME', 10, rl.get_screen_height() - 60, 10, rl.darkgray)
            rl.draw_text('PRESS C to CYCLE THROUGH ANIMATIONS', 10, rl.get_screen_height() - 40, 10, rl.darkgray)
            rl.draw_text('PRESS M to toggle MESH, B to toggle SKELETON DRAWING', 10, rl.get_screen_height() - 20, 10, rl.darkgray)
            rl.draw_text('(c) CesiumMan model by KhronosGroup', rl.get_screen_width() - 210, rl.get_screen_height() - 20, 10, rl.gray)

        rl.end_drawing()
    }
}
