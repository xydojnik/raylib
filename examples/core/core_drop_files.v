/*******************************************************************************************
*
*   raylib [core] example - Windows drop files
*
*   NOTE: This example only works on platforms that support drag & drop (Windows, Linux, OSX, Html5?)
*
*   Example originally created with raylib 1.3, last time updated with raylib 4.2
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

const max_filepath_recorded = 5
const max_filepath_recorded = 4096
const max_filepath_size     = 2048

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - drop files")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }          // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // int filePathCounter = 0
    // char *file_paths[max_filepath_recorded] = { 0 } // We will register a maximum of filepaths

    mut file_paths := []string{} // We will register a maximum of filepaths

    // Allocate space for the required file paths
    // for (int i = 0 i < max_filepath_recorded i++) {
    //     file_paths[i] = (char *)RL_CALLOC(max_filepath_size, 1)
    // }

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_file_dropped() {
            dropped_files := rl.load_dropped_files()
            for i in 0..dropped_files.count {
                if file_paths.len <= max_filepath_recorded-1 {
                    file_paths << unsafe { dropped_files.paths[i].vstring() }
                } else {
                    break
                }
            }

            rl.unload_dropped_files(dropped_files)    // Unload filepaths from memory
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            if file_paths.len == 0 {
                rl.draw_text("Drop your files to this window!", 100, 40, 20, rl.darkgray)
            } else if file_paths.len >= max_filepath_recorded {
                txt      := "MAXIMUM FILES!"
                txt_size := 40
                rl.draw_text(txt, screen_width/2-((txt.len/3)*txt_size), screen_height/2-txt_size/2, txt_size, rl.red)
            } else {
                rl.draw_text("Dropped files:", 100, 40, 20, rl.darkgray)

                for i in 0..file_paths.len {
                    if i%2 == 0 {
                        rl.draw_rectangle(0, 85 + 40*i, screen_width, 40, rl.Color.fade(rl.lightgray, 0.5))
                    } else {
                        rl.draw_rectangle(0, 85 + 40*i, screen_width, 40, rl.Color.fade(rl.lightgray, 0.3))
                    }

                    rl.draw_text(file_paths[i], 120, 100 + 40*i, 10, rl.gray)
                }
                rl.draw_text("Drop new files...", 100, 110 + 40*file_paths.len, 20, rl.darkgray)
            }
        
        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    unsafe { file_paths.free() }
    // for (int i = 0 i < max_filepath_recorded i++) {
    //     RL_FREE(file_paths[i]) // Free allocated memory for all filepaths
    // }
}
