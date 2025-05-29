/*******************************************************************************************
*
*   raylib [textures] example - Background scrolling
*
*   Example originally created with raylib 2.0, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main

import raylib as rl


const asset_path = @VMODROOT+'/thirdparty/raylib/examples/textures/resources/'


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [textures] example - background scrolling')
    defer { rl.close_window() }        // Close window and OpenGL context

    // NOTE: Be careful, background width must be equal or bigger than screen width
    // if not, texture should be draw more than two times for scrolling effect
    background := rl.Texture.load(asset_path+'cyberpunk_street_background.png')
    midground  := rl.Texture.load(asset_path+'cyberpunk_street_midground.png')
    foreground := rl.Texture.load(asset_path+'cyberpunk_street_foreground.png')
    defer {
        background.unload()  // Unload background texture
        midground.unload()   // Unload midground texture
        foreground.unload()  // Unload foreground texture
    }

    mut scrolling_back := f32(0.0)
    mut scrolling_mid  := f32(0.0)
    mut scrolling_fore := f32(0.0)

    rl.set_target_fps(60)              // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {    // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        scrolling_back -= 0.1
        scrolling_mid  -= 0.5
        scrolling_fore -= 1.0

        // NOTE: Texture is scaled twice its size, so it sould be considered on scrolling
        if scrolling_back <= -background.width*2 { scrolling_back = 0 }
        if scrolling_mid  <= -midground.width *2 { scrolling_mid  = 0 }
        if scrolling_fore <= -foreground.width*2 { scrolling_fore = 0 }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.Color.get(0x052c46ff))

            // Draw background image twice
            // NOTE: Texture is scaled twice its size
            rl.draw_texture_ex(background, rl.Vector2 { scrolling_back, 20 }, 0.0, 2.0, rl.white)
            rl.draw_texture_ex(background, rl.Vector2 { background.width*2 + scrolling_back, 20 }, 0.0, 2.0, rl.white)

            // Draw midground image twice
            rl.draw_texture_ex(midground, rl.Vector2 { scrolling_mid, 20 }, 0.0, 2.0, rl.white)
            rl.draw_texture_ex(midground, rl.Vector2 { midground.width*2 + scrolling_mid, 20 }, 0.0, 2.0, rl.white)

            // Draw foreground image twice
            rl.draw_texture_ex(foreground, rl.Vector2 { scrolling_fore, 70 }, 0.0, 2.0, rl.white)
            rl.draw_texture_ex(foreground, rl.Vector2 { foreground.width*2 + scrolling_fore, 70 }, 0.0, 2.0, rl.white)

            rl.draw_text('BACKGROUND SCROLLING & PARALLAX', 10, 10, 20, rl.red)
            rl.draw_text('(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)', screen_width - 330, screen_height - 20, 10, rl.raywhite)

        rl.end_drawing()
    }
}
