/*******************************************************************************************
*
*   raylib [text] example - Font loading
*
*   NOTE: raylib can load fonts from multiple input file formats:
*
*     - TTF/OTF > Sprite font atlas is generated on loading, user can configure
*                 some of the generation parameters (size, characters to include)
*     - BMFonts > Angel code font fileformat, sprite font image must be provided
*                 together with the .fnt file, font generation cna not be configured
*     - XNA Spritefont > Sprite font image, following XNA Spritefont conventions,
*                 Characters in image must follow some spacing and order rules
*
*   Example originally created with raylib 1.4, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2016-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024 Fedorov Alexandr     (@xydojnik)
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

    rl.init_window(screen_width, screen_height, "raylib [text] example - font loading")
    defer { rl.close_window() }     // Close window and OpenGL context

    // Define characters to draw
    // NOTE: raylib supports UTF-8 encoding, following list is actually codified as UTF8 internally
    msg := "!\"#$%&'()*+,-./0123456789:<=>?@ABCDEFGHI\nJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmn\nopqrstuvwxyz{|}~¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓ\nÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷\nøùúûüýþÿ"

    // NOTE: Textures/Fonts MUST be loaded after Window initialization (OpenGL context is required)

    // BMFont (AngelCode) : Font data and image atlas have been generated using external program
    font_bm := rl.load_font("resources/pixantiqua.fnt")

    // TTF font : Font data and atlas are generated directly from TTF
    // NOTE: We define a font base size of 32 pixels tall and up-to 250 characters
    font_ttf := rl.load_font_ex("resources/pixantiqua.ttf", 32, voidptr(0), 250)

    defer {
        rl.unload_font(font_bm)     // AngelCode Font unloading
        rl.unload_font(font_ttf)    // TTF Font unloading
    }

    rl.set_text_line_spacing(30)    // Set line spacing for multiline text (when line breaks are included '\n')

    mut use_ttf := false

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        use_ttf = rl.is_key_down(rl.key_space)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)
        
            rl.draw_text("Hold SPACE to use TTF generated font", 20, 20, 20, rl.lightgray)

            if use_ttf {
                rl.draw_text_ex(font_ttf, msg, rl.Vector2 { 20.0, 100.0 }, f32(font_ttf.baseSize), 2, rl.lime)
                rl.draw_text("Using TTF font generated", 20, rl.get_screen_height() - 30, 20, rl.gray)
            } else {
                rl.draw_text_ex(font_bm, msg, rl.Vector2 { 20.0, 100.0 }, f32(font_bm.baseSize), 2, rl.maroon)
                rl.draw_text("Using BMFont (Angelcode) imported", 20, rl.get_screen_height() - 30, 20, rl.gray)
            }

        rl.end_drawing()
    }
}
