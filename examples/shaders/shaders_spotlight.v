/*******************************************************************************************
*
*   raylib [shaders] example - Simple shader mask
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.7
*
*   Example contributed by Chris Camacho (@chriscamacho) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Chris Camacho     (@chriscamacho) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************
*
*   The shader makes alpha holes in the forground to give the appearance of a top
*   down look at a spotlight casting a pool of light...
*
*   The right hand side of the screen there is just enough light to see whats
*   going on without the spot light, great for a stealth type game where you
*   have to avoid the spotlights.
*
*   The left hand side of the screen is in pitch dark except for where the spotlights are.
*
*   Although this example doesn t scale like the letterbox example, you could integrate
*   the two techniques, but by scaling the actual colour of the render texture rather
*   than using alpha as a mask.
*
********************************************************************************************/

module main


import raylib as rl


// const glsl_version = $if PLATFORM_DESKTOP ? { 330 } $else { 100 }
const glsl_version = 330

const max_spots    =   3        // NOTE: It must be the same as define in shader
const max_stars    = 400


// Spot data
struct Spot {
mut:
    position     rl.Vector2
    speed        rl.Vector2
    inner        f32
    radius       f32

    // Shader locations
    position_loc int
    inner_loc    int
    radius_loc   int
}


// Stars in the star field have a position and velocity
struct Star {
mut:
    position rl.Vector2
    speed    rl.Vector2
}

fn (mut s Star) update() {
    s.position = rl.Vector2.add(s.position, s.speed)

    if (s.position.x < 0) || (s.position.x > rl.get_screen_width()) ||
       (s.position.y < 0) || (s.position.y > rl.get_screen_height())
    {
        s.reset()
    }
}

fn (mut s Star ) reset() {
    s.position = rl.Vector2 { f32(rl.get_screen_width())/2.0, f32(rl.get_screen_height())/2.0 }

    for !((rl.fabsf(s.speed.x) + rl.fabsf(s.speed.y)) > 1) {
        s.speed.x = f32(rl.get_random_value(-1000, 1000)) / 100.0
        s.speed.y = f32(rl.get_random_value(-1000, 1000)) / 100.0
    }
    
    s.position = rl.Vector2.add(s.position, rl.Vector2.multiply(s.speed, rl.Vector2 { 8.0, 8.0 }))
}



//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shaders] example - shader spotlight")
    defer { rl.close_window() }       // Close window and OpenGL context
    rl.hide_cursor()

    tex_ray := rl.load_texture("resources/raysan.png")
    defer { rl.unload_texture(tex_ray) }

    mut stars := []Star { len: max_stars }

    for mut star in stars { star.reset() }
    // Progress all the stars on, so they don't all start in the centre
    for mut star in stars { star.update() }

    mut frame_counter := int(0)

    // Use default vert shader
    shader_spot := rl.load_shader(voidptr(0), "resources/shaders/glsl${glsl_version}/spotlight.fs".str)
    defer { rl.unload_shader(shader_spot) }

    // Get the locations of spots in the shader
    mut spots := []Spot { len: max_spots }

    for i, mut spot in spots {
        spot.position_loc = rl.get_shader_location(shader_spot, "spots[${i}].pos")
        spot.inner_loc    = rl.get_shader_location(shader_spot, "spots[${i}].inner")
        spot.radius_loc   = rl.get_shader_location(shader_spot, "spots[${i}].radius")
    }

    // Tell the shader how wide the screen is so we can have
    // a pitch black half and a dimly lit half.
    screen_width_loc := rl.get_shader_location(shader_spot, "screenWidth")
    sw := f32(rl.get_screen_width())
    rl.set_shader_value(shader_spot, screen_width_loc, &sw, rl.shader_uniform_float)

    // Randomize the locations and velocities of the spotlights
    // and initialize the shader locations
    for i, mut spot in spots {
        spot.position.x = f32(rl.get_random_value(64, screen_width - 64))
        spot.position.y = f32(rl.get_random_value(64, screen_height - 64))
        spot.speed      = rl.Vector2 {}

        for rl.fabsf(spot.speed.x) + rl.fabsf(spot.speed.y) < 2 {
            spot.speed.x = f32(rl.get_random_value(-400, 40)) / 10.0
            spot.speed.y = f32(rl.get_random_value(-400, 40)) / 10.0
        }

        spot.inner  = 28.0 * f32(i+1)
        spot.radius = 48.0 * f32(i+1)

        rl.set_shader_value(shader_spot, spot.position_loc, &spot.position, rl.shader_uniform_vec2)
        rl.set_shader_value(shader_spot, spot.inner_loc,    &spot.inner,    rl.shader_uniform_float)
        rl.set_shader_value(shader_spot, spot.radius_loc,   &spot.radius,   rl.shader_uniform_float)
    }

    rl.set_target_fps(60)            // Set  to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        frame_counter++

        // Move the stars, resetting them if the go offscreen
        for mut star in stars { star.update() }

        // Update the spots, send them to the shader
        for i, mut spot in spots {
            if i == 0 {
                mp := rl.get_mouse_position()
                spot.position.x = mp.x
                spot.position.y = screen_height - mp.y
            } else {
                spot.position.x += spot.speed.x
                spot.position.y += spot.speed.y

                if spot.position.x < 64                 { spot.speed.x = -spot.speed.x }
                if spot.position.x > (screen_width-64)  { spot.speed.x = -spot.speed.x }
                if spot.position.y < 64                 { spot.speed.y = -spot.speed.y }
                if spot.position.y > (screen_height-64) { spot.speed.y = -spot.speed.y }
            }
            rl.set_shader_value(shader_spot, spot.position_loc, &spot.position, rl.shader_uniform_vec2)
        }

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.darkblue)

            // Draw stars and bobs
            for star in stars {
                // Single pixel is just too small these days!
                rl.draw_rectangle(int(star.position.x), int(star.position.y), 2, 2, rl.white)
            }

            for i in 0..16 {
                tex_ray.draw(
                    int((f32(screen_width) /2.0) + rl.cosf(f32(frame_counter + i*8)/51.45)*(f32(screen_width) /2.2) - 32),
                    int((f32(screen_height)/2.0) + rl.sinf(f32(frame_counter + i*8)/17.87)*(f32(screen_height)/4.2)),
                    rl.white
                )
            }

            // Draw spot lights
            rl.begin_shader_mode(shader_spot)
                // Instead of a blank rectangle you could render here
                // a render texture of the full screen used to do screen
                // scaling (slight adjustment to shader would be required
                // to actually pay attention to the colour!)
                rl.draw_rectangle(0, 0, screen_width, screen_height, rl.white)
            rl.end_shader_mode()

            rl.draw_fps(10, 10)

            rl.draw_text("Move the mouse!", 10, 30, 20, rl.green)
            rl.draw_text("Pitch Black", int(f32(screen_width)*0.2), screen_height/2, 20, rl.green)
            rl.draw_text("Dark",        int(f32(screen_width)*.66), screen_height/2, 20, rl.green)

        rl.end_drawing()
    }
}
