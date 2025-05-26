/*******************************************************************************************
*
*   raylib [audio] example - Music playing (streaming)
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


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [audio] example - music playing (streaming)")
    defer { rl.close_window() } // Close window and OpenGL context

    rl.init_audio_device()            // Initialize audio device
    defer { rl.close_audio_device() } // Close audio device (music streaming is automatically stopped)

    music := rl.load_music_stream("resources/country.mp3")
    defer { rl.unload_music_stream(music) } // Unload music stream buffers from RAM

    rl.play_music_stream(music)

    mut time_played := f32(0.0) // Time played normalized [0.0f..1.0f]
    mut pause       := false    // Music playing paused

    rl.set_target_fps(30)       // Set our game to run at 30 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_music_stream(music)   // Update music buffer with new stream data
        
        // Restart music playing (stop and play)
        if rl.is_key_pressed(rl.key_space) {
            rl.stop_music_stream(music)
            rl.play_music_stream(music)
        }

        // Pause/Resume music playing
        if rl.is_key_pressed(rl.key_p) {
            pause = !pause

            if pause {
                rl.pause_music_stream(music)
            } else {
                rl.resume_music_stream(music)
            }
        }

        // Get normalized time played for current music stream
        time_played = rl.get_music_time_played(music)/rl.get_music_time_length(music)

        if time_played > 1.0 { time_played = 1.0 } // Make sure time played is no longer than music
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("MUSIC SHOULD BE PLAYING!", 255, 150, 20, rl.lightgray)

            rl.draw_rectangle(200, 200, 400                   , 12, rl.lightgray)
            rl.draw_rectangle(200, 200, int(time_played*400.0), 12, rl.maroon)
            rl.draw_rectangle_lines(200, 200, 400, 12, rl.gray)

            rl.draw_text("PRESS SPACE TO RESTART MUSIC",  215, 250, 20, rl.lightgray)
            rl.draw_text("PRESS P TO PAUSE/RESUME MUSIC", 208, 280, 20, rl.lightgray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
