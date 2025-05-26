/*******************************************************************************************
*
*   raylib [core] example - 3d cmaera split screen
*
*   Example originally created with raylib 3.7, last time updated with raylib 4.0
*
*   Example contributed by Jeffery Myers (@JeffM2501) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Jeffery Myers     (@JeffM2501)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - 3d camera split screen")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }                    // Close window and OpenGL context
    //--------------------------------------------------------------------------------------


    // Setup player 1 camera and screen
    mut camera_player1 := rl.Camera {
        fovy:       45.0,
        up:         rl.Vector3{ 0.0, 1.0, 0.0 },
        target:     rl.Vector3{ 0.0, 1.0, 0.0 },
        position:   rl.Vector3{ 0.0, 1.0,-3.0 }
    }

    screen_player1 := rl.load_render_texture(screen_width/2, screen_height)
    defer {  rl.unload_render_texture(screen_player1) } // Unload render texture

    // Setup player two camera and screen
    mut camera_player2 := rl.Camera {
        fovy:       45.0,
        up:         rl.Vector3{ 0.0, 1.0, 0.0 },
        target:     rl.Vector3{ 0.0, 3.0, 0.0 },
        position:   rl.Vector3{-3.0, 3.0, 0.0 }
    }

    screen_player2 := rl.load_render_texture(screen_width / 2, screen_height)
    defer {  rl.unload_render_texture(screen_player2) } // Unload render texture

    // Build a flipped rectangle the size of the split view to use for drawing later
    split_screen_rect := rl.Rectangle {
        0.0, 0.0,
        f32(screen_player1.texture.width),
        f32(-screen_player1.texture.height)
    }
    
    // Grid data
    mut count   := int(5)
    mut spacing := f32(4)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // If anyone moves this frame, how far will they move based on the time since the last frame
        // this moves thigns at 10 world units per second, regardless of the actual FPS
        mut offset_this_frame := 10.0*rl.get_frame_time()

        // Move Player1 forward and backwards (no turning)
        if rl.is_key_down(rl.key_w) {
            camera_player1.position.z += offset_this_frame
            camera_player1.target.z   += offset_this_frame
        }
        else if rl.is_key_down(rl.key_s) {
            camera_player1.position.z -= offset_this_frame
            camera_player1.target.z   -= offset_this_frame
        }

        // Move Player2 forward and backwards (no turning)
        if rl.is_key_down(rl.key_up) {
            camera_player2.position.x += offset_this_frame
            camera_player2.target.x   += offset_this_frame
        } else if rl.is_key_down(rl.key_down) {
            camera_player2.position.x -= offset_this_frame
            camera_player2.target.x   -= offset_this_frame
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        // Draw Player1 view to the render texture
        rl.begin_texture_mode(screen_player1)
            rl.clear_background(rl.skyblue)
            
            rl.begin_mode_3d(rl.Camera3D(camera_player1))
            
                // Draw scene: grid of cube trees on a plane to make a "world"
                rl.draw_plane(rl.Vector3 { 0, 0, 0 }, rl.Vector2 { 50, 50 }, rl.beige) // Simple world plane

                // for (float x = -count*spacing x <= count*spacing x += spacing) {
                //     for (float z = -count*spacing z <= count*spacing z += spacing) {

                for x := -count*spacing; x <= count*spacing; x += spacing {
                    for z := -count*spacing; z <= count*spacing;  z += spacing {
                        rl.draw_cube(rl.Vector3  { x, 1.5, z }, 1, 1, 1, rl.lime)
                        rl.draw_cube(rl.Vector3  { x, 0.5, z }, 0.25, 1, 0.25, rl.brown)
                    }
                }

                // Draw a cube at each player's position
                rl.draw_cube(camera_player1.position, 1, 1, 1, rl.red)
                rl.draw_cube(camera_player2.position, 1, 1, 1, rl.blue)
                
            rl.end_mode_3d()
            
            rl.draw_rectangle(0, 0, rl.get_screen_width()/2, 40, rl.Color.fade(rl.raywhite, 0.8))
            rl.draw_text("PLAYER1: W/S to move", 10, 10, 20, rl.maroon)
            
        rl.end_texture_mode()

        // Draw Player2 view to the render texture
        rl.begin_texture_mode(screen_player2)
            rl.clear_background(rl.skyblue)
            
            rl.begin_mode_3d(rl.Camera3D(camera_player2))
            
                // Draw scene: grid of cube trees on a plane to make a "world"
                rl.draw_plane(rl.Vector3 { 0, 0, 0 }, rl.Vector2 { 50, 50 }, rl.beige) // Simple world plane

                // for (float x = -count*spacing x <= count*spacing x += spacing) {
                //     for (float z = -count*spacing z <= count*spacing z += spacing) {
                for x := -count*spacing; x <= count*spacing; x += spacing {
                    for z := -count*spacing; z <= count*spacing;  z += spacing {
                        rl.draw_cube(rl.Vector3  { x, 1.5, z }, 1, 1, 1, rl.lime)
                        rl.draw_cube(rl.Vector3  { x, 0.5, z }, 0.25, 1, 0.25, rl.brown)
                    }
                }

                // Draw a cube at each player's position
                rl.draw_cube(camera_player1.position, 1, 1, 1, rl.red)
                rl.draw_cube(camera_player2.position, 1, 1, 1, rl.blue)
                
            rl.end_mode_3d()
            
            rl.draw_rectangle(0, 0, rl.get_screen_width()/2, 40, rl.Color.fade(rl.raywhite, 0.8))
            rl.draw_text("PLAYER2: UP/DOWN to move", 10, 10, 20, rl.darkblue)
            
        rl.end_texture_mode()

        // Draw both views render textures to the screen side by side
        rl.begin_drawing()
            rl.clear_background(rl.black)
            
            rl.draw_texture_rec(rl.Texture2D(screen_player1.texture), split_screen_rect, rl.Vector2 { 0, 0 }, rl.white)
            rl.draw_texture_rec(rl.Texture2D(screen_player2.texture), split_screen_rect, rl.Vector2 { f32(screen_width)/2.0, 0 }, rl.white)
            
            rl.draw_rectangle(rl.get_screen_width()/2 - 2, 0, 4, rl.get_screen_height(), rl.lightgray)
        rl.end_drawing()
    }
}
