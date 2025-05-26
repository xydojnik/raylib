module main

/*******************************************************************************************
*
*   raylib [textures] example - Image processing
*
*   NOTE: Images are loaded in CPU memory (RAM); textures are loaded in GPU memory (VRAM)
*
*   Example originally created with raylib 1.4, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2016-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

const num_processes = 9

enum ImageProcess {
    @none
    color_grayscale
    color_tint
    color_invert
    color_contrast
    color_brightness
    gaussian_blur
    flip_vertical
    flip_horizontal
}

// static const char *process_text[] = {
//     "NO PROCESSING",
//     "COLOR GRAYSCALE",
//     "COLOR TINT",
//     "COLOR INVERT",
//     "COLOR CONTRAST",
//     "COLOR BRIGHTNESS",
//     "GAUSSIAN BLUR",
//     "FLIP VERTICAL",
//     "FLIP HORIZONTAL"
// };

const process_text = [
    "NO PROCESSING",
    "COLOR GRAYSCALE",
    "COLOR TINT",
    "COLOR INVERT",
    "COLOR CONTRAST",
    "COLOR BRIGHTNESS",
    "GAUSSIAN BLUR",
    "FLIP VERTICAL",
    "FLIP HORIZONTAL"
 ]


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - image processing")
    defer { rl.close_window() }         // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)

    im_origin := rl.load_image("resources/parrots.png")   // Loaded in CPU memory (RAM)
    rl.image_format(&im_origin, rl.pixelformat_uncompressed_r8_g8_b8_a8)         // Format image to RGBA 32bit (required for texture update) <-- ISSUE
    texture := rl.load_texture_from_image(im_origin)    // Image converted to texture, GPU memory (VRAM)
    mut im_copy := rl.image_copy(im_origin)

    defer {
        rl.unload_texture(texture) // Unload texture from VRAM
        rl.unload_image(im_origin) // Unload image-origin from RAM
        rl.unload_image(im_copy)   // Unload image-copy from RAM
    }

    mut current_process := ImageProcess.@none
    mut texture_reload  := false

    mut toggle_recs     := []rl.Rectangle {len: num_processes }
    mut mouse_hover_rec := int(-1)

    for i, mut toggle_rec in toggle_recs {
        toggle_rec = rl.Rectangle { 40.0, f32(50 + 32*i), 150.0, 30.0 }
    }

    rl.set_target_fps(60)
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        // Mouse toggle group logic
        // for (int i = 0 i < num_processes i++)
        for i in 0..num_processes {
            if rl.check_collision_point_rec(rl.get_mouse_position(), toggle_recs[i]) {
                mouse_hover_rec = i

                if rl.is_mouse_button_released(rl.mouse_button_left) {
                    current_process = unsafe { ImageProcess(i) }
                    texture_reload  = true
                }
                break
            } else {
                mouse_hover_rec = -1
            }
        }

        // Keyboard toggle group logic
        if rl.is_key_pressed(rl.key_down) {
            current_process = unsafe { ImageProcess(int(current_process)+1) }
            if int(current_process) > (num_processes - 1) {
                current_process = .@none
            }
            texture_reload = true
        } else if rl.is_key_pressed(rl.key_up) {
            current_process = unsafe { ImageProcess(int(current_process)-1) }
            if int(current_process) < 0 {
                current_process = unsafe { ImageProcess(7) }
            }
            texture_reload = true
        }

        // Reload texture when required
        if texture_reload {
            rl.unload_image(im_copy)           // Unload image-copy data
            im_copy = rl.image_copy(im_origin) // Restore image-copy from image-origin

            // NOTE: Image processing is a costly CPU process to be done every frame,
            // If image processing is required in a frame-basis, it should be done
            // with a texture and by shaders
            match current_process {
                .color_grayscale { rl.image_color_grayscale(&im_copy)       }
                .color_tint      { rl.image_color_tint(&im_copy, rl.green)  }
                .color_invert    { rl.image_color_invert(&im_copy)          }
                .color_contrast  { rl.image_color_contrast(&im_copy, -40)   }
                .color_brightness{ rl.image_color_brightness(&im_copy, -80) }
                .gaussian_blur   { rl.image_blur_gaussian(&im_copy, 10)     }
                .flip_vertical   { rl.image_flip_vertical(&im_copy)         }
                .flip_horizontal { rl.image_flip_horizontal(&im_copy)       }
                else{}
            }

            pixels := rl.load_image_colors(im_copy) // Load pixel data from image (RGBA 32bit)
            rl.update_texture(texture, pixels)     // Update texture with new image data
            rl.unload_image_colors(pixels)         // Unload pixels data from RAM

            texture_reload = false
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("IMAGE PROCESSING:", 40, 30, 10, rl.darkgray)

            // Draw rectangles
            for i in 0..num_processes {
                rl.draw_rectangle_rec(
                    toggle_recs[i],
                    if (i == int(current_process)) || (i == mouse_hover_rec) { rl.skyblue } else { rl.lightgray }
                )
                rl.draw_rectangle_lines(
                    int(toggle_recs[i].x),
                    int(toggle_recs[i].y),
                    int(toggle_recs[i].width),
                    int(toggle_recs[i].height),
                    if (i == int(current_process)) || (i == mouse_hover_rec) { rl.blue } else { rl.gray }
                )
                rl.draw_text(
                    process_text[i],
                    int(toggle_recs[i].x) + int(toggle_recs[i].width)/2 - rl.measure_text(process_text[i], 10)/2,
                    int(toggle_recs[i].y) + 11, 10,
                    if (i == int(current_process)) || (i == mouse_hover_rec) { rl.darkblue } else { rl.darkgray })
            }

            rl.draw_texture(texture, screen_width - texture.width - 60, screen_height/2 - texture.height/2, rl.white)
            rl.draw_rectangle_lines(screen_width  - texture.width - 60, screen_height/2 - texture.height/2, texture.width, texture.height, rl.black)

        rl.end_drawing()
    }
}
