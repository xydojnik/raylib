/*******************************************************************************************
*
*   raylib example - procedural mesh generation
*
*   Example originally created with raylib 1.8, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const num_models = 8               // Parametric 3d shapes to generate

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [models] example - mesh generation")
    defer { rl.close_window() }// Close window and OpenGL context

    // We generate a checked image for texturing
    checked := rl.gen_image_checked(2, 2, 1, 1, rl.red, rl.green)

    texture := rl.load_texture_from_image(checked)
    defer { rl.unload_texture(texture) }// Unload texture

    rl.unload_image(checked)

    mut models := []rl.Model{cap: num_models}
    defer { for model in models { rl.unload_model(model) } } // Unload models data (GPU VRAM)

    models << rl.load_model_from_mesh(rl.gen_mesh_plane(2, 2, 4, 3))
    models << rl.load_model_from_mesh(rl.gen_mesh_cube(2.0, 1.0, 2.0))
    models << rl.load_model_from_mesh(rl.gen_mesh_sphere(2, 32, 32))
    models << rl.load_model_from_mesh(rl.gen_mesh_hemi_sphere(2, 16, 16))
    models << rl.load_model_from_mesh(rl.gen_mesh_cylinder(1, 2, 16))
    models << rl.load_model_from_mesh(rl.gen_mesh_torus(0.25, 4.0, 16, 32))
    models << rl.load_model_from_mesh(rl.gen_mesh_knot(1.0, 2.0, 16, 128))
    models << rl.load_model_from_mesh(rl.gen_mesh_poly(5, 2.0))
    models << rl.load_model_from_mesh(gen_mesh_custom())
    
    // Generated meshes could be exported as .obj files
    // unsafe {
    //     rl.export_mesh(models[0].meshes[0], "plane.obj")
    //     rl.export_mesh(models[1].meshes[0], "cube.obj")
    //     rl.export_mesh(models[2].meshes[0], "sphere.obj")
    //     rl.export_mesh(models[3].meshes[0], "hemisphere.obj")
    //     rl.export_mesh(models[4].meshes[0], "cylinder.obj")
    //     rl.export_mesh(models[5].meshes[0], "torus.obj")
    //     rl.export_mesh(models[6].meshes[0], "knot.obj")
    //     rl.export_mesh(models[7].meshes[0], "poly.obj")
    //     rl.export_mesh(models[8].meshes[0], "custom.obj")
    // }

    // Set checked texture as default diffuse component for all models material
    for model in models {
        unsafe { model.materials[0].maps[rl.material_map_diffuse].texture = texture }
    }

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        rl.Vector3 { 5.0, 5.0, 5.0 },
        rl.Vector3 { 0.0, 0.0, 0.0 },
        rl.Vector3 { 0.0, 1.0, 0.0 },
        45.0,
        rl.camera_perspective
    }

    // Model drawing position
    mut position := rl.Vector3 { 0.0, 0.0, 0.0 }

    mut current_model := 0

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_orbital)

        if rl.is_mouse_button_pressed(rl.mouse_button_left) {
            current_model = (current_model + 1)%models.len // Cycle between the textures
        }

        if rl.is_key_pressed(rl.key_right) {
            current_model++
            if current_model >= models.len { current_model = 0 }
        } else if rl.is_key_pressed(rl.key_left) {
            current_model--
            if current_model < 0 { current_model = models.len - 1 }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

               rl.draw_model(models[current_model], position, 1.0, rl.white)
               rl.draw_grid(10, 1.0)

            rl.end_mode_3d()

            rl.draw_rectangle(30, 400, 310, 30, rl.Color.fade(rl.skyblue, 0.5))
            rl.draw_rectangle_lines(30, 400, 310, 30, rl.Color.fade(rl.darkblue, 0.5))
            rl.draw_text("MOUSE LEFT BUTTON to CYCLE PROCEDURAL MODELS", 40, 410, 10, rl.blue)

            match current_model {
                0 { rl.draw_text("PLANE",             680, 10, 20, rl.darkblue) }
                1 { rl.draw_text("CUBE",              680, 10, 20, rl.darkblue) }
                2 { rl.draw_text("SPHERE",            680, 10, 20, rl.darkblue) }
                3 { rl.draw_text("HEMISPHERE",        640, 10, 20, rl.darkblue) }
                4 { rl.draw_text("CYLINDER",          680, 10, 20, rl.darkblue) }
                5 { rl.draw_text("TORUS",             680, 10, 20, rl.darkblue) }
                6 { rl.draw_text("KNOT",              680, 10, 20, rl.darkblue) }
                7 { rl.draw_text("POLY",              680, 10, 20, rl.darkblue) }
                8 { rl.draw_text("Custom (triangle)", 580, 10, 20, rl.darkblue) }
                else {}
            }

        rl.end_drawing()
    }
}

// Generate a simple triangle mesh from code
fn gen_mesh_custom() rl.Mesh {
    mut mesh := rl.Mesh {
        triangleCount: 1
        vertexCount:   3
        vertices:      rl.mem_alloc(3*3*sizeof(f32))
        texcoords:     rl.mem_alloc(2*3*sizeof(f32))
        normals:       rl.mem_alloc(3*3*sizeof(f32))
    }
    
    unsafe {
        // Vertex at (0, 0, 0)
        mesh.vertices[0]  = 0
        mesh.vertices[1]  = 0
        mesh.vertices[2]  = 0

        mesh.normals[0]   = 0
        mesh.normals[1]   = 1
        mesh.normals[2]   = 0

        mesh.texcoords[0] = 0
        mesh.texcoords[1] = 0

        // Vertex at (1, 0, 2)
        mesh.vertices[3]  = 1
        mesh.vertices[4]  = 0
        mesh.vertices[5]  = 2

        mesh.normals[3]   = 0
        mesh.normals[4]   = 1
        mesh.normals[5]   = 0

        mesh.texcoords[2] = 0.5
        mesh.texcoords[3] = 1.0

        // Vertex at (2, 0, 0)
        mesh.vertices[6]  = 2
        mesh.vertices[7]  = 0
        mesh.vertices[8]  = 0

        mesh.normals[6]   = 0
        mesh.normals[7]   = 1
        mesh.normals[8]   = 0

        mesh.texcoords[4] = 1
        mesh.texcoords[5] = 0
    }
    // Upload mesh data from CPU (RAM) to GPU (VRAM) memory
    rl.upload_mesh(&mesh, false)

    return mesh
}
