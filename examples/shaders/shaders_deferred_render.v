/*******************************************************************************************
*   raylib [shaders] example - deferred rendering
*   NOTE: This example requires raylib OpenGL 3.3 or OpenGL ES 3.0
*   Example originally created with raylib 4.5, last time updated with raylib 4.5
*   Example contributed by Justin Andreas Lacoste (@27justin) and reviewed by Ramon Santamaria (@raysan5)
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*   Copyright           (c) 2023 Justin Andreas Lacoste (@27justin)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
********************************************************************************************/

module main


import raylib as rl


const asset_path = @VMODROOT+'/thirdparty/raylib/examples/shaders/resources/'
const max_cubes  = 30


// FrameBuffer
type FrameBuffer = u32

fn FrameBuffer.new() !FrameBuffer {
    fb := rl.rl_load_framebuffer()
    if fb == 0 {
        return error('Failed to create GBuffer')
    }
    return fb
}

@[inline]
fn (fb FrameBuffer) enable() { rl.rl_enable_framebuffer(fb) }

@[inline]
fn FrameBuffer.disable() { rl.rl_disable_framebuffer() }

@[inline]
fn (fb FrameBuffer) attach(tex_id u32, attach_type int, tex_type int, mip_level int) {
    rl.rl_framebuffer_attach(fb, tex_id, attach_type, tex_type, mip_level)
}

fn (fb FrameBuffer) complete() ! {
    if !rl.rl_framebuffer_complete(fb) {
        return error('Framebuffer is not complete')
    }
}

@[inline]
fn (fb FrameBuffer) unload() { rl.rl_unload_framebuffer(fb) }


// GBuffer
@[noinit]
struct GBuffer {
mut:
    framebuffer         FrameBuffer
    position_texture    u32
    normal_texture      u32
    albedo_spec_texture u32
    depth_renderbuffer  u32
}

fn GBuffer.new(width int, height int) !GBuffer {
    mut gb:= GBuffer {}
    gb.framebuffer = FrameBuffer.new()!
    // Unload geometry buffer and all attached textures

    gb.framebuffer.enable()

    // Since we are storing position and normal data in these textures, 
    // we need to use a floating point format.
    gb.position_texture = rl.rl_load_texture(voidptr(0), width, height, rl.pixelformat_uncompressed_r32_g32_b32, 1)
    gb.normal_texture   = rl.rl_load_texture(voidptr(0), width, height, rl.pixelformat_uncompressed_r32_g32_b32, 1)
    // Albedo (diffuse color) and specular strength can be combined into one tex1.
    // The color in RGB, and the specular strength in the alpha channel.
    gb.albedo_spec_texture = rl.rl_load_texture(voidptr(0), width, height, rl.pixelformat_uncompressed_r8_g8_b8_a8, 1)

    // Activate the draw buffers for our framebuffer
    rl.rl_active_draw_buffers(3)

    // Now we attach our textures to the framebuffer.
    gb.framebuffer.attach(gb.position_texture,    rl.rl_attachment_color_channel0, rl.rl_attachment_texture_2d, 0)
    gb.framebuffer.attach(gb.normal_texture,      rl.rl_attachment_color_channel1, rl.rl_attachment_texture_2d, 0)
    gb.framebuffer.attach(gb.albedo_spec_texture, rl.rl_attachment_color_channel2, rl.rl_attachment_texture_2d, 0)

    // Finally we attach the depth buffer.
    gb.depth_renderbuffer = rl.rl_load_texture_depth(width, height, true)
    rl.rl_framebuffer_attach(gb.framebuffer, gb.depth_renderbuffer, rl.rl_attachment_depth, rl.rl_attachment_renderbuffer, 0)

    // Make sure our framebuffer is complete.
    // NOTE: rl.rl_framebuffer_complete() automatically unbinds the framebuffer, so we don't have
    // to rl.rl_disable_framebuffer() here. or FrameBuffer.disable()
    gb.framebuffer.complete()!

    return gb
}

fn (gb GBuffer) active_texture_slots() {
    // Activate our g-buffer textures
    // These will now be bound to the sampler2D uniforms `gPosition`, `gNormal`,
    // and `gAlbedoSpec
    rl.rl_active_texture_slot(0)
    rl.rl_enable_texture(gb.position_texture)
    rl.rl_active_texture_slot(1)
    rl.rl_enable_texture(gb.normal_texture)
    rl.rl_active_texture_slot(2)
    rl.rl_enable_texture(gb.albedo_spec_texture)
}

fn (gb GBuffer) bind(width int, height int) {
    // // As a last step, we now copy over the depth buffer from our g-buffer to the default framebuffer.
    rl.rl_bind_framebuffer(rl.rl_read_framebuffer, gb.framebuffer)
    rl.rl_bind_framebuffer(rl.rl_draw_framebuffer, 0)
    rl.rl_blit_framebuffer(0, 0, width, height, 0, 0, width, height, 0x00000100)    // GL_DEPTH_BUFFER_BIT
    // rl.rl_disable_framebuffer()
    FrameBuffer.disable()
 }

fn (gb GBuffer) unload() {
    // rl.rl_unload_framebuffer(gb.framebuffer)
    rl.rl_unload_texture(gb.position_texture)
    rl.rl_unload_texture(gb.normal_texture)
    rl.rl_unload_texture(gb.albedo_spec_texture)
    rl.rl_unload_texture(gb.depth_renderbuffer)
    gb.framebuffer.unload()
}


enum DeferredMode {
   position normal albedo shading
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    // -------------------------------------------------------------------------------------
    width  := 800
    height := 450

    rl.init_window(width, height, 'raylib [shaders] example - deferred active_texture_slots')
    defer { rl.close_window() }                     // Close window and OpenGL context

    mut camera := rl.Camera {
        position:   rl.Vector3{ 5.0, 4.0, 5.0 },
        target:     rl.Vector3{ y:1 },
        fovy:       60.0,
        projection: rl.camera_perspective
    }

    // Load plane model from a generated mesh
    mut model := rl.Model.load_from_mesh(rl.Mesh.gen_plane(10.0, 10.0, 3, 3))
    mut cube  := rl.Model.load_from_mesh(rl.Mesh.gen_cube(2.0, 2.0, 2.0))
    defer {
        model.unload()
        cube .unload()
    }

    tex1 := rl.Texture.load(asset_path+'texel_checker.png')
    tex2 := rl.Texture.load(asset_path+'cubicmap_atlas.png')
    defer {
        tex1.unload()
        tex2.unload()
    }

    // Load geometry buffer (G-buffer) shader and deferred shader
    gbuffer_shader := rl.Shader.load(
        (asset_path+'shaders/glsl330/gbuffer.vs').str,
        (asset_path+'shaders/glsl330/gbuffer.fs').str
    )!
    defer { gbuffer_shader.unload() }
    
    mut deferred_shader := rl.Shader.load(
        (asset_path+'shaders/glsl330/deferred_shading.vs').str,
        (asset_path+'shaders/glsl330/deferred_shading.fs').str
    )!
    defer { deferred_shader.unload() }
    
    // Initialize the G-buffer
    mut g_buffer := GBuffer.new(width, height)!
    defer { g_buffer.unload() }

    // Now we initialize the sampler2D uniform's in the deferred shader.
    // We do this by setting the uniform's value to the color channel slot we earlier
    // bound our textures to.
    // rl.rl_enable_shader(deferred_shader.id)
    deferred_shader.enable()
        deferred_shader.set_sampler('gPosition',   0)
        deferred_shader.set_sampler('gNormal',     1)
        deferred_shader.set_sampler('gAlbedoSpec', 2)
    deferred_shader.disable() // or rl.Shader.disable()

    // Assign out lighting shader to model
    model.set_texture(0, rl.material_map_albedo, tex1)
    model.set_shader(0, gbuffer_shader)
    cube.set_texture(0, rl.material_map_albedo, tex2)
    cube.set_shader(0, gbuffer_shader)
    
    deferred_shader.set_loc(rl.shader_loc_vector_view, 'viewPosition')

    // Create lights
    //--------------------------------------------------------------------------------------
    light_colors := [
        rl.yellow,
        rl.red,
        rl.green,
        rl.blue
    ]!

    light_positions := [
        rl.Vector3 {-2, 1.5, -2 },
        rl.Vector3 { 2, 1.5,  2 },
        rl.Vector3 {-2, 1.5,  2 },
        rl.Vector3 { 2, 1.5, -2 }
    ]!
    
    mut lights:= []rl.Light{cap: 4}
    for i in 0..lights.cap {
        lights << rl.Light.create(
            rl.light_point,  light_positions[i], rl.Vector3{},
            light_colors[i], deferred_shader,    i
        )
    }

    cube_scale := f32(0.25)
    mut cube_positions := []rl.Vector3 { len: max_cubes }
    mut cube_rotations := []f32        { len: max_cubes }
    
    for i in 0..max_cubes {
        cube_positions[i] = rl.Vector3 {
            rl.fmodf(rl.randnf(10), 10)-5
            rl.fmodf(rl.randnf(10), 10)
            rl.fmodf(rl.randnf(10), 10)-5
        }
        cube_rotations[i] = rl.randf()*360
    }

    mut mode := DeferredMode.shading

    rl.rl_enable_depth_test()

    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {
        // Update
        //----------------------------------------------------------------------------------
        camera.update(rl.camera_orbital)
        // rl.update_camera(&camera, rl.camera_orbital)
        // rl.update_camera(&camera, rl.camera_third_person)

        // Update the shader with the camera view vector (points towards { 0.0, 0.0, 0.0 })
        // camera_pos[3] = [ camera.position.x, camera.position.y, camera.position.z ]!
        deferred_shader.set_value(
            unsafe { deferred_shader.locs[rl.shader_loc_vector_view] }, // or deferred_shader.get_loc_index(rl.shader_loc_vector_view),
            &camera.position,
            rl.shader_uniform_vec3
        )
        
        // Check key inputs to enable/disable lights
        if rl.is_key_pressed(rl.key_y) { lights[0].enabled = !lights[0].enabled }
        if rl.is_key_pressed(rl.key_r) { lights[1].enabled = !lights[1].enabled }
        if rl.is_key_pressed(rl.key_g) { lights[2].enabled = !lights[2].enabled }
        if rl.is_key_pressed(rl.key_b) { lights[3].enabled = !lights[3].enabled }

        // Check key inputs to switch between G-buffer textures
        if rl.is_key_pressed(rl.key_one)   { mode = .position }
        if rl.is_key_pressed(rl.key_two)   { mode = .normal   }
        if rl.is_key_pressed(rl.key_three) { mode = .albedo   }
        if rl.is_key_pressed(rl.key_four)  { mode = .shading  }

        // Update light values (actually, only enable/disable them)
        for mut light in lights { light.update_values(deferred_shader) }
        //----------------------------------------------------------------------------------

        // Draw
        // ---------------------------------------------------------------------------------
        rl.begin_drawing()
        
            rl.clear_background(rl.raywhite)
        
            // Draw to the geometry buffer by first activating it
            rl.rl_enable_framebuffer(g_buffer.framebuffer)
            rl.rl_clear_screen_buffers()  // Clear color and depth buffer
            
            rl.rl_disable_color_blend()
            rl.begin_mode_3d(camera)
                // NOTE: We have to use rl.rl_enable_shader here. `BeginShaderMode` or thus `rlSetShader`
                // will not work, as they won't immediately load the shader program.
                gbuffer_shader.enable()
                    // When drawing a model here, make sure that the material's shaders
                    // are set to the gbuffer shader!
                    model.draw(rl.Vector3{}, 1.0, rl.white)
                    cube.draw(rl.Vector3{y:1}, 1.0, rl.white)

                    for i in 0..max_cubes {
                        cube.draw_ex(
                            cube_positions[i],
                            rl.Vector3 { 1, 1, 1 },
                            cube_rotations[i],
                            rl.Vector3 { cube_scale, cube_scale, cube_scale },
                            rl.white
                        )
                    }

                // rl.rl_disable_shader()
                rl.Shader.disable()
            rl.end_mode_3d()
            rl.rl_enable_color_blend()

            // Go back to the default framebuffer (0) and draw our deferred shading.
            rl.rl_disable_framebuffer()
            rl.rl_clear_screen_buffers() // Clear color & depth buffer

            match mode {
                .shading {
                    rl.begin_mode_3d(camera)
                        rl.rl_disable_color_blend()
                            rl.rl_enable_shader(deferred_shader.id)
                                g_buffer.active_texture_slots()
                                rl.rl_load_draw_quad()
                            rl.rl_disable_shader()
                        rl.rl_enable_color_blend()
                    rl.end_mode_3d()

                    g_buffer.bind(width, height)
                    // Since our shader is now done and disabled, we can draw our lights in default;
                    // forward rendering
                    rl.begin_mode_3d(camera)
                        rl.rl_enable_shader(rl.rl_get_shader_id_default())
                        for light in lights {
                            if light.enabled {
                                // rl.draw_sphere(light.position, 0.2, light.color)
                                rl.draw_sphere(light.position, 0.2, light.color)
                            } else {
                                rl.draw_sphere_wires(light.position, 0.2, 8, 8, rl.Color.alpha(light.color, 0.3))
                                rl.draw_sphere_wires(light.position, 0.2, 8, 8, rl.Color.alpha(light.color, 0.3))
                            }
                        }
                        rl.rl_disable_shader()
                    rl.end_mode_3d()

                    $if debug ? {
                        for light in lights {
                            center := rl.get_world_to_screen(light.position, camera)
                            rl.draw_circle_v(center, if light.enabled {4} else {2}, light.color)
                        }
                    }
                    
                    rl.draw_text('FINAL RESULT', 10, height - 30, 20, rl.darkgreen)
                }
                
                .position {
                    rl.draw_texture_rec(
                        rl.Texture {
                            id:      g_buffer.position_texture,
                            width:   width,
                            height:  height,
                    }, rl.Rectangle  { 0, 0, width, -height }, rl.Vector2{}, rl.raywhite)
                    rl.draw_text('POSITION TEXTURE', 10, height - 30, 20, rl.darkgreen)
                }
                
                .normal {
                    rl.draw_texture_rec(
                        rl.Texture {
                            id:      g_buffer.normal_texture,
                            width:   width,
                            height:  height,
                        },
                        rl.Rectangle {
                            0, 0, width, -height
                        },
                        rl.Vector2{},
                        rl.raywhite
                    )
                    rl.draw_text('NORMAL TEXTURE', 10, height - 30, 20, rl.darkgreen)
                }

                .albedo {
                    rl.draw_texture_rec(
                        rl.Texture {
                            id:      g_buffer.albedo_spec_texture,
                            width:   width,
                            height:  height,
                        },
                        rl.Rectangle  {
                            0, 0,
                            width, -height
                        },
                        rl.Vector2{},
                        rl.raywhite
                    )
                    rl.draw_text('ALBEDO TEXTURE', 10, height - 30, 20, rl.darkgreen)
                }
            }

            text_pos              := rl.Vector2{10, 40}
            text_size             := int(20)
            light_text            := 'Toggle lights keys: '
            light_text_width      := rl.measure_text(light_text.str, text_size)
            light_text_char_width := rl.measure_text('[W]'.str, text_size)

            rl.draw_text(light_text, int(text_pos.x), int(text_pos.y), text_size, rl.darkgray)

            yellow_color := if lights[0].enabled { rl.yellow } else { rl.darkgray }
            red_color    := if lights[1].enabled { rl.red    } else { rl.darkgray }
            green_color  := if lights[2].enabled { rl.green  } else { rl.darkgray }
            blue_color   := if lights[3].enabled { rl.blue   } else { rl.darkgray }

            char_pos_x := int(text_pos.x)+light_text_width
        
            rl.draw_rectangle(
                char_pos_x-3,
                int(text_pos.y)-3,
                light_text_char_width*4+3,
                text_size+3,
                rl.black
            )
        
            rl.draw_text('[Y]', char_pos_x+(light_text_char_width*0), int(text_pos.y), text_size, yellow_color)
            rl.draw_text('[R]', char_pos_x+(light_text_char_width*1), int(text_pos.y), text_size, red_color)
            rl.draw_text('[G]', char_pos_x+(light_text_char_width*2), int(text_pos.y), text_size, green_color)
            rl.draw_text('[B]', char_pos_x+(light_text_char_width*3), int(text_pos.y), text_size, blue_color)

            gb_txt := 'Switch G-buffer textures:  '
            gb_txt_len := rl.measure_text(gb_txt.str, text_size)
            rl.draw_text(gb_txt, int(text_pos.x), 70, text_size, rl.darkgray)

            rl.draw_rectangle(
                gb_txt_len-3,
                70-3,
                light_text_char_width*4+3,
                text_size+3,
                rl.black
            )

            rl.draw_text('[1]', gb_txt_len+(light_text_char_width*0), 70, text_size, if mode == .position { rl.red } else { rl.gray })
            rl.draw_text('[2]', gb_txt_len+(light_text_char_width*1), 70, text_size, if mode == .normal   { rl.red } else { rl.gray })
            rl.draw_text('[3]', gb_txt_len+(light_text_char_width*2), 70, text_size, if mode == .albedo   { rl.red } else { rl.gray })
            rl.draw_text('[4]', gb_txt_len+(light_text_char_width*3), 70, text_size, if mode == .shading  { rl.red } else { rl.gray })

            rl.draw_fps(10, 10)
            
        rl.end_drawing()
    }
}
