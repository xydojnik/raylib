module main

/*******************************************************************************************
*
*   raylib [shapes] example - Draw Textured Polygon
*
*   Example originally created with raylib 3.7, last time updated with raylib 3.7
*
*   Example contributed by Chris Camacho (@codifies) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Chris Camacho     (@codifies) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

const max_points = int(11)      // 10 points and back to the start


// Draw textured polygon, defined by vertex and texture coordinates
// NOTE: Polygon center must have straight line path to all points
// without crossing perimeter, points must be in anticlockwise order
fn draw_texture_poly(texture rl.Texture2D, center rl.Vector2, points []rl.Vector2, texcoords []rl.Vector2, color rl.Color) {
    rl.rl_set_texture(texture.id)

    // Texturing is only supported on RL_QUADS
    rl.rl_begin(rl.rl_quads)
        rl.rl_color4ub(color.r, color.g, color.b, color.a)

        for i in 0..texcoords.len-1 {
            rl.rl_tex_coord2f(0.5, 0.5)
            rl.rl_vertex2f(center.x, center.y)

            rl.rl_tex_coord2f(texcoords[i].x, texcoords[i].y)
            rl.rl_vertex2f(points[i].x + center.x, points[i].y + center.y)

            rl.rl_tex_coord2f(texcoords[i + 1].x, texcoords[i + 1].y)
            rl.rl_vertex2f(points[i + 1].x + center.x, points[i + 1].y + center.y)

            rl.rl_tex_coord2f(texcoords[i + 1].x, texcoords[i + 1].y)
            rl.rl_vertex2f(points[i + 1].x + center.x, points[i + 1].y + center.y)
        }
    rl.rl_end()

    rl.rl_set_texture(0)
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450
    
    rl.init_window(screen_width, screen_height, "raylib [textures] example - textured polygon")
    defer { rl.close_window() }        // Close window and OpenGL context

    // Define texture coordinates to map our texture to poly
    texcoords := [
        rl.Vector2 {  0.75,   0.0 },
        rl.Vector2 {  0.25,   0.0 },
        rl.Vector2 {   0.0,   0.5 },
        rl.Vector2 {   0.0,  0.75 },
        rl.Vector2 {  0.25,   1.0 },
        rl.Vector2 { 0.375, 0.875 },
        rl.Vector2 { 0.625, 0.875 },
        rl.Vector2 {  0.75,   1.0 },
        rl.Vector2 {   1.0,  0.75 },
        rl.Vector2 {   1.0,   0.5 },
        rl.Vector2 {  0.75,   0.0 }  // Close the poly
    ]

    // Define the base poly vertices from the UV's
    // NOTE: They can be specified in any other way
    mut points    := []rl.Vector2 { len: max_points }
    // Define the vertices drawing position
    // NOTE       : Initially same as points but updated every frame
    mut positions := []rl.Vector2 { len  :max_points }

    for i in 0..texcoords.len {
        point := rl.Vector2 {
            (texcoords[i].x - 0.5)*256.0
            (texcoords[i].y - 0.5)*256.0
        }
        points[i]    = point
        positions[i] = point
    }

    // Load texture to be mapped to poly
    texture := rl.load_texture("resources/cat.png")
    defer { rl.unload_texture(texture) } // Unload texture

    mut angle := f32(0.0)                // Rotation angle (in degrees)

    rl.set_target_fps(60)                // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Update points rotation with an angle transform
        // NOTE: Base points position are not modified
        angle++
        for i in 0..max_points {
            positions[i] = rl.Vector2.rotate(points[i], rl.deg2rad(angle))
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("textured polygon", 20, 20, 20, rl.darkgray)
            draw_texture_poly(
                texture,
                rl.Vector2 {
                    f32(rl.get_screen_width()) /2.0,
                    f32(rl.get_screen_height())/2.0
                },
                positions, texcoords, rl.white
            )

        rl.end_drawing()
    }
}
