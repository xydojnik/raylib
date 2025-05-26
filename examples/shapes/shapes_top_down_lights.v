/*******************************************************************************************
*
*   raylib [shapes] example - top down lights
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2022-2023 Jeffery Myers     (@JeffM2501)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

// Custom Blend Modes
const rlgl_src_alpha = 0x0302
const rlgl_min       = 0x8007
const rlgl_max       = 0x8008

const max_boxes   = 20
const max_shadows = max_boxes*3  // max_boxes *3. Each box can cast up to two shadow volumes for the edges it is away from, and one for the box itself
const max_lights  = 16


// Shadow geometry type
struct ShadowGeometry {
pub mut:
    vertices [4]rl.Vector2
}

fn (mut sg ShadowGeometry) set_vertices(
    v1 rl.Vector2, v2 rl.Vector2, v3 rl.Vector2, v4 rl.Vector2
) {
    sg.vertices[0] = v1
    sg.vertices[1] = v2
    sg.vertices[2] = v3
    sg.vertices[3] = v4
}

// Light info type
struct LightInfo {
pub mut:
    active       bool             // Is this light slot active?
    dirty        bool             // Does this light need to be updated?
    valid        bool             // Is this light in a valid position?

    position     rl.Vector2       // Light position
    mask         rl.RenderTexture // Alpha mask for the light
    outer_radius f32              // The distance the light touches
    bounds       rl.Rectangle     // A cached rectangle of the light bounds to help with culling

    shadow_count int
    shadows      []ShadowGeometry
}

// Setup a light
fn (mut light LightInfo) setup(x f32, y f32, radius f32) {
    light.active        = true
    light.valid         = false  // The light must prove it is valid
    light.mask          = rl.RenderTexture.load(rl.get_screen_width(), rl.get_screen_height())
    light.outer_radius  = radius

    light.bounds.width  = radius * 2
    light.bounds.height = radius * 2

    light.shadows = []ShadowGeometry{len:max_shadows}

    light.move(x, y)

    // Force the render texture to have something in it
    light.draw_mask()
}

// Move a light and mark it as dirty so that we update it's mask next frame
fn (mut light LightInfo) move(x f32, y f32) {
    light.dirty      = true
    light.position.x = x 
    light.position.y = y

    // update the cached bounds
    light.bounds.x = x - light.outer_radius
    light.bounds.y = y - light.outer_radius
}

// Compute a shadow volume for the edge
// It takes the edge and projects it back by the light radius and turns it into a quad
fn (mut light LightInfo) compute_shadow_volume_for_edge(sp rl.Vector2, ep rl.Vector2) {
    if light.shadow_count >= max_shadows { return }

    extension := light.outer_radius*2

    sp_vector     := rl.Vector2.normalize(rl.Vector2.subtract(sp, light.position))
    sp_projection := rl.Vector2.add(sp, rl.Vector2.scale(sp_vector, extension))

    ep_vector     := rl.Vector2.normalize(rl.Vector2.subtract(ep, light.position))
    ep_projection := rl.Vector2.add(ep, rl.Vector2.scale(ep_vector, extension))

    light.shadows[light.shadow_count].set_vertices(sp, ep, ep_projection, sp_projection)
    
    light.shadow_count++
}

// Draw the light and shadows to the mask for a light
fn (light &LightInfo) draw_mask() {
    // Use the light mask
    rl.begin_texture_mode(light.mask)

        rl.clear_background(rl.white)

        // Force the blend mode to only set the alpha of the destination
        rl.rl_set_blend_factors(rlgl_src_alpha, rlgl_src_alpha, rlgl_min)
        rl.rl_set_blend_mode(rl.blend_custom)

        // If we are valid, then draw the light radius to the alpha mask
        if light.valid {
            rl.draw_circle_gradient(
                int(light.position.x),
                int(light.position.y),
                light.outer_radius,
                rl.color_alpha(rl.white, 0),
                rl.white
            )
        }
        
        rl.rl_draw_render_batch_active()

        // Cut out the shadows from the light radius by forcing the alpha to maximum
        rl.rl_set_blend_mode(rl.blend_alpha)
        rl.rl_set_blend_factors(rlgl_src_alpha, rlgl_src_alpha, rlgl_max)
        rl.rl_set_blend_mode(rl.blend_custom)

        // Draw the shadows to the alpha mask
        for i in 0..light.shadow_count {
            rl.draw_triangle_fan(&light.shadows[i].vertices[0], 4, rl.white)
        }

        rl.rl_draw_render_batch_active()
        
        // Go back to normal blend mode
        rl.rl_set_blend_mode(rl.blend_alpha)

    rl.end_texture_mode()
}

// See if a light needs to update it's mask
fn (mut light LightInfo) update(boxes []rl.Rectangle) bool {
    if !light.active      || !light.dirty { return false }

    light.dirty        = false
    light.shadow_count = 0
    light.valid        = false

    for box in boxes {
        // Are we in a box? if so we are not valid
        if rl.check_collision_point_rec(light.position, box) { return false }

        // If this box is outside our bounds, we can skip it
        if !rl.check_collision_recs(light.bounds, box) { continue }

        // Check the edges that are on the same side we are, and cast shadow volumes out from them
        
        // Top
        mut sp := rl.Vector2 { box.x            , box.y }
        mut ep := rl.Vector2 { box.x + box.width, box.y }

        if light.position.y > ep.y { light.compute_shadow_volume_for_edge(sp, ep) }

        // Right
        sp = ep
        ep.y += box.height
        if light.position.x < ep.x { light.compute_shadow_volume_for_edge(sp, ep) }

        // Bottom
        sp = ep
        ep.x -= box.width
        if light.position.y < ep.y { light.compute_shadow_volume_for_edge(sp, ep) }

        // Left
        sp = ep
        ep.y -= box.height
        if light.position.x > ep.x { light.compute_shadow_volume_for_edge(sp, ep) }

        // The box itself
        light.shadows[light.shadow_count%max_shadows].set_vertices(
            rl.Vector2 { box.x,             box.y              },
            rl.Vector2 { box.x,             box.y + box.height },
            rl.Vector2 { box.x + box.width, box.y + box.height },
            rl.Vector2 { box.x + box.width, box.y              }           
        )
        
        light.shadow_count++
    }

    light.valid = true

    light.draw_mask()

    return true
}


// Setup a light
fn create_lights(x f32, y f32, radius f32) []LightInfo {
    mut lights := []LightInfo{ len: max_lights }
    for mut light in lights {
        light.setup(x, y, radius)
    }
    return lights
}



// Set up some boxes
// fn create_boxes(mut boxes []rl.Rectangle, count &int) {
fn create_boxes() []rl.Rectangle {
    mut boxes := []rl.Rectangle{len: max_boxes }

    boxes[0] = rl.Rectangle {  150,  80, 40, 40 }
    boxes[1] = rl.Rectangle { 1200, 700, 40, 40 }
    boxes[2] = rl.Rectangle {  200, 600, 40, 40 }
    boxes[3] = rl.Rectangle { 1000,  50, 40, 40 }
    boxes[4] = rl.Rectangle {  500, 350, 40, 40 }

    for i in 0..max_boxes {
        boxes[i] = rl.Rectangle {
            f32(rl.get_random_value(0, rl.get_screen_width())),
            f32(rl.get_random_value(0, rl.get_screen_height())),
            f32(rl.get_random_value(10,100)),
            f32(rl.get_random_value(10,100))
        }
    }
    return boxes
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [shapes] example - top down lights")
    defer { rl.close_window() }       // Close window and OpenGL context


    // Create a checkerboard ground texture
    img := rl.gen_image_checked(64, 64, 32, 32, rl.darkbrown, rl.darkgray)
    background_texture := rl.load_texture_from_image(img)
    defer { rl.unload_texture(background_texture) }
    rl.unload_image(img)

    // Create a global light mask to hold all the blended lights
    light_mask := rl.load_render_texture(rl.get_screen_width(), rl.get_screen_height())
    defer { rl.unload_render_texture(light_mask) }

    // Initialize our 'world' of boxes
    mut boxes := create_boxes()
    // Setup initial light
    mut lights := create_lights(600, 400, 300)
    defer { for light in lights { if light.active { rl.unload_render_texture(light.mask) }}}
    
    mut next_light := int(1)
    mut show_lines := false

    rl.set_target_fps(60)            // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Drag light 0
        if rl.is_mouse_button_down(rl.mouse_button_left) {
            lights[0].move(rl.get_mouse_position().x, rl.get_mouse_position().y)
        }

        // Make a new light
        if rl.is_mouse_button_pressed(rl.mouse_button_right) && (next_light < max_lights) {
            lights[next_light].setup(rl.get_mouse_position().x, rl.get_mouse_position().y, 200)
            next_light++
        }

        // Toggle debug info
        if rl.is_key_pressed(rl.key_f1) {
            show_lines = !show_lines
        }

        // Update the lights and keep track if any were dirty so we know if we need to update the master light mask
        mut dirty_lights := false
        for mut light in lights {
            if light.update(boxes) {
                dirty_lights = true
            }
        }

        // Update the light mask
        if dirty_lights {
            // Build up the light mask
            rl.begin_texture_mode(light_mask)
            
                rl.clear_background(rl.black)

                // Force the blend mode to only set the alpha of the destination
                rl.rl_set_blend_factors(rlgl_src_alpha, rlgl_src_alpha, rlgl_min)
                rl.rl_set_blend_mode(rl.blend_custom)

                // Merge in all the light masks
                // for (int i = 0 i < max_lights i++)
                for light in lights {
                    if light.active {
                        rl.draw_texture_rec(
                            light.mask.texture,
                            rl.Rectangle {
                                0, 0,
                                f32(rl.get_screen_width()),
                                f32(-rl.get_screen_height())
                            },
                            rl.Vector2{},
                            rl.white
                        )
                    }
                }

                rl.rl_draw_render_batch_active()

                // Go back to normal blend
                rl.rl_set_blend_mode(rl.blend_alpha)
            rl.end_texture_mode()
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.black)
            
            // Draw the tile background
            rl.draw_texture_rec(
                background_texture,
                rl.Rectangle {
                    0, 0, f32(rl.get_screen_width()), f32(rl.get_screen_height())
                },
                rl.Vector2{},
                rl.white
            )
            
            // Overlay the shadows from all the lights
            rl.draw_texture_rec(
                light_mask.texture,
                rl.Rectangle {
                    0, 0, f32(rl.get_screen_width()), f32(-rl.get_screen_height())
                },
                rl.Vector2{},
                rl.color_alpha(rl.white, if show_lines { f32(0.75) } else { f32(1.0) })
            )

            // Draw the lights
            // for (int i = 0 i < max_lights i++)
            for i, light in lights {
                if light.active {
                    rl.draw_circle(int(light.position.x), int(light.position.y), 10, if i == 0 { rl.yellow } else { rl.white })
                    rl.draw_circle(int(light.position.x), int(light.position.y), 10, if i == 0 { rl.yellow } else { rl.white })
                }
            }

            if show_lines {
                // for (int s = 0 s < lights[0].shadow_count s++)
                light := lights[0]
                for s in 0..light.shadow_count {
                    rl.draw_triangle_fan(&light.shadows[s].vertices[0], 4, rl.darkpurple)
                }

                // for (int b = 0 b < box_count b++)
                for box in boxes {
                    if rl.check_collision_recs(box, light.bounds) {
                        rl.draw_rectangle_rec(box, rl.purple)
                    }

                    rl.draw_rectangle_lines(int(box.x), int(box.y), int(box.width), int(box.height), rl.darkblue)
                }

                rl.draw_text("(F1) Hide Shadow Volumes", 10, 50, 10, rl.green)
            }
            else
            {
                rl.draw_text("(F1) Show Shadow Volumes", 10, 50, 10, rl.green)
            }

            rl.draw_fps(screen_width - 80, 10)
            rl.draw_text("Drag to move light #1", 10, 10, 10, rl.darkgreen)
            rl.draw_text("Right click to add new light", 10, 30, 10, rl.darkgreen)

        rl.end_drawing()
    }
}
