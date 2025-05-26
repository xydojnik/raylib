module main

/*******************************************************************************************
*
*   raylib [textures] example - gif playing
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

const max_frame_delay = 20
const min_frame_delay =  1

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - gif playing")
    defer { rl.close_window() }                // Close window and OpenGL context

    anim_frames := int(0)

    // Load all GIF animation frames into a single Image
    // NOTE: GIF data is always loaded as RGBA (32bit) by default
    // NOTE: Frames are just appended one after another in image.data memory
    im_scarfy_anim := rl.load_image_anim("resources/scarfy_run.gif", &anim_frames)

    // Load texture from image
    // NOTE: We will update this texture when required with next frame data
    // WARNING: It's not recommended to use this technique for sprites animation,
    // use spritesheets instead, like illustrated in textures_sprite_anim example
    tex_scarfy_anim := rl.load_texture_from_image(im_scarfy_anim)

    defer {
        rl.unload_texture(tex_scarfy_anim) // Unload texture
        rl.unload_image(im_scarfy_anim)    // Unload image (contains all frames)
    }
    
    mut next_frame_data_offset := int(0)   // Current byte offset to next frame in image.data

    mut current_anim_frame := int(0)        // Current animation frame to load and draw
    mut frame_delay        := int(8)        // Frame delay to switch between animation frames
    mut frame_counter      := int(0)        // General frames counter

    rl.set_target_fps(60)                  // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        frame_counter++
        if frame_counter >= frame_delay {
            // Move to next frame
            // NOTE: If final frame is reached we return to first frame
            current_anim_frame++
            if current_anim_frame >= anim_frames { current_anim_frame = 0 }

            // Get memory offset position for next frame data in image.data
            next_frame_data_offset = im_scarfy_anim.width*im_scarfy_anim.height*4*current_anim_frame

            // Update GPU texture data with next frame image data
            // WARNING: Data size (frame size) and pixel format must match already created texture
            rl.update_texture(
                tex_scarfy_anim,
                unsafe { &u8(im_scarfy_anim.data) + next_frame_data_offset }
            )

            frame_counter = 0
        }

        // Control frames delay
        if      rl.is_key_pressed(rl.key_right) { frame_delay++ }
        else if rl.is_key_pressed(rl.key_left)  { frame_delay-- }

        if      frame_delay > max_frame_delay { frame_delay = max_frame_delay }
        else if frame_delay < min_frame_delay { frame_delay = min_frame_delay }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("TOTAL GIF FRAMES:  ${anim_frames}", 50, 30, 20, rl.lightgray)
            rl.draw_text("CURRENT FRAME: ${current_anim_frame}", 50, 60, 20, rl.gray)
            rl.draw_text("CURRENT FRAME IMAGE.DATA OFFSET: ${next_frame_data_offset}", 50, 90, 20, rl.gray)

            rl.draw_text("FRAMES DELAY: ", 100, 305, 10, rl.darkgray)
            rl.draw_text("${frame_delay} frames", 620, 305, 10, rl.darkgray)
            rl.draw_text("PRESS RIGHT/LEFT KEYS to CHANGE SPEED!", 290, 350, 10, rl.darkgray)

            for i := 0; i < max_frame_delay; i++ {
                if i < frame_delay {
                    rl.draw_rectangle(190 + 21*i, 300, 20, 20, rl.red)
                }
                rl.draw_rectangle_lines(190 + 21*i, 300, 20, 20, rl.maroon)
            }

            rl.draw_texture(tex_scarfy_anim, rl.get_screen_width()/2 - tex_scarfy_anim.width/2, 140, rl.white)

            rl.draw_text("(c) Scarfy sprite by Eiden Marsal", screen_width - 200, screen_height - 20, 10, rl.gray)

        rl.end_drawing()
    }
}
