module main

/*******************************************************************************************
*
*   raylib [textures] example - N-patch drawing
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example originally created with raylib 2.0, last time updated with raylib 2.5
*
*   Example contributed by Jorge A. Gomes (@overdev) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2018-2023 Jorge A. Gomes    (@overdev) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
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

    rl.init_window(screen_width, screen_height, "raylib [textures] example - N-patch drawing")
    defer { rl.close_window() }                  // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    n_patch_texture := rl.load_texture("resources/ninepatch_button.png")
    defer { rl.unload_texture(n_patch_texture) } // Texture unloading

    mut mouse_position := rl.Vector2 {}
    mut origin         := rl.Vector2 {}

    // Position and size of the n-patches
    mut dst_rec1  := rl.Rectangle { 480.0, 160.0, 32.0, 32.0 }
    mut dst_rec2  := rl.Rectangle { 160.0, 160.0, 32.0, 32.0 }
    mut dst_rec_h := rl.Rectangle { 160.0,  93.0, 32.0, 32.0 }
    mut dst_rec_v := rl.Rectangle {  92.0, 160.0, 32.0, 32.0 }

    // A 9-patch (NPATCH_NINE_PATCH) changes its sizes in both axis
    nine_patch_info1 := rl.NPatchInfo { rl.Rectangle { 0.0,   0.0, 64.0, 64.0 }, 12, 40, 12, 12, rl.npatch_nine_patch }
    nine_patch_info2 := rl.NPatchInfo { rl.Rectangle { 0.0, 128.0, 64.0, 64.0 }, 16, 16, 16, 16, rl.npatch_nine_patch }

    // A horizontal 3-patch (NPATCH_THREE_PATCH_HORIZONTAL) changes its sizes along the x axis only
    h3_patch_info := rl.NPatchInfo { rl.Rectangle { 0.0,  64.0, 64.0, 64.0 }, 8, 8, 8, 8, rl.npatch_three_patch_horizontal }

    // A vertical 3-patch (NPATCH_THREE_PATCH_VERTICAL) changes its sizes along the y axis only
    v3_patch_info := rl.NPatchInfo { rl.Rectangle { 0.0, 192.0, 64.0, 64.0 }, 6, 6, 6, 6, rl.npatch_three_patch_vertical }

    rl.set_target_fps(60)
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        mouse_position = rl.get_mouse_position()

        // Resize the n-patches based on mouse position
        dst_rec1.width   = mouse_position.x - dst_rec1.x
        dst_rec1.height  = mouse_position.y - dst_rec1.y
        dst_rec2.width   = mouse_position.x - dst_rec2.x
        dst_rec2.height  = mouse_position.y - dst_rec2.y
        dst_rec_h.width  = mouse_position.x - dst_rec_h.x
        dst_rec_v.height = mouse_position.y - dst_rec_v.y

        // Set a minimum width and/or height
        if dst_rec1.width   <   1.0 { dst_rec1.width   =   1.0 }
        if dst_rec1.width   > 300.0 { dst_rec1.width   = 300.0 }
        if dst_rec1.height  <   1.0 { dst_rec1.height  =   1.0 }
        if dst_rec2.width   <   1.0 { dst_rec2.width   =   1.0 }
        if dst_rec2.width   > 300.0 { dst_rec2.width   = 300.0 }
        if dst_rec2.height  <   1.0 { dst_rec2.height  =   1.0 }
        if dst_rec_h.width  <   1.0 { dst_rec_h.width  =   1.0 }
        if dst_rec_v.height <   1.0 { dst_rec_v.height =   1.0 }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // Draw the n-patches
            rl.draw_texture_n_patch(n_patch_texture, nine_patch_info2, dst_rec2,  origin, 0.0, rl.white)
            rl.draw_texture_n_patch(n_patch_texture, nine_patch_info1, dst_rec1,  origin, 0.0, rl.white)
            rl.draw_texture_n_patch(n_patch_texture, h3_patch_info,    dst_rec_h, origin, 0.0, rl.white)
            rl.draw_texture_n_patch(n_patch_texture, v3_patch_info,    dst_rec_v, origin, 0.0, rl.white)

            // Draw the source texture
            rl.draw_rectangle_lines(5, 88, 74, 266, rl.blue)
            rl.draw_texture(n_patch_texture, 10, 93, rl.white)
            rl.draw_text("TEXTURE", 15, 360, 10, rl.darkgray)

            rl.draw_text("Move the mouse to stretch or shrink the n-patches", 10, 20, 20, rl.darkgray)

        rl.end_drawing()
    }
}
