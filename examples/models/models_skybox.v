/*******************************************************************************************
*
*   raylib [models] example - Skybox loading and drawing
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const asset_path = @VMODROOT+'/thirdparty/raylib/examples/models/resources/'
const glsl_version = 330


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [models] example - skybox loading and drawing')
    defer { rl.close_window() } // Close window and OpenGL context

    // Define the camera to look into our 3d world
    camera := rl.Camera {
        position:   rl.Vector3 { 1.0, 1.0, 1.0 } // Camera position
        target:     rl.Vector3 { 4.0, 1.0, 4.0 } // Camera looking at point
        up:         rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:       45.0                         // Camera field-of-view Y
        projection: rl.camera_perspective        // Camera projection type
    }

    // Load skybox model
    cube := rl.Mesh.gen_cube(1.0, 1.0, 1.0)
    mut skybox := rl.Model.load_from_mesh(cube)
    defer { skybox.unload() }        // Unload skybox model

    mut use_hdr   := false
    mut do_gammma := false
    
    shader := rl.Shader.load(
        (asset_path+'shaders/glsl${glsl_version}/skybox.vs').str,
        (asset_path+'shaders/glsl${glsl_version}/skybox.fs').str
    )!
    skybox.set_shader(0, shader)

    shader.set_value_1i(shader.get_loc('environmentMap'), rl.material_map_cubemap)
    shader.set_value_1i(shader.get_loc('doGamma'),        int(do_gammma))
    shader.set_value_1i(shader.get_loc('vflipped'),       int(use_hdr))
    
    // // Load cubemap shader and setup required shader locations
    shdr_cubemap := rl.load_shader(
        (asset_path+'shaders/glsl${glsl_version}/cubemap.vs').str,
        (asset_path+'shaders/glsl${glsl_version}/cubemap.fs').str
    )
    rl.set_shader_value1i(shdr_cubemap, rl.get_shader_location(shdr_cubemap, 'equirectangularMap'),  0)
    
    mut skybox_file_name := ''
    
    if use_hdr {
        skybox_file_name = asset_path+'dresden_square_2k.hdr' // it did'nt work

        // Load HDR panorama (sphere) texture
        panorama := rl.Texture.load(skybox_file_name)
        // defer { rl.unload_texture(panorama) }        // Texture not required anymore, cubemap already generated

        // Generate cubemap (texture with 6 quads-cube-mapping) from panorama HDR texture
        // NOTE 1: New texture is generated rendering to texture, shader calculates the sphere->cube coordinates mapping
        // NOTE 2: It seems on some Android devices WebGL, fbo does not properly support a FLOAT-based attachment,
        // despite texture can be successfully created.. so using rl.pixelformat_uncompressed_r8g8b8a8 instead of PIXELFORMAT_UNCOMPRESSED_R32G32B32A32
        texture := rl.Texture(
            // gen_texture_cubemap(shdr_cubemap, panorama, 1024, rl.pixelformat_uncompressed_r8g8b8a8)
            gen_texture_cubemap(shdr_cubemap, panorama, 1024, rl.rl_pixelformat_uncompressed_r8g8b8)
        )
        skybox.set_texture(0, rl.material_map_cubemap, rl.Texture(texture))

        rl.unload_texture(panorama)
    } else {
        skybox_file_name = asset_path+'skybox.png'
        img := rl.load_image(skybox_file_name)
        skybox.set_texture(0, rl.material_map_cubemap, rl.Texture(rl.load_texture_cubemap(img, rl.cubemap_layout_auto_detect)))    // CUBEMAP_LAYOUT_PANORAMA
        img.unload()
    }

    rl.disable_cursor()             // Limit cursor to relative movement inside the window
    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

                                    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_first_person)

        // Load new cubemap texture on drag&drop
        if rl.is_file_dropped() {
            dropped_files := rl.load_dropped_files()

            if dropped_files.count == 1 {   // Only support one file dropped
                unsafe {
                    if rl.is_file_extension(dropped_files.paths[0].vstring(), '.png.jpg.hdr.bmp.tga') {
                        // Unload current cubemap texture to load new one
                        skybox.materials[0].maps[rl.material_map_cubemap].texture.unload()

                        if use_hdr {
                            // Load HDR panorama (sphere) texture
                            panorama := rl.load_texture(dropped_files.paths[0].vstring())

                            // Generate cubemap from panorama texture
                            skybox.materials[0].maps[rl.material_map_cubemap].texture = rl.Texture(gen_texture_cubemap(shdr_cubemap, panorama, 1024, rl.rl_pixelformat_uncompressed_r8g8b8a8))

                            panorama.unload()    // Texture not required anymore, cubemap already generated
                        } else {
                            img := rl.Image.load(dropped_files.paths[0].vstring())
                            // skybox.materials[0].maps[rl.material_map_cubemap].texture = rl.Texture2D(rl.load_texture_cubemap(img, rl.cubemap_layout_auto_detect))
                            skybox.set_texture(0, rl.material_map_cubemap, rl.Texture(rl.load_texture_cubemap(img, rl.cubemap_layout_auto_detect)))
                            img.unload()
                        }
                        // TextCopy(skybox_file_name, dropped_files.paths[0])
                        skybox_file_name = cstring_to_vstring(dropped_files.paths[0])
                    }
                }
            }

            rl.unload_dropped_files(dropped_files)    // Unload filepaths from memory
        }
        
        if rl.is_key_pressed(rl.key_space) {
            do_gammma = !do_gammma
            rl.set_shader_value1i(shader, rl.get_shader_location(shader, 'doGamma'), int(do_gammma))
        }

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)
            rl.begin_mode_3d(camera)

                // We are inside the cube, we need to disable backface culling!
                rl.rl_disable_backface_culling()
                rl.rl_disable_depth_mask()

                rl.draw_model(skybox, rl.Vector3 {0, 0, 0}, 1.0, rl.white)
        
                rl.rl_enable_backface_culling()
                rl.rl_enable_depth_mask()

                rl.draw_grid(10, 1.0)

            rl.end_mode_3d()
            

            if use_hdr {
                rl.draw_text(
                    'Panorama image from hdrihaven.com: ${rl.get_file_name(skybox_file_name)}', 10, rl.get_screen_height() - 25, 20, rl.black)
            } else {
                rl.draw_text('Image: ${rl.get_file_name(skybox_file_name)}', 10, rl.get_screen_height()-25, 20, rl.black)
            }

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}

// Generate cubemap (6 faces) from equirectangular (panorama) texture
// Generate cubemap texture from HDR texture
fn gen_texture_cubemap(shader rl.Shader, panorama rl.Texture2D, size int, format int) rl.TextureCubemap {
    mut cubemap := rl.TextureCubemap {}

    rl.rl_disable_backface_culling()     // Disable backface culling to render inside the cube

    // STEP 1: Setup framebuffer
    //------------------------------------------------------------------------------------------
    rbo := rl.rl_load_texture_depth(size, size, true)
    
    // gen_texture_cubemap(shdr_cubemap, panorama, 1024, rl.pixelformat_uncompressed_r8g8b8a8)
    cubemap.id = rl.rl_load_texture_cubemap(voidptr(0), size, format, 1)

    fbo := rl.rl_load_framebuffer()
    rl.rl_framebuffer_attach(fbo, rbo, rl.rl_attachment_depth, rl.rl_attachment_renderbuffer, 0)
    rl.rl_framebuffer_attach(fbo, cubemap.id, rl.rl_attachment_color_channel0, rl.rl_attachment_cubemap_positive_x, 0)

    // Check if framebuffer is complete with attachments (valid)
    if rl.rl_framebuffer_complete(fbo) {
        // TraceLog(LOG_INFO, 'FBO: [ID %i] Framebuffer object created successfully', fbo)
        println('INFO: FBO: [ID ${fbo}] Framebuffer object created successfully')
    }
    //------------------------------------------------------------------------------------------

    // STEP 2: Draw to framebuffer
    //------------------------------------------------------------------------------------------
    // NOTE: rl.Shader is used to convert HDR equirectangular environment map to cubemap equivalent (6 faces)
    rl.rl_enable_shader(shader.id)

    // Define projection matrix and send it to shader
    mat_fbo_projection := rl.Matrix.perspective(rl.deg2rad(90.0), 1.0, rl.rl_cull_distance_near, rl.rl_cull_distance_far)
    unsafe {
        rl.rl_set_uniform_matrix(shader.locs[rl.shader_loc_matrix_projection], mat_fbo_projection)
    }

    // Define view matrix for every side of the cubemap
    fbo_views := [
        rl.Matrix.look_at(rl.Vector3 { 0.0, 0.0, 0.0 }, rl.Vector3 {  1.0,  0.0,  0.0 }, rl.Vector3 { 0.0, -1.0,  0.0 }),
        rl.Matrix.look_at(rl.Vector3 { 0.0, 0.0, 0.0 }, rl.Vector3 { -1.0,  0.0,  0.0 }, rl.Vector3 { 0.0, -1.0,  0.0 }),
        rl.Matrix.look_at(rl.Vector3 { 0.0, 0.0, 0.0 }, rl.Vector3 {  0.0,  1.0,  0.0 }, rl.Vector3 { 0.0,  0.0,  1.0 }),
        rl.Matrix.look_at(rl.Vector3 { 0.0, 0.0, 0.0 }, rl.Vector3 {  0.0, -1.0,  0.0 }, rl.Vector3 { 0.0,  0.0, -1.0 }),
        rl.Matrix.look_at(rl.Vector3 { 0.0, 0.0, 0.0 }, rl.Vector3 {  0.0,  0.0,  1.0 }, rl.Vector3 { 0.0, -1.0,  0.0 }),
        rl.Matrix.look_at(rl.Vector3 { 0.0, 0.0, 0.0 }, rl.Vector3 {  0.0,  0.0, -1.0 }, rl.Vector3 { 0.0, -1.0,  0.0 })
    ]!

    rl.rl_viewport(0, 0, size, size)   // Set viewport to current fbo dimensions
    
    // Activate and enable texture for drawing to cubemap faces
    rl.rl_active_texture_slot(0)
    rl.rl_enable_texture(panorama.id)

    for i in 0..fbo_views.len {
        // Set the view matrix for the current cube face
        unsafe {
            rl.rl_set_uniform_matrix(shader.locs[rl.shader_loc_matrix_view], fbo_views[i])
        }
        
        // Select the current cubemap face attachment for the fbo
        // WARNING: This function by default enables->attach->disables fbo!!!
        rl.rl_framebuffer_attach(fbo, cubemap.id, rl.rl_attachment_color_channel0, rl.rl_attachment_cubemap_positive_x + i, 0)
        rl.rl_enable_framebuffer(fbo)

        // Load and draw a cube, it uses the current enabled texture
        // rl.rl_clear_screen_buffers()
        rl.rl_load_draw_cube()

        // ALTERNATIVE: Try to use internal batch system to draw the cube instead of rlLoadDrawCube
        // for some reason this method does not work, maybe due to cube triangles definition? normals pointing out?
        // TODO: Investigate this issue...
        //rlSetTexture(panorama.id) // WARNING: It must be called after enabling current framebuffer if using internal batch system!
        // rl.rl_clear_screen_buffers()
        // rl.draw_cube_v(rl.Vector3.zero(), rl.Vector3.one(), rl.white)
        // rl.rl_draw_render_batch_active()
    }

    //------------------------------------------------------------------------------------------
    // STEP 3: Unload framebuffer and reset state
    //------------------------------------------------------------------------------------------
    rl.rl_disable_shader()          // Unbind shader
    rl.rl_disable_texture()         // Unbind texture
    rl.rl_disable_framebuffer()     // Unbind framebuffer
    rl.rl_unload_framebuffer(fbo)   // Unload framebuffer (and automatically attached depth texture/renderbuffer)

    // Reset viewport dimensions to default
    rl.rl_viewport(0, 0, rl.rl_get_framebuffer_width(), rl.rl_get_framebuffer_height())
    rl.rl_enable_backface_culling()
    //------------------------------------------------------------------------------------------

    cubemap.width   = size
    cubemap.height  = size
    cubemap.mipmaps = 1
    cubemap.format  = format

    return cubemap
}
