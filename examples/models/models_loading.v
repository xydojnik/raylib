/*******************************************************************************************
*
*   raylib [models] example - Models loading
*
*   NOTE: raylib supports multiple models file formats:
*
*     - OBJ  > Text file format. Must include vertex position-texcoords-normals information,
*              if files references some .mtl materials file, it will be loaded (or try to).
*     - GLTF > Text/binary file format. Includes lot of information and it could
*              also reference external files, raylib will try loading mesh and materials data.
*     - IQM  > Binary file format. Includes mesh vertex data but also animation data,
*              raylib can load .iqm animations.
*     - VOX  > Binary file format. MagikaVoxel mesh format:
*              https://github.com/ephtracy/voxel-model/blob/master/MagicaVoxel-file-format-vox.txt
*     - M3D  > Binary file format. Model 3D format:
*              https://bztsrc.gitlab.io/model3d
*
*   Example originally created with raylib 2.0, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const asset_path = @VMODROOT+'/thirdparty/raylib/examples/models/resources/'


// TODO: Move camera position from target enough distance to visualize model properly | Done...?
fn calculate_debug_sphere(bbox rl.BoundingBox) (rl.Vector3, f32) {
    bbox_center := rl.Vector3.scale(rl.Vector3.add(bbox.max, bbox.min), 0.5)
    bbox_radius := rl.Vector3.distance(bbox_center, bbox.max)
    return bbox_center, bbox_radius
}


fn calculate_camera_velocity(camera rl.Camera, bbox_center rl.Vector3, camera_offset f32) rl.Vector3 {
    distance := rl.Vector3.distance(bbox_center, camera.position)
    dif      := distance-camera_offset
    forward  := rl.Vector3.scale(camera.get_forward(), dif)

    mut camera_velocity := rl.Vector3.add(camera.position, forward)
    camera_velocity.y = bbox_center.y * 1.5

    return camera_velocity
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [models] example - models loading')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }             // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // rl.disable_cursor()   // Limit cursor to relative movement inside the window
    rl.set_target_fps(60) // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 50.0, 50.0, 50.0 } // Camera position
        target:      rl.Vector3 {  0.0, 10.0,  0.0 } // Camera looking at point
        up:          rl.Vector3 {  0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                            // Camera field-of-view Y
        projection:  rl.camera_perspective           // Camera mode type
    }
    camera_offset := int(3)

    model_file_path   := asset_path+'models/obj/castle.obj'
    texture_file_path := asset_path+'models/obj/castle_diffuse.png'
    
    mut selected_model_name   := rl.get_file_name(model_file_path)
    mut selected_texture_name := rl.get_file_name(texture_file_path)
    
    mut model   := rl.load_model(model_file_path)          // Load model
    mut texture := rl.load_texture(texture_file_path)      // Load model texture

    model.set_texture(0, rl.material_map_diffuse, texture) // Set map diffuse texture
    mut rotate_around_target := false

    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer {
        rl.unload_texture(texture)  // Unload texture
        rl.unload_model(model)      // Unload model
    }
    //--------------------------------------------------------------------------------------
    position := rl.Vector3 {}       // Set model position

    // NOTE: bounds are calculated from the original size of the model,
    // if model is scaled on drawing, bounds must be also scaled
    mut bounds                           := rl.get_model_bounding_box(model) // Set model bounds
    mut sphere_center, mut sphere_radius := calculate_debug_sphere(bounds)
    mut camera_velocity                  := calculate_camera_velocity(camera, sphere_center, sphere_radius*camera_offset)
    camera.target = sphere_center
    mut selected := false // Selected object flag

    mut show_uv     := false
    mut half_screen := true

    move_speed := f32(0.1)
    mut lerp_value := f32(0)
    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        if rotate_around_target {
            if rl.is_mouse_button_down(rl.mouse_button_left) {
                rl.update_camera(&camera, rl.camera_third_person)
            } else {
                rl.update_camera(&camera, rl.camera_orbital)
            }
        } else {
            if !rl.Vector3.equals(camera.position, camera_velocity) {
                lerp_value += f32(rl.get_frame_time()) * move_speed
                camera.position = rl.Vector3.lerp(camera.position, camera_velocity, lerp_value)
            } else {
                lerp_value           = 0
                rotate_around_target = true
            }
        }

        if rl.is_key_pressed(rl.key_space) { show_uv     = !show_uv     }
        if rl.is_key_pressed(rl.key_one)   { half_screen = !half_screen }
        
        // Load new models/textures on drag&drop
        if rl.is_file_dropped() {
            dropped_files  := rl.load_dropped_files()
            file_path      := unsafe { dropped_files.paths[0].vstring() }
            file_extention := rl.get_file_extension(file_path)
            if dropped_files.count == 1 {            // Only support one file dropped
                if file_extention in ['.obj', '.gltf', '.glb', '.vox', '.iqm', '.m3d'] {
                    rl.unload_model(model)           // Unload previous model

                    model = rl.load_model(file_path) // Load new model
                    model.set_texture(0, rl.material_map_diffuse, texture)  // Set current map diffuse texture
                    bounds = rl.get_model_bounding_box(model)

                    selected_model_name = rl.get_file_name(file_path)
                    // TODO: Move camera position from target enough distance to visualize model properly
                    // Hope its done.
                    sphere_center, sphere_radius = calculate_debug_sphere(bounds)
                    camera_velocity              = calculate_camera_velocity(camera, sphere_center, sphere_radius*camera_offset)
                    camera.target                = sphere_center
                    rotate_around_target         = false
                } else if file_extention in ['.png'] { // Texture file formats supported
                    // Unload current model texture and load new one
                    rl.unload_texture(texture)

                    selected_texture_name = rl.get_file_name(file_path)
                    texture               = rl.load_texture(file_path)
                    model.set_texture(0, rl.material_map_diffuse, texture)
                }
            }
            rl.unload_dropped_files(dropped_files)       // Unload filepaths from memory
        }
        
        // Select model on mouse click
        if rl.is_mouse_button_pressed(rl.mouse_button_left) {
            // Check collision between ray and box
            selected = if rl.get_ray_collision_box(rl.get_mouse_ray(rl.get_mouse_position(), camera), bounds).hit {
                !selected
            } else {
                false
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.gray)

            rl.begin_mode_3d(rl.Camera3D(camera))
                rl.draw_model(model, position, 1.0, rl.white) // Draw 3d model with texture
                rl.draw_grid(20, 10.0)                        // Draw a grid

                if selected {
                    rl.draw_bounding_box(bounds, rl.green)    // Draw selection box
                    rl.draw_sphere_wires(sphere_center, sphere_radius, 10, 10, rl.yellow)
                }
            rl.end_mode_3d()

            rl.draw_text('Drag & drop model to load mesh/texture.', 10, rl.get_screen_height() - 20, 10, rl.raywhite)
        
            if selected {
                center_screen_pos := rl.get_world_to_screen(sphere_center, camera)
                origin_screen_pos := rl.get_world_to_screen(position, camera)

                rl.draw_circle_v(center_screen_pos, 2, rl.yellow)
                rl.draw_circle_v(origin_screen_pos, 2, rl.yellow)

                rl.draw_text_v('center', rl.Vector2.subtract(center_screen_pos, rl.Vector2{ 15, 15 }), 13, rl.yellow)
                rl.draw_text_v('origin', rl.Vector2.subtract(origin_screen_pos, rl.Vector2{ 15, 15 }), 13, rl.yellow)

                rl.draw_text('TEXTURE: [ ${selected_texture_name} ]', 10, 10, 25, rl.black)
                
                padding := int(40)
                texture_rec   := if half_screen {
                    rl.Rectangle{ 10, padding, texture.width/10, texture.height/10 }
                } else {
                    asspect_ratio := f32(texture.width)/f32(texture.height)
                    h := screen_height-padding*2
                    w := h*asspect_ratio
                    x := screen_width/2-w/2
                    rl.Rectangle{ x, padding, w, h }
                }
                rl.draw_texture_pro(
                    texture,
                    rl.Rectangle{ 0, 0,texture.width, texture.height }, texture_rec,
                    rl.Vector2{}, 0.0, rl.white
                )

                if half_screen {
                    txt       := ' press 1 '
                    txt_size  := 15
                    txt_width := rl.measure_text(txt.str, txt_size)
                    rl.draw_rectangle(
                        int(texture_rec.x+20),
                        int(texture_rec.y+texture_rec.height+3),
                        txt_width, txt_size+4, rl.black.fade(0.5))
                    rl.draw_text(
                        'press 1',
                        int(texture_rec.x+25),
                        int(texture_rec.y+texture_rec.height+5),
                        txt_size, rl.green)
                }
                
                if show_uv { model.draw_uv(0, 0, true, texture_rec, 1.0, rl.white) }
                txt       := if show_uv { 'Press SPACE:  Hide Model UV' } else {'Press SPACE: Show Model UV'}
                font_size := 20
                txt_width := rl.measure_text(txt.str, font_size)
                txt_rec   := rl.Vector2{ screen_width/2-txt_width/2, screen_height-int(f32(font_size)*1.5) }

                rl.draw_rectangle(int(txt_rec.x)-font_size/2, int(txt_rec.y), txt_width+font_size, font_size, rl.black.fade(0.7))
                rl.draw_text(txt, int(txt_rec.x), int(txt_rec.y), font_size, if show_uv { rl.red } else { rl.green })
                rl.draw_rectangle_lines_ex(texture_rec, 1, rl.red)
            } else {
                rl.draw_text('MODEL: [ ${selected_model_name} ]', 10, 10, 25, rl.black)
            }

            if selected_model_name == 'castle.obj' {
                rl.draw_text('(c) Castle 3D model by Alberto Cano', screen_width - 200, screen_height - 20, 10, rl.black)
            }
        
            rl.draw_fps(screen_width-80, 10)
        rl.end_drawing()
    }
}
