/*******************************************************************************************
*
*   raylib [core] example - VR Simulator (Oculus Rift CV1 parameters)
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
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

const asset_path   = @VMODROOT+'/thirdparty/raylib/examples/core/resources/'
const glsl_version = 330

// TODO: Not working at this time. Too lazy to fix.

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    // NOTE: screen_width/screen_height should match VR device aspect ratio
    rl.init_window(screen_width, screen_height, 'raylib [core] example - vr simulator')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }                  // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // VR device parameters definition
    device := rl.VrDeviceInfo {
        // Oculus Rift CV1 parameters for simulator
        hResolution:            2160,       // Horizontal resolution in pixels
        vResolution:            1200,       // Vertical resolution in pixels
        hScreenSize:            0.133793,   // Horizontal size in meters
        vScreenSize:            0.0669,     // Vertical size in meters
        // vScreenCenter:          0.04678,    // Screen center in meters

        eyeToScreenDistance:    0.041,      // Distance between eye and display in meters
        lensSeparationDistance: 0.07,       // Lens separation distance in meters
        interpupillaryDistance: 0.07,       // IPD (distance between pupils) in meters

                                            // NOTE: CV1 uses fresnel-hybrid-asymmetric lenses with specific compute shaders
                                            // Following parameters are just an approximation to CV1 distortion stereo rendering

        lensDistortionValues: [f32(1.0),      // Lens distortion constant parameter 0
                                   0.22,      // Lens distortion constant parameter 1
                                   0.24,      // Lens distortion constant parameter 2
                                   0.0]!      // Lens distortion constant parameter3 

        chromaAbCorrection: [f32(0.996),      // Chromatic aberration correction parameter 0
                                -0.004,       // Chromatic aberration correction parameter 1
                                 1.014,       // Chromatic aberration correction parameter 2
                                   0.0]!      // Chromatic aberration correction parameter 3
    }

    // Load VR stereo config for VR device parameteres (Oculus Rift CV1 parameters)
    config := rl.load_vr_stereo_config(device)
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.unload_vr_stereo_config(config) }  // Unload stereo config
    //--------------------------------------------------------------------------------------

    // Distortion shader (uses device lens distortion and chroma)
    distortion := rl.Shader.load(voidptr(0), (asset_path+'distortion${glsl_version}.fs').str)!
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.unload_shader(distortion) }      // Unload distortion shader
    //--------------------------------------------------------------------------------------

    // Update distortion shader with lens and distortion-scale parameters
    rl.set_shader_value(distortion, rl.get_shader_location(distortion, 'leftLensCenter'),    &config.leftLensCenter,    rl.shader_uniform_vec2)
    rl.set_shader_value(distortion, rl.get_shader_location(distortion, 'rightLensCenter'),   &config.rightLensCenter,   rl.shader_uniform_vec2)
    rl.set_shader_value(distortion, rl.get_shader_location(distortion, 'leftScreenCenter'),  &config.leftScreenCenter,  rl.shader_uniform_vec2)
    rl.set_shader_value(distortion, rl.get_shader_location(distortion, 'rightScreenCenter'), &config.rightScreenCenter, rl.shader_uniform_vec2)

    rl.set_shader_value(distortion, rl.get_shader_location(distortion, 'scale'),           &config.scale,                  rl.shader_uniform_vec2)
    rl.set_shader_value(distortion, rl.get_shader_location(distortion, 'scaleIn'),         &config.scaleIn,               rl.shader_uniform_vec2)
    rl.set_shader_value(distortion, rl.get_shader_location(distortion, 'deviceWarpParam'), &device.lensDistortionValues, rl.shader_uniform_vec4)
    rl.set_shader_value(distortion, rl.get_shader_location(distortion, 'chromaAbParam'),   &device.chromaAbCorrection,   rl.shader_uniform_vec4)

    // Initialize framebuffer for stereo rendering
    // NOTE: Screen size should match HMD aspect ratio

    // target := rl.load_render_texture(device.h_resolution, device.v_resolution)
    target := rl.load_render_texture(100, 100)
    defer { rl.unload_render_texture(target) }    // Unload stereo render fbo

    // The target's height is flipped (in the source Rectangle), due to OpenGL reasons
    mut source_rec := rl.Rectangle{ 0.0, 0.0, f32(target.texture.width), -f32(target.texture.height)  }
    mut dest_rec   := rl.Rectangle{ 0.0, 0.0, f32(rl.get_screen_width()), f32(rl.get_screen_height()) }

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 5.0, 2.0, 5.0 } // Camera position
        target:      rl.Vector3 { 0.0, 2.0, 0.0 } // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector
        fovy:        60.0                         // Camera field-of-view Y
        projection:  rl.camera_perspective        // Camera projection type
    }

    mut cube_position := rl.Vector3 { 0.0, 0.0, 0.0 }

    rl.disable_cursor()             // Limit cursor to relative movement inside the window

    rl.set_target_fps(90)           // Set our game to run at 90 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_first_person)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_texture_mode(target)
            rl.clear_background(rl.raywhite)
            rl.begin_vr_stereo_mode(config)
                rl.begin_mode_3d(rl.Camera3D(camera))

                    rl.draw_cube(cube_position, 2.0, 2.0, 2.0, rl.red)
                    rl.draw_cube_wires(cube_position, 2.0, 2.0, 2.0, rl.maroon)
                    rl.draw_grid(40, 1.0)

                rl.end_mode_3d()
            rl.end_vr_stereo_mode()
        rl.end_texture_mode()
        
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)
            rl.begin_shader_mode(distortion)
                rl.draw_texture_pro(rl.Texture2D(target.texture), source_rec, dest_rec, rl.Vector2 { 0.0, 0.0 }, 0.0, rl.white)
            rl.end_shader_mode()
            rl.draw_fps(10, 10)
        rl.end_drawing()
    }
}
