/*******************************************************************************************
*
*   raylib [core] example - Smooth Pixel-perfect camera
*
*   Example originally created with raylib 3.7, last time updated with raylib 4.0
*   
*   Example contributed by Giancamillo Alessandroni (@NotManyIdeasDev) and
*   reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Giancamillo Alessandroni (@NotManyIdeasDev) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr         (@xydojnik)
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
    mut screen_width          := 800
    mut screen_height         := 450

    mut virtual_screen_width  := 160
    mut virtual_screen_height := 90

    virtual_ratio := f32(screen_width)/f32(virtual_screen_width)

    rl.init_window(screen_width, screen_height, "raylib [core] example - smooth pixel-perfect camera")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }                 // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut world_space_camera := rl.Camera2D {     // Game world camera
        zoom: 1.0
    }

    mut screen_space_camera := rl.Camera2D {    // Smoothing camera
        zoom: 1.0
    }

    target := rl.load_render_texture(virtual_screen_width, virtual_screen_height) // This is where we'll draw all our objects.
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.unload_render_texture(target) }  // Unload render texture
    //--------------------------------------------------------------------------------------

    rec01 := rl.Rectangle { 70.0, 35.0, 20.0, 20.0 }
    rec02 := rl.Rectangle { 90.0, 55.0, 30.0, 10.0 }
    rec03 := rl.Rectangle { 80.0, 65.0, 15.0, 25.0 }

    // The target's height is flipped (in the source Rectangle), due to OpenGL reasons
    source_rec := rl.Rectangle { 0.0, 0.0, f32(target.texture.width), -f32(target.texture.height) }
    dest_rec   := rl.Rectangle { -virtual_ratio, -virtual_ratio, screen_width + (virtual_ratio*2), screen_height + (virtual_ratio*2) }

    origin := rl.Vector2 {}

    mut rotation := f32(0.0)

    mut camera_x := f32(0.0)
    mut camera_y := f32(0.0)

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rotation += f32(60.0*rl.get_frame_time())   // Rotate the rectangles, 60 degrees per second
        time := f32(rl.get_time())

        // Make the camera move to demonstrate the effect
        camera_x = (rl.sinf(time)*50.0) - 10.0
        camera_y =  rl.cosf(time)*30.0

        // Set the camera's target to the values computed above
        screen_space_camera.target = rl.Vector2 { camera_x, camera_y }

        // Round worldSpace coordinates, keep decimals into screenSpace coordinates
        world_space_camera.target.x   = int(screen_space_camera.target.x)
        screen_space_camera.target.x -= world_space_camera.target.x
        screen_space_camera.target.x *= virtual_ratio

        world_space_camera.target.y   = int(screen_space_camera.target.y)
        screen_space_camera.target.y -= world_space_camera.target.y
        screen_space_camera.target.y *= virtual_ratio
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_texture_mode(target)
            rl.clear_background(rl.raywhite)

            rl.begin_mode_2d(world_space_camera)
                rl.draw_rectangle_pro(rec01, origin, rotation, rl.black)
                rl.draw_rectangle_pro(rec02, origin, -rotation, rl.red)
                rl.draw_rectangle_pro(rec03, origin, rotation + 45.0, rl.blue)
            rl.end_mode_2d()
        rl.end_texture_mode()

        rl.begin_drawing()
            rl.clear_background(rl.red)

            rl.begin_mode_2d(screen_space_camera)
            rl.draw_texture_pro(rl.Texture2D(target.texture), source_rec, dest_rec, origin, 0.0, rl.white)
            rl.end_mode_2d()

            rl.draw_text("Screen resolution: ${screen_width}, ${screen_height}", 10, 10, 20, rl.darkblue)
        rl.draw_text("World resolution: ${virtual_screen_width}, ${virtual_screen_height}", 10, 40, 20, rl.darkgreen)
            rl.draw_fps(rl.get_screen_width() - 95, 10)
        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
