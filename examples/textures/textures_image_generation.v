module main

/*******************************************************************************************
*
*   raylib [textures] example - Procedural images generation
*
*   Example originally created with raylib 1.8, last time updated with raylib 1.8
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2O17-2023 Wilhem Barbier    (@nounoursheureux) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl

const num_textures = 9      // Currently we have 8 generation algorithms but some are have multiple purposes (Linear and Square Gradients)

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - procedural images generation")
    defer { rl.close_window() }              // Close window and OpenGL context

    vertical_gradient   := rl.gen_image_gradient_linear(screen_width, screen_height,  0, rl.red, rl.blue)
    horizontal_gradient := rl.gen_image_gradient_linear(screen_width, screen_height, 90, rl.red, rl.blue)
    diagonal_gradient   := rl.gen_image_gradient_linear(screen_width, screen_height, 45, rl.red, rl.blue)
    radial_gradient     := rl.gen_image_gradient_radial(screen_width, screen_height, 0.0, rl.white, rl.black)
    square_gradient     := rl.gen_image_gradient_square(screen_width, screen_height, 0.0, rl.white, rl.black)
    checked             := rl.gen_image_checked(screen_width, screen_height, 32, 32, rl.red, rl.blue)
    white_noise         := rl.gen_image_white_noise(screen_width, screen_height, 0.5)
    perlin_noise        := rl.gen_image_perlin_noise(screen_width, screen_height, 50, 50, 4.0)
    cellular            := rl.gen_image_cellular(screen_width, screen_height, 32)

    // Texture2D textures[num_textures] = { 0 }
    mut textures := []rl.Texture2D { len: num_textures }
    textures[0] = rl.load_texture_from_image(vertical_gradient)
    textures[1] = rl.load_texture_from_image(horizontal_gradient)
    textures[2] = rl.load_texture_from_image(diagonal_gradient)
    textures[3] = rl.load_texture_from_image(radial_gradient)
    textures[4] = rl.load_texture_from_image(square_gradient)
    textures[5] = rl.load_texture_from_image(checked)
    textures[6] = rl.load_texture_from_image(white_noise)
    textures[7] = rl.load_texture_from_image(perlin_noise)
    textures[8] = rl.load_texture_from_image(cellular)

    // Unload image data (CPU RAM)
    rl.unload_image(vertical_gradient)
    rl.unload_image(horizontal_gradient)
    rl.unload_image(diagonal_gradient)
    rl.unload_image(radial_gradient)
    rl.unload_image(square_gradient)
    rl.unload_image(checked)
    rl.unload_image(white_noise)
    rl.unload_image(perlin_noise)
    rl.unload_image(cellular)

    // Unload textures data (GPU VRAM)
    defer { for texture in textures { rl.unload_texture(texture) } }

    mut current_texture := int(0)

    rl.set_target_fps(60)
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_mouse_button_pressed(rl.mouse_button_left) || rl.is_key_pressed(rl.key_right) {
            current_texture = (current_texture + 1)%num_textures // Cycle between the textures
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_texture(textures[current_texture], 0, 0, rl.white)

            rl.draw_rectangle(30, 400, 325, 30, rl.Color.fade(rl.skyblue, 0.5))
            rl.draw_rectangle_lines(30, 400, 325, 30, rl.Color.fade(rl.white, 0.5))
            rl.draw_text("MOUSE LEFT BUTTON to CYCLE PROCEDURAL TEXTURES", 40, 410, 10, rl.white)

            match current_texture {
                0    { rl.draw_text("VERTICAL GRADIENT",   560, 10, 20, rl.raywhite)  }
                1    { rl.draw_text("HORIZONTAL GRADIENT", 540, 10, 20, rl.raywhite)  }
                2    { rl.draw_text("DIAGONAL GRADIENT",   540, 10, 20, rl.raywhite)  }
                3    { rl.draw_text("RADIAL GRADIENT",     580, 10, 20, rl.lightgray) }
                4    { rl.draw_text("SQUARE GRADIENT",     580, 10, 20, rl.lightgray) }
                5    { rl.draw_text("CHECKED",             680, 10, 20, rl.raywhite)  }
                6    { rl.draw_text("rl.white NOISE",      640, 10, 20, rl.red)       }
                7    { rl.draw_text("PERLIN NOISE",        640, 10, 20, rl.red)       }
                8    { rl.draw_text("CELLULAR",            670, 10, 20, rl.raywhite)  }
                else {}
            }

        rl.end_drawing()
    }
}
