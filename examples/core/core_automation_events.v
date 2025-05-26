/*******************************************************************************************
*
*   raylib [core] example - automation events
*
*   Example originally created with raylib 5.0, last time updated with raylib 5.0
*
*   Example based on 2d_camera_platformer example by arvyy (@arvyy)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2023 Ramon Santamaria      (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

// Not finished.

module main


import raylib as rl

const gravity         = 400
const player_jump_spd = 350.0
const player_hor_spd  = 200.0

const max_environment_elements = 5

struct Player {
mut:
    position rl.Vector2
    speed    f32
    can_jump bool
}

struct EnvElement {
    rect     rl.Rectangle
    blocking bool
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

    rl.init_window(screen_width, screen_height, "raylib [core] example - automation events")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    // Define player
    mut player := Player {
        position:  rl.Vector2 { 400, 280 }
        speed:     0
        can_jump:  false
    }
    
    // Define environment elements (platforms)
    env_elements := [ //EnvElement 
        EnvElement { rl.Rectangle {   0,   0, 1000, 400 }, false, rl.lightgray },
        EnvElement { rl.Rectangle {   0, 400, 1000, 200 }, true,  rl.gray      },
        EnvElement { rl.Rectangle { 300, 200,  400,  10 }, true,  rl.gray      },
        EnvElement { rl.Rectangle { 250, 300,  100,  10 }, true,  rl.gray      },
        EnvElement { rl.Rectangle { 650, 300,  100,  10 }, true,  rl.gray      }
    ]

    // Define camera
    mut camera := rl.Camera2D{
        target:   player.position
        offset:   rl.Vector2 { f32(screen_width)/2.0, f32(screen_height)/2.0 }
        rotation: 0.0
        zoom:     1.0
    }
    
    // Automation events
    mut aelist := rl.load_automation_event_list('')  // Initialize list of automation events to record new events
    rl.set_automation_event_list(&aelist)
    mut event_recording := false
    mut event_playing   := false
    
    mut frame_counter      := 0
    mut play_frame_counter := 0
    mut current_play_frame := 0

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {
        // Update
        //----------------------------------------------------------------------------------
        mut delta_time := 0.015//GetFrameTime()
        
        // Dropped files logic
        //----------------------------------------------------------------------------------
        if rl.is_file_dropped() {
            dropped_files := rl.load_dropped_files() // FilePathList 

            // Supports loading .rgs style files (text or binary) and .png style palette images
            droped_file := unsafe { cstring_to_vstring(dropped_files.paths[0]) }

            if rl.is_file_extension(droped_file, ".txt.rae") {
                rl.unload_automation_event_list(aelist)
                aelist = rl.load_automation_event_list(droped_file)
                
                event_recording = false
                
                // Reset scene state to play
                event_playing      = true
                play_frame_counter = 0
                current_play_frame = 0
                
                player.position = rl.Vector2 { 400, 280 }
                player.speed    = 0
                player.can_jump = false

                camera.target   = player.position
                camera.offset   = rl.Vector2 { f32(screen_width)/2.0, f32(screen_height)/2.0 }
                camera.rotation = 0.0
                camera.zoom     = 1.0
            }

            rl.unload_dropped_files(dropped_files)   // Unload filepaths from memory
        }
        //----------------------------------------------------------------------------------

        // Update player
        //----------------------------------------------------------------------------------
        if rl.is_key_down(rl.key_left)  { player.position.x -= f32(player_hor_spd*delta_time) }
        if rl.is_key_down(rl.key_right) { player.position.x += f32(player_hor_spd*delta_time) }
        if rl.is_key_down(rl.key_space) && player.can_jump {
            player.speed    = -player_jump_spd
            player.can_jump = false
        }

        mut hit_obstacle := false
        // for (int i = 0 i < max_environment_elements i++) {
        for element in env_elements {
            // EnvElement *element = &env_elements[i]
            mut p := &player.position
            
            if element.blocking                            &&
                element.rect.x <= p.x                      &&
                element.rect.x + element.rect.width >= p.x &&
                element.rect.y >= p.y                      &&
                element.rect.y <= p.y + player.speed*delta_time
            {
                hit_obstacle = true
                player.speed = 0.0
                p.y          = element.rect.y
            }
        }

        if !hit_obstacle {
            player.position.y += f32(player.speed*delta_time)
            player.speed      += f32(gravity*delta_time)
            player.can_jump    = false
        }
        else {
            player.can_jump = true
        }

        camera.zoom += (f32(rl.get_mouse_wheel_move())*0.05)

        if      camera.zoom > 3.0  { camera.zoom = 3.0  }
        else if camera.zoom < 0.25 { camera.zoom = 0.25 }

        if rl.is_key_pressed(rl.key_r) {
            // Reset game state
            player.position = rl.Vector2 { 400, 280 }
            player.speed    = 0
            player.can_jump = false

            camera.target   = player.position
            camera.offset   = rl.Vector2 { f32(screen_width)/2.0, f32(screen_height)/2.0 }
            camera.rotation = 0.0
            camera.zoom     = 1.0
        }
        //----------------------------------------------------------------------------------

        // Update camera
        //----------------------------------------------------------------------------------
        camera.target = player.position
        camera.offset = rl.Vector2 { f32(screen_width)/2.0, f32(screen_height)/2.0 }

        mut min_x := f32( 1000)
        mut min_y := f32( 1000)
        mut max_x := f32(-1000)
        mut max_y := f32(-1000)

        // for (int i = 0 i < max_environment_elements i++) {
        for element in env_elements {
            // EnvElement *element = &env_elements[i]
            min_x = rl.fminf(element.rect.x, min_x)
            max_x = rl.fmaxf(element.rect.x + element.rect.width, max_x)
            min_y = rl.fminf(element.rect.y, min_y)
            max_y = rl.fmaxf(element.rect.y + element.rect.height, max_y)
        }

        max := rl.get_world_to_screen_2d(rl.Vector2 { max_x, max_y }, camera)
        min := rl.get_world_to_screen_2d(rl.Vector2 { min_x, min_y }, camera)

        if max.x < screen_width  { camera.offset.x = screen_width  - (max.x - screen_width/2) }
        if max.y < screen_height { camera.offset.y = screen_height - (max.y - screen_height/2) }

        if min.x > 0 { camera.offset.x = screen_width/2  - min.x }
        if min.y > 0 { camera.offset.y = screen_height/2 - min.y }
        //----------------------------------------------------------------------------------
        
        // Toggle events recording
        if rl.is_key_pressed(rl.key_s) {
            if !event_playing {
                if event_recording {
                    rl.stop_automation_event_recording()
                    event_recording = false
                    
                    rl.export_automation_event_list(aelist, "automation.rae")
                    
                    println("RECORDED FRAMES: ${aelist.count}")
                } else {
                    rl.set_automation_event_base_frame(180)
                    rl.start_automation_event_recording()
                    event_recording = true
                }
            }
        } else if rl.is_key_pressed(rl.key_a) {
            if !event_recording && (aelist.count > 0) {
                // Reset scene state to play
                event_playing      = true
                play_frame_counter = 0
                current_play_frame = 0

                player.position    = rl.Vector2 { 400, 280 }
                player.speed       = 0
                player.can_jump    = false

                camera.target      = player.position
                camera.offset      = rl.Vector2 { f32(screen_width)/2.0, f32(screen_height)/2.0 }
                camera.rotation    = 0.0
                camera.zoom        = 1.0
            }
        }
        
        if event_playing {
            // NOTE: Multiple events could be executed in a single frame
            event := unsafe { aelist.events[current_play_frame] }
            for play_frame_counter == event.frame {

                unsafe {
                    println(
                        "PLAYING: PlayFrameCount: ${play_frame_counter} | current_play_frame: ${current_play_frame} | Event Frame: ${aelist.events[current_play_frame].frame}, param: ${aelist.events[current_play_frame].params[0]}")
                }
                
                unsafe { rl.play_automation_event(aelist.events[current_play_frame]) }
                current_play_frame++

                if current_play_frame == aelist.count {
                    event_playing      = false
                    current_play_frame = 0
                    play_frame_counter = 0

                    println("FINISH PLAYING!")
                    break
                }
            }
            
            play_frame_counter++
        }
        
        if event_recording || event_playing { frame_counter++   }
        else                                { frame_counter = 0 }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.lightgray)

            rl.begin_mode_2d(camera)

                // Draw environment elements
                // for (int i = 0 i < max_environment_elements i++) {
                //     rl.draw_rectangle_rec(env_elements[i].rect, env_elements[i].color)
                // }
                for element in env_elements {
                    rl.draw_rectangle_rec(element.rect, element.color)
                }

                // Draw player rectangle
                rl.draw_rectangle_rec(rl.Rectangle { player.position.x - 20, player.position.y - 40, 40, 40 }, rl.red)

            rl.end_mode_2d()
            
            // Draw game controls
            rl.draw_rectangle(10, 10, 290, 145, rl.Color.fade(rl.skyblue, 0.5))
            rl.draw_rectangle_lines(10, 10, 290, 145, rl.Color.fade(rl.blue, 0.8))

            rl.draw_text("Controls:", 20, 20, 10, rl.black)
            rl.draw_text("- RIGHT | LEFT: Player movement", 30, 40, 10, rl.darkgray)
            rl.draw_text("- SPACE: Player jump", 30, 60, 10, rl.darkgray)
            rl.draw_text("- R: Reset game state", 30, 80, 10, rl.darkgray)

            rl.draw_text("- S: START/STOP RECORDING INPUT EVENTS", 30, 110, 10, rl.black)
            rl.draw_text("- A: REPLAY LAST RECORDED INPUT EVENTS", 30, 130, 10, rl.black)

            // Draw automation events recording indicator
            if event_recording {
                rl.draw_rectangle(10, 160, 290, 30, rl.Color.fade(rl.red, 0.3))
                rl.draw_rectangle_lines(10, 160, 290, 30, rl.Color.fade(rl.maroon, 0.8))
                rl.draw_circle(30, 175, 10, rl.maroon)

                if ((frame_counter/15)%2) == 1 {
                    rl.draw_text("RECORDING EVENTS... [${aelist.count}]", 50, 170, 10, rl.maroon)
                }
            } else if event_playing {
                rl.draw_rectangle(10, 160, 290, 30, rl.Color.fade(rl.lime, 0.3))
                rl.draw_rectangle_lines(10, 160, 290, 30, rl.Color.fade(rl.darkgreen, 0.8))
                rl.draw_triangle(rl.Vector2 { 20, 155 + 10 }, rl.Vector2 { 20, 155 + 30 }, rl.Vector2 { 40, 155 + 20 }, rl.darkgreen)

                if ((frame_counter/15)%2) == 1 {
                    rl.draw_text("PLAYING RECORDED EVENTS... [${current_play_frame}]", 50, 170, 10, rl.darkgreen)
                }
            }
        rl.end_drawing()
    }
}
