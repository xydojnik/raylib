/*******************************************************************************************
*
*   raylib [shaders] example - Shadowmap
*
*   Example originally created with raylib 5.0, last time updated with raylib 5.0
*
*   Example contributed by @TheManTheMythTheGameDev and reviewed by Ramon Santamaria (@raysan5)
*
*   Translated&Modified (c) 2025 Fedorov Alexandr (@xydojnik)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
********************************************************************************************/

import raylib as rl


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint)
    // Shadows are a HUGE topic, and this example shows an extremely simple implementation of the shadowmapping algorithm,
    // which is the industry standard for shadows. This algorithm can be extended in a ridiculous number of ways to improve
    // realism and also adapt it for different scenes. This is pretty much the simplest possible implementation.
    rl.init_window(screen_width, screen_height, 'raylib [shaders] example - shadowmap')
    defer { rl.close_window() }      // Close window and OpenGL context

    // rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    camera := rl.Camera {
        position:    rl.Vector3 { 10.0, 10.0, 10.0 },
        target:      rl.Vector3{},
        projection:  rl.camera_perspective,
        up:          rl.Vector3 { y:1.0 },
        fovy:        45.0
    }

    mut shadow_shader := rl.Shader.load(
        c'resources/shaders/glsl330/shadowmap.vs',
        c'resources/shaders/glsl330/shadowmap.fs'
    )!
    defer { shadow_shader.unload() }
    
    shadow_shader.set_loc(rl.shader_loc_vector_view, 'viewPos')
    
    mut light_dir := rl.Vector3{ 0.35, -1.0, -0.35 }
    light_dir_max_offset := f32(0.6)
    
    light_dir_loc := shadow_shader.get_loc('lightDir')
    light_col_loc := shadow_shader.get_loc('lightColor')
    shadow_shader.set_value(light_dir_loc, &light_dir, rl.shader_uniform_vec3)
    shadow_shader.set_value(light_col_loc, [f32(1), 1, 1, 1].data, rl.shader_uniform_vec4)
    
    ambient_loc := shadow_shader.get_loc('ambient')
    shadow_shader.set_value(ambient_loc, [f32(0.1), 0.1, 0.1, 1.0].data, rl.shader_uniform_vec4)
    
    light_vp_loc         := shadow_shader.get_loc('lightVP')
    shadow_map_loc       := shadow_shader.get_loc('shadowMap')
    shadowmap_resolution := int(1024)

    shadow_shader.set_value(shadow_shader.get_loc('shadowMapResolution'), &shadowmap_resolution, rl.shader_uniform_int)

    mut cube := rl.Model.load_from_mesh(rl.Mesh.gen_cube(1.0, 1.0, 1.0))
    defer { cube.unload() }
    cube.set_shader(0, shadow_shader)
    
    mut robot := rl.Model.load('resources/models/robot.glb')
    defer { robot.unload() }
    for i in 0..robot.materialCount {
        robot.set_shader(i, shadow_shader)
    }

    robot_animations := rl.ModelAnimation.load('resources/models/robot.glb')
    defer { robot_animations.unload() }

    shadow_map := load_shadowmap_render_texture(shadowmap_resolution, shadowmap_resolution)
    defer { shadow_map.unload() }
    {
        slot:= int(10)     // Can be anything 0 to 15, but 0 will probably be taken up
        shadow_shader.enable()
        shadow_map.depth.set_slot(slot)
        shadow_shader.set_value_1i(shadow_map_loc, slot)
    }
    
    // For the shadowmapping algorithm, we will be rendering everything from the light's point of view
    mut light_cam := rl.Camera {
        position:    rl.Vector3.scale(light_dir, -15.0),
        target:      rl.Vector3{},
        // Use an orthographic projection for directional lights
        projection:  rl.camera_orthographic
        up:          rl.Vector3 { 0.0, 1.0, 0.0 },
        fovy:        20.0
    }

    mut animation  := int(0)
    mut anim_frame := f32(0)
    mut anim_name  := 'Anim( ${animation} ): ${robot_animations[animation].get_name()}'
    anim_speed     := int(60)

    camera_speed := 0.05 * 60.0
    
    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        dt := f32(rl.get_frame_time())

        unsafe {
            shadow_shader.set_value(
                shadow_shader.locs[rl.shader_loc_vector_view],
                &camera.position, rl.shader_uniform_vec3
            )
        }

        rl.update_camera(&camera, rl.camera_orbital)

        {// ANIMATION
            anim_frame+=anim_speed * dt
            if int(anim_frame) >= robot_animations[animation].frameCount {
                animation++
                animation  %= robot_animations.len
                anim_frame  = 0
                anim_name   = 'Anim( ${animation} ): ${robot_animations[animation].get_name()}'
            }
            robot_animations[animation].update(robot, int(anim_frame))
        }

        if rl.is_key_down(rl.key_left) {
            light_dir.x += f32(camera_speed * dt)
        } else if rl.is_key_down(rl.key_right) {
            light_dir.x -= f32(camera_speed * dt)
        }
        
        if rl.is_key_down(rl.key_up) {
            light_dir.z += f32(camera_speed * dt)
        } else if rl.is_key_down(rl.key_down) {
            light_dir.z -= f32(camera_speed * dt)
        }

        light_dir = rl.Vector3.clamp(
            light_dir,
            rl.Vector3{ -light_dir_max_offset, light_dir.y, -light_dir_max_offset },
            rl.Vector3{  light_dir_max_offset, light_dir.y,  light_dir_max_offset }
        )
        
        light_dir          = rl.Vector3.normalize(light_dir)
        light_cam.position = rl.Vector3.scale(light_dir, -15.0)
        shadow_shader.set_value(light_dir_loc, &light_dir, rl.shader_uniform_vec3)

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

        // First, render all objects into the shadowmap
        // The idea is, we record all the objects' depths (as rendered from the light source's point of view) in a buffer
        // Anything that is 'visible' to the light is in light, anything that isn't is in shadow
        // We can later use the depth buffer when rendering everything from the player's point of view
        // to determine whether a given point is 'visible' to the light

        // Record the light matrices for future use!
        shadow_map.begin()
            rl.clear_background(rl.white)
            rl.begin_mode_3d(light_cam)
                light_view := rl.rl_get_matrix_modelview()
                light_proj := rl.rl_get_matrix_projection()
                draw_scene(cube, robot)
            rl.end_mode_3d()
            rl.end_texture_mode()
        shadow_map.end()

        light_view_proj := rl.Matrix.multiply(light_view, light_proj)
        shadow_shader.set_value_matrix(light_vp_loc, light_view_proj)

        rl.clear_background(rl.gray)
        rl.begin_mode_3d(camera)
        {
            // Draw the same exact things as we drew in the shadowmap!
            draw_scene(cube, robot)
        }
        rl.end_mode_3d()

        {
            x_offset := int(5)
            y_offset := int(45)
            img_size := int(150)
            shadow_map.texture.draw_pro(
                rl.Rectangle{ 0, 0, shadow_map.texture.width, -shadow_map.texture.height },
                rl.Rectangle{ x_offset, y_offset, img_size, img_size },
                rl.Vector2{}, 0, rl.white
            )
            shadow_map.depth.draw_pro(
                rl.Rectangle{ 0, 0, shadow_map.depth.width, -shadow_map.depth.height },
                rl.Rectangle{ x_offset, img_size+y_offset, img_size, img_size },
                rl.Vector2{}, 0, rl.white
            )
        }

        rl.draw_text('Shadows in raylib using the shadowmapping algorithm!', screen_width-320, screen_height-20, 10, rl.gray)
        rl.draw_text('Use the arrow keys to rotate the light!', 10, 10, 30, rl.red)
        rl.draw_text(anim_name, 10, screen_height-25, 20, rl.black)
        rl.draw_fps(screen_width-100, 10)

        rl.end_drawing()

        if rl.is_key_pressed(rl.key_f) {
            rl.take_screenshot('shaders_shadowmap.png')
        }
    }
}

fn load_shadowmap_render_texture(width int, height int) rl.RenderTexture {
    mut target := rl.RenderTexture.load(width, height)

    if target.id > 0 {
        rl.rl_enable_framebuffer(target.id)

        // // Create depth texture
        // // We don't need a color texture for the shadowmap
        target.depth.id      = rl.rl_load_texture_depth(width, height, false)
        target.depth.width   = width
        target.depth.height  = height
        target.depth.format  = 19       //DEPTH_COMPONENT_24BIT?
        target.depth.mipmaps = 1

        // // Attach depth texture to FBO
        rl.rl_framebuffer_attach(target.id, target.depth.id, rl.rl_attachment_depth, rl.rl_attachment_texture_2d, 0)

        // // Check if fbo is complete with attachments (valid)
        if rl.rl_framebuffer_complete(target.id) {
            println('FBO: [ID ${target.id}] Framebuffer object created successfully')
        }

        rl.rl_disable_framebuffer()
    } else {
        println('FBO: Framebuffer object can not be created')
    }

    return target
}

fn draw_scene(cube rl.Model, robot rl.Model) {
    rl.draw_model_ex(cube,  rl.Vector3{},               rl.Vector3{y:1.0}, 0, rl.Vector3{10.0, 1.0, 10.0 }, rl.blue)
    rl.draw_model_ex(cube,  rl.Vector3{1.5, 1.0, -1.5}, rl.Vector3{y:1.0}, 0, rl.Vector3{1,1,1},            rl.white)
    rl.draw_model_ex(robot, rl.Vector3{y:0.5},          rl.Vector3{y:1.0}, 0, rl.Vector3{1.0, 1.0, 1.0},    rl.red)
}
