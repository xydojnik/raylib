/*******************************************************************************************
*
*   raylib [core] example - window scale letterbox (and virtual mouse)
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
*
*   Example contributed by Anata (@anatagawa) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Anata            (@anatagawa) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    window_width  := 800
    window_height := 450

    // Enable config flags for resizable window and vertical synchro
    rl.set_config_flags(rl.flag_window_resizable | rl.flag_vsync_hint)
    rl.init_window(window_width, window_height, "raylib [core] example - window scale letterbox")
                        
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }              // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    rl.set_window_min_size(320, 240)

    game_screen_width  := 640
    game_screen_height := 480

    // Render texture initialization, used to hold the rendering result so we can easily resize it
    target := rl.load_render_texture(game_screen_width, game_screen_height)
    defer { rl.unload_render_texture(target) } // Unload render texture

    rl.set_texture_filter(rl.Texture2D(target.texture), rl.texture_filter_bilinear)  // Texture scale filter to use

    mut colors := []rl.Color{len: 10}
    for i in 0..colors.len {
        colors[i] = rl.Color {
            u8(rl.get_random_value(100, 250)),
            u8(rl.get_random_value( 50, 150)),
            u8(rl.get_random_value( 10, 100)),
            u8(255)
        }
    }

    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    scale := rl.fminf(
        f32(rl.get_screen_width())  / game_screen_width,
        f32(rl.get_screen_height()) / game_screen_height
    )
    
    // Main game loop
    for !rl.window_should_close() {      // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Compute required framebuffer scaling
        // scale := MIN((f32(rl.get_screen_width())/game_screen_width), (f32(rl.get_screen_height())/game_screen_height))

        if rl.is_key_pressed(rl.key_space) {
            // Recalculate random colors for the bars
            for mut color in colors {
                color = rl.Color{
                    u8(rl.get_random_value(100, 250)),
                    u8(rl.get_random_value(50,  150)),
                    u8(rl.get_random_value(10,  100)),
                    u8(255)
                }
            }
        }

        // Update virtual mouse (clamped mouse value behind game screen)
        mouse := rl.get_mouse_position()
        mut virtual_mouse := rl.Vector2 {
            x: (mouse.x - (rl.get_screen_width()  - (game_screen_width *scale))*0.5)/scale
            y: (mouse.y - (rl.get_screen_height() - (game_screen_height*scale))*0.5)/scale
        }
        virtual_mouse = rl.Vector2.clamp(
            virtual_mouse,
            rl.Vector2 {},
            rl.Vector2 {
                x: f32(game_screen_width),
                y: f32(game_screen_height)
            }
        )

        // Apply the same transformation as the virtual mouse to the real mouse (i.e. to work with raygui)
        // rl.set_mouse_offset(
        //     int(-(rl.get_screen_width()  - (game_screen_width *scale))*0.5),
        //     int(-(rl.get_screen_height() - (game_screen_height*scale))*0.5)
        // )
        // rl.set_mouse_scale(1/scale, 1/scale)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        // Draw everything in the render texture, note this will not be rendered on screen, yet
        rl.begin_texture_mode(target)
            rl.clear_background(rl.raywhite)  // Clear render texture background color

            for i, color in colors {
                rl.draw_rectangle(
                    0,
                    (game_screen_height/10)*i,
                    game_screen_width,
                    game_screen_height/10,
                    color
                )
            }

            rl.draw_text("If executed inside a window,\nyou can resize the window,\nand see the screen scaling!", 10, 25, 20, rl.white)
            rl.draw_text("Default Mouse: [${int(mouse.x)} , ${int(mouse.y)}]", 350, 25, 20, rl.green)
            rl.draw_text("Virtual Mouse: [${int(virtual_mouse.x)} , ${int(virtual_mouse.y)}]", 350, 55, 20, rl.yellow)
        rl.end_texture_mode()
        
        rl.begin_drawing()
            rl.clear_background(rl.black)     // Clear screen background

            // Draw render texture to screen, properly scaled
            rl.draw_texture_pro(
                rl.Texture2D(target.texture),
                rl.Rectangle { 0.0, 0.0, f32(target.texture.width), -f32(target.texture.height) },
                rl.Rectangle {
                    (f32(rl.get_screen_width())  - (f32(game_screen_width  * scale))) * 0.5,
                    (f32(rl.get_screen_height()) - (f32(game_screen_height * scale))) * 0.5,
                    f32(game_screen_width) *scale,
                    f32(game_screen_height)*scale
                },
                rl.Vector2 {}, 0.0, rl.white
            )
        rl.end_drawing()
    }
}
