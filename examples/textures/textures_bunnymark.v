module main

/*******************************************************************************************
*
*   raylib [textures] example - Bunnymark
*
*   Example originally created with raylib 1.6, last time updated with raylib 2.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl


const max_bunnies = int(50000)    // 50K bunnies limit

// This is the maximum amount of elements (quads) per batch
// NOTE: This value is defined in [rlgl] module and can be changed there
const max_batch_elements = int(8192)

struct Bunny {
pub mut:
    position rl.Vector2
    speed    rl.Vector2
    color    rl.Color
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - bunnymark")
    defer { rl.close_window()  }            // Close window and OpenGL context

    // Load bunny texture
    tex_bunny := rl.load_texture("resources/wabbit_alpha.png")
    defer { rl.unload_texture(tex_bunny) }  // Unload bunny texture

    // Bunny *bunnies = (Bunny *)malloc(max_bunnies*sizeof(Bunny))    // Bunnies array
    mut bunnies       := []Bunny{len: max_bunnies}
    mut bunnies_count := int(0) // Bunnies counter

    rl.set_target_fps(60)       // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_mouse_button_down(rl.mouse_button_left) {
            // Create more bunnies
            for _ in 0..100 {
                if bunnies_count < max_bunnies {
                    bunnies[bunnies_count].position = rl.get_mouse_position()
                    bunnies[bunnies_count].speed.x  = f32(rl.get_random_value(-250, 250))/60.0
                    bunnies[bunnies_count].speed.y  = f32(rl.get_random_value(-250, 250))/60.0
                    bunnies[bunnies_count].color    = rl.Color {
                        u8(rl.get_random_value(50, 240)),
                        u8(rl.get_random_value(80, 240)),
                        u8(rl.get_random_value(100, 240)),
                        255
                    }
                    bunnies_count++
                }
            }
        }

        // Update bunnies
        for mut bunnie in bunnies {
            bunnie.position.x += bunnie.speed.x
            bunnie.position.y += bunnie.speed.y

            if ((bunnie.position.x + tex_bunny.width/2) > rl.get_screen_width()) ||
               ((bunnie.position.x + tex_bunny.width/2) < 0)
            {
                 bunnie.speed.x *= -1
            }
            if ((bunnie.position.y + tex_bunny.height/2) > rl.get_screen_height()) ||
               ((bunnie.position.y + tex_bunny.height/2 - 40) < 0)
            {
                bunnie.speed.y *= -1
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // for i in 0..bunnies_count {
            for bunnie in bunnies {
                // NOTE: When internal batch buffer limit is reached (max_batch_elements),
                // a draw call is launched and buffer starts being filled again
                // before issuing a draw call, updated vertex data from internal CPU buffer is send to GPU...
                // Process of sending data is costly and it could happen that GPU data has not been completely
                // processed for drawing while new data is tried to be sent (updating current in-use buffers)
                // it could generates a stall and consequently a frame drop, limiting the number of drawn bunnies
                rl.draw_texture(
                    tex_bunny, int(bunnie.position.x), int(bunnie.position.y), bunnie.color
                )
            }

            rl.draw_rectangle(0, 0, screen_width, 40, rl.black)
            rl.draw_text("bunnies: ${bunnies_count}", 120, 10, 20, rl.green)
            rl.draw_text("batched draw calls: ${1 + bunnies_count/max_batch_elements}", 320, 10, 20, rl.maroon)

            rl.draw_fps(10, 10)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}
