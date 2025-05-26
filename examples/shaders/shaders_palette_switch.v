/*******************************************************************************************
*
*   raylib [shaders] example - Color palette switch
*
*   NOTE: This example requires raylib OpenGL 3.3 or ES2 versions for shaders support,
*         OpenGL 1.1 does not support shaders, recompile raylib to OpenGL 3.3 version.
*
*   NOTE: Shaders used in this example are #version 330 (OpenGL 3.3), to test this example
*         on OpenGL ES 2.0 platforms (Android, Raspberry Pi, HTML5), use #version 100 shaders
*         raylib comes with shaders ready for both versions, check raylib/shaders install folder
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.7
*
*   Example contributed by Marco Lizza (@MarcoLizza) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Marco Lizza       (@MarcoLizza) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const glsl_version = $if PLATFORM_DESKTOP ? { 330 } $else { 100 }

const max_palettes       = 3
const colors_per_palette = 8
const values_per_color   = 3

const palettes = [
    [ // 3-BIT RGB
          0,   0,   0,
        255,   0,   0,
          0, 255,   0,
          0,   0, 255,
          0, 255, 255,
        255,   0, 255,
        255, 255,   0,
        255, 255, 255,
    ],
    [ // AMMO-8 (GameBoy-like)
          4,  12,   6,
         17,  35,  24,
         30,  58,  41,
         48,  93,  66,
         77, 128,  97,
        137, 162,  87,
        190, 220, 127,
        238, 255, 204,
    ],
    [ // RKBV (2-strip film)
         21,  25,  26,
        138,  76,  88,
        217,  98, 117,
        230, 184, 193,
         69, 107, 115,
         75, 151, 166,
        165, 189, 194,
        255, 245, 247,
    ]
]


const palette_text = [
    "3-BIT RGB",
    "AMMO-8 (GameBoy-like)",
    "RKBV (2-strip film)"
]


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - color palette switch")
    defer { rl.close_window() }             // Close window and OpenGL context

    // Load shader to be used on some parts drawing
    // NOTE 1: Using GLSL 330 shader version, on OpenGL ES 2.0 use GLSL 100 shader version
    // NOTE 2: Defining 0 (NULL) for vertex shader forces usage of internal default vertex shader
    shader := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/palette_switch.fs".str)
    defer { rl.unload_shader(shader) }     // Unload shader

    // Get variable (uniform) location on the shader to connect with the program
    // NOTE: If uniform variable could not be found in the shader, function returns -1
    palette_loc := rl.get_shader_location(shader, "palette")

    mut current_palette := int(0)
    mut line_height     := int(screen_height/colors_per_palette)

    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {         // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if      rl.is_key_pressed(rl.key_right) { current_palette++ }
        else if rl.is_key_pressed(rl.key_left)  { current_palette-- }

        if      current_palette >= max_palettes { current_palette = 0 }
        else if current_palette < 0             { current_palette = max_palettes - 1 }

        // Send new value to the shader to be used on drawing.
        // NOTE: We are sending RGB triplets w/o the alpha channel
        rl.set_shader_value_v(shader, palette_loc, palettes[current_palette].data, rl.shader_uniform_ivec3, colors_per_palette)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_shader_mode(shader)

                for i in 0..colors_per_palette {
                    // Draw horizontal screen-wide rectangles with increasing "palette index"
                    // The used palette index is encoded in the RGB components of the pixel
                    rl.draw_rectangle(0, line_height*i, rl.get_screen_width(), line_height, rl.Color { i, i, i, 255 })
                }

            rl.end_shader_mode()

            rl.draw_text("< >", 10, 10, 30, rl.darkblue)
            rl.draw_text("CURRENT PALETTE:", 60, 15, 20, rl.raywhite)
            rl.draw_text(palette_text[current_palette], 300, 15, 20, rl.red)

            rl.draw_fps(700, 15)

        rl.end_drawing()
    }
}
