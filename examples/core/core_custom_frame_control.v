/*******************************************************************************************
*
*   raylib [core] example - custom frame control
*
*   NOTE: WARNING: This is an example for advance users willing to have full control over
*   the frame processes. By default, EndDrawing() calls the following processes:
*       1. Draw remaining batch data: rlDrawRenderBatchActive()
*       2. rl.swap_screen_buffer()
*       3. Frame time control: rl.wait_time()
*       4. rl.poll_input_events()
*
*   To avoid steps 2, 3 and 4, flag SUPPORT_CUSTOM_FRAME_CONTROL can be enabled in
*   config.h (it requires recompiling raylib). This way those steps are up to the user.
*
*   Note that enabling this flag invalidates some functions:
*       - GetFrameTime()
*       - SetTargetFPS()
*       - GetFPS()
*
*   Example originally created with raylib 4.0, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Ramon Santamaria (@raysan5)
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
    
    rl.init_window(screen_width, screen_height, "raylib [core] example - custom frame control")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Custom timming variables
    mut previous_time    := rl.get_time() // Previous time measure
    mut current_time     := f64(0.0)      // Current time measure
    mut update_draw_time := f64(0.0)      // Update + Draw time
    mut wait_time        := f64(0.0)      // Wait time (if target fps required)
    mut delta_time       := f32(0.0)      // Frame time (Update + Draw + Wait time)

    mut time_counter     := f32(0.0)      // Accumulative time counter (seconds)
    mut position         := f32(0.0)      // Circle position
    mut pause            := false         // Pause control flag

    mut target_fps       := int(60)       // Our initial target fps

    rl.set_target_fps(target_fps)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.poll_input_events()           // Poll input events (SUPPORT_CUSTOM_FRAME_CONTROL)
        
        if rl.is_key_pressed(rl.key_space) { pause = !pause }
        
        if rl.is_key_pressed(rl.key_up)    {
            target_fps += 20
            rl.set_target_fps(target_fps)
        } else if rl.is_key_pressed(rl.key_down)  {
            target_fps -= 20
            rl.set_target_fps(target_fps)
        }
        
        if target_fps < 0 { target_fps = 0 }

        if !pause {
            position += 200*delta_time  // We move at 200 pixels per second
            if position >= rl.get_screen_width() { position = 0 }
            time_counter += delta_time   // We count time (seconds)
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            for i in 0..rl.get_screen_width()/200 {
                rl.draw_rectangle(200*i, 0, 1, rl.get_screen_height(), rl.skyblue)
            }
            
            rl.draw_circle(int(position), rl.get_screen_height()/2 - 25, 50, rl.red)
            
            rl.draw_text("${time_counter*1000.0} ms", int(position) - 40, rl.get_screen_height()/2 - 100, 20, rl.maroon)
            rl.draw_text("PosX: ${position}",         int(position) - 50, rl.get_screen_height()/2 +  40, 20, rl.black)
            
            rl.draw_text("Circle is moving at a constant 200 pixels/sec,\nindependently of the frame rate.", 10, 10, 20, rl.darkgray)
            rl.draw_text("PRESS SPACE to PAUSE MOVEMENT", 10, rl.get_screen_height() - 60,  20, rl.gray)
            rl.draw_text("PRESS UP | DOWN to CHANGE TARGET FPS", 10, rl.get_screen_height() - 30,  20, rl.gray)
            rl.draw_text("TARGET FPS: ${target_fps}", rl.get_screen_width()  - 220, 10, 20, rl.lime)
            rl.draw_text("CURRENT FPS: ${int((1.0/f32(delta_time)))}", rl.get_screen_width()  - 220, 40, 20, rl.green)

        rl.end_drawing()

        // NOTE: In case raylib is configured to SUPPORT_CUSTOM_FRAME_CONTROL, 
        // Events polling, screen buffer swap and frame time control must be managed by the user
        rl.swap_screen_buffer() // Flip the back buffer to screen (front buffer)
        
        current_time     = rl.get_time()
        update_draw_time = current_time - previous_time
        
        if target_fps > 0 {        // We want a fixed frame rate
            wait_time = (1.0/f32(target_fps)) - update_draw_time
            if wait_time > 0.0 {
                rl.wait_time(f32(wait_time))
                current_time = rl.get_time()
                delta_time   = f32(current_time - previous_time)
            }
        } else {
            delta_time = f32(update_draw_time)    // Framerate could be variable
        }

        previous_time = current_time
    }
}
