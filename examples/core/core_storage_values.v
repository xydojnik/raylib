/*******************************************************************************************
*
*   raylib [core] example - Storage save/load values
*
*   Example originally created with raylib 1.4, last time updated with raylib 4.2
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


// TODO: Not working at this time. Too lazy to fix.

const storage_data_file = "storage.data"   // Storage file

// NOTE: Storage positions must start with 0, directly related to file memory layout
const storage_position_score   = 0
const storage_position_hiscore = 1

// Persistent storage functions
// Save integer value to storage file (to defined position)
// NOTE: Storage positions is directly related to file memory layout (4 bytes each integer)
fn save_storage_value(position u32, value int) bool  {
    mut success       := false
    mut new_data_size := u32(0)
    
    mut data_size := int(0)
    mut file_data := rl.load_file_data(storage_data_file, &data_size)
    mut new_file_data := []u8{ len: data_size }
    
    if new_file_data.len > 0 {
        if data_size <= (position*sizeof(int)) {
            new_data_size = (position + 1)*sizeof(int)

            if new_file_data.data != voidptr(0) {
                // RL_REALLOC succeded
                data_ptr := &int(new_file_data.data)
                unsafe { data_ptr[position] = value }
            } else {
                // RL_REALLOC failed
                println("FILEIO: [${storage_data_file}] Failed to realloc data (${data_size}), position in bytes (${position*sizeof(int)}) bigger than actual file size")

                // We store the old size of the file
                unsafe { new_file_data.data = file_data }
                new_data_size = u32(data_size)
            }
        } else {
            // Store the old size of the file
            unsafe { new_file_data.data = file_data }
            new_data_size = u32(data_size)

            data_ptr := &int(new_file_data.data)
            unsafe { data_ptr[position] = value }
        }

        success = rl.save_file_data(storage_data_file, new_file_data.data, new_data_size)
        unsafe { free(new_file_data)} // rl.rl_free(new_file_data)

        println("FILEIO: [${storage_data_file}] Saved storage value: ${value}")
    } else {
        println("FILEIO: [${storage_data_file}] File created successfully", )

        data_size = int((position + 1)*sizeof(int))
        file_data = &[]u8{len: data_size}
        unsafe {
            data_ptr := &int(file_data)
            data_ptr[position] = value
        }

        success = rl.save_file_data(storage_data_file, file_data, u32(data_size))
        rl.unload_file_data(file_data)

        println("FILEIO: [${storage_data_file}] Saved storage value: ${value}")
    }
    return success
}


// Load integer value from storage file (from defined position)
// NOTE: If requested position could not be found, value 0 is returned
fn load_storage_value(position u32) int {
    mut value     := int(0)
    mut data_size := int(0)
    mut file_data := rl.load_file_data(storage_data_file, &data_size)

    if file_data != voidptr(0) {
        if data_size < (position*4) {
            println("FILEIO: [${storage_data_file}] Failed to find storage position: ${position}")
        } else {
            value = unsafe { file_data[position] }
            return value
        }

        rl.unload_file_data(file_data)
        println("FILEIO: [${storage_data_file}] Loaded storage value: ${value}")
    }
    return 0
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - storage save/load values")

    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut score          := int(0)
    mut hiscore        := int(0)
    mut frames_counter := int(0)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_r) {
            score   = rl.get_random_value(1000, 2000)
            hiscore = rl.get_random_value(2000, 4000)
        }

        if rl.is_key_pressed(rl.key_enter) {
            save_storage_value(storage_position_score, score)
            save_storage_value(storage_position_hiscore, hiscore)
        } else if rl.is_key_pressed(rl.key_space) {
            // NOTE: If requested position could not be found, value 0 is returned
            score   = load_storage_value(storage_position_score)
            hiscore = load_storage_value(storage_position_hiscore)
        }

        frames_counter++
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text("SCORE:    ${score}", 280, 130, 40, rl.maroon)
            rl.draw_text("HI-SCORE: ${hiscore}", 210, 200, 50, rl.black)

            rl.draw_text("frames: ${frames_counter}", 10, 10, 20, rl.lime)

            rl.draw_text("Press R to generate random numbers", 220, 40, 20, rl.lightgray)
            rl.draw_text("Press ENTER to SAVE values", 250, 310, 20, rl.lightgray)
            rl.draw_text("Press SPACE to LOAD values", 252, 350, 20, rl.lightgray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
