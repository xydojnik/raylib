/*******************************************************************************************
*
*   raylib [textures] example - Draw part of the texture tiled
*
*   Example originally created with raylib 3.0, last time updated with raylib 4.2
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2020-2023 Vlad Adrian      (@demizdor) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

const asset_path  = @VMODROOT+'/thirdparty/raylib/examples/textures/resources/'
const opt_width   = 220       // Max width for the options container
const margin_size =   8       // Size for the margins
const color_size  =  16       // Size of the color select buttons

// Draw part of a texture (defined by a rectangle) with rotation and scale tiled into dest.
fn draw_texture_tiled(texture rl.Texture2D, source rl.Rectangle, dest rl.Rectangle, origin rl.Vector2, rotation f32, scale f32, tint rl.Color) {
    if (texture.id   <= 0) || (scale         <= 0.0) { return }  
    if (source.width == 0) || (source.height == 0)   { return }

    tile_width  := int(source.width *scale)
    tile_height := int(source.height*scale)
    
    if (dest.width < tile_width) && (dest.height < tile_height) {
        // Can fit only one tile
        rl.draw_texture_pro(
            texture,
            rl.Rectangle {
                source.x, source.y,
                f32(dest.width/tile_width)  *source.width,
                f32(dest.height/tile_height)*source.height
            },
            rl.Rectangle {
                dest.x,     dest.y,
                dest.width, dest.height
            }, origin, rotation, tint)
    } else if dest.width <= tile_width {
        // Tiled vertically (one column)
        mut dy := int(0)
        for (dy+tile_height) < dest.height {
            rl.draw_texture_pro(
                texture,
                rl.Rectangle {
                    source.x, source.y, f32(dest.width/tile_width)*source.width, source.height
                },
                rl.Rectangle {
                    dest.x, dest.y + dy, dest.width, f32(tile_height)
                }, origin, rotation, tint
            )
            dy += tile_height
        }

        // Fit last tile
        if dy < dest.height {
            rl.draw_texture_pro(
                texture,
                rl.Rectangle {
                    source.x, source.y,
                    f32(dest.width/tile_width)*source.width,
                    (f32(dest.height - dy)/tile_height)*source.height
                },
                rl.Rectangle { dest.x, dest.y + dy, dest.width, dest.height - dy }, origin, rotation, tint)
        }
    } else if dest.height <= tile_height {
        // Tiled horizontally (one row)
        mut dx := int(0)
        for dx+tile_width < dest.width {
            rl.draw_texture_pro(
                texture,
                rl.Rectangle {
                    source.x, source.y,
                    source.width,
                    (f32(dest.height)/tile_height)*source.height},
                rl.Rectangle {
                    dest.x + dx, dest.y, f32(tile_width), dest.height
                }, origin, rotation, tint
            )
            dx += tile_width
        }

        // Fit last tile
        if dx < dest.width {
            rl.draw_texture_pro(
                texture,
                rl.Rectangle {
                    source.x, source.y,
                    (f32(dest.width - dx)/tile_width)*source.width,
                    (f32(dest.height)/tile_height)*source.height
                },
                rl.Rectangle { dest.x + dx, dest.y, dest.width - dx, dest.height }, origin, rotation, tint
            )
        }
    } else {
        // Tiled both horizontally and vertically (rows and columns)
        mut dx := int(0)
        for dx+tile_width < dest.width {
            mut dy := int(0)
            for dy+tile_height < dest.height  {
                rl.draw_texture_pro(
                    texture,
                    source,
                    rl.Rectangle {
                        dest.x + dx, dest.y + dy, f32(tile_width), f32(tile_height)
                    }, origin, rotation, tint
                )
                dx += tile_width
                dy += tile_height
            }

            if dy < dest.height {
                rl.draw_texture_pro(
                    texture,
                    rl.Rectangle { source.x, source.y, source.width, (f32(dest.height - dy)/tile_height)*source.height},
                    rl.Rectangle { dest.x + dx, dest.y + dy, f32(tile_width), dest.height - dy}, origin, rotation, tint
                )
            }
        }

        // Fit last column of tiles
        if dx < dest.width {
            mut dy := int(0)
            for dy+tile_height < dest.height {
                rl.draw_texture_pro(
                    texture,
                    rl.Rectangle {source.x, source.y, (f32(dest.width - dx)/tile_width)*source.width, source.height},
                    rl.Rectangle {dest.x + dx, dest.y + dy, dest.width - dx, f32(tile_height)}, origin, rotation, tint
                )
                dy += tile_height
            }

            // Draw final tile in the bottom right corner
            if dy < dest.height {
                rl.draw_texture_pro(
                    texture,
                    rl.Rectangle {
                        source.x, source.y,
                        (f32(dest.width  - dx)/tile_width) *source.width,
                        (f32(dest.height - dy)/tile_height)*source.height
                    },
                    rl.Rectangle {
                        dest.x + dx,     dest.y + dy,
                        dest.width - dx, dest.height - dy
                    }, origin, rotation, tint)
            }
        }
    }
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_window_resizable) // Make the window resizable
    rl.init_window(screen_width, screen_height, 'raylib [textures] example - Draw part of a texture tiled')
    defer { rl.close_window() }                                     // Close window and OpenGL context

    // NOTE: Textures MUST be loaded after Window initialization (OpenGL context is required)
    tex_pattern := rl.Texture.load(asset_path+'patterns.png')
    defer { rl.unload_texture(tex_pattern) }                        // Unload texture
    rl.set_texture_filter(tex_pattern, rl.texture_filter_trilinear) // Makes the texture smoother when upscaled

    // Coordinates for all patterns inside the texture
    rec_pattern := [
        rl.Rectangle {  3,   3,  66,  66 },
        rl.Rectangle { 75,   3, 100, 100 },
        rl.Rectangle {  3,  75,  66,  66 },
        rl.Rectangle {  7, 156,  50,  50 },
        rl.Rectangle { 85, 106,  90,  45 },
        rl.Rectangle { 75, 154, 100, 60  }
    ]

    // Setup colors
    colors := [
        rl.black, rl.maroon, rl.orange, rl.blue,     rl.purple,
        rl.beige, rl.lime,   rl.red,    rl.darkgray, rl.skyblue
    ]
    
    mut color_rec := []rl.Rectangle{len: colors.len}
    
    // Calculate rectangle for each color
    {
        mut x := int(0)
        mut y := int(0)
        // for i in 0..colors.len {
        for i, mut cr in color_rec {
            cr.x      = 2.0 + f32(margin_size + x)
            cr.y      = 22.0 + 256.0 + f32(margin_size + y)
            cr.width  = color_size*2.0
            cr.height = f32(color_size)

            if i == (colors.len/2 - 1) {
                x = 0
                y += color_size + margin_size
            } else {
                x += (color_size*2 + margin_size)
            }
        }
    }

    mut active_pattern := int(0)
    mut active_col     := int(0)
    mut scale          := f32(1.0)
    mut rotation       := f32(0.0)

    rl.set_target_fps(60)
    //---------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Handle mouse
        if rl.is_mouse_button_pressed(rl.mouse_button_left) {
            mouse := rl.get_mouse_position()

            // Check which pattern was clicked and set it as the active pattern
            for i, pattern in rec_pattern {
                if rl.check_collision_point_rec(
                    mouse,
                    rl.Rectangle {
                        2  + margin_size + pattern.x,
                        40 + margin_size + pattern.y,
                        pattern.width,
                        pattern.height })
                {
                    active_pattern = i
                    break
                }
            }

            // Check to see which color was clicked and set it as the active color
            for i, color in color_rec {
                if rl.check_collision_point_rec(mouse, color) {
                    active_col = i
                    break
                }
            }
        }

        // Handle keys

        // Change scale
        if rl.is_key_pressed(rl.key_up)   { scale += 0.25 }
        if rl.is_key_pressed(rl.key_down) { scale -= 0.25 }

        if      scale >  10.0 { scale = 10.0 }
        else if scale <= 0.0  { scale = 0.25 }

        // Change rotation
        if rl.is_key_pressed(rl.key_left)  { rotation -= 25.0 }
        if rl.is_key_pressed(rl.key_right) { rotation += 25.0 }

        // Reset
        if rl.is_key_pressed(rl.key_space) { rotation=0.0 scale=1.0 }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.raywhite)

            // Draw the tiled area
            draw_texture_tiled(
                tex_pattern, rec_pattern[active_pattern],
                rl.Rectangle {
                    f32(opt_width+margin_size),
                    f32(margin_size),
                    f32(rl.get_screen_width())  - opt_width - 2.0*margin_size,
                    f32(rl.get_screen_height()) - 2.0*margin_size
                },
                rl.Vector2 {0.0, 0.0}, rotation, scale, colors[active_col]
            )

            // Draw options
            rl.draw_rectangle(margin_size, margin_size, opt_width - margin_size, rl.get_screen_height() - 2*margin_size, rl.Color.alpha(rl.lightgray, 0.5))

            rl.draw_text('Select Pattern', 2 + margin_size, 30 + margin_size, 10, rl.black)
            rl.draw_texture(tex_pattern, 2 + margin_size, 40 + margin_size, rl.black)
            rl.draw_rectangle(
                2  + margin_size + int(rec_pattern[active_pattern].x),
                40 + margin_size + int(rec_pattern[active_pattern].y),
                int(rec_pattern[active_pattern].width),
                int(rec_pattern[active_pattern].height),
                rl.Color.alpha(rl.darkblue, 0.3)
            )

            rl.draw_text('Select rl.Color', 2+margin_size, 10+256+margin_size, 10, rl.black)
            for i in 0..colors.len {
                rl.draw_rectangle_rec(color_rec[i], colors[i])
                if active_col == i {
                    rl.draw_rectangle_lines_ex(color_rec[i], 3, rl.Color.alpha(rl.white, 0.5))
                }
            }

            rl.draw_text('Scale (UP/DOWN to change)', 2 + margin_size, 80 + 256 + margin_size, 10, rl.black)
            rl.draw_text('${scale}', 2 + margin_size, 92 + 256 + margin_size, 20, rl.black)

            rl.draw_text('Rotation (LEFT/RIGHT to change)', 2 + margin_size, 122 + 256 + margin_size, 10, rl.black)
            rl.draw_text('${rotation} degrees', 2 + margin_size, 134 + 256 + margin_size, 20, rl.black)

            rl.draw_text('Press [SPACE] to reset', 2 + margin_size, 164 + 256 + margin_size, 10, rl.darkblue)

            // Draw FPS
            rl.draw_text('${rl.get_fps()} FPS', 2 + margin_size, 2 + margin_size, 20, rl.black)
        rl.end_drawing()
    }
}
