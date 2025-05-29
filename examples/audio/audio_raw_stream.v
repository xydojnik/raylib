/*******************************************************************************************
*
*   raylib [audio] example - Raw audio streaming
*
*   Example originally created with raylib 1.6, last time updated with raylib 4.2
*
*   Example created by Ramon Santamaria (@raysan5) and reviewed by James Hofmann (@triplefox)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria (@raysan5) and James Hofmann (@triplefox)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const max_samples            =  512
const max_samples_per_update = 4096


__global (
    frequency       = f32(440.0) // Cycles per second (hz)
    audio_frequency = f32(440.0) // Audio frequency, for smoothing
    old_frequency   = f32(1.0)   // Previous value, used to test if sine needs to be rewritten, and to smoothly modulate frequency
    sine_idx        = f32(0.0)   // Index for audio rendering
)


// Audio input processing callback
fn audio_input_callback(buffer voidptr, frames u32) {
    audio_frequency = frequency + (audio_frequency - frequency)*0.95
    audio_frequency += 1.0
    audio_frequency -= 1.0

    incr := audio_frequency/44100.0
    data := &u16(buffer)

    for i in 0..frames {
        unsafe { data[i] = u16(32000.0*rl.sinf(2*rl.pi*sine_idx)) }
        sine_idx += incr
        if sine_idx > 1.0 { sine_idx -= 1.0 }
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

    rl.init_window(screen_width, screen_height, 'raylib [audio] example - raw audio streaming')
    defer { rl.close_window() }       // Close window and OpenGL context

    rl.init_audio_device()            // Initialize audio device
    defer { rl.close_audio_device() } // Close audio device (music streaming is automatically stopped)

    rl.set_audio_stream_buffer_size_default(max_samples_per_update)

    // Init raw audio stream (sample rate: 44100, sample size: 16bit-short, channels: 1-mono)
    stream := rl.load_audio_stream(44100, 16, 1)
    defer { rl.unload_audio_stream(stream) } // Close raw audio stream and delete buffers from RAM

    rl.set_audio_stream_callback(stream, &audio_input_callback)

    // Buffer for the single cycle waveform we are synthesizing
    // short *data = (short *)malloc(sizeof(short)*max_samples)
    mut data := &[]u16{ len: max_samples }
    defer { unsafe { free(data) } }

    // Frame buffer, describing the waveform when repeated over the course of a frame
    // short *write_buf = (short *)malloc(sizeof(short)*max_samples_per_update)
    // mut write_buf := &[]u16{ len: max_samples_per_update }
    // defer { unsafe { free(write_buf) } }

    rl.play_audio_stream(stream)        // Start processing stream buffer (no data loaded currently)

    // Position read in to determine next frequency
    mut mouse_position := rl.Vector2 { -100.0, -100.0 }

    // Computed size in samples of the sine wave
    mut wave_length := int(1)
    mut position    := rl.Vector2 { 0, 0 }

    rl.set_target_fps(30)            // Set our game to run at 30 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        // Sample mouse input.
        mouse_position = rl.get_mouse_position()

        if rl.is_mouse_button_down(rl.mouse_button_left) {
            fp := f32(mouse_position.y)
            frequency = 40.0 + f32(fp)

            pan := f32(mouse_position.x) / f32(screen_width)
            rl.set_audio_stream_pan(stream, pan)
        }

        // Rewrite the sine wave
        // Compute two cycles to allow the buffer padding, simplifying any modulation, resampling, etc.
        if frequency != old_frequency {
            // Compute wavelength. Limit size in both directions.
            //int oldWavelength = wave_length
            wave_length = int(22050/frequency)
            if wave_length > max_samples/2 {
                wave_length = max_samples/2
            } else if wave_length < 1 {
                wave_length = 1
            }

            // Write sine wave
            for i in 0..wave_length*2 {
                unsafe { data[i] = u16(rl.sinf(2*rl.pi*f32(i)/wave_length)*32000) }
            }
            // Make sure the rest of the line is flat
            for j := wave_length*2; j < max_samples; j++ {
                unsafe { data[j] = u16(0) }
            }

            // Scale read cursor's position to minimize transition artifacts
            // read_cursor = (int)(read_cursor * ((float)wave_length / (float)oldWavelength))
            old_frequency = frequency
        }

    /*
        // Refill audio stream if required
        if rl.is_audio_stream_processed(stream) {
            // Synthesize a buffer that is exactly the requested size
            mut write_cursor := 0
            
            for write_cursor < max_samples_per_update {
                // Start by trying to write the whole chunk at once
                mut write_length := max_samples_per_update-write_cursor

                // Limit to the maximum readable size
                read_length := wave_length-read_cursor

                if write_length > read_length {
                    write_length = read_length
                }

                // Write the slice
                unsafe { vmemcpy(write_buf + write_cursor, data + read_cursor, write_length*sizeof(short)) }

                // Update cursors and loop audio
                read_cursor = (read_cursor + write_length) % wave_length
                write_cursor += write_length
            }

            // Copy finished frame to audio stream
            rl.update_audio_stream(stream, write_buf, max_samples_per_update)
        }
    */
        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

        rl.draw_text('sine frequency: ${int(frequency)}', rl.get_screen_width() - 220, 10, 20, rl.red)
            rl.draw_text('click mouse button to change frequency or pan', 10, 10, 20, rl.darkgray)

            // Draw the current buffer state proportionate to the screen
            for i in 0..screen_width {
                position.x = f32(i)
                position.y = unsafe { 250 + f32(50*data[i*max_samples/screen_width])/32000.0 }

                rl.draw_pixel_v(position, rl.red)
            }

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
