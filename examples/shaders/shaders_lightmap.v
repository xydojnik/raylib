/*******************************************************************************************
*
*   raylib [shaders] example - lightmap
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3).
*
*   Example contributed by Jussi Viitala (@nullstare) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2024 Jussi Viitala (@nullstare) and Ramon Santamaria (@raysan5)
*
********************************************************************************************/
import raylib as rl


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    width  := 800
    height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint) // Enable Multi Sampling Anti Aliasing 4x (if available)
    rl.init_window(width, height, 'raylib [shaders] example - lightmap')
    defer { rl.close_window() }               // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera{
        position:   rl.Vector3 { 4.0, 6.0, 8.0 } // Camera position
        target:     rl.Vector3 { 0.0, 0.0, 0.0 } // Camera looking at point
        up:         rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:       f32(45.0)                    // Camera field-of-view Y
        projection: rl.camera_perspective        // Camera projection type
    }

    map_size := int(10)
    mut mesh := rl.gen_mesh_plane(map_size, f32(map_size), 1, 1)

    // GenMeshPlane doesn't generate texcoords2 so we will upload them separately
    mut texcoords2 := rl.ptr_arr_to_varr[f32](
        rl.mem_alloc(u32(mesh.vertexCount)*2*sizeof(f32)),
        mesh.vertexCount*2
    )
    defer { unsafe { texcoords2.free() } }
    
    mesh.texcoords2 = texcoords2.data
    
//  |       X         |    |        Y        |
    texcoords2[0] = 0.0    texcoords2[1] = 0.0
    texcoords2[2] = 1.0    texcoords2[3] = 0.0
    texcoords2[4] = 0.0    texcoords2[5] = 1.0
    texcoords2[6] = 1.0    texcoords2[7] = 1.0

    // Load a new texcoords2 attributes buffer
    unsafe {
        mesh.vboId[rl.shader_loc_vertex_texcoord02] = rl.load_vertex_buffer(
            texcoords2.data,
            texcoords2.len*int(sizeof(f32)),
            false
        )
    }
    rl.rl_enable_vertex_array(mesh.vaoId)
    
    // Index 5 is for texcoords2
    rl.set_vertex_attribute(5, 2, rl.rl_float, false, 0, voidptr(0))
    rl.rl_enable_vertex_attribute(5)
    rl.rl_disable_vertex_array()

    // Load lightmap shader
    shader := rl.Shader.load(
        c'resources/shaders/glsl330/lightmap.vs',
        c'resources/shaders/glsl330/lightmap.fs'
    )!

    texture := rl.Texture.load('resources/cubicmap_atlas.png')
    light   := rl.Texture.load('resources/spark_flame.png')

    texture.gen_mipmaps()
    texture.set_filter(rl.texture_filter_trilinear)

    lightmap := rl.RenderTexture.load(map_size, map_size)

    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer {
        mesh.unload()    // Unload the mesh
        shader.unload()  // Unload shader
        texture.unload() // Unload texture
        light.unload()   // Unload texture
    }
    
    lightmap.texture.set_filter(rl.texture_filter_trilinear)

    // mut material := rl.load_material_default()
    mut material := rl.Material.get_default()
    material.set_shader(shader)
    material.set_texture(rl.material_map_albedo,    texture)
    material.set_texture(rl.material_map_metalness, lightmap.texture)

    // Drawing to lightmap
    rl.begin_texture_mode(lightmap)
        rl.clear_background(rl.black)

        rl.begin_blend_mode(rl.blend_additive)
            light.draw_pro(
                rl.Rectangle { 0, 0, light.width, light.height },
                rl.Rectangle { 0, 0, 20, 20 },
                rl.Vector2   { 10.0, 10.0 },
                0.0,
                rl.red
            )
            light.draw_pro(
                rl.Rectangle { 0, 0, light.width, light.height },
                rl.Rectangle { 8, 4, 20, 20 },
                rl.Vector2   { 10.0, 10.0 },
                0.0,
                rl.blue
            )
            light.draw_pro(
                rl.Rectangle { 0, 0, light.width, light.height },
                rl.Rectangle { 8, 8, 10, 10 },
                rl.Vector2   { 5.0, 5.0 },
                0.0,
                rl.green
            )
        rl.end_blend_mode()
    rl.end_texture_mode()

    rl.set_target_fps(60)                // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        camera.update(rl.camera_orbital)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)
                mesh.draw(material, rl.Matrix.identity())
            rl.end_mode_3d()

            rl.draw_fps(10, 10)

            rl.draw_texture_pro(
                lightmap.texture,
                rl.Rectangle { 0, 0, -map_size, -map_size },
                rl.Rectangle { rl.get_render_width() - map_size*8 - 10, 10, map_size*8, map_size*8 },
                rl.Vector2   { 0.0, 0.0 },
                0.0,
                rl.white
            )
                
            rl.draw_text('lightmap',     rl.get_render_width() - 66, 16 + map_size*8, 10, rl.gray)
            rl.draw_text('10x10 pixels', rl.get_render_width() - 76, 30 + map_size*8, 10, rl.gray)
                
        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
