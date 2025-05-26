/*******************************************************************************************
*
*   raylib [core] example - 2D Camera platformer
*   Example originally created with raylib 2.5, last time updated with raylib 3.0
*   Example contributed by arvyy (@arvyy) and reviewed by Ramon Santamaria (@raysan5)
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 arvyy            (@arvyy)
*   Translated&Modified (c) 2024      Fedorov Alexandr (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl


__global (
    even_out_target = f32(0.0)
    evening_out     = false
)


const g               = 400
const player_jump_spd = 350.0
const player_hor_spd  = 200.0

//----------------------------------------------------------------------------------
// Module structures
//----------------------------------------------------------------------------------
struct EnvItem {
pub mut:
    rect     rl.Rectangle
    blocking bool
    color    rl.Color
}

struct Player {
pub mut:
    position rl.Vector2
    speed    f32
    can_jump bool
}

fn (mut player Player) update(env_items []EnvItem, delta f32) {
    if rl.is_key_down(rl.key_left)  { player.position.x -= player_hor_spd*delta }
    if rl.is_key_down(rl.key_right) { player.position.x += player_hor_spd*delta }
    if rl.is_key_down(rl.key_space) && player.can_jump {
        player.speed    = -player_jump_spd
        player.can_jump = false
    }

    mut hit_obstacle := false
    for ei in env_items {
        mut p := &player.position
        
        if ei.blocking                        &&
            ei.rect.x <= p.x                  &&
            ei.rect.x +  ei.rect.width >= p.x &&
            ei.rect.y >= p.y                  &&
            ei.rect.y <= p.y + player.speed*delta
        {
            hit_obstacle = true
            player.speed = 0.0
            p.y          = ei.rect.y
        }
    }

    if !hit_obstacle {
        player.position.y += player.speed*delta
        player.speed      += g*delta
        player.can_jump    = false
    } else {
        player.can_jump = true
    }
}

//----------------------------------------------------------------------------------
// Module functions
//----------------------------------------------------------------------------------
fn update_camera_center(
    mut camera rl.Camera2D, mut player Player,
    env_items  []EnvItem,   delta f32,
    width int,              height int)
{
    camera.offset = rl.Vector2 { f32(width)/2.0, f32(height)/2.0 }
    camera.target = player.position
}

fn update_camera_center_inside_map(
    mut camera rl.Camera2D, mut player Player,
    env_items  []EnvItem, delta f32, width int, height int)
{
    camera.target = player.position
    camera.offset = rl.Vector2 { f32(width)/2.0, f32(height)/2.0 }
    
    mut min_x := f32( 1000)
    mut min_y := f32( 1000)
    mut max_x := f32(-1000)
    mut max_y := f32(-1000)

    for ei in env_items {
        min_x = rl.fminf(f32(ei.rect.x), f32(min_x))
        max_x = rl.fmaxf(f32(ei.rect.x + ei.rect.width), f32(max_x))
        min_y = rl.fminf(f32(ei.rect.y), f32(min_y))
        max_y = rl.fmaxf(f32(ei.rect.y + ei.rect.height), f32(max_y))
    }
    
    max := rl.get_world_to_screen_2d(rl.Vector2 { max_x, max_y }, *camera)
    min := rl.get_world_to_screen_2d(rl.Vector2 { min_x, min_y }, *camera)
    
    if max.x < width  { camera.offset.x = width  - (max.x - width /2) }
    if max.y < height { camera.offset.y = height - (max.y - height/2) }

    if min.x > 0 { camera.offset.x = width/2  - min.x }
    if min.y > 0 { camera.offset.y = height/2 - min.y }
}

fn update_camera_center_smooth_follow(
    mut camera rl.Camera2D, mut player Player,
    env_items  []EnvItem, delta f32, width int, height int)
{
    min_speed         := f32(30)
    min_effect_length := f32(10)
    fraction_speed    := f32(0.8)

    camera.offset = rl.Vector2 { f32(width)/2.0, f32(height)/2.0 }

    diff   := rl.Vector2.subtract(player.position, camera.target)
    length := rl.Vector2.length(diff)

    if length > min_effect_length {
        speed := rl.fmaxf(fraction_speed*length, min_speed)
        camera.target = rl.Vector2.add(camera.target, rl.Vector2.scale(diff, speed*delta/length))
    }
}

fn update_camera_even_out_on_landing(
    mut camera rl.Camera2D, mut player Player,
    env_items []EnvItem, delta f32, width int, height int)
{
    even_out_speed  := f32(700)
    camera.offset   = rl.Vector2 { f32(width)/2.0, f32(height)/2.0 }
    camera.target.x = player.position.x

    if evening_out {
        if even_out_target > camera.target.y {
            camera.target.y += even_out_speed*delta
            
            if camera.target.y > even_out_target {
                camera.target.y = even_out_target
                evening_out     = false
            }
        } else {
            camera.target.y -= even_out_speed*delta

            if camera.target.y < even_out_target {
                camera.target.y = even_out_target
                evening_out     = false
            }
        }
    } else {
        if player.can_jump && player.speed == 0 && player.position.y != camera.target.y {
            evening_out     = true
            even_out_target = player.position.y
        }
    }
}

fn update_camera_player_bounds_push(
    mut camera rl.Camera2D, mut player Player,
    env_items  []EnvItem, delta f32, width int, height int)
{
    bbox := rl.Vector2 { 0.2, 0.2 }

    bbox_world_min := rl.get_screen_to_world_2d(rl.Vector2{ (1 - bbox.x)*0.5*width, (1 - bbox.y)*0.5*height }, *camera)
    bbox_world_max := rl.get_screen_to_world_2d(rl.Vector2{ (1 + bbox.x)*0.5*width, (1 + bbox.y)*0.5*height }, *camera)
    camera.offset = rl.Vector2{ (1 - bbox.x)*0.5 * width, (1 - bbox.y)*0.5*height }

    if player.position.x < bbox_world_min.x { camera.target.x = player.position.x }
    if player.position.y < bbox_world_min.y { camera.target.y = player.position.y }
    if player.position.x > bbox_world_max.x { camera.target.x = bbox_world_min.x + (player.position.x - bbox_world_max.x) }
    if player.position.y > bbox_world_max.y { camera.target.y = bbox_world_min.y + (player.position.y - bbox_world_max.y) }
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [core] example - 2d camera")
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }       // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    mut player := Player {
        position: rl.Vector2{ 400, 280 }
        speed:    0
        can_jump: false
    }

    env_items := [
        EnvItem{ rl.Rectangle{ 0,   0,   1000, 400 }, false, rl.lightgray },
        EnvItem{ rl.Rectangle{ 0,   400, 1000, 200 }, true,  rl.gray      },
        EnvItem{ rl.Rectangle{ 300, 200, 400,  10  }, true,  rl.gray      },
        EnvItem{ rl.Rectangle{ 250, 300, 100,  10  }, true,  rl.gray      },
        EnvItem{ rl.Rectangle{ 650, 300, 100,  10  }, true,  rl.gray      }
    ]

    mut camera := rl.Camera2D {
        target:    player.position
        offset:    rl.Vector2{ f32(screen_width)/2.0, f32(screen_height)/2.0 }
        rotation:  0.0
        zoom:      1.0
    }

    // Store pointers to the multiple update camera functions
    camera_updaters := [
        update_camera_center,
        update_camera_center_inside_map,
        update_camera_center_smooth_follow,
        update_camera_even_out_on_landing,
        update_camera_player_bounds_push
    ]

    mut camera_option := int(0)

    camera_descriptions := [
        "Follow player center",
        "Follow player center, but clamp to map edges",
        "Follow player center smoothed",
        "Follow player center horizontally update player center vertically after landing",
        "Player push camera on getting too close to screen edge"
    ]

    rl.set_target_fps(60)
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {
        // Update
        //----------------------------------------------------------------------------------
        delta_time := rl.get_frame_time()

        player.update(env_items, delta_time)

        camera.zoom += f32(rl.get_mouse_wheel_move())*0.05

        if      camera.zoom > 3.0  { camera.zoom = 3.0  }
        else if camera.zoom < 0.25 { camera.zoom = 0.25 }

        if rl.is_key_pressed(rl.key_r) {
            camera.zoom     = 1.0
            player.position = rl.Vector2{ 400, 280 }
        }

        if rl.is_key_pressed(rl.key_c) {
            camera_option = (camera_option + 1) % camera_updaters.len
        }

        // Call update camera function by its pointer
        camera_updaters[camera_option](mut camera, mut player, env_items, delta_time, screen_width, screen_height)
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.lightgray)

            rl.begin_mode_2d(camera)

                for i in 0..env_items.len {
                    rl.draw_rectangle_rec(env_items[i].rect, env_items[i].color)
                }

                player_rect := rl.Rectangle{ player.position.x - 20, player.position.y - 40, 40, 40 }
                rl.draw_rectangle_rec(player_rect, rl.red)

            rl.end_mode_2d()

            rl.draw_text("Controls:", 20, 20, 10, rl.black)
            rl.draw_text("- Right/Left to move", 40, 40, 10, rl.darkgray)
            rl.draw_text("- Space to jump", 40, 60, 10, rl.darkgray)
            rl.draw_text("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, rl.darkgray)
            rl.draw_text("- C to change camera mode", 40, 100, 10, rl.darkgray)
            rl.draw_text("Current camera mode:", 20, 120, 10, rl.black)
            rl.draw_text(camera_descriptions[camera_option], 40, 140, 10, rl.darkgray)

        rl.end_drawing()
    }
}
