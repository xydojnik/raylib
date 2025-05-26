/*******************************************************************************************
*
*   raylib [txt] example - Draw 3d
*
*   NOTE: Draw a 2D txt in 3D space, each letter is drawn in a quad (or 2 quads if backface is set)
*   where the texture coodinates of each quad map to the texture coordinates of the glyphs
*   inside the font texture.
*
*   A more efficient approach, i believe, would be to render the txt in a render texture and
*   map that texture to a plane and render that, or maybe a shader but my method allows more
*   flexibility...for example to change position of each letter individually to make somethink
*   like a wavy txt effect.
*    
*   Special thanks to:
*        @Nighten for the DrawTextStyle() code https://github.com/NightenDushi/Raylib_DrawTextStyle
*        Chris Camacho (codifies - http://bedroomcoders.co.uk/) for the alpha discard shader
*
*   Example originally created with raylib 3.5, last time updated with raylib 4.0
*
*   Example contributed by Vlad Adrian (@demizdor) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2021-2023 Vlad Adrian  (@demizdor)
*   Translated&Modified (c) 2024 Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

                        
// It does not work liky it should. I will fix it... some day.
                        
//--------------------------------------------------------------------------------------
// Globals
//--------------------------------------------------------------------------------------
const letter_boundry_size  = 0.25
const text_max_layers      = 32
const letter_boundry_color = rl.violet

__global (
    show_letter_boundry = false
    show_text_boundry   = false
)

//--------------------------------------------------------------------------------------
// Data Types definition
//--------------------------------------------------------------------------------------

// Configuration structure for waving the txt
struct WaveTextConfig {
pub mut:
    wave_range  rl.Vector3
    wave_speed  rl.Vector3
    wave_offset rl.Vector3
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.set_config_flags(rl.flag_msaa_4x_hint | rl.flag_vsync_hint)
    rl.init_window(screen_width, screen_height, "raylib [txt] example - draw 2D txt in 3D")
    defer { rl.close_window() }       // Close window and OpenGL context

    mut spin       := true  // Spin the camera?
    mut multicolor := false // Multicolor mode

    // Define the camera to look into our 3d world
    mut camera := rl.Camera3D {
        position:    rl.Vector3 { -10.0, 15.0, -10.0 } // Camera position
        target:      rl.Vector3 {}                     // Camera looking at point
        up:          rl.Vector3 { 0.0, 1.0, 0.0 }      // Camera up vector (rotation towards target)
        fovy:        45.0                              // Camera field-of-view Y
        projection:  rl.camera_perspective             // Camera projection type
    }

    mut camera_mode := rl.camera_orbital

    cube_position := rl.Vector3 { 0.0, 1.0, 0.0 }
    cube_size     := rl.Vector3 { 2.0, 2.0, 2.0 }

    // Use the default font
    mut font := rl.get_font_default()
    defer { rl.unload_font(font) }
    
    mut font_size    := f32( 8.0)
    mut font_spacing := f32( 0.5)
    mut line_spacing := f32(-1.0)

    // Set the txt (using markdown!)
    mut txt := []u8{len: 64, init: 0}
    mut t   := "Hello ~~World~~ in 3D!"
    unsafe { vmemcpy(txt.data, t.str, t.len) }

    mut tbox           := rl.Vector3 {}
    mut layers         := int(1)
    mut quads          := int(0)
    mut layer_distance := f32(0.01)

    wcfg := WaveTextConfig {
        wave_speed:  rl.Vector3{ 3.0,  3.0,   0.5 }
        wave_offset: rl.Vector3{ 0.35, 0.35, 0.35 }
        wave_range:  rl.Vector3{ 0.45, 0.45, 0.45 }
    }

    mut time := f32(0.0)

    // Setup a light and dark color
    mut light := rl.maroon
    mut dark  := rl.red

    // Load the alpha discard shader
    alpha_discard := rl.load_shader(voidptr(0), "resources/shaders/glsl330/alpha_discard.fs".str)

    // Array filled with multiple random colors (when multicolor mode is set)
    mut multi := []rl.Color{len: text_max_layers }

    rl.disable_cursor()                     // Limit cursor to relative movement inside the window

    rl.set_target_fps(60)                   // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {         // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        rl.update_camera(&camera, camera_mode)
        
        // Handle font files dropped
        if rl.is_file_dropped() {
            dropped_files := rl.load_dropped_files()

            // NOTE: We only support first ttf file dropped
            drop_file_name := unsafe { dropped_files.paths[0].vstring() }

            if rl.is_file_extension(drop_file_name, ".ttf") {
                rl.unload_font(font)
                font = rl.load_font_ex(drop_file_name, int(font_size), voidptr(0), 0)
            } else if rl.is_file_extension(drop_file_name, ".fnt") {
                rl.unload_font(font)
                font      = rl.load_font(drop_file_name)
                font_size = f32(font.baseSize)
            }
            
            rl.unload_dropped_files(dropped_files)    // Unload filepaths from memory
        }

        // Handle Events
        if rl.is_key_pressed(rl.key_f1) { show_letter_boundry = !show_letter_boundry }
        if rl.is_key_pressed(rl.key_f2) { show_text_boundry   = !show_text_boundry   }
        if rl.is_key_pressed(rl.key_f3) {
            // Handle camera change
            spin = !spin
            // we need to reset the camera when changing modes
            camera = rl.Camera3D {
                target:      rl.Vector3 { 0.0, 0.0, 0.0 } // Camera looking at point
                up:          rl.Vector3 { 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
                fovy:        45.0                         // Camera field-of-view Y
                projection:  rl.camera_perspective        // Camera mode type
            }
            

            if spin {
                camera.position = rl.Vector3 { -10.0, 15.0, -10.0 }   // Camera position
                camera_mode     = rl.camera_orbital
            } else {
                camera.position = rl.Vector3 { 10.0, 10.0, -10.0 }    // Camera position
                camera_mode     = rl.camera_free
            }
        }

        // Handle clicking the cube
        if rl.is_mouse_button_pressed(rl.mouse_button_left) {
            ray := rl.get_mouse_ray(rl.get_mouse_position(), camera)

            // Check collision between ray and box
            collision := rl.get_ray_collision_box(
                ray,
                rl.BoundingBox {
                    rl.Vector3 {
                        cube_position.x - cube_size.x/2,
                        cube_position.y - cube_size.y/2,
                        cube_position.z - cube_size.z/2
                    },
                    rl.Vector3 {
                        cube_position.x + cube_size.x/2,
                        cube_position.y + cube_size.y/2,
                        cube_position.z + cube_size.z/2
                    }
                }
            )
            if collision.hit {
                // Generate new random colors
                light = generate_random_color(0.5, 0.78)
                dark  = generate_random_color(0.4, 0.58)
            }
        }

        // Handle txt layers changes
        if      rl.is_key_pressed(rl.key_home) { if layers > 1               { layers-- } }
        else if rl.is_key_pressed(rl.key_end)  { if layers < text_max_layers { layers++ } }

        // Handle txt changes
        if      rl.is_key_pressed(rl.key_left)      { font_size      -= 0.5   }
        else if rl.is_key_pressed(rl.key_right)     { font_size      += 0.5   }
        else if rl.is_key_pressed(rl.key_up)        { font_spacing   -= 0.1   }
        else if rl.is_key_pressed(rl.key_down)      { font_spacing   += 0.1   }
        else if rl.is_key_pressed(rl.key_page_up)   { line_spacing   -= 0.1   }
        else if rl.is_key_pressed(rl.key_page_down) { line_spacing   += 0.1   }
        else if rl.is_key_down(rl.key_insert)       { layer_distance -= 0.001 }
        else if rl.is_key_down(rl.key_delete)       { layer_distance += 0.001 }
        else if rl.is_key_pressed(rl.key_tab)       {
            multicolor = !multicolor   // Enable /disable multicolor mode

            if multicolor {
                // Fill color array with random colors
                for i in 0..text_max_layers {
                    multi[i]   = generate_random_color(0.5, 0.8)
                    multi[i].a = u8(rl.get_random_value(0, 255))
                }
            }
        }

        // Handle txt input
        ch := rl.get_char_pressed()
        if rl.is_key_pressed(rl.key_backspace) {
            // Remove last char
            len := rl.text_length(txt.data)
            if len > 0 { txt[len - 1] = `\0` }
        } else if rl.is_key_pressed(rl.key_enter) {
            // handle newline
            len := rl.text_length(txt.data)
            if len < sizeof(txt) - 1 {
                txt[len]   = `\n`
                txt[len+1] =`\0`
            }
        } else {
            // append only printable chars
            len := rl.text_length(txt.data)
            if len < txt.len-1 {
                txt[len]   = u8(ch)
                txt[len+1] =`\0`
            }
        }

        // Measure 3D txt so we can center it
        tbox = measure_text_wave_3d(font, txt, font_size, font_spacing, line_spacing)

        quads = 0                   // Reset quad counter
        time += rl.get_frame_time() // Update timer needed by `draw_text_wave_3d()`
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.begin_mode_3d(camera)
                rl.draw_cube_v(cube_position, cube_size, dark)
                rl.draw_cube_wires(cube_position, 2.1, 2.1, 2.1, light)

                rl.draw_grid(10, 2.0)

                // Use a shader to handle the depth buffer issue with transparent textures
                // NOTE: more info at https://bedroomcoders.co.uk/raylib-billboards-advanced-use/
                rl.begin_shader_mode(alpha_discard)

                    // Draw the 3D txt above the red cube
                    rl.rl_push_matrix()
                        rl.rl_rotatef(90.0, 1.0, 0.0,  0.0)
                        rl.rl_rotatef(90.0, 0.0, 0.0, -1.0)

                        for i in 0..layers {
                            mut clr := light
                            if multicolor {
                                clr = multi[i]
                            }
                            draw_text_wave_3d(
                                font, txt, rl.Vector3 { -tbox.x/2.0, layer_distance*i, -4.5 },
                                font_size, font_spacing, line_spacing, true, &wcfg, time, clr
                            )
                        }

                        // Draw the txt boundry if set
                        if show_text_boundry {
                            rl.draw_cube_wires_v(
                                rl.Vector3 { 0.0, 0.0, -4.5 + tbox.z/2 }, tbox, dark
                            )
                        }
                    rl.rl_pop_matrix()

                    // Don't draw the letter boundries for the 3D txt below
                    mut slb := show_letter_boundry
                    show_letter_boundry = false

                    // Draw 3D options (use default font)
                    //-------------------------------------------------------------------------
                    default_font := rl.get_font_default()
                    rl.rl_push_matrix()
                        rl.rl_rotatef(180.0, 0.0, 1.0, 0.0)
                        mut opt := "< SIZE: ${font_size} >".str           // println(unsafe { (&opt[0]).vstring() })
                        quads += rl.text_length(opt)
                        mut m   := measure_text_3d(default_font, opt, 8.0, 1.0, 0.0)
                        mut pos := rl.Vector3 { -m.x/2.0, 0.01, 2.0}
                        draw_text_3d(default_font, opt, pos, 8.0, 1.0, 0.0, false, rl.blue)
                        pos.z += 0.5 + m.z

                        opt = "< SPACING: ${font_spacing} >".str
                        quads += rl.text_length(opt)
                        m = measure_text_3d(default_font, opt, 8.0, 1.0, 0.0)
                        pos.x = -m.x/2.0
                        draw_text_3d(default_font, opt, pos, 8.0, 1.0, 0.0, false, rl.blue)
                        pos.z += 0.5 + m.z

                        opt = "< LINE: ${line_spacing} >".str             // println(unsafe { (&opt[0]).vstring() })
                        quads += rl.text_length(opt)
                        m = measure_text_3d(default_font, opt, 8.0, 1.0, 0.0)
                        pos.x = -m.x/2.0
                        draw_text_3d(default_font, opt, pos, 8.0, 1.0, 0.0, false, rl.blue)
                        pos.z += 1.0 + m.z

                        opt = "< LBOX: ${if slb {'ON'}else{'OFF'}} >".str // println(unsafe { (&opt[0]).vstring() })
                        quads += rl.text_length(opt)
                        m = measure_text_3d(default_font, opt, 8.0, 1.0, 0.0)
                        pos.x = -m.x/2.0
                        draw_text_3d(default_font, opt, pos, 8.0, 1.0, 0.0, false, rl.red)
                        pos.z += 0.5 + m.z

                        is_show_txt_boundry := if show_text_boundry { 'ON' } else { 'OFF'}
                        opt = "< TBOX: ${is_show_txt_boundry} >".str      // println(unsafe { (&opt[0]).vstring() })
                        quads += rl.text_length(opt)
                        m = measure_text_3d(default_font, opt, 8.0, 1.0, 0.0)
                        pos.x = -m.x/2.0
                        draw_text_3d(default_font, opt, pos, 8.0, 1.0, 0.0, false, rl.red)
                        pos.z += 0.5 + m.z

                        opt = "< LAYER DISTANCE: ${layer_distance} >".str // println(unsafe { (&opt[0]).vstring() })
                        quads += rl.text_length(opt)
                        m = measure_text_3d(default_font, opt, 8.0, 1.0, 0.0)
                        pos.x = -m.x/2.0
                        draw_text_3d(default_font, opt, pos, 8.0, 1.0, 0.0, false, rl.darkpurple)
                    rl.rl_pop_matrix()
                    //-------------------------------------------------------------------------

                    // Draw 3D info txt (use default font)
                    //-------------------------------------------------------------------------
                    opt = "All the txt displayed here is in 3D".str
                    quads += 36
                    m = measure_text_3d(default_font, opt, 10.0, 0.5, 0.0)
                    pos = rl.Vector3 {-m.x/2.0, 0.01, 2.0}
                    draw_text_3d(default_font, opt, pos, 10.0, 0.5, 0.0, false, rl.darkblue)
                    pos.z += 1.5 + m.z

                    opt = "Press [Left]/[Right] to change the font size".str
                    quads += 44
                    m = measure_text_3d(default_font, opt, 6.0, 0.5, 0.0)
                    pos.x = -m.x/2.0
                    draw_text_3d(default_font, opt, pos, 6.0, 0.5, 0.0, false, rl.darkblue)
                    pos.z += 0.5 + m.z

                    opt = "Press [Up]/[Down] to change the font spacing".str
                    quads += 44
                    m = measure_text_3d(default_font, opt, 6.0, 0.5, 0.0)
                    pos.x = -m.x/2.0
                    draw_text_3d(default_font, opt, pos, 6.0, 0.5, 0.0, false, rl.darkblue)
                    pos.z += 0.5 + m.z

                    opt = "Press [PgUp]/[PgDown] to change the line spacing".str
                    quads += 48
                    m = measure_text_3d(default_font, opt, 6.0, 0.5, 0.0)
                    pos.x = -m.x/2.0
                    draw_text_3d(default_font, opt, pos, 6.0, 0.5, 0.0, false, rl.darkblue)
                    pos.z += 0.5 + m.z

                    opt = "Press [F1] to toggle the letter boundry".str
                    quads += 39
                    m = measure_text_3d(default_font, opt, 6.0, 0.5, 0.0)
                    pos.x = -m.x/2.0
                    draw_text_3d(default_font, opt, pos, 6.0, 0.5, 0.0, false, rl.darkblue)
                    pos.z += 0.5 + m.z

                    opt = "Press [F2] to toggle the txt boundry".str
                    quads += 37
                    m = measure_text_3d(default_font, opt, 6.0, 0.5, 0.0)
                    pos.x = -m.x/2.0
                    draw_text_3d(default_font, opt, pos, 6.0, 0.5, 0.0, false, rl.darkblue)
                    //-------------------------------------------------------------------------

                    show_letter_boundry = slb
                rl.end_shader_mode()

            rl.end_mode_3d()

            // Draw 2D info txt & stats
            //-------------------------------------------------------------------------
            rl.draw_text("Drag & drop a font file to change the font!\nType something, see what happens!\n\nPress [F3] to toggle the camera", 10, 35, 10, rl.black)

            quads += rl.text_length(txt.data)*2*layers
            mut tmp := "${layers} layer(s) | ${if spin {'ORBITAL'}else{'FREE'}} camera | ${quads} quads (${quads*4} verts)".str

            mut width := rl.measure_text(tmp, 10)
            rl.draw_text( unsafe { tmp.vstring() }, screen_width - 20 - width, 10, 10, rl.darkgreen)

            tmp = "[Home]/[End] to add/remove 3D txt layers".str
            width = rl.measure_text(tmp, 10)
            rl.draw_text(unsafe { tmp.vstring() }, screen_width - 20 - width, 25, 10, rl.darkgray)

            tmp = "[Insert]/[Delete] to increase/decrease distance between layers".str
            width = rl.measure_text(tmp, 10)
            rl.draw_text(unsafe { tmp.vstring() }, screen_width - 20 - width, 40, 10, rl.darkgray)

            tmp = "click the [CUBE] for a random color".str
            width = rl.measure_text(tmp, 10)
            rl.draw_text(unsafe { tmp.vstring() }, screen_width - 20 - width, 55, 10, rl.darkgray)

            tmp = "[Tab] to toggle multicolor mode".str
            width = rl.measure_text(tmp, 10)
            rl.draw_text(unsafe { tmp.vstring() }, screen_width - 20 - width, 70, 10, rl.darkgray)
            //-------------------------------------------------------------------------

            rl.draw_fps(10, 10)

        rl.end_drawing()
        //----------------------------------------------------------------------------------
    }
}



// // Draw a codepoint in 3D space
// static void draw_text_codepoint_3d(Font font, int codepoint, rl.Vector3 position, f32 font_size, bool backface, Color tint)
// // Draw a 2D txt in 3D space
// static void draw_text_3d(Font font, const char *txt, rl.Vector3 position, f32 font_size, f32 font_spacing, f32 line_spacing, bool backface, Color tint)
// // Measure a txt in 3D. For some reason `MeasureTextEx()` just doesn't seem to work so i had to use this instead.


//--------------------------------------------------------------------------------------
// Module Functions Definitions
//--------------------------------------------------------------------------------------
// Draw codepoint at specified position in 3D space
fn draw_text_codepoint_3d(font rl.Font, codepoint int, pos rl.Vector3, font_size f32, backface bool, tint rl.Color) {
    // // Character index position in sprite font
    // // NOTE: In case a codepoint is not available in the font, index returned points to '?'
    index := rl.get_glyph_index(font, codepoint)
    scale := font_size/f32(font.baseSize)

    // // Character destination rectangle on screen
    // // NOTE: We consider charsPadding on drawing
    mut position := rl.Vector3 {
        pos.x + f32(unsafe { font.glyphs[index].offsetX } - font.glyphPadding)/f32(font.baseSize)*scale
        pos.y
        pos.z + f32(unsafe { font.glyphs[index].offsetY } - font.glyphPadding)/f32(font.baseSize)*scale
    }

    // // Character source rectangle from font texture atlas
    // // NOTE: We consider chars padding when drawing, it could be required for outline/glow shader effects
    src_rec := unsafe {
        rl.Rectangle {
            font.recs[index].x      - f32(font.glyphPadding)
            font.recs[index].y      - f32(font.glyphPadding)
            font.recs[index].width  + 2.0*f32(font.glyphPadding)
            font.recs[index].height + 2.0*f32(font.glyphPadding)
        }
    }

    width  := f32(unsafe { font.recs[index].width  } + 2.0*f32(font.glyphPadding))/f32(font.baseSize)*scale
    height := f32(unsafe { font.recs[index].height } + 2.0*f32(font.glyphPadding))/f32(font.baseSize)*scale

    if font.texture.id > 0 {
        x := f32(0.0)
        y := f32(0.0)
        z := f32(0.0)

        // normalized texture coordinates of the glyph inside the font texture (0.0 -> 1.0)
        tx :=  src_rec.x/font.texture.width
        ty :=  src_rec.y/font.texture.height
        tw := (src_rec.x+src_rec.width) /font.texture.width
        th := (src_rec.y+src_rec.height)/font.texture.height

        if show_letter_boundry {
            rl.draw_cube_wires_v(
                rl.Vector3 { position.x + width/2, position.y, position.z + height/2},
                rl.Vector3 { width, letter_boundry_size, height },
                letter_boundry_color
            )
        }

        rl.rl_check_render_batch_limit(4 + 4*int(backface))
        rl.rl_set_texture(font.texture.id)

        rl.rl_push_matrix()
            rl.rl_translatef(position.x, position.y, position.z)

            rl.rl_begin(rl.rl_quads)
                rl.rl_color4ub(tint.r, tint.g, tint.b, tint.a)

                // Front Face
                rl.rl_normal3f(0.0, 1.0, 0.0)                                   // Normal Pointing Up
                rl.rl_tex_coord2f(tx, ty) rl.rl_vertex3f(x,         y, z)              // Top Left Of The Texture and Quad
                rl.rl_tex_coord2f(tx, th) rl.rl_vertex3f(x,         y, z + height)     // Bottom Left Of The Texture and Quad
                rl.rl_tex_coord2f(tw, th) rl.rl_vertex3f(x + width, y, z + height)     // Bottom Right Of The Texture and Quad
                rl.rl_tex_coord2f(tw, ty) rl.rl_vertex3f(x + width, y, z)              // Top Right Of The Texture and Quad

                if backface {
                    // Back Face
                    rl.rl_normal3f(0.0, -1.0, 0.0)                              // Normal Pointing Down
                    rl.rl_tex_coord2f(tx, ty) rl.rl_vertex3f(x,         y, z)          // Top Right Of The Texture and Quad
                    rl.rl_tex_coord2f(tw, ty) rl.rl_vertex3f(x + width, y, z)          // Top Left Of The Texture and Quad
                    rl.rl_tex_coord2f(tw, th) rl.rl_vertex3f(x + width, y, z + height) // Bottom Left Of The Texture and Quad
                    rl.rl_tex_coord2f(tx, th) rl.rl_vertex3f(x,         y, z + height) // Bottom Right Of The Texture and Quad
                }
            rl.rl_end()
        rl.rl_pop_matrix()

        rl.rl_set_texture(0)
    }
}


// Draw a 2D txt in 3D space
// fn draw_text_3d(font rl.Font, txt &char, position rl.Vector3, font_size f32, font_spacing f32, line_spacing f32, backface bool, tint rl.Color) {
fn draw_text_3d(font rl.Font, txt &u8, position rl.Vector3, font_size f32, font_spacing f32, line_spacing f32, backface bool, tint rl.Color) {
    len:= rl.text_length(txt) // Total length in bytes of the txt, scanned by codepoints in loop

    mut text_offset_y := f32(0.0) // Offset between lines (on line break '\n')
    mut text_offset_x := f32(0.0) // Offset X to next character to draw

    scale := font_size/f32(font.baseSize)

    for i:=int(0); i<len; i++ {
        // Get next codepoint from byte string and glyph index in font
        mut codepoint_byte_count := 0
        mut codepoint            := rl.get_codepoint(txt, &codepoint_byte_count)
        mut index                := rl.get_glyph_index(font, codepoint)

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if codepoint == 0x3 {
            codepoint_byte_count = 1
        }

        if codepoint == `\n` {
            // NOTE: Fixed line spacing of 1.5 line-height
            // TODO: Support custom line spacing defined by user
            text_offset_y += scale + line_spacing/f32(font.baseSize)*scale
            text_offset_x = 0.0
        } else {
            if (codepoint != ` `) && (codepoint != `\t`) {
                draw_text_codepoint_3d(
                    font, codepoint,
                    rl.Vector3 { position.x + text_offset_x, position.y, position.z + text_offset_y },
                    font_size, backface, tint
                )
            }
            
            text_offset_x += unsafe {
                if font.glyphs[index].advanceX  == 0 {;
                    f32(font.recs[index].width + font_spacing)/f32(font.baseSize)*scale
                } else {
                    f32(font.glyphs[index].advanceX + font_spacing)/f32(font.baseSize)*scale
                }
            }
        }
        i += codepoint_byte_count   // Move txt bytes counter to next codepoint
    }
}


// // Measure a txt in 3D. For some reason `MeasureTextEx()` just doesn't seem to work so i had to use this instead.
// fn measure_text_3d(font rl.Font, txt &char, font_size f32, font_spacing f32, line_spacing f32) rl.Vector3 {
fn measure_text_3d(font rl.Font, txt &u8, font_size f32, font_spacing f32, line_spacing f32) rl.Vector3 {
    // return rl.Vector3{}
    
    len := rl.text_length(txt)
    // len             := txt.len
    mut temp_len    := int(0)       // Used to count longer txt line num chars
    mut len_counter := int(0)

    mut temp_text_width := f32(0.0) // Used to count longer txt line width

    mut scale       := font_size/f32(font.baseSize)
    mut text_height := scale
    mut text_width  := f32(0.0)

    mut letter := int(0)            // Current character
    mut index  := int(0)            // Index position in sprite font

    for i:=int(0); i<len; i++ {
        len_counter++

        mut next := int(0)
        letter = rl.get_codepoint(txt, &next)
        index  = rl.get_glyph_index(font, letter)

        // NOTE: normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol so to not skip any we set next = 1
        if letter == 0x3 { next = 1 }
        i += next - 1

        if letter != `\n` {
            unsafe {
                text_width += if font.glyphs[index].advanceX != 0 {
                    (font.glyphs[index].advanceX+font_spacing)/f32(font.baseSize)*scale
                } else {
                    (font.recs[index].width + font.glyphs[index].offsetX)/f32(font.baseSize)*scale
                }
            }
        } else {
            if temp_text_width < text_width {
                temp_text_width = text_width
            }
            len_counter = 0
            text_width  = 0.0
            text_height += scale + line_spacing/f32(font.baseSize)*scale
        }

        if temp_len < len_counter {
            temp_len = len_counter
        }
    }

    if temp_text_width < text_width {
        temp_text_width = text_width
    }

    mut vec := rl.Vector3{
        temp_text_width + f32((temp_len - 1)*font_spacing/f32(font.baseSize)*scale) // Adds chars spacing to measure
        0.25
        text_height
    }

    return vec
}


// // Draw a 2D txt in 3D space and wave the parts that start with `~~` and end with `~~`.
// // This is a modified version of the original code by @Nighten found here https://github.com/NightenDushi/Raylib_DrawTextStyle
fn draw_text_wave_3d(font rl.Font, txt []u8, position rl.Vector3, font_size f32, font_spacing f32, line_spacing f32, backface bool, config &WaveTextConfig, time f32, tint rl.Color)
{
    // length := txt.len            // Total length in bytes of the txt, scanned by codepoints in loop
    length := rl.text_length(txt.data)            // Total length in bytes of the txt, scanned by codepoints in loop

    mut text_offset_y := f32(0.0) // Offset between lines (on line break '\n')
    mut text_offset_x := f32(0.0) // Offset X to next character to draw

    scale := font_size/f32(font.baseSize)

    mut wave := false

    mut i := int(0)
    mut k := int(0)
    for i < length {
        // Get next codepoint from byte string and glyph index in font
        mut codepoint_byte_count := int(0)
        mut codepoint            := rl.get_codepoint(&txt[i], &codepoint_byte_count)
        mut index                := rl.get_glyph_index(font, codepoint)

        // NOTE: Normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol moving one byte
        if codepoint == 0x3f {
            codepoint_byte_count = 1
        }

        if codepoint == `\n` {
            // NOTE: Fixed line spacing of 1.5 line-height
            // TODO: Support custom line spacing defined by user
            text_offset_y += scale + line_spacing/f32(font.baseSize)*scale
            text_offset_x = 0.0
            k = 0
        } else if codepoint == `~` {
            if rl.get_codepoint(&txt[i+1], &codepoint_byte_count) == `~` {
                codepoint_byte_count += 1
                wave = !wave
            }
        } else {
            if (codepoint != ` `) && (codepoint != `\t`) {
                mut pos := position
                if wave {// Apply the wave effect
                    pos.x += rl.sinf(time*config.wave_speed.x-k*config.wave_offset.x)*config.wave_range.x
                    pos.y += rl.sinf(time*config.wave_speed.y-k*config.wave_offset.y)*config.wave_range.y
                    pos.z += rl.sinf(time*config.wave_speed.z-k*config.wave_offset.z)*config.wave_range.z
                }

                draw_text_codepoint_3d(
                    font, codepoint,
                    rl.Vector3 { pos.x + text_offset_x, pos.y, pos.z + text_offset_y },
                    font_size, backface, tint
                )
            }

            text_offset_x += unsafe { if font.glyphs[index].advanceX == 0 {
                    f32(font.recs[index].width + font_spacing)/f32(font.baseSize)*scale
                } else {
                    f32(font.glyphs[index].advanceX + font_spacing)/f32(font.baseSize)*scale
                }
            }
        }

        i += codepoint_byte_count   // Move txt bytes counter to next codepoint
        k++
    }
}


// // Measure a txt in 3D ignoring the `~~` chars.
fn measure_text_wave_3d(font rl.Font, txt []u8, font_size f32, font_spacing f32, line_spacing f32) rl.Vector3 {
    len := rl.text_length(txt.data)

    mut temp_len        := int(0)   // Used to count longer txt line num chars
    mut len_counter     := int(0)

    mut temp_text_width := f32(0.0) // Used to count longer txt line width

    mut scale           := font_size/f32(font.baseSize)
    mut text_height     := scale
    mut text_width      := f32(0.0)

    mut letter          := int(0)   // Current character
    mut index           := int(0)   // Index position in sprite font

    for i:=int(0); i < len; i++ {
        len_counter++

        mut next := int(0)
        letter = rl.get_codepoint(&txt[i], &next)
        index  = rl.get_glyph_index(font, letter)

        // NOTE: normally we exit the decoding sequence as soon as a bad byte is found (and return 0x3f)
        // but we need to draw all of the bad bytes using the '?' symbol so to not skip any we set next = 1
        if letter == 0x3 { next = 1 }
        i += next - 1

        if letter != `\n` {
            if letter == `~` && rl.get_codepoint(&txt[i+1], &next) == `~` {
                i++
            } else {
                unsafe {
                    text_width += if font.glyphs[index].advanceX != 0 {
                        (font.glyphs[index].advanceX+font_spacing)/f32(font.baseSize)*scale
                    } else {
                        (font.recs[index].width + font.glyphs[index].offsetX)/f32(font.baseSize)*scale
                    }
                }
            }
        } else {
            if temp_text_width < text_width { temp_text_width = text_width }
            len_counter = 0
            text_width  = 0.0
            text_height += scale + line_spacing/f32(font.baseSize)*scale
        }

        if temp_len < len_counter { temp_len = len_counter }
    }
    if temp_text_width < text_width { temp_text_width = text_width }

    mut vec := rl.Vector3 {
        temp_text_width + (temp_len-1)*font_spacing/f32(font.baseSize)*scale // Adds chars spacing to measure
        0.25
        text_height
    }

    return vec
}


// Generates a nice color with a random hue
fn generate_random_color(s f32, v f32) rl.Color {
    phi := f32(0.618033988749895) // Golden ratio conjugate
    mut h := f32(rl.get_random_value(0, 360))
    
    h = rl.fmodf(h + h*phi, 360.0)
    
    return rl.color_from_hsv(h, s, v)
}
