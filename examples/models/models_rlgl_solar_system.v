/*******************************************************************************************
*
*   raylib [models] example - rlgl module usage with push/pop matrix transformations
*
*   NOTE: This example uses [rlgl] module functionality (pseudo-OpenGL 1.1 style coding)
*
*   Example originally created with raylib 2.5, last time updated with raylib 4.0
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2018-2023 Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
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

    mut sun_radius         := f32( 4.0)
    mut earth_radius       := f32( 0.6)
    mut earth_orbit_radius := f32( 8.0)
    mut moon_radius        := f32(0.16)
    mut moon_orbit_radius  := f32( 1.5)

    rl.init_window(screen_width, screen_height, 'raylib [models] example - rlgl module usage with push/pop matrix transformations')

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 16.0, 16.0, 16.0 } // Camera position
        target:      rl.Vector3 {  0.0,  0.0,  0.0 } // Camera looking at point
        up:          rl.Vector3 {  0.0,  1.0,  0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                            // Camera field-of-view Y
        projection:  rl.camera_perspective           // Camera projection type
    }

    rotation_speed := 0.2  // General system rotation speed

    mut earth_rotation       := f32(0.0) // Rotation of earth around itself (days) in degrees
    mut earth_orbit_rotation := f32(0.0) // Rotation of earth around the Sun (years) in degrees
    mut moon_rotation        := f32(0.0) // Rotation of moon around itself
    mut moon_orbit_rotation  := f32(0.0) // Rotation of moon around earth in degrees

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, rl.camera_orbital)

        earth_rotation       += f32(5.0*rotation_speed)
        earth_orbit_rotation += f32(365/360.0*(5.0*rotation_speed)*rotation_speed)
        moon_rotation        += f32(2.0*rotation_speed)
        moon_orbit_rotation  += f32(8.0*rotation_speed)

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                rl.rl_push_matrix()
                    rl.rl_scalef(sun_radius, sun_radius, sun_radius)           // Scale Sun
                    draw_sphere_basic(rl.gold)                                 // Draw the Sun
                rl.rl_pop_matrix()

                rl.rl_push_matrix()
                    rl.rl_rotatef(earth_orbit_rotation, 0.0, 1.0, 0.0)         // Rotation for Earth orbit around Sun
                    rl.rl_translatef(earth_orbit_radius, 0.0, 0.0)             // Translation for Earth orbit

                    rl.rl_push_matrix()
                        rl.rl_rotatef(earth_rotation, 0.25, 1.0, 0.0)          // Rotation for Earth itself
                        rl.rl_scalef(earth_radius, earth_radius, earth_radius) // Scale Earth

                        draw_sphere_basic(rl.blue)                             // Draw the Earth
                    rl.rl_pop_matrix()

                    rl.rl_rotatef(moon_orbit_rotation, 0.0, 1.0, 0.0)          // Rotation for Moon orbit around Earth
                    rl.rl_translatef(moon_orbit_radius, 0.0, 0.0)              // Translation for Moon orbit
                    rl.rl_rotatef(moon_rotation, 0.0, 1.0, 0.0)                // Rotation for Moon itself
                    rl.rl_scalef(moon_radius, moon_radius, moon_radius)        // Scale Moon

                    draw_sphere_basic(rl.lightgray)                            // Draw the Moon
                rl.rl_pop_matrix()

                // Some reference elements (not affected by previous matrix transformations)
                rl.draw_circle_3d(rl.Vector3 {}, earth_orbit_radius, rl.Vector3 {x:1}, 90.0, rl.Color.fade(rl.red, 0.5))
                rl.draw_grid(20, 1.0)

            rl.end_mode_3d()

            rl.draw_text('EARTH ORBITING AROUND THE SUN!', 400, 10, 20, rl.maroon)
            rl.draw_fps(10, 10)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    rl.close_window()        // Close window and OpenGL context
}

//--------------------------------------------------------------------------------------------
// Module Functions Definitions (local)
//--------------------------------------------------------------------------------------------
// Draw sphere without any matrix transformation
// NOTE: Sphere is drawn in world position ( 0, 0, 0 ) with radius 1.0f
fn draw_sphere_basic(color rl.Color) {
    rings  := 16
    slices := 16

    // Make sure there is enough space in the internal render batch
    // buffer to store all required vertex, batch is reseted if required
    rl.rl_check_render_batch_limit((rings + 2)*slices*6)

    rl.rl_begin(rl.rl_triangles)
        rl.rl_color4ub(color.r, color.g, color.b, color.a)

        for i in 0..(rings + 2) {
            for j in 0..(slices) {
                rl.rl_vertex3f(
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*i))*rl.sinf(rl.deg2rad(j*360/slices)),
                    rl.sinf(rl.deg2rad(0+(180/(rings + 1))*i)),
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*i))*rl.cosf(rl.deg2rad(j*360/slices))
                )
                rl.rl_vertex3f(
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*(i+1)))*rl.sinf(rl.deg2rad((j+1)*360/slices)),
                    rl.sinf(rl.deg2rad(0+(180/(rings + 1))*(i+1))),
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*(i+1)))*rl.cosf(rl.deg2rad((j+1)*360/slices))
                )
                rl.rl_vertex3f(
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*(i+1)))*rl.sinf(rl.deg2rad(j*360/slices)),
                    rl.sinf(rl.deg2rad(0+(180/(rings + 1))*(i+1))),
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*(i+1)))*rl.cosf(rl.deg2rad(j*360/slices))
                )
                rl.rl_vertex3f(
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*i))*rl.sinf(rl.deg2rad(j*360/slices)),
                    rl.sinf(rl.deg2rad(0+(180/(rings + 1))*i)),
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*i))*rl.cosf(rl.deg2rad(j*360/slices))
                )
                rl.rl_vertex3f(
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*(i)))*rl.sinf(rl.deg2rad((j+1)*360/slices)),
                    rl.sinf(rl.deg2rad(0+(180/(rings + 1))*(i))),
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*(i)))*rl.cosf(rl.deg2rad((j+1)*360/slices))
                )
                rl.rl_vertex3f(
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*(i+1)))*rl.sinf(rl.deg2rad((j+1)*360/slices)),
                    rl.sinf(rl.deg2rad(0+(180/(rings + 1))*(i+1))),
                    rl.cosf(rl.deg2rad(0+(180/(rings + 1))*(i+1)))*rl.cosf(rl.deg2rad((j+1)*360/slices))
                )
            }
        }
    rl.rl_end()
}
