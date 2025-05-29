/*******************************************************************************************
*
*   raylib [textures] example - Fog of war
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
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

const map_tile_size          = 32 // Tiles size 32x32 pixels
const player_size            = 16 // Player size
const player_tile_visibility = 2  // Player can see 2 tiles around its position

// Map data type
struct Map {
pub mut:
    tiles_x  u32        // Number of tiles in X axis
    tiles_y  u32        // Number of tiles in Y axis
    tile_ids []u8       // Tile ids (tiles_x*tiles_y), defines type of tile to draw
    tile_fog []u8       // Tile fog state (tiles_x*tiles_y), defines if a tile has fog or half-fog
}


//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [textures] example - fog of war')
    defer { rl.close_window() }        // Close window and OpenGL context

    tiles_x := u32(25)
    tiles_y := u32(15)
    
    mut fog_map := Map {}
    fog_map.tiles_x  = tiles_x
    fog_map.tiles_y  = tiles_y
    fog_map.tile_ids = []u8{len: int(tiles_x*tiles_y)} 
    fog_map.tile_fog = []u8{len: int(tiles_x*tiles_y)} 

    // NOTE: We can have up to 256 values for tile ids and for tile fog state,
    // probably we don't need that many values for fog state, it can be optimized
    // to use only 2 bits per fog state (reducing size by 4) but logic will be a bit more complex

    // Load fog_map tiles (generating 2 random tile ids for testing)
    // NOTE: Map tile ids should be probably loaded from an external fog_map file
    for i:=u32(0); i < fog_map.tiles_y*fog_map.tiles_x; i++ {
        fog_map.tile_ids[i] = u8(rl.get_random_value(0, 1))
    }

    // Player position on the screen (pixel coordinates, not tile coordinates)
    mut player_position := rl.Vector2 { 180, 130 }
    mut player_tile_x   := int(0)
    mut player_tile_y   := int(0)

    // Render texture to render fog of war
    // NOTE: To get an automatic smooth-fog effect we use a render texture to render fog
    // at a smaller size (one pixel per tile) and scale it on drawing with bilinear filtering
    fog_of_war := rl.RenderTexture.load(int(fog_map.tiles_x), int(fog_map.tiles_y))
    defer { fog_of_war.unload() } // Unload render texture

    rl.set_texture_filter(fog_of_war.texture, rl.texture_filter_bilinear)

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // Move player around
        if rl.is_key_down(rl.key_right) { player_position.x += 5 }
        if rl.is_key_down(rl.key_left)  { player_position.x -= 5 }
        if rl.is_key_down(rl.key_down)  { player_position.y += 5 }
        if rl.is_key_down(rl.key_up)    { player_position.y -= 5 }

        // Check player position to avoid moving outside tilemap limits
        if player_position.x < 0 {
            player_position.x = 0
        } else if (player_position.x + player_size) > (fog_map.tiles_x*map_tile_size) {
            player_position.x = f32(fog_map.tiles_x)*map_tile_size - player_size
        }
        
        if player_position.y < 0 {
            player_position.y = 0
        } else if (player_position.y + player_size) > (fog_map.tiles_y*map_tile_size) {
            player_position.y = f32(fog_map.tiles_y)*map_tile_size - player_size
        }

        // Previous visited tiles are set to partial fog
        for i:=u32(0); i < fog_map.tiles_x*fog_map.tiles_y; i++ {
            if fog_map.tile_fog[i] == 1 { fog_map.tile_fog[i] = 2 }
        }

        // Get current tile position from player pixel position
        player_tile_x = int((player_position.x + map_tile_size/2)/map_tile_size)
        player_tile_y = int((player_position.y + map_tile_size/2)/map_tile_size)

        // Check visibility and update fog
        // NOTE: We check tilemap limits to avoid processing tiles out-of-array-bounds (it could crash program)
        for y := (player_tile_y - player_tile_visibility); y < (player_tile_y + player_tile_visibility); y++ {
            for x := (player_tile_x - player_tile_visibility); x < (player_tile_x + player_tile_visibility); x++ {
                if (x >= 0) && (x < int(fog_map.tiles_x)) && (y >= 0) && (y < int(fog_map.tiles_y)) {
                    fog_map.tile_fog[y*int(fog_map.tiles_x) + x] = 1
                }
            }
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        // Draw fog of war to a small render texture for automatic smoothing on scaling
        rl.begin_texture_mode(fog_of_war)
            rl.clear_background(rl.blank)
            for y := u32(0); y < fog_map.tiles_y; y++ {
                for x := u32(0); x < fog_map.tiles_x; x++ {
                        if fog_map.tile_fog[y*fog_map.tiles_x + x] == 0 {
                            rl.draw_rectangle(int(x), int(y), 1, 1, rl.black)
                        } else if fog_map.tile_fog[y*fog_map.tiles_x + x] == 2 {
                            rl.draw_rectangle(int(x), int(y), 1, 1, rl.Color.fade(rl.black, 0.8))
                        }
                }
            }
        rl.end_texture_mode()

        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            for y := u32(0); y < fog_map.tiles_y; y++ {
                for x := u32(0); x < fog_map.tiles_x; x++ {
                    // Draw tiles from id (and tile borders)
                        rl.draw_rectangle(
                            int(x*map_tile_size), int(y*map_tile_size), map_tile_size, map_tile_size,
                            if fog_map.tile_ids[y*fog_map.tiles_x + x] == 0 { rl.blue } else { rl.Color.fade(rl.blue, 0.9) }
                        )
                        rl.draw_rectangle_lines(
                            int(x*map_tile_size), int(y*map_tile_size), map_tile_size, map_tile_size, rl.Color.fade(rl.darkblue, 0.5)
                        )
                }
            }

            // Draw player
            rl.draw_rectangle_v(player_position, rl.Vector2 { player_size, player_size }, rl.red)

            // Draw fog of war (scaled to full fog_map, bilinear filtering)
            rl.draw_texture_pro(
                fog_of_war.texture,
                rl.Rectangle { 0, 0, f32(fog_of_war.texture.width),  f32(-fog_of_war.texture.height) },
                rl.Rectangle { 0, 0, f32(fog_map.tiles_x*map_tile_size), f32(fog_map.tiles_y*map_tile_size)  } ,
                rl.Vector2 { 0, 0 }, 0.0, rl.white
            )

            // Draw player current tile
            rl.draw_text('Current tile: [${player_tile_x}, ${player_tile_y}]', 10, 10, 20, rl.raywhite)
            rl.draw_text('ARROW KEYS to move', 10, screen_height-25, 20, rl.raywhite)

        rl.end_drawing()
    }
}
