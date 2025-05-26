/*******************************************************************************************
*
*   raylib [models] example - Load 3d model with animations and play them
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.5
*
*   Example contributed by Culacant (@culacant) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Culacant         (@culacant) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************
*
*   NOTE: To export a model from blender, make sure it is not posed, the vertices need to be 
*         in the same position as they would be in edit mode and the scale of your models is 
*         set to 0. Scaling can be done from the export menu.
*
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

    rl.init_window(screen_width, screen_height, 'raylib [models] example - model animation')
    defer { rl.close_window() }                 // Close window and OpenGL context

    rl.disable_cursor()   // Catch cursor
    rl.set_target_fps(60) // Set our game to run at 60 frames-per-second

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 10.0, 10.0, 10.0 } // Camera position
        target:      rl.Vector3 {  0.0,  0.0,  0.0 } // Camera looking at point
        up:          rl.Vector3 {  0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                            // Camera field-of-view Y
        projection:  rl.camera_perspective           // Camera mode type
    }

    texture := rl.Texture.load(asset_path+'models/iqm/guytex.png') // Load model texture and set material
    defer { texture.unload() }

    mut model := rl.Model.load(asset_path+'models/iqm/guy.iqm')    // Load the animated model mesh and basic data
    defer { model.unload() }
    model.set_texture(0, rl.material_map_diffuse, texture)        // Set model material map texture
    model.transform = rl.Matrix.multiply(model.transform, rl.Matrix.rotate_x(rl.deg2rad(-90)))

    mut position := rl.Vector3 {}                                 // Set model position

    // Load animation data
    anims := rl.ModelAnimation.load(asset_path+'models/iqm/guyanim.iqm')
    defer { anims.unload() }
    
    mut anim_frame_counter := int(0)

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_first_person)

        // Play animation when spacebar is held down
        if rl.is_key_down(rl.key_space) {
            anim_frame_counter++
            unsafe {
                rl.update_model_animation(model, anims[0], anim_frame_counter)
                // if anim_frame_counter >= anims[0].frameCount {
                if anim_frame_counter >= anims[0].frameCount {
                    anim_frame_counter = 0
                }
            }
        }


        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(rl.Camera3D(camera))

                // rl.draw_model_ex(model, position, rl.Vector3 { 1.0, 0.0, 0.0 }, -90.0, rl.Vector3 { 1.0, 1.0, 1.0 }, rl.white)
                rl.draw_model(model, position, 1.0, rl.white)

                for i in 0..model.boneCount {
                    unsafe {
                        // rl.draw_cube(anims[0].framePoses[anim_frame_counter][i].translation, 0.2, 0.2, 0.2, rl.red)
                        rl.draw_cube(anims[0].framePoses[anim_frame_counter][i].translation, 0.2, 0.2, 0.2, rl.red)
                    }
                }

                rl.draw_grid(10, 1.0)         // Draw a grid

            rl.end_mode_3d()

            rl.draw_text('PRESS SPACE to PLAY MODEL ANIMATION', 10, 10, 20, rl.maroon)
            rl.draw_text('(c) Guy IQM 3D model by @culacant', screen_width - 200, screen_height - 20, 10, rl.gray)

        rl.end_drawing()
    }
}
