/*******************************************************************************************
*
*   raylib [audio] example - Mixed audio processing
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example contributed by hkc (@hatkidchan) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2023 hkc               (@hatkidchan)
*   Translated&Modified (c) 2024 Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


__global (
    exponent       = f32(1.0)           // Audio exponentiation value
    average_volume = []f32 { len: 400 } // Average volume history
)


//------------------------------------------------------------------------------------
// Audio processing function
//------------------------------------------------------------------------------------
fn process_audio(buffer voidptr, frames u32) {
    mut samples := &f32(buffer) // Samples internally stored as <float>s
    mut average := f32(0.0)     // Temporary average volume

    unsafe {
        for frame in 0..frames {
                mut left  := &samples[frame * 2 + 0]
                mut right := &samples[frame * 2 + 1]

                *left  = f32(rl.powf(rl.fabsf(*left) , exponent) * ( if *left  < 0.0 { -1.0 } else { 1.0 } ))
                *right = f32(rl.powf(rl.fabsf(*right), exponent) * ( if *right < 0.0 { -1.0 } else { 1.0 } ))

                average += rl.fabsf(*left)  / frames // accumulating average volume
                average += rl.fabsf(*right) / frames
            }
    }
    // Moving history to the left
    for i in 0..average_volume.len-1 {
        average_volume[i] = average_volume[i + 1]
    }
    average_volume[399] = average         // Adding last average value
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [audio] example - processing mixed output")
    defer { rl.close_window() }                              // Close window and OpenGL context

    rl.init_audio_device()                                   // Initialize audio device
    defer { rl.close_audio_device() }                        // Close audio device (music streaming is automatically stopped)

    rl.attach_audio_mixed_processor(process_audio)
    defer { rl.detach_audio_mixed_processor(process_audio) } // Disconnect audio processor

    music := rl.load_music_stream("resources/country.mp3")
    defer { rl.unload_music_stream(music) }                  // Unload music stream buffers from RAM
    
    sound := rl.load_sound("resources/coin.wav")

    rl.play_music_stream(music)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {     // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_music_stream(music)   // Update music buffer with new stream data

        // Modify processing variables
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_left)  { exponent -= 0.05 }
        if rl.is_key_pressed(rl.key_right) { exponent += 0.05 }

        if exponent <= 0.5 { exponent = 0.5 }
        if exponent >= 3.0 { exponent = 3.0 }

        if rl.is_key_pressed(rl.key_space) { rl.play_sound(sound) }

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("MUSIC SHOULD BE PLAYING!", 255, 150, 20, rl.lightgray)
            rl.draw_text("EXPONENT = ${exponent}",   215, 180, 20, rl.lightgray)

            rl.draw_rectangle(199, 199, 402, 34, rl.lightgray)

            for i, volume in average_volume {
                rl.draw_line(201 + i, int(232 - volume * 32), 201 + i, 232, rl.maroon)
            }
            rl.draw_rectangle_lines(199, 199, 402, 34, rl.gray)

            rl.draw_text("PRESS SPACE TO PLAY OTHER SOUND",               200, 250, 20, rl.lightgray)
            rl.draw_text("USE LEFT AND RIGHT ARROWS TO ALTER DISTORTION", 140, 280, 20, rl.lightgray)

        rl.end_drawing()
    }
}
