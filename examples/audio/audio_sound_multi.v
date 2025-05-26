/*******************************************************************************************
*
*   raylib [audio] example - Playing sound multiple times
*
*   Example originally created with raylib 4.6
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2023 Jeffery Myers    (@JeffM2501)
*   Translated&Modified (c) 2024 Fedorov Alexandr (@xydojnik)
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

    rl.init_window(screen_width, screen_height, 'raylib [audio] example - playing sound multiple times')
    defer { rl.close_window() }

    rl.init_audio_device()                                        // Initialize audio device
    defer { rl.close_audio_device() }

    max_sounds := 10
    mut sound_array := []rl.Sound { len: max_sounds }

    sound_array[0] = rl.load_sound(asset_path+'sound.wav')         // Load WAV audio file into the first slot as the 'source' sound
    for i in 0..sound_array.len {                                 // this sound owns the sample data
        sound_array[i] = rl.load_sound_alias(sound_array[0])      // Load an alias of the sound into slots 1-9. These do not own the sound data, but can be played
    }
    defer {
        for sound in sound_array { rl.unload_sound_alias(sound) } // Unload sound aliases
                                                                  // rl.unload_sound(sound_array[0]) // Unload source sound data
    }
    mut current_sound := int(0)                                   // set the sound list to the start

    rl.set_target_fps(60)                                         // Set our game to run at 60 frames-per-second

    //--------------------------------------------------------------------------------------
    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_space) {
            rl.play_sound(sound_array[current_sound])              // play the next open sound slot
            current_sound++                                        // increment the sound slot
            if current_sound >= max_sounds {                       // if the sound slot is out of bounds, go back to 0
                current_sound = 0
            }
            // Note: a better way would be to look at the list for the first sound that is not playing and use that slot
        }

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text('Press SPACE to PLAY a WAV sound!', 200, 180, 20, rl.lightgray)

        rl.end_drawing()
    }
}
