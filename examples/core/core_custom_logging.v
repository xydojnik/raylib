/*******************************************************************************************
*
*   raylib [core] example - Custom logging
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example contributed by Pablo Marcos Oltra (@pamarcos) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2018-2023 Pablo Marcos Oltra (@pamarcos) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr   (@xydojnik)
*
********************************************************************************************/

module main

import raylib as rl


fn get_all_indexes(str string, chr char) []int {
    mut arr := []int{}
    for i, c in str {
        if c == chr { arr << i }
    }
    return arr
}

fn parse_format(format charptr, opt voidptr) string {
    if opt == voidptr(0) { return '' }

    mut f := unsafe { cstring_to_vstring(format) }

    inds := get_all_indexes(f, u8(`%`))

    for i in inds {
        if f[i+1] == `i` {
            c_int_arr := unsafe { &int(opt)    }
            c_int     := unsafe { c_int_arr[i] }
            f = f.replace_once('%i', '${c_int }')
        }
    }
    return f
}

// Custom logging function.
// Dont know how to do THIS in VLANG.
fn custom_log(msg_type int, format charptr, opt voidptr) {
    // mut vstr := unsafe { '${time.now()} | '+format.vstring()+'\n' }
    // ap := C.va_list{}
    // C.va_start(ap, format)
    //     C.vfprintf(C.stdout, vstr.str, ap)
    // C.va_end(ap)

    println(parse_format(format, opt))

    // time_now := time.now()
    // log_type := match msg_type {
    //     rl.log_info    { 'INFO'  }
    //     rl.log_error   { 'ERROR' }
    //     rl.log_warning { 'WARN'  }
    //     rl.log_debug   { 'DEBUG' }
    //     else           { 'NONE'  }
    // }
    // C.printf(c'%s\n', 'test'.str)
    // txt := rl.text_format(format, ...args) ????
    // println("${time_now} | ${log_type}: ${unsafe {format.vstring()}}")
    // println("${log_type}: ${unsafe {format.vstring()}}")
    flush_stdout()
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    // Set custom logger
    rl.set_trace_log_callback(custom_log)

    rl.init_window(screen_width, screen_height, "raylib [core] example - custom logging")

    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

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

        rl.draw_text("Check out the console output to see the custom logger in action!", 60, 200, 20, rl.lightgray)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
