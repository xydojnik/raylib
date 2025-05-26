/*******************************************************************************************
*
*   raylib [shapes] example - Vector Angle
*
*   Example originally created with raylib 1.0, last time updated with raylib 4.6
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024 Fedorov Alexandr (@xydojnik)
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

    rl.init_window(screen_width, screen_height, "raylib [math] example - vector angle")
    defer { rl.close_window() }

    mut v0 := rl.Vector2 { screen_width/2, screen_height/2 }
    mut v1 := rl.Vector2.add(v0, rl.Vector2 { 100.0, 80.0 })
    mut v2 := rl.Vector2 {}             // Updated with mouse position
    
    mut angle      := f32(0.0) // Angle in degrees
    mut angle_mode := false    // 0-Vector2Angle(), 1-Vector2LineAngle()

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        startangle := if angle_mode { 0.0 } else { rl.rad2deg(-rl.Vector2.line_angle(v0, v1)) }

        v2 = rl.get_mouse_position()

        if rl.is_key_pressed(rl.key_space) {
            angle_mode = !angle_mode
        }
        
        if !angle_mode && rl.is_mouse_button_down(rl.mouse_button_right) {
            v1 = rl.get_mouse_position()
        }

        if !angle_mode {
            // Calculate angle between two vectors, considering a common origin (v0)
            v1_normal := rl.Vector2.normalize(rl.Vector2.subtract(v1, v0))
            v2_normal := rl.Vector2.normalize(rl.Vector2.subtract(v2, v0))
            angle = rl.rad2deg(rl.Vector2.angle(v1_normal, v2_normal))
        } else if angle_mode {
            // Calculate angle defined by a two vectors line, in reference to horizontal line
            angle = rl.rad2deg(rl.Vector2.line_angle(v0, v2))
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)
            
            if !angle_mode {
                rl.draw_text("MODE 0: Angle between V1 and V2", 10, 10, 20, rl.black)
                rl.draw_text("Right Click to Move V2", 10, 30, 20, rl.darkgray)

                rl.draw_line_ex(v0, v1, 2.0, rl.black)
                rl.draw_line_ex(v0, v2, 2.0, rl.red)

                rl.draw_circle_sector(v0, 40.0, startangle, startangle + angle, 32, rl.Color.fade(rl.green, 0.6))
            } else if angle_mode {
                rl.draw_text("MODE 1: Angle formed by line V1 to V2", 10, 10, 20, rl.black)
                
                rl.draw_line(0, screen_height/2, screen_width, screen_height/2, rl.lightgray)
                rl.draw_line_ex(v0, v2, 2.0, rl.red)

                rl.draw_circle_sector(v0, 40.0, startangle, startangle - angle, 32, rl.Color.fade(rl.green, 0.6))
            }
            
            rl.draw_text("v0", int(v0.x), int(v0.y), 10, rl.darkgray)

            // If the line from v0 to v1 would overlap the text, move it's position up 10
            if !angle_mode  && rl.Vector2.subtract(v0, v1).y > 0.0 { rl.draw_text("v1", int(v1.x), int(v1.y-10.0), 10, rl.darkgray) }
            if !angle_mode  && rl.Vector2.subtract(v0, v1).y < 0.0 { rl.draw_text("v1", int(v1.x), int(v1.y),      10, rl.darkgray) }

            // If angle mode 1, use v1 to emphasize the horizontal line
            if angle_mode {
                rl.draw_text("v1", int(v0.x+40.0), int(v0.y), 10, rl.darkgray)
            }

            // position adjusted by -10 so it isn't hidden by cursor
            rl.draw_text("v2", int(v2.x-10.0), int(v2.y-10.0), 10, rl.darkgray)

            rl.draw_text("Press SPACE to change MODE", 460, 10, 20, rl.darkgray)
            rl.draw_text("ANGLE: ${angle}", 10, 70, 20, rl.lime)
            
        rl.end_drawing()
    }
}
