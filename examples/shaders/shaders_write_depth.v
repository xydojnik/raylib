/*******************************************************************************************
*
*   raylib [shaders] example - Depth buffer writing
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example contributed by Buğra Alptekin Sarı (@BugraAlptekinSari) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2022-2023 Buğra Alptekin Sarı (@BugraAlptekinSari)
*   Translated&Modified (c) 2024      Fedorov Alexandr   (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const glsl_version = $if PLATFORM_DESKTOP ? { 330 } $else { 100 }


//------------------------------------------------------------------------------------
// Define custom functions required for the example
//------------------------------------------------------------------------------------
// Load custom render texture, create a writable depth texture buffer
fn load_render_texture_depth_tex(width int, height int) rl.RenderTexture2D {
    mut target := rl.RenderTexture2D {}
    target.id = rl.rl_load_framebuffer()   // Load an empty framebuffer

    if target.id > 0 {
        rl.rl_enable_framebuffer(target.id)

        // Create color texture (default to RGBA)
        target.texture.id = rl.rl_load_texture(voidptr(0), width, height, rl.pixelformat_uncompressed_r8_g8_b8_a8, 1)
        target.texture.width   = width
        target.texture.height  = height
        target.texture.format  = rl.pixelformat_uncompressed_r8_g8_b8_a8
        target.texture.mipmaps = 1

        // Create depth texture buffer (instead of raylib default renderbuffer)
        target.depth.id      = rl.rl_load_texture_depth(width, height, false)
        target.depth.width   = width
        target.depth.height  = height
        target.depth.format  = 19       //DEPTH_COMPONENT_24BIT?
        target.depth.mipmaps = 1

        // Attach color texture and depth texture to FBO
        rl.rl_framebuffer_attach(target.id, target.texture.id, rl.rl_attachment_color_channel0, rl.rl_attachment_texture_2d, 0)
        rl.rl_framebuffer_attach(target.id, target.depth.id, rl.rl_attachment_depth, rl.rl_attachment_texture_2d, 0)

        // Check if fbo is complete with attachments (valid)
        if rl.rl_framebuffer_complete(target.id) {
            println("FBO: [ID ${target.id}] Framebuffer object created successfully")
        }

        rl.rl_disable_framebuffer()
    } else {
        println("FBO: Framebuffer object can not be created")
    }

    return target
}


// Unload render texture from GPU memory (VRAM)
fn unload_render_texture_depth_tex(target rl.RenderTexture2D) {
    if target.id > 0 {
        // Color texture attached to FBO is deleted
        rl.rl_unload_texture(target.texture.id)
        rl.rl_unload_texture(target.depth.id)

        // NOTE: Depth texture is automatically
        // queried and deleted before deleting framebuffer
        rl.rl_unload_framebuffer(target.id)
    }
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - write depth buffer")
    defer { rl.close_window() }       // Close window and OpenGL context

    // The shader inverts the depth buffer by writing into it by `gl_FragDepth = 1 - gl_FragCoord.z`
    shader := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/write_depth.fs".str)
    defer { rl.unload_shader(shader) }

    // Use Customized function to create writable depth texture buffer
    target := load_render_texture_depth_tex(screen_width, screen_height)
    defer { unload_render_texture_depth_tex(target) }
    

    // Define the camera to look into our 3d world
    camera := rl.Camera {
        position:    rl.Vector3 { 2.0, 2.0, 3.0 }, // Camera position
        target:      rl.Vector3 { 0.0, 0.5, 0.0 }, // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 }, // Camera up vector (rotation towards target)
        fovy:        45.0,                         // Camera field-of-view Y
        projection:  rl.camera_perspective         // Camera projection type
    }
    
    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_orbital)
        //----------------------------------------------------------------------------------
        
        // Draw
        //----------------------------------------------------------------------------------
        
        // Draw into our custom render texture (framebuffer)
        rl.begin_texture_mode(target)
            rl.clear_background(rl.white)
            
            rl.begin_mode_3d(camera)
                rl.begin_shader_mode(shader)
                    rl.draw_cube_wires_v(rl.Vector3 { 0.0, 0.5, 1.0 }, rl.Vector3 { 1.0, 1.0, 1.0 }, rl.red)
                    rl.draw_cube_v(rl.Vector3 { 0.0, 0.5, 1.0 }, rl.Vector3 { 1.0, 1.0, 1.0 }, rl.purple)
                    rl.draw_cube_wires_v(rl.Vector3 { 0.0, 0.5, -1.0 }, rl.Vector3 { 1.0, 1.0, 1.0 }, rl.darkgreen)
                    rl.draw_cube_v(rl.Vector3  { 0.0, 0.5, -1.0 }, rl.Vector3 { 1.0, 1.0, 1.0 }, rl.yellow)
                    rl.draw_grid(10, 1.0)
                rl.end_shader_mode()
            rl.end_mode_3d()
        rl.end_texture_mode()

        // Draw into screen our custom render texture 
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)
        
        rl.draw_texture_rec(target.texture, rl.Rectangle { 0, 0, f32(screen_width), f32(-screen_height) }, rl.Vector2 { 0, 0 }, rl.white)
            rl.draw_fps(10, 10)
        rl.end_drawing()
    }
}
