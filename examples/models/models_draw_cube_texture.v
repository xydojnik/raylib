/*******************************************************************************************
*
*   raylib [models] example - Draw textured cube
*
*   Example originally created with raylib 4.5, last time updated with raylib 4.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2022-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
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

    rl.init_window(screen_width, screen_height, 'raylib [models] example - draw cube texture')

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 0.0, 10.0, 10.0 }
        target:      rl.Vector3 { 0.0,  0.0,  0.0 }
        up:          rl.Vector3 { 0.0,  1.0,  0.0 }
        fovy:        45.0
        projection:  rl.camera_perspective
    }
    
    // Load texture to be applied to the cubes sides
    texture := rl.Texture.load(asset_path+'cubicmap_atlas.png')
    defer { texture.unload() }          // Unload texture

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                // Draw cube with an applied texture
                draw_cube_texture(texture, rl.Vector3 { -2.0, 2.0, 0.0 }, 2.0, 4.0, 2.0, rl.white)

                // Draw cube with an applied texture, but only a defined rectangle piece of the texture
                draw_cube_texture_rec(texture, rl.Rectangle { 0, texture.height/2, texture.width/2, texture.height/2 }, 
                    rl.Vector3 { 2.0, 1.0, 0.0 }, 2.0, 2.0, 2.0, rl.white)

                rl.draw_grid(10, 1.0)        // Draw a grid

            rl.end_mode_3d()

            rl.draw_fps(10, 10)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
    
    rl.close_window()          // Close window and OpenGL context
}

//------------------------------------------------------------------------------------
// Custom Functions Definition
//------------------------------------------------------------------------------------
// Draw cube textured
// NOTE: Cube position is the center position
fn draw_cube_texture(texture rl.Texture2D, position rl.Vector3, width f32, height f32, length f32, color rl.Color) {
    x := f32(position.x)
    y := f32(position.y)
    z := f32(position.z)

    // Set desired texture to be enabled while drawing following vertex data
    rl.rl_set_texture(texture.id)

    // Vertex data transformation can be defined with the commented lines,
    // but in this example we calculate the transformed vertex data directly when calling rlVertex3f()
    //rlPushMatrix()
        // NOTE: Transformation is applied in inverse order (scale -> rotate -> translate)
        //rlTranslatef(2.0f, 0.0f, 0.0f)
        //rlRotatef(45, 0, 1, 0)
        //rlScalef(2.0f, 2.0f, 2.0f)

        rl.rl_begin(rl.rl_quads)
            rl.rl_color4ub(color.r, color.g, color.b, color.a)
            // Front Face
            rl.rl_normal3f(0.0, 0.0, 1.0)       // Normal Pointing Towards Viewer
            rl.rl_tex_coord2f(0.0, 0.0) rl.rl_vertex3f(x - width/2, y - height/2, z + length/2)  // Bottom Left Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 0.0) rl.rl_vertex3f(x + width/2, y - height/2, z + length/2)  // Bottom Right Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 1.0) rl.rl_vertex3f(x + width/2, y + height/2, z + length/2)  // Top Right Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 1.0) rl.rl_vertex3f(x - width/2, y + height/2, z + length/2)  // Top Left Of The Texture and Quad
            // Back Face
            rl.rl_normal3f(0.0, 0.0, - 1.0)     // Normal Pointing Away From Viewer
            rl.rl_tex_coord2f(1.0, 0.0) rl.rl_vertex3f(x - width/2, y - height/2, z - length/2)  // Bottom Right Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 1.0) rl.rl_vertex3f(x - width/2, y + height/2, z - length/2)  // Top Right Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 1.0) rl.rl_vertex3f(x + width/2, y + height/2, z - length/2)  // Top Left Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 0.0) rl.rl_vertex3f(x + width/2, y - height/2, z - length/2)  // Bottom Left Of The Texture and Quad
            // Top Face
            rl.rl_normal3f(0.0, 1.0, 0.0)       // Normal Pointing Up
            rl.rl_tex_coord2f(0.0, 1.0) rl.rl_vertex3f(x - width/2, y + height/2, z - length/2)  // Top Left Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 0.0) rl.rl_vertex3f(x - width/2, y + height/2, z + length/2)  // Bottom Left Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 0.0) rl.rl_vertex3f(x + width/2, y + height/2, z + length/2)  // Bottom Right Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 1.0) rl.rl_vertex3f(x + width/2, y + height/2, z - length/2)  // Top Right Of The Texture and Quad
            // Bottom Face
            rl.rl_normal3f(0.0, - 1.0, 0.0)     // Normal Pointing Down
            rl.rl_tex_coord2f(1.0, 1.0) rl.rl_vertex3f(x - width/2, y - height/2, z - length/2)  // Top Right Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 1.0) rl.rl_vertex3f(x + width/2, y - height/2, z - length/2)  // Top Left Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 0.0) rl.rl_vertex3f(x + width/2, y - height/2, z + length/2)  // Bottom Left Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 0.0) rl.rl_vertex3f(x - width/2, y - height/2, z + length/2)  // Bottom Right Of The Texture and Quad
            // Right face
            rl.rl_normal3f(1.0, 0.0, 0.0)       // Normal Pointing Right
            rl.rl_tex_coord2f(1.0, 0.0) rl.rl_vertex3f(x + width/2, y - height/2, z - length/2)  // Bottom Right Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 1.0) rl.rl_vertex3f(x + width/2, y + height/2, z - length/2)  // Top Right Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 1.0) rl.rl_vertex3f(x + width/2, y + height/2, z + length/2)  // Top Left Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 0.0) rl.rl_vertex3f(x + width/2, y - height/2, z + length/2)  // Bottom Left Of The Texture and Quad
            // Left Face
            rl.rl_normal3f( - 1.0, 0.0, 0.0)    // Normal Pointing Left
            rl.rl_tex_coord2f(0.0, 0.0) rl.rl_vertex3f(x - width/2, y - height/2, z - length/2)  // Bottom Left Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 0.0) rl.rl_vertex3f(x - width/2, y - height/2, z + length/2)  // Bottom Right Of The Texture and Quad
            rl.rl_tex_coord2f(1.0, 1.0) rl.rl_vertex3f(x - width/2, y + height/2, z + length/2)  // Top Right Of The Texture and Quad
            rl.rl_tex_coord2f(0.0, 1.0) rl.rl_vertex3f(x - width/2, y + height/2, z - length/2)  // Top Left Of The Texture and Quad
        rl.rl_end()
    //rlPopMatrix()

    rl.rl_set_texture(0)
}

// Draw cube with texture piece applied to all faces
fn draw_cube_texture_rec(texture rl.Texture2D, source rl.Rectangle, position rl.Vector3, width f32, height f32, length f32, color rl.Color) {
    x          := f32(position.x)
    y          := f32(position.y)
    z          := f32(position.z)
    tex_width  := f32(texture.width)
    tex_height := f32(texture.height)

    // Set desired texture to be enabled while drawing following vertex data
    rl.rl_set_texture(texture.id)

    // We calculate the normalized texture coordinates for the desired texture-source-rectangle
    // It means converting from (tex.width, tex.height) coordinates to [0.0f, 1.0f] equivalent 
    rl.rl_begin(rl.rl_quads)
        rl.rl_color4ub(color.r, color.g, color.b, color.a)

        // Front face
        rl.rl_normal3f(0.0, 0.0, 1.0)
        rl.rl_tex_coord2f(source.x/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x - width/2, y - height/2, z + length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x + width/2, y - height/2, z + length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x + width/2, y + height/2, z + length/2)
        rl.rl_tex_coord2f(source.x/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x - width/2, y + height/2, z + length/2)

        // Back face
        rl.rl_normal3f(0.0, 0.0, - 1.0)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x - width/2, y - height/2, z - length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x - width/2, y + height/2, z - length/2)
        rl.rl_tex_coord2f(source.x/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x + width/2, y + height/2, z - length/2)
        rl.rl_tex_coord2f(source.x/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x + width/2, y - height/2, z - length/2)

        // Top face
        rl.rl_normal3f(0.0, 1.0, 0.0)
        rl.rl_tex_coord2f(source.x/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x - width/2, y + height/2, z - length/2)
        rl.rl_tex_coord2f(source.x/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x - width/2, y + height/2, z + length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x + width/2, y + height/2, z + length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x + width/2, y + height/2, z - length/2)

        // Bottom face
        rl.rl_normal3f(0.0, - 1.0, 0.0)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x - width/2, y - height/2, z - length/2)
        rl.rl_tex_coord2f(source.x/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x + width/2, y - height/2, z - length/2)
        rl.rl_tex_coord2f(source.x/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x + width/2, y - height/2, z + length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x - width/2, y - height/2, z + length/2)

        // Right face
        rl.rl_normal3f(1.0, 0.0, 0.0)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x + width/2, y - height/2, z - length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x + width/2, y + height/2, z - length/2)
        rl.rl_tex_coord2f(source.x/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x + width/2, y + height/2, z + length/2)
        rl.rl_tex_coord2f(source.x/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x + width/2, y - height/2, z + length/2)

        // Left face
        rl.rl_normal3f( - 1.0, 0.0, 0.0)
        rl.rl_tex_coord2f(source.x/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x - width/2, y - height/2, z - length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
        rl.rl_vertex3f(x - width/2, y - height/2, z + length/2)
        rl.rl_tex_coord2f((source.x + source.width)/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x - width/2, y + height/2, z + length/2)
        rl.rl_tex_coord2f(source.x/tex_width, source.y/tex_height)
        rl.rl_vertex3f(x - width/2, y + height/2, z - length/2)

    rl.rl_end()

    rl.rl_set_texture(0)
}
