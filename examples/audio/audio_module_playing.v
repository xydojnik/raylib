/*******************************************************************************************
*
*   raylib [audio] example - Module playing (streaming)
*
*   Example originally created with raylib 1.5, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2016-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const asset_path  = @VMODROOT+'/thirdparty/raylib/examples/audio/resources/'
const max_circles = 64


struct CircleWave {
mut:
    position rl.Vector2 
    radius   f32
    alpha    f32
    speed    f32
    color    rl.Color
} 


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint) // NOTE: Try to enable MSAA 4X

    rl.init_window(screen_width, screen_height, 'raylib [audio] example - module playing (streaming)')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }         // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    rl.init_audio_device()              // Initialize audio device
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_audio_device() }   // Close audio device (music streaming is automatically stopped)
    //--------------------------------------------------------------------------------------

    colors := [
        rl.Color(rl.orange), rl.red,       rl.gold,   
                 rl.lime,    rl.blue,      rl.violet,
                 rl.brown,   rl.lightgray, rl.pink,   
                 rl.yellow,  rl.green,     rl.skyblue,
                 rl.purple,  rl.beige
    ]!

    // Creates some circles for visual effect
    mut circles := []CircleWave { len: max_circles }
    for mut circle in circles {
        circle.alpha      = 0.0
        circle.radius     = f32(rl.get_random_value(10, 40))
        circle.position.x = f32(rl.get_random_value(int(circle.radius), int((screen_width - circle.radius))))
        circle.position.y = f32(rl.get_random_value(int(circle.radius), int((screen_height - circle.radius))))
        circle.speed      = f32(rl.get_random_value(1, 100))/2000.0
        circle.color      = colors[rl.get_random_value(0, 13)]
    }

    mut music := rl.load_music_stream(asset_path+'mini1111.xm')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.unload_music_stream(music) }         // Unload music stream buffers from RAM
    //--------------------------------------------------------------------------------------

    music.looping = false
    mut pitch := f32(1.0)

    rl.play_music_stream(music)

    mut time_played := 0.0
    mut pause       := false

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_music_stream(music)      // Update music buffer with new stream data

        // Restart music playing (stop and play)
        if rl.is_key_pressed(rl.key_space) {
            rl.stop_music_stream(music)
            rl.play_music_stream(music)
            pause = false
        }

        // Pause/Resume music playing
        if rl.is_key_pressed(rl.key_p) {
            pause = !pause

            if pause { rl.pause_music_stream (music) }
            else     { rl.resume_music_stream(music) }
        }

        if      rl.is_key_down(rl.key_down) { pitch -= 0.01 }
        else if rl.is_key_down(rl.key_up)   { pitch += 0.01 }

        pitch = rl.clamp(pitch, f32(0), f32(10))

        rl.set_music_pitch(music, pitch)

        // Get time_played scaled to bar dimensions
        time_played = rl.get_music_time_played(music)/rl.get_music_time_length(music)*(screen_width - 40)

        // Color circles animation
        if !pause {
            for mut circle in circles {
                circle.alpha  += circle.speed
                circle.radius += circle.speed*10.0

                if circle.alpha > 1.0 {
                    circle.speed *= -1
                }

                if circle.alpha <= 0.0 {
                    circle.alpha      = 0.0
                    circle.radius     = f32(rl.get_random_value(10, 40))
                    circle.position.x = f32(rl.get_random_value(int(circle.radius), int((screen_width  - circle.radius))))
                    circle.position.y = f32(rl.get_random_value(int(circle.radius), int((screen_height - circle.radius))))
                    circle.color      = colors[rl.get_random_value(0, colors.len-1)]
                    circle.speed      = f32(rl.get_random_value(1, 100))/2000.0
                }
            }
        }

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)
        
            for circle in circles {
                rl.draw_circle_v(circle.position, circle.radius, rl.Color.fade(circle.color, circle.alpha))
            }

            // Draw time bar
            rl.draw_rectangle(20, screen_height - 20 - 12, screen_width-40,  12, rl.lightgray)
            rl.draw_rectangle(20, screen_height - 20 - 12, int(time_played), 12, rl.maroon)
            rl.draw_rectangle_lines(20, screen_height - 20 - 12, screen_width - 40, 12, rl.gray)

            // Draw help instructions
            rl.draw_rectangle(20, 20, 425, 145, rl.white)
            rl.draw_rectangle_lines(20, 20, 425, 145, rl.gray)
            rl.draw_text('PRESS SPACE TO RESTART MUSIC',  40, 40 , 20, rl.black)
            rl.draw_text('PRESS P TO PAUSE/RESUME',       40, 70 , 20, rl.black)
            rl.draw_text('PRESS UP/DOWN TO CHANGE SPEED', 40, 100, 20, rl.black)
            rl.draw_text('SPEED: ${pitch}',               40, 130, 20, rl.maroon)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
