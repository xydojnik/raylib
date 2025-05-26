module main

/*******************************************************************************************
*
*   raylib example - particles blending
*
*   Example originally created with raylib 1.7, last time updated with raylib 3.5
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Ramon Santamaria  (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

import raylib as rl


const max_particles = 200


// Particle structure with basic data
struct Particle {
pub mut:
    position rl.Vector2
    color    rl.Color
    alpha    f32
    size     f32
    rotation f32
    active   bool  // NOTE: Use it to activate/deactive particle
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [textures] example - particles blending")
    defer { rl.close_window() }      // Close window and OpenGL context

    // Particles pool, reuse them!
    // Particle mouse_tail[max_particles] = { 0 }
    mut mouse_tail := []Particle{ len:max_particles }

    // Initialize particles
    for mut tail in mouse_tail {
        tail.position = rl.Vector2 {}
        tail.color    = rl.Color {
            u8(rl.get_random_value(0, 255)),
            u8(rl.get_random_value(0, 255)),
            u8(rl.get_random_value(0, 255)),
            u8(255)
        }
        tail.alpha    = 1.0
        tail.size     = f32(rl.get_random_value(1,  30))/20.0
        tail.rotation = f32(rl.get_random_value(0, 360))
        tail.active   = false
    }

    gravity := f32(3.0)

    smoke := rl.load_texture("resources/spark_flame.png")
    defer { rl.unload_texture(smoke) }

    mut blending := rl.blend_alpha

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------

        // Activate one particle every frame and Update active particles
        // NOTE: Particles initial position should be mouse position when activated
        // NOTE: Particles fall down with gravity and rotation... and disappear after 2 seconds (alpha = 0)
        // NOTE: When a particle disappears, active = false and it can be reused.
        for mut tail in mouse_tail {
            if !tail.active {
                tail.active   = true
                tail.alpha    = 1.0
                tail.position = rl.get_mouse_position()
                break
            }
        }
        
        for mut tail in mouse_tail  {
            if tail.active {
                tail.position.y += gravity/2
                tail.alpha      -= 0.005

                if tail.alpha <= 0.0 {
                    tail.active = false
                }

                tail.rotation += 2.0
            }
        }

        if rl.is_key_pressed(rl.key_space) {
            blending = if blending == rl.blend_alpha { rl.blend_additive } else { rl.blend_alpha }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.darkgray)

            rl.begin_blend_mode(blending)

                // Draw active particles
                for tail in mouse_tail {
                    if tail.active {
                        rl.draw_texture_pro(
                            smoke,
                            rl.Rectangle { 0.0, 0.0, f32(smoke.width), f32(smoke.height) },
                            rl.Rectangle { tail.position.x, tail.position.y, smoke.width*tail.size, smoke.height*tail.size },
                            rl.Vector2   { f32(smoke.width*tail.size/2.0), f32(smoke.height*tail.size/2.0) }, tail.rotation,
                            rl.Color.fade(tail.color, tail.alpha))
                    }
                }

            rl.end_blend_mode()

            rl.draw_text("PRESS SPACE to CHANGE BLENDING MODE", 180, 20, 20, rl.black)

            if blending == rl.blend_alpha {
                rl.draw_text("ALPHA BLENDING", 290, screen_height - 40, 20, rl.raywhite)
            } else {
                rl.draw_text("ADDITIVE BLENDING", 280, screen_height - 40, 20, rl.black)
            }

        rl.end_drawing()
    }
}
