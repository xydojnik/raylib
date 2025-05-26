/*******************************************************************************************
*
*   raylib [audio] example - Sound loading and playing
*
*   Example originally created with raylib 1.1, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const asset_path = @VMODROOT+'/thirdparty/raylib/examples/audio/resources/'


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [audio] example - sound loading and playing')
    defer { rl.close_window() }         // Close window and OpenGL context

    rl.init_audio_device()            // Initialize audio device
    defer { rl.close_audio_device() } // Close audio device

    fx_wav := rl.load_sound(asset_path+'sound.wav')         // Load WAV audio file
    fx_ogg := rl.load_sound(asset_path+'target.ogg')        // Load OGG audio file
    defer {
        rl.unload_sound(fx_wav)     // Unload sound data
        rl.unload_sound(fx_ogg)     // Unload sound data
    }

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_space) { rl.play_sound(fx_wav) } // Play WAV sound
        if rl.is_key_pressed(rl.key_enter) { rl.play_sound(fx_ogg) } // Play OGG sound
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text('Press SPACE to PLAY the WAV sound!', 200, 180, 20, rl.lightgray)
            rl.draw_text('Press ENTER to PLAY the OGG sound!', 200, 220, 20, rl.lightgray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
