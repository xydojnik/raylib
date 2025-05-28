/*******************************************************************************************
*
*   raylib [text] example - raylib fonts loading
*
*   NOTE: raylib is distributed with some free to use fonts (even for commercial pourposes!)
*         To view details and credits for those fonts, check raylib license file
*
*   Example originally created with raylib 1.7, last time updated with raylib 3.7
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const asset_path = @VMODROOT+'/thirdparty/raylib/examples/text/resources/'
const max_fonts  = 8

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [text] example - raylib fonts')
    defer { rl.close_window() }               // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    fonts := [
        rl.load_font(asset_path+'fonts/alagard.png'),
        rl.load_font(asset_path+'fonts/pixelplay.png'),
        rl.load_font(asset_path+'fonts/mecha.png'),
        rl.load_font(asset_path+'fonts/setback.png'),
        rl.load_font(asset_path+'fonts/romulus.png'),
        rl.load_font(asset_path+'fonts/pixantiqua.png'),
        rl.load_font(asset_path+'fonts/alpha_beta.png'),
        rl.load_font(asset_path+'fonts/jupiter_crash.png')
    ]
    defer { for font in fonts { rl.unload_font(font) } }     // Fonts unloading
    
    messages := [
        'ALAGARD FONT designed by Hewett Tsoi',
        'PIXELPLAY FONT designed by Aleksander Shevchuk',
        'MECHA FONT designed by Captain Falcon',
        'SETBACK FONT designed by Brian Kent (AEnigma)',
        'ROMULUS FONT designed by Hewett Tsoi',
        'PIXANTIQUA FONT designed by Gerhard Grossmann',
        'ALPHA_BETA FONT designed by Brian Kent (AEnigma)',
        'JUPITER_CRASH FONT designed by Brian Kent (AEnigma)'
    ]
    spacings := [ int(2), 4, 8, 4, 3, 4, 4, 1 ]

    mut positions:= []rl.Vector2 { len: max_fonts }
    for i, mut position in positions {
        position.x = f32(screen_width)/2.0 - rl.measure_text_ex(
            fonts[i],
            messages[i],
            f32(fonts[i].baseSize)*2.0,
            f32(spacings[i])).x/2.0
        position.y = 60.0 + f32(fonts[i].baseSize) + 45.0*f32(i)
    }
    // Small Y position corrections
    positions[3].y += 8
    positions[4].y += 2
    positions[7].y -= 8

    colors := [ rl.maroon, rl.orange, rl.darkgreen, rl.darkblue, rl.darkpurple, rl.lime, rl.gold, rl.red ]

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

        rl.clear_background(rl.raywhite)

            rl.draw_text('free fonts included with raylib', 250, 20, 20, rl.darkgray)
            rl.draw_line(220, 50, 590, 50, rl.darkgray)

            for i in 0..fonts.len {
                rl.draw_text_ex(
                    fonts[i],         messages[i],
                    positions[i],     f32(fonts[i].baseSize)*2.0,
                    f32(spacings[i]), colors[i]
                )
            }

        rl.end_drawing()
    }
}
