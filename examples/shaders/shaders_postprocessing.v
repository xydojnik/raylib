/*******************************************************************************************
*
*   raylib [shaders] example - Apply a postprocessing shader to a scene
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const glsl_version        = $if PLATFORM_DESKTOP ? { 330 } $else { 100 }
const max_postpro_shaders = 12

enum PostproShader as int {
    fx_grayscale = 0
    fx_posterization
    fx_dream_vision
    fx_pixelizer
    fx_cross_hatching
    fx_cross_stitching
    fx_predator_view
    fx_scanlines
    fx_fisheye
    fx_sobel
    fx_bloom
    fx_blur
    //FX_FXAA
}

const postpro_shader_text = [
    "GRAYSCALE",
    "POSTERIZATION",
    "DREAM_VISION",
    "PIXELIZER",
    "CROSS_HATCHING",
    "CROSS_STITCHING",
    "PREDATOR_VIEW",
    "SCANLINES",
    "FISHEYE",
    "SOBEL",
    "BLOOM",
    "BLUR",
    //"FXAA"
]

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint) // Enable Multi Sampling Anti Aliasing 4x (if available)

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - postprocessing shader")
    defer { rl.close_window() }                     // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 2.0, 3.0, 2.0 }   // Camera position
        target:      rl.Vector3 { 0.0, 1.0, 0.0 }   // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 }   // Camera up vector (rotation towards target)
        fovy:        45.0                           // Camera field-of-view Y
        projection:  rl.camera_perspective          // Camera projection type
    }

    mut model := rl.load_model("resources/models/church.obj")           // Load OBJ model
    texture   := rl.load_texture("resources/models/church_diffuse.png") // Load model texture (diffuse map)
    defer {
        rl.unload_texture(texture)                  // Unload texture
        rl.unload_model(model)                      // Unload model
    }

    unsafe { model.materials[0].maps[rl.material_map_diffuse].texture = texture } // Set model diffuse texture
    

    mut position := rl.Vector3 {}                   // Set model position
    // Load all postpro shaders
    // NOTE 1: All postpro shader use the base vertex shader (DEFAULT_VERTEX_SHADER)
    // NOTE 2: We load the correct shader depending on GLSL version
    mut shaders := []rl.Shader {len: max_postpro_shaders }

    // NOTE: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
    shaders[int(PostproShader.fx_grayscale)]       = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/grayscale.fs".str)
    shaders[int(PostproShader.fx_posterization)]   = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/posterization.fs".str)
    shaders[int(PostproShader.fx_dream_vision)]    = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/dream_vision.fs".str)
    shaders[int(PostproShader.fx_pixelizer)]       = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/pixelizer.fs".str)
    shaders[int(PostproShader.fx_cross_hatching)]  = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/cross_hatching.fs".str)
    shaders[int(PostproShader.fx_cross_stitching)] = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/cross_stitching.fs".str)
    shaders[int(PostproShader.fx_predator_view)]   = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/predator.fs".str)
    shaders[int(PostproShader.fx_scanlines)]       = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/scanlines.fs".str)
    shaders[int(PostproShader.fx_fisheye)]         = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/fisheye.fs".str)
    shaders[int(PostproShader.fx_sobel)]           = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/sobel.fs".str)
    shaders[int(PostproShader.fx_bloom)]           = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/bloom.fs".str)
    shaders[int(PostproShader.fx_blur)]            = rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/blur.fs".str)

    defer { for shader in shaders { rl.unload_shader(shader) } } // Unload all postpro shaders

    mut current_shader := int(PostproShader.fx_grayscale)

    // Create a RenderTexture2D to be used for render to texture
    target := rl.load_render_texture(screen_width, screen_height)
    defer { rl.unload_render_texture(target) } // Unload render texture

    rl.set_target_fps(60)                      // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {            // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_orbital)

        if      rl.is_key_pressed(rl.key_right) { current_shader++ }
        else if rl.is_key_pressed(rl.key_left)  { current_shader-- }

        if      current_shader >= max_postpro_shaders { current_shader = 0 }
        else if current_shader < 0                    { current_shader = max_postpro_shaders - 1 }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_texture_mode(target)                         // Enable drawing to texture
            rl.clear_background(rl.raywhite)                  // Clear texture background

            rl.begin_mode_3d(camera)                          // Begin 3d mode drawing
                rl.draw_model(model, position, 0.1, rl.white) // Draw 3d model with texture
                rl.draw_grid(10, 1.0)                         // Draw a grid
            rl.end_mode_3d()                                  // End 3d mode drawing, returns to orthographic 2d mode
        rl.end_texture_mode()                                 // End drawing to texture (now we have a texture available for next passes)
        
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)  // Clear screen background

            // Render generated texture using selected postprocessing shader
            rl.begin_shader_mode(shaders[current_shader])
                // NOTE: Render texture must be y-flipped due to default OpenGL coordinates (left-bottom)
            rl.draw_texture_rec(
                target.texture,
                rl.Rectangle { 0, 0, f32(target.texture.width), f32(-target.texture.height) },
                rl.Vector2 { 0, 0 },
                rl.white
            )
            rl.end_shader_mode()

            // Draw 2d shapes and text over drawn texture
            rl.draw_rectangle(0, 9, 580, 30, rl.Color.fade(rl.lightgray, 0.7))

            rl.draw_text("(c) Church 3D model by Alberto Cano", screen_width - 200, screen_height - 20, 10, rl.gray)
            rl.draw_text("CURRENT POSTPRO SHADER:", 10, 15, 20, rl.black)
            rl.draw_text(postpro_shader_text[current_shader], 330, 15, 20, rl.red)
            rl.draw_text("< >", 540, 10, 30, rl.darkblue)
            rl.draw_fps(700, 15)
        rl.end_drawing()
    }
}
