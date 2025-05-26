/*******************************************************************************************
*
*   raylib [core] example - Gamepad input
*
*   NOTE: This example requires a Gamepad connected to the system
*         raylib is configured to work with the following gamepads:
*                - Xbox 360 Controller (Xbox 360, Xbox One)
*                - PLAYSTATION(R)3 Controller
*         Check raylib.h for buttons configuration
*
*   Example originally created with raylib 1.1, last time updated with raylib 4.2
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2013-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const xbox360_legacy_name_id = "Xbox Controller"
const xbox360_name_id        = "Xbox 360 Controller"
const ps3_name_id            = "PLAYSTATION(R)3 Controller"

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint)  // Set MSAA 4X hint before windows creation

    rl.init_window(screen_width, screen_height, "raylib [core] example - gamepad input")

    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    tex_ps3_pad  := rl.load_texture("resources/ps3.png")
    tex_xbox_pad := rl.load_texture("resources/xbox.png")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.unload_texture(tex_ps3_pad) }
    defer { rl.unload_texture(tex_xbox_pad) }
    //--------------------------------------------------------------------------------------

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    mut gamepad := int(0) // which gamepad to display

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // ...
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            if rl.is_key_pressed(rl.key_left) && gamepad > 0 { gamepad-- }
            if rl.is_key_pressed(rl.key_right)               { gamepad++ }

            if rl.is_gamepad_available(gamepad) {
                rl.draw_text("GP(${gamepad}): ${rl.get_gamepad_name(gamepad)}", 10, 10, 10, rl.black)

                if true {
                    rl.draw_texture(tex_xbox_pad, 0, 0, rl.darkgray)

                    // Draw buttons: xbox home
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_middle) {
                        rl.draw_circle(394, 89, 19, rl.red)
                    }

                    // Draw buttons: basic
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_middle_right    ) { rl.draw_circle( 436, 150,  9, rl.red    ) }
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_middle_left     ) { rl.draw_circle( 352, 150,  9, rl.red    ) }
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_right_face_left ) { rl.draw_circle( 501, 151, 15, rl.blue   ) }
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_right_face_down ) { rl.draw_circle( 536, 187, 15, rl.lime   ) }
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_right_face_right) { rl.draw_circle( 572, 151, 15, rl.maroon ) }
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_right_face_up   ) { rl.draw_circle( 536, 115, 15, rl.gold   ) }

                    // Draw buttons: d-pad
                    rl.draw_rectangle(317, 202, 19, 71, rl.black)
                    rl.draw_rectangle(293, 228, 69, 19, rl.black)

                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_left_face_up   ) { rl.draw_rectangle( 317,      202,      19, 26, rl.red ) }
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_left_face_down ) { rl.draw_rectangle( 317,      202 + 45, 19, 26, rl.red ) }
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_left_face_left ) { rl.draw_rectangle( 292,      228,      25, 19, rl.red ) }
                    if rl.is_gamepad_button_down( gamepad, rl.gamepad_button_left_face_right) { rl.draw_rectangle( 292 + 44, 228,      26, 19, rl.red ) }

                    // Draw buttons: left-right back
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_left_trigger_1 ) { rl.draw_circle(259, 61, 20, rl.red) }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_right_trigger_1) { rl.draw_circle(536, 61, 20, rl.red) }

                    // Draw axis: left joystick

                    mut left_gamepad_color := rl.black
                
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_left_thumb) {
                        left_gamepad_color = rl.red
                    }

                    rl.draw_circle(259, 152, 39, rl.black)
                    rl.draw_circle(259, 152, 34, rl.lightgray)
                    rl.draw_circle(
                        259 + int((rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_left_x)*20)),
                        152 + int((rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_left_y)*20)), 25, left_gamepad_color
                    )

                    // Draw axis: right joystick
                    mut right_gamepad_color := rl.black

                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_right_thumb) {
                        right_gamepad_color = rl.red
                    }
                    rl.draw_circle(461, 237, 38, rl.black)
                    rl.draw_circle(461, 237, 33, rl.lightgray)
                    rl.draw_circle(
                        461 + int((rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_right_x)*20)),
                        237 + int((rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_right_y)*20)), 25, right_gamepad_color
                    )

                    // Draw axis: left-right triggers
                    rl.draw_rectangle(170, 30, 15, 70, rl.gray)
                    rl.draw_rectangle(604, 30, 15, 70, rl.gray)

                    rl.draw_rectangle(170, 30, 15, int(((1 + rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_left_trigger)) /2)*70), rl.red)
                    rl.draw_rectangle(604, 30, 15, int(((1 + rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_right_trigger))/2)*70), rl.red)

                    rl.draw_text("Xbox axis LT: ${rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_left_trigger)}",  10, screen_height-60, 10, rl.red)
                    rl.draw_text("Xbox axis RT: ${rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_right_trigger)}", 10, screen_height-40, 10, rl.red)
                } else if rl.get_gamepad_name(gamepad) == ps3_name_id {
                    rl.draw_texture(tex_ps3_pad, 0, 0, rl.darkgray)

                    // Draw buttons: ps
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_middle) { rl.draw_circle(396, 222, 13, rl.red) }

                    // Draw buttons: basic
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_middle_left)  { rl.draw_rectangle(328, 170, 32, 13, rl.red) }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_middle_right) {
                        rl.draw_triangle(rl.Vector2 { 436, 168 }, rl.Vector2 { 436, 185 }, rl.Vector2 { 464, 177 }, rl.red)
                    }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_right_face_up   )  { rl.draw_circle(557, 144, 13, rl.lime)   }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_right_face_right)  { rl.draw_circle(586, 173, 13, rl.red)    }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_right_face_down )  { rl.draw_circle(557, 203, 13, rl.violet) }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_right_face_left )  { rl.draw_circle(527, 173, 13, rl.pink)   }

                    // Draw buttons: d-pad
                    rl.draw_rectangle(225, 132, 24, 84, rl.black)
                    rl.draw_rectangle(195, 161, 84, 25, rl.black)

                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_left_face_up   ) { rl.draw_rectangle(225,      132,      24, 29, rl.red) }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_left_face_down ) { rl.draw_rectangle(225,      132 + 54, 24, 30, rl.red) }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_left_face_left ) { rl.draw_rectangle(195,      161,      30, 25, rl.red) }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_left_face_right) { rl.draw_rectangle(195 + 54, 161,      30, 25, rl.red) }

                    // Draw buttons: left-right back buttons
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_left_trigger_1)  { rl.draw_circle(239, 82, 20, rl.red) }
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_right_trigger_1) { rl.draw_circle(557, 82, 20, rl.red) }

                    // Draw axis: left joystick
                    mut left_gamepad_color := rl.black
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_left_thumb) { left_gamepad_color = rl.red }
                    rl.draw_circle(319, 255, 35, left_gamepad_color)
                    rl.draw_circle(319, 255, 31, rl.lightgray)
                    rl.draw_circle(
                        319 + int((rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_left_x) * 20)),
                        255 + int((rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_left_y) * 20)),
                        25, left_gamepad_color
                    )

                    // Draw axis: right joystick
                    mut right_gamepad_color := rl.black
                    if rl.is_gamepad_button_down(gamepad, rl.gamepad_button_right_thumb) {
                        right_gamepad_color = rl.red
                    }
                    rl.draw_circle(475, 255, 35, rl.black)
                    rl.draw_circle(475, 255, 31, rl.lightgray)
                    rl.draw_circle(
                        475 + int((rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_right_x) * 20)),
                        255 + int((rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_right_y) * 20)),
                        25, right_gamepad_color
                    )

                    // Draw axis: left-right triggers
                    rl.draw_rectangle(169, 48, 15, 70, rl.gray)
                    rl.draw_rectangle(611, 48, 15, 70, rl.gray)
                    rl.draw_rectangle(169, 48, 15, int(((1 - rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_left_trigger))  / 2) * 70), rl.red)
                    rl.draw_rectangle(611, 48, 15, int(((1 - rl.get_gamepad_axis_movement(gamepad, rl.gamepad_axis_right_trigger)) / 2) * 70), rl.red)
                } else {
                    rl.draw_text("- GENERIC GAMEPAD -", 280, 180, 20, rl.gray)
                    // TODO: Draw generic gamepad
                }

                rl.draw_text("DETECTED AXIS [${rl.get_gamepad_axis_count(0)}]:", 10, 50, 10, rl.maroon)

                for i in 0..rl.get_gamepad_axis_count(0) {
                    rl.draw_text("AXIS ${i}: ${rl.get_gamepad_axis_movement(0, i)}", 20, 70 + 20*i, 10, rl.darkgray)
                }

                if rl.get_gamepad_button_pressed() != rl.gamepad_button_unknown {
                    rl.draw_text("DETECTED BUTTON: ${rl.get_gamepad_button_pressed()}", 10, 430, 10, rl.red)
                } else {
                    rl.draw_text("DETECTED BUTTON: NONE", 10, 430, 10, rl.gray)
                }
            } else {
                rl.draw_text("GP${gamepad}: NOT DETECTED", 10, 10, 10, rl.gray)
                rl.draw_texture(tex_xbox_pad, 0, 0, rl.lightgray)
            }

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
