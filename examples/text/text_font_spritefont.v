/*******************************************************************************************
*
*   raylib [text] example - Sprite font loading
*
*   NOTE: Sprite fonts should be generated following this conventions:
*
*     - Characters must be ordered starting with character 32 (Space)
*     - Every character must be contained within the same Rectangle height
*     - Every character and every line must be separated by the same distance (margin/padding)
*     - Rectangles must be defined by a MAGENTA color background
*
*   Following those constraints, a font can be provided just by an image,
*   this is quite handy to avoid additional font descriptor files (like BMFonts use).
*
*   Example originally created with raylib 1.0, last time updated with raylib 1.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [text] example - sprite font loading")
    defer { rl.close_window() }        // Close window and OpenGL context

    msgs := [ "THIS IS A custom SPRITE FONT...",
             "...and this is ANOTHER CUSTOM font...",
             "...and a THIRD one! GREAT! :D"]

    // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)
    fonts := [
        rl.load_font("resources/custom_mecha.png"),        // Font loading
        rl.load_font("resources/custom_alagard.png"),      // Font loading
        rl.load_font("resources/custom_jupiter_crash.png") // Font loading
    ]
    defer {for font in fonts {rl.unload_font(font) } }     // Font unloading

    font_positions := [
        rl.Vector2 {
            f32(screen_width)/2.0  - rl.measure_text_ex(fonts[0], msgs[0], f32(fonts[0].baseSize), -3).x/2,
            f32(screen_height)/2.0 - f32(fonts[0].baseSize)/2.0 - 80.0
        },
        rl.Vector2 {
            f32(screen_width)/2.0   - rl.measure_text_ex(fonts[1], msgs[1], f32(fonts[1].baseSize), -2.0).x/2.0,
            f32(screen_height)/2.0 - f32(fonts[1].baseSize)/2.0 - 10.0
        },
        rl.Vector2 {
            f32(screen_width)/2.0  - rl.measure_text_ex(fonts[2], msgs[2], f32(fonts[2].baseSize), 2.0).x/2.0,
            f32(screen_height)/2.0 - f32(fonts[1].baseSize)/2.0 + 50.0
        }
    ]
    pos_offsets := [int(-3), -2, 2]

    assert (msgs.len == fonts.len) && (font_positions.len == pos_offsets.len) && (msgs.len == pos_offsets.len)
    
    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update variables here...
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            for i, font in fonts {
                rl.draw_text_ex(font, msgs[i], font_positions[i], f32(font.baseSize), pos_offsets[i], rl.white)
            }

        rl.end_drawing()
    }
}
