/*******************************************************************************************
*
*   raylib [models] example - Mesh picking in 3d mode, ground plane, triangle, mesh
*
*   Example originally created with raylib 1.7, last time updated with raylib 4.0
*
*   Example contributed by Joel Davis (@joeld42) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2017-2023 Joel Davis        (@joeld42) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


const flt_max = f32(340282346638528859811704183484516925440.0)     // Maximum value of a float, from bit pattern 01111111011111111111111111111111


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [models] example - mesh picking')
    defer { rl.close_window() }             // Close window and OpenGL context

    // Define the camera to look into our 3d world
    mut camera := rl.Camera {
        position:    rl.Vector3 { 20.0 20.0, 20.0 }     // Camera position
        target:      rl.Vector3 {  0.0  8.0,  0.0 }     // Camera looking at point
        up:          rl.Vector3 {  0.0  1.6,  0.0 }     // Camera up vector (rotation towards target)
        fovy:        45.0                               // Camera field-of-view Y
        projection:  rl.camera_perspective              // Camera projection type
    }

    mut ray := rl.Ray {}                                                   // Picking ray
    
    mut tower := rl.Model.load('resources/models/obj/turret.obj')          // Load OBJ model
    defer { tower.unload() }                                               // Unload model

    texture := rl.Texture.load('resources/models/obj/turret_diffuse.png')  // Load model texture
    defer { texture.unload()  }                                            // Unload texture

    tower.set_texture(0, rl.material_map_diffuse, texture)                 // Set model diffuse texture

    mut tower_pos  := rl.Vector3 {}                                        // Set model position
    mut tower_bbox := rl.get_mesh_bounding_box(unsafe { tower.meshes[0] }) // Get mesh bounding box

    // Ground quad
    g0 := rl.Vector3 { -50.0, 0.0, -50.0 }
    g1 := rl.Vector3 { -50.0, 0.0,  50.0 }
    g2 := rl.Vector3 {  50.0, 0.0,  50.0 }
    g3 := rl.Vector3 {  50.0, 0.0, -50.0 }

    // Test triangle
    ta := rl.Vector3 { -25.0, 0.5, 0.0 }
    tb := rl.Vector3 { -4.0,  2.5, 1.0 }
    tc := rl.Vector3 { -8.0,  6.5, 0.0 }

    mut bary := rl.Vector3 { 0.0, 0.0, 0.0 }

    // Test sphere
    sphere_pos    := rl.Vector3 { -30.0, 5.0, 5.0 }
    sphere_radius := f32(4.0)

    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------
    // Main game loop
    for !rl.window_should_close() {         // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_cursor_hidden() {
            rl.update_camera(&camera, rl.camera_first_person)          // Update camera
        }

        // Toggle camera controls
        if rl.is_mouse_button_pressed(rl.mouse_button_right) {
            if rl.is_cursor_hidden() {
                rl.enable_cursor()
            } else {
                rl.disable_cursor()
            }
        }

        // Display information about closest hit
        mut hit_object_name := 'None'
        mut collision := rl.RayCollision {
            distance:  flt_max
            hit:       false
        }
        mut cursor_color := rl.white

        // Get ray and test against objects
        ray = rl.get_mouse_ray(rl.get_mouse_position(), camera)

        // Check ray collision against ground quad
        ground_hit_info := rl.get_ray_collision_quad(ray, g0, g1, g2, g3)

        if (ground_hit_info.hit) && (ground_hit_info.distance < collision.distance) {
            collision       = ground_hit_info
            cursor_color    = rl.green
            hit_object_name = 'Ground'
        }

        // Check ray collision against test triangle
        tri_hit_info := rl.get_ray_collision_triangle(ray, ta, tb, tc)

        if (tri_hit_info.hit) && (tri_hit_info.distance < collision.distance) {
            collision       = tri_hit_info
            cursor_color    = rl.purple
            hit_object_name = 'Triangle'

            bary = rl.Vector3.barycenter(collision.point, ta, tb, tc)
        }

        // Check ray collision against test sphere
        sphere_hit_info := rl.get_ray_collision_sphere(ray, sphere_pos, sphere_radius)

        if (sphere_hit_info.hit) && (sphere_hit_info.distance < collision.distance) {
            collision       = sphere_hit_info
            cursor_color    = rl.orange
            hit_object_name = 'Sphere'
        }

        // Check ray collision against bounding box first, before trying the full ray-mesh test
        box_hit_info := rl.get_ray_collision_box(ray, tower_bbox)

        if (box_hit_info.hit) && (box_hit_info.distance < collision.distance) {
            collision       = box_hit_info
            cursor_color    = rl.orange
            hit_object_name = 'Box'

            // Check ray collision against model meshes
            mut mesh_hit_info := rl.RayCollision {}
            for m := 0; m < tower.meshCount; m++ {
                // NOTE: We consider the model.transform for the collision check but 
                // it can be checked against any transform Matrix, used when checking against same
                // model drawn multiple times with multiple transforms
                // mesh_hit_info = rl.get_ray_collision_mesh(ray, tower.meshes[m], tower.transform)
                mesh_hit_info = rl.get_ray_collision_mesh(ray, unsafe { tower.meshes[m] }, tower.transform)
                if mesh_hit_info.hit {
                    // Save the closest hit mesh
                    if (!collision.hit) || (collision.distance > mesh_hit_info.distance) {
                        collision = mesh_hit_info
                    }
                    break  // Stop once one mesh collision is detected, the colliding mesh is m
                }
            }

            if mesh_hit_info.hit {
                collision       = mesh_hit_info
                cursor_color    = rl.orange
                hit_object_name = 'Mesh'
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)

                // Draw the tower
                // WARNING: If scale is different than 1.0f,
                // not considered by GetRayCollisionModel()
                rl.draw_model(tower, tower_pos, 1.0, rl.white)

                // Draw the test triangle
                rl.draw_line_3d(ta, tb, rl.purple)
                rl.draw_line_3d(tb, tc, rl.purple)
                rl.draw_line_3d(tc, ta, rl.purple)

                // Draw the test sphere
                rl.draw_sphere_wires(sphere_pos, sphere_radius, 8, 8, rl.purple)

                // Draw the mesh bbox if we hit it
                if box_hit_info.hit {
                    rl.draw_bounding_box(tower_bbox, rl.lime)
                }

                // If we hit something, draw the cursor at the hit point
                if collision.hit {
                    rl.draw_cube(collision.point, 0.3, 0.3, 0.3, cursor_color)
                    rl.draw_cube_wires(collision.point, 0.3, 0.3, 0.3, rl.red)

                    normal_end := rl.Vector3.add(collision.point, collision.normal)

                    rl.draw_line_3d(collision.point, normal_end, rl.red)
                }

                rl.draw_ray(ray, rl.maroon)

                rl.draw_grid(10, 10.0)

            rl.end_mode_3d()

            // Draw some debug GUI text
            rl.draw_text('Hit Object: ${hit_object_name}', 10, 50, 10, rl.black)

            if collision.hit {
                ypos := int(70)

                rl.draw_text('Distance: ${collision.distance}', 10, ypos, 10, rl.black)

                rl.draw_text(
                    'Hit Pos: ${collision.point.x}, ${collision.point.y}, ${collision.point.z}',
                    10, ypos + 15, 10, rl.black
                )

                rl.draw_text(
                    'Hit Norm: ${collision.normal.x}, ${collision.normal.y}, ${collision.normal.z}',
                    10, ypos + 30, 10, rl.black
                )

                if tri_hit_info.hit && (hit_object_name == 'Triangle') {
                    rl.draw_text(
                        'Barycenter: ${bary.x}, ${bary.y}, ${bary.z}', 10, ypos + 45, 10, rl.black
                    )
                }
            }

            rl.draw_text('Right click mouse to toggle camera controls', 10, 430, 10, rl.gray)

            rl.draw_text('(c) Turret 3D model by Alberto Cano', screen_width - 200, screen_height - 20, 10, rl.gray)

            rl.draw_fps(10, 10)

        rl.end_drawing()
    }
}
