/*******************************************************************************************
*
*   raylib [core] example - Basic window (adapted for HTML5 platform)
*
*   NOTE: This example is prepared to compile for PLATFORM_WEB, and PLATFORM_DESKTOP
*   As you will notice, code structure is slightly diferent to the other examples...
*   To compile it for PLATFORM_WEB just uncomment #define PLATFORM_WEB at beginning
*
*   Example originally created with raylib 1.3, last time updated with raylib 1.3
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2015-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


//----------------------------------------------------------------------------------
// Global Variables Definition
//----------------------------------------------------------------------------------
const screen_width  = 800
const screen_height = 450


$if PLATFORM_WEB ? {
    #include <emscripten/emscripten.h>
    // fn C.emscripten_set_main_loop(voidptr, int, int)
}


//----------------------------------------------------------------------------------
// Module Functions Definition
//----------------------------------------------------------------------------------
fn update_draw_frame() {
    // Update
    //----------------------------------------------------------------------------------
    // TODO: Update your variables here
    //----------------------------------------------------------------------------------

    // Draw
    //----------------------------------------------------------------------------------
    rl.begin_drawing()

        rl.clear_background(rl.raywhite)

        rl.draw_text("Congrats! You created your first window!", 190, 200, 20, rl.black)

    rl.end_drawing()
    //----------------------------------------------------------------------------------
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    rl.init_window(screen_width, screen_height, "raylib [core] example - basic window")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

$if PLATFORM_WEB ? {
    C.emscripten_set_main_loop(update_draw_frame, 0, 1)
}    
    rl.set_target_fps(60)   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        update_draw_frame()
    }
}
