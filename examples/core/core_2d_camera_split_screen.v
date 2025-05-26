/*******************************************************************************************
*
*   raylib [core] example - 2d camera split screen
*
*   Addapted from the core_3d_camera_split_screen example: 
*       https://github.com/raysan5/raylib/blob/master/examples/core/core_3d_camera_split_screen.c
*
*   Example originally created with raylib 4.5, last time updated with raylib 4.5
*
*   Example contributed by Gabriel dos Santos Sanches (@gabrielssanches) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2023 Gabriel dos Santos Sanches (@gabrielssanches)
*   Translated&Modified (c) 2024      Fedorov Alexandr      (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const player_size = 40

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 440

    rl.init_window(screen_width, screen_height, "raylib [core] example - 2d camera split screen")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }          // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut player1 := rl.Rectangle { 200, 200, player_size, player_size }
    mut player2 := rl.Rectangle { 250, 200, player_size, player_size }

    mut camera1 := rl.Camera2D {
        target: rl.Vector2 { player1.x, player1.y },
        offset: rl.Vector2 { 200.0, 200.0 },
        rotation: 0.0,
        zoom: 1.0
    }

    mut camera2 := rl.Camera2D {
        target:   rl.Vector2 { player2.x, player2.y },
        offset:   rl.Vector2 { 200.0, 200.0 },
        rotation: 0.0,
        zoom:     1.0
    }

    screen_camera1 := rl.load_render_texture(screen_width/2, screen_height)
    screen_camera2 := rl.load_render_texture(screen_width/2, screen_height)

    // De-Initialization render textures
    //--------------------------------------------------------------------------------------
    defer {
        rl.unload_render_texture(screen_camera1) // Unload render texture
        rl.unload_render_texture(screen_camera2) // Unload render texture
    }
    //--------------------------------------------------------------------------------------

    // Build a flipped rectangle the size of the split view to use for drawing later
    split_screen_rect := rl.Rectangle {
        0.0, 0.0,
        f32(screen_camera1.texture.width),
        f32(-screen_camera1.texture.height)
    }

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if      rl.is_key_down(rl.key_s)     { player1.y += 3.0 }
        else if rl.is_key_down(rl.key_w)     { player1.y -= 3.0 }
        if      rl.is_key_down(rl.key_d)     { player1.x += 3.0 }
        else if rl.is_key_down(rl.key_a)     { player1.x -= 3.0 }

        if      rl.is_key_down(rl.key_up)    { player2.y -= 3.0 }
        else if rl.is_key_down(rl.key_down)  { player2.y += 3.0 }
        if      rl.is_key_down(rl.key_right) { player2.x += 3.0 }
        else if rl.is_key_down(rl.key_left)  { player2.x -= 3.0 }

        camera1.target = rl.Vector2{ player1.x, player1.y }
        camera2.target = rl.Vector2{ player2.x, player2.y }
        
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_texture_mode(screen_camera1)
            rl.clear_background(rl.raywhite)
            
            rl.begin_mode_2d(camera1)
            
                // Draw full scene with first camera
                for i in 0..screen_width/player_size + 1 {
                    rl.draw_line_v(rl.Vector2 { f32(player_size*i), 0 }, rl.Vector2 { f32(player_size*i), f32(screen_height) }, rl.lightgray)
                }

                for i in 0..screen_height/player_size + 1 {
                    rl.draw_line_v(rl.Vector2 {0, f32(player_size*i)}, rl.Vector2 { f32(screen_width), f32(player_size*i)}, rl.lightgray)
                }

                for i in 0..screen_width/player_size {
                    for j in 0..screen_height/player_size {
                        rl.draw_text("[${i},${j}]", 10 + player_size*i, 15 + player_size*j, 10, rl.lightgray)
                    }
                }

                rl.draw_rectangle_rec(player1, rl.red)
                rl.draw_rectangle_rec(player2, rl.blue)
            rl.end_mode_2d()
            
            rl.draw_rectangle(0, 0, rl.get_screen_width()/2, 30, rl.Color.fade(rl.raywhite, 0.6))
            rl.draw_text("PLAYER1: W/S/A/D to move", 10, 10, 10, rl.maroon)
            
        rl.end_texture_mode()

        rl.begin_texture_mode(screen_camera2)
            rl.clear_background(rl.raywhite)
            
            rl.begin_mode_2d(camera2)
            
                // Draw full scene with second camera
                for i in 0..screen_width/player_size + 1 {
                    rl.draw_line_v(rl.Vector2 { f32(player_size*i), 0}, rl.Vector2 { f32(player_size*i), f32(screen_height) }, rl.lightgray)
                }

                for i in 0..screen_height/player_size + 1 {
                    rl.draw_line_v(rl.Vector2 {0, f32(player_size*i) }, rl.Vector2 { f32(screen_width), f32(player_size*i) }, rl.lightgray)
                }

                for i in 0..screen_width/player_size {
                    for j in 0..screen_height/player_size {
                        rl.draw_text("[$[i],${j}]", 10 + player_size*i, 15 + player_size*j, 10, rl.lightgray)
                    }
                }

                rl.draw_rectangle_rec(player1, rl.red)
                rl.draw_rectangle_rec(player2, rl.blue)
                
            rl.end_mode_2d()
            
            rl.draw_rectangle(0, 0, rl.get_screen_width()/2, 30, rl.Color.fade(rl.raywhite, 0.6))
            rl.draw_text("PLAYER2: UP/DOWN/LEFT/RIGHT to move", 10, 10, 10, rl.darkblue)
            
        rl.end_texture_mode()

        // Draw both views render textures to the screen side by side
        rl.begin_drawing()
            rl.clear_background(rl.black)
            
            rl.draw_texture_rec(rl.Texture2D(screen_camera1.texture), split_screen_rect, rl.Vector2 { 0, 0 }, rl.white)
            rl.draw_texture_rec(rl.Texture2D(screen_camera2.texture), split_screen_rect, rl.Vector2 { f32(screen_width)/2.0, 0 }, rl.white)
            
            rl.draw_rectangle(rl.get_screen_width()/2 - 2, 0, 4, rl.get_screen_height(), rl.lightgray)
        rl.end_drawing()
    }
}
