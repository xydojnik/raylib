/*******************************************************************************************
*   raylib [core] example - 2D Camera system
*
*   Example originally created with raylib 1.5, last time updated with raylib 3.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2016-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const max_buildings = 100
const screen_width  = 800
const screen_height = 450

// Program main entry point
fn main() {// Initialization

    rl.init_window(screen_width, screen_height, "raylib [core] example - 2d camera")
    // De-Initialization
    defer { rl.close_window() }       // Close window and OpenGL context

    mut player       := rl.Rectangle  { 400, 280, 40, 40 }
    mut buildings    := []rl.Rectangle{ len: max_buildings }
    mut build_colors := []rl.Color    { len: max_buildings }

    mut spacing := int(0)
    for i in 0..max_buildings {
        buildings[i].width  = f32(rl.get_random_value(50,  200))
        buildings[i].height = f32(rl.get_random_value(100, 800))
        buildings[i].y      = screen_height - 130.0 - buildings[i].height
        buildings[i].x      = -6000.0 + f32(spacing)

        spacing += int(buildings[i].width)

        build_colors[i] = rl.Color {
            u8(rl.get_random_value(200, 240)),
            u8(rl.get_random_value(200, 240)),
            u8(rl.get_random_value(200, 250)),
            u8(255)
        }
    }

    mut camera := rl.Camera2D {
        target:   rl.Vector2{ player.x+20.0,    player.y + 20.0   },
        offset:   rl.Vector2{ screen_width/2.0, screen_height/2.0 },
        rotation: 0.0,
        zoom:     1.0
    }

    rl.set_target_fps(60)           // Set our game to run at 60 frames-per-second

    // Main game loop
    for !rl.window_should_close() { // Detect window close button or ESC key
        // Update
        // Player movement
        if      rl.is_key_down(rl.key_right) { player.x += 2 }
        else if rl.is_key_down(rl.key_left)  { player.x -= 2 }

        // Camera target follows player
        camera.target = rl.Vector2{ player.x + 20, player.y + 20 }

        // Camera rotation controls
        if      rl.is_key_down(rl.key_a) { camera.rotation-- }
        else if rl.is_key_down(rl.key_s) { camera.rotation++ }

        // Limit camera rotation to 80 degrees (-40 to 40)
        if      camera.rotation >  40 { camera.rotation =  40 }
        else if camera.rotation < -40 { camera.rotation = -40 }

        // Camera zoom controls
        camera.zoom += f32(rl.get_mouse_wheel_move())*0.05

        if      camera.zoom > 3.0 { camera.zoom = 3.0 }
        else if camera.zoom < 0.1 { camera.zoom = 0.1 }

        // Camera reset (zoom and rotation)
        if rl.is_key_pressed(rl.key_r) {
            camera.zoom     = 1.0
            camera.rotation = 0.0
        }

        // Draw
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)
            rl.begin_mode_2d(camera)
                rl.draw_rectangle(-6000, 320, 13000, 8000, rl.darkgray)

                for i in 0..max_buildings {
                    rl.draw_rectangle_rec(buildings[i], build_colors[i])
                }

                rl.draw_rectangle_rec(player, rl.red)
                rl.draw_line(int(camera.target.x), -screen_height*10, int(camera.target.x), screen_height*10, rl.green)
                rl.draw_line(-screen_width*10, int(camera.target.y), screen_width*10, int(camera.target.y), rl.green)

            rl.end_mode_2d()

            rl.draw_text("SCREEN AREA", 640, 10, 20, rl.red)

            rl.draw_rectangle(0, 0, screen_width, 5, rl.red)
            rl.draw_rectangle(0, 5, 5, screen_height - 10,  rl.red)
            rl.draw_rectangle(screen_width - 5, 5 , 5, screen_height - 10, rl.red)
            rl.draw_rectangle(0, screen_height - 5, screen_width, 5, rl.red)

            rl.draw_rectangle      ( 10, 10, 250, 113, rl.Color.fade(rl.skyblue, 0.5 ))
            rl.draw_rectangle_lines( 10, 10, 250, 113, rl.blue)

            rl.draw_text("Free 2d camera controls:",       20, 20 , 10, rl.black   )
            rl.draw_text("- Right/Left to move Offset",    40, 40 , 10, rl.darkgray)
            rl.draw_text("- Mouse Wheel to Zoom in-out",   40, 60 , 10, rl.darkgray)
            rl.draw_text("- A / S to Rotate",              40, 80 , 10, rl.darkgray)
            rl.draw_text("- R to reset Zoom and Rotation", 40, 100, 10, rl.darkgray)

        rl.end_drawing()
    }
}
