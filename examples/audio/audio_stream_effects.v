/*******************************************************************************************
*
*   raylib [audio] example - Music stream processing effects
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2022-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


__global(
    // Required delay effect variables
    delay_buffer      = &[]f32(0)
    delay_buffer_size = u32(0)
    delay_read_index  = u32(2)
    delay_write_index = u32(0)

    low = [ f32(0.0), 0.0 ]!
)


//------------------------------------------------------------------------------------
// Module Functions Definition
//------------------------------------------------------------------------------------
// Audio effect: lowpass filter
fn audio_process_effect_lpf(buffer voidptr, frames u32) {
    cutoff := 70.0 / 44100.0 // 70 Hz lowpass filter
    unsafe {
        mut fbuffer := &f32(buffer)

        k := cutoff / (cutoff + 0.1591549431) // RC filter formula

        for i := 0; i < frames*2; i += 2 {
            l := fbuffer[i+0]
            r := fbuffer[i+1]

            low[0] += f32(k * (l - low[0]))
            low[1] += f32(k * (r - low[1]))

            fbuffer[i+0] = low[0]
            fbuffer[i+1] = low[1]
        }
    }
}

// Audio effect: delay
fn audio_process_effect_delay(buffer voidptr, frames u32) {
    unsafe {
        fbuffer := &f32(buffer)
        for i := 0; i < frames*2; i += 2 {
            left_delay  := delay_buffer[delay_read_index]
            delay_read_index++
            right_delay := delay_buffer[delay_read_index]
            delay_read_index++

            if delay_read_index == delay_buffer_size {
                delay_read_index = 0
            }

            fbuffer[i+0] = 0.5*fbuffer[i+0] + 0.5*left_delay
            fbuffer[i+1] = 0.5*fbuffer[i+1] + 0.5*right_delay

            delay_buffer[delay_write_index] = fbuffer[i+0]
            delay_read_index++
            delay_buffer[delay_write_index] = fbuffer[i+1]
            delay_read_index++

            if delay_write_index == delay_buffer_size {
                delay_write_index = 0
            }
        }
    }
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [audio] example - stream effects")
    defer { rl.close_window() }

    rl.init_audio_device()                  // Initialize audio device
    defer { rl.close_audio_device() }

    music := rl.load_music_stream("resources/country.mp3")
    defer { rl.unload_music_stream(music) } // Unload music stream buffers from RAM

    // Allocate buffer for the delay effect
    delay_buffer_size = u32(48000*2)        // 1 second delay (device sampleRate*channels);
    delay_buffer      = &[]f32{ len: int(delay_buffer_size) }
    defer { unsafe { free(delay_buffer) } }

    rl.play_music_stream(music)

    mut time_played := f32(0.0)             // Time played normalized [0.0f..1.0f]
    mut pause := false                      // Music playing paused
    
    mut enable_effect_lpf   := false        // Enable effect low-pass-filter
    mut enable_effect_delay := false        // Enable effect delay (1 second)

    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {         // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_music_stream(music)       // Update music buffer with new stream data

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

        // Add/Remove effect: lowpass filter
        if rl.is_key_pressed(rl.key_f) {
            enable_effect_lpf = !enable_effect_lpf
            if enable_effect_lpf {
                rl.attach_audio_stream_processor(music.stream, audio_process_effect_lpf)
            } else {
                rl.detach_audio_stream_processor(music.stream, audio_process_effect_lpf)
            }
        }

        // Add/Remove effect: delay
        if rl.is_key_pressed(rl.key_d) {
            enable_effect_delay = !enable_effect_delay
            if enable_effect_delay {
                rl.attach_audio_stream_processor(music.stream, audio_process_effect_delay)
            } else {
                rl.detach_audio_stream_processor(music.stream, audio_process_effect_delay)
            }
        }
        
        // Get normalized time played for current music stream
        time_played = rl.get_music_time_played(music)/rl.get_music_time_length(music)

        if time_played > 1.0 { time_played = 1.0 }  // Make sure time played is no longer than music
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("MUSIC SHOULD BE PLAYING!", 245, 150, 20, rl.lightgray)

            rl.draw_rectangle(200, 180, 400, 12, rl.lightgray)
            rl.draw_rectangle(200, 180, int(time_played*400.0), 12, rl.maroon)
            rl.draw_rectangle_lines(200, 180, 400, 12, rl.gray)

            rl.draw_text("PRESS SPACE TO RESTART MUSIC",  215, 230, 20, rl.lightgray)
            rl.draw_text("PRESS P TO PAUSE/RESUME MUSIC", 208, 260, 20, rl.lightgray)
            
            mut on_off := if enable_effect_lpf { "ON" } else { "OFF" }
            rl.draw_text(
                "PRESS F TO TOGGLE LPF EFFECT: ${on_off}", 200, 320, 20, rl.gray)

            on_off = if enable_effect_delay { "ON" } else { "OFF" }
            rl.draw_text(
                "PRESS D TO TOGGLE DELAY EFFECT: ${on_off}", 180, 350, 20, rl.gray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
