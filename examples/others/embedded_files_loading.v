/*******************************************************************************************
*
*   raylib [others] example - Embedded files loading (Wave and Image)
*
*   Example originally created with raylib 3.0, last time updated with raylib 2.5
*
*   Example contributed by Kristian Holmgren (@defutura) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2020-2023 Kristian Holmgren (@defutura) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr  (@xydojnik)
*
********************************************************************************************/

module main


import raylib  as rl


#include "@VMODROOT/thirdparty/raylib/examples/others/resources/audio_data.h" // Wave file exported with ExportWaveAsCode()

// Wave data information
const audio_frame_count = u32(C.AUDIO_FRAME_COUNT)
const audio_sample_rate = u32(C.AUDIO_SAMPLE_RATE)
const audio_sample_size = u32(C.AUDIO_SAMPLE_SIZE)
const audio_channels    = u32(C.AUDIO_CHANNELS)
const audio_data        = voidptr(C.AUDIO_DATA)


#include "@VMODROOT/thirdparty/raylib/examples/others/resources/image_data.h" // Image file exported with ExportImageAsCode()
// Image data information
const image_width  = int(C.IMAGE_WIDTH)
const image_height = int(C.IMAGE_HEIGHT)
const image_format = int(C.IMAGE_FORMAT) // raylib internal pixel format
const image_data   = voidptr(C.IMAGE_DATA)

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [others] example - embedded files loading")
    defer { rl.close_window()  }        // Close window and OpenGL context

    rl.init_audio_device()              // Initialize audio device
    defer { rl.close_audio_device() }   // Close audio device
    
    // Loaded in CPU memory (RAM) from header file (audio_data.h)
    // Same as: Wave wave = LoadWave("sound.wav")
    wave := rl.Wave {
        data:        audio_data,
        frameCount:  audio_frame_count,
        sampleRate:  audio_sample_rate,
        sampleSize:  audio_sample_size,
        channels:    audio_channels
    }

    // // // Wave converted to Sound to be played
    sound := rl.load_sound_from_wave(wave)
    defer { rl.unload_sound(sound) }        // Unload sound from VRAM

    // With a Wave loaded from file, after Sound is loaded, we can unload Wave
    // but in our case, Wave is embedded in executable, in program .data segment
    // we can not (and should not) try to free that private memory region
    // rl.unload_wave(wave)             // Do not unload wave data!

    // Loaded in CPU memory (RAM) from header file (image_data.h)
    // Same as: Image image = LoadImage("raylib_logo.png")
    image := rl.Image {
        data:     image_data,
        width:    image_width,
        height:   image_height,
        format:   image_format,
        mipmaps:  1
    }

    // Image converted to Texture (VRAM) to be drawn
    texture := rl.load_texture_from_image(image)
    defer { rl.unload_texture(texture) }    // Unload texture from VRAM

    // With an Image loaded from file, after Texture is loaded, we can unload Image
    // but in our case, Image is embedded in executable, in program .data segment
    // we can not (and should not) try to free that private memory region
    // rl.unload_image(image)               // Do not unload image data!

    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    // //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {         // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_space) {
            rl.play_sound(sound)            // Play sound
        }
        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)
            rl.draw_texture(texture, screen_width/2 - texture.width/2, 40, rl.white)
            rl.draw_text("raylib logo and sound loaded from header files", 150, 320, 20, rl.lightgray)
            rl.draw_text("Press SPACE to PLAY the sound!", 220, 370, 20, rl.lightgray)
        rl.end_drawing()
    }
}
