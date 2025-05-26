/*******************************************************************************************
*
*   raylib [easings] example - easings Testbed
*
*   Example originally created with raylib 2.5, last time updated with raylib 2.5
*
*   Example contributed by Juan Miguel López (@flashback-fx) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright           (c) 2019-2023 Juan Miguel López (@flashback-fx ) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Alexandr  (@xydojnik)
*
********************************************************************************************/

module main


import raylib as rl

#include "@VMODROOT/thirdparty/raylib/examples/others/reasings.h"

// Linear Easing functions
fn C.EaseLinearNone (t f32, b f32, c f32, d f32) f32  // Ease: Linear
fn C.EaseLinearIn   (t f32, b f32, c f32, d f32) f32  // Ease: Linear In
fn C.EaseLinearOut  (t f32, b f32, c f32, d f32) f32  // Ease: Linear Out
fn C.EaseLinearInOut(t f32, b f32, c f32, d f32) f32  // Ease: Linear In Out

// Sine Easing functions
fn C.EaseSineIn   (t f32, b f32, c f32, d f32) f32    // Ease: Sine In
fn C.EaseSineOut  (t f32, b f32, c f32, d f32) f32    // Ease: Sine Out
fn C.EaseSineInOut(t f32, b f32, c f32, d f32) f32    // Ease: Sine In Out

// Circular Easing functions
fn C.EaseCircIn   (t f32, b f32, c f32, d f32) f32    // Ease: Circular In
fn C.EaseCircOut  (t f32, b f32, c f32, d f32) f32    // Ease: Circu lar Out
fn C.EaseCircInOut(t f32, b f32, c f32, d f32) f32    // Ease: Circu   lar In Out

// Cubic Easing functions
fn C.EaseCubicIn   (t f32, b f32, c f32, d f32) f32   // Ease: Cubic In
fn C.EaseCubicOut  (t f32, b f32, c f32, d f32) f32   // Ease: Cubic Out
fn C.EaseCubicInOut(t f32, b f32, c f32, d f32) f32   // Ease: Cubic In Out

// Quadratic Easing functions
fn C.EaseQuadIn   (t f32, b f32, c f32, d f32) f32    // Ease: Quadratic In
fn C.EaseQuadOut  (t f32, b f32, c f32, d f32) f32    // Ease: Quadratic Out
fn C.EaseQuadInOut(t f32, b f32, c f32, d f32) f32    // Ease: Quadratic In Out

// Exponential Easing functions
fn C.EaseExpoIn   (t f32, b f32, c f32, d f32) f32    // Ease: Exponential In
fn C.EaseExpoOut  (t f32, b f32, c f32, d f32) f32    // Ease: Exponential Out
fn C.EaseExpoInOut(t f32, b f32, c f32, d f32) f32    // Ease: Exponential In Out

// Back Easing functions
fn C.EaseBackIn   (t f32, b f32, c f32, d f32) f32    // Ease: Back In
fn C.EaseBackOut  (t f32, b f32, c f32, d f32) f32    // Ease: Back Out
fn C.EaseBackInOut(t f32, b f32, c f32, d f32) f32    // Ease: Back In Out

// Bounce Easing functions
fn C.EaseBounceOut  (t f32, b f32, c f32, d f32) f32  // Ease: Bounce Out
fn C.EaseBounceIn   (t f32, b f32, c f32, d f32) f32  // Ease: Bounce In
fn C.EaseBounceInOut(t f32, b f32, c f32, d f32) f32  // Ease: Bounce In Out

// Elastic Easing functions
fn C.EaseElasticIn   (t f32, b f32, c f32, d f32) f32 // Ease: Elastic In
fn C.EaseElasticOut  (t f32, b f32, c f32, d f32) f32 // Ease: Elastic Out
fn C.EaseElasticInOut(t f32, b f32, c f32, d f32) f32 // Ease: Elastic In Out


const font_size   = 20
const d_step      = f32(20.0)
const d_step_fine = f32(2.0)
const d_min       = f32(1.0)
const d_max       = f32(10000.0)

// Easing types
enum EasingTypes as int {
    ease_none = 0
    ease_linear_in
    ease_linear_out
    ease_linear_in_out
    ease_sine_in
    ease_sine_out
    ease_sine_in_out
    ease_circ_in
    ease_circ_out
    ease_circ_in_out
    ease_cubic_in
    ease_cubic_out
    ease_cubic_in_out
    ease_quad_in
    ease_quad_out
    ease_quad_in_out
    ease_expo_in
    ease_expo_out
    ease_expo_in_out
    ease_back_in
    ease_back_out
    ease_back_in_out
    ease_bounce_out
    ease_bounce_in
    ease_bounce_in_out
    ease_elastic_in
    ease_elastic_out
    ease_elastic_in_out
    num_easing_types
    ease_linear_none = int(EasingTypes.num_easing_types)
}

// no_ease function, used when "no easing" is selected for any axis. It just ignores all parameters besides b.
fn no_ease(t f32, b f32, c f32, d f32) f32 {
    burn := f32(t + b + c + d)  // Hack to avoid compiler warning (about unused variables)
    return d + burn
}

struct Easing {
    name string
    func fn(f32, f32, f32, f32) f32 = voidptr(0)
}

const easings = {

    int(EasingTypes.ease_none)          : Easing { name: "None"               , func: no_ease             },
    int(EasingTypes.ease_linear_in)     : Easing { name: "ease_linear_in"     , func: C.EaseLinearIn      },
    int(EasingTypes.ease_linear_out)    : Easing { name: "ease_linear_out"    , func: C.EaseLinearOut     },
    int(EasingTypes.ease_linear_in_out) : Easing { name: "ease_linear_in_out" , func: C.EaseLinearInOut   },
    int(EasingTypes.ease_sine_in)       : Easing { name: "ease_sine_in"       , func: C.EaseSineIn        },
    int(EasingTypes.ease_sine_out)      : Easing { name: "ease_sine_out"      , func: C.EaseSineOut       },
    int(EasingTypes.ease_sine_in_out)   : Easing { name: "ease_sine_in_out"   , func: C.EaseSineInOut     },
    int(EasingTypes.ease_circ_in)       : Easing { name: "ease_circ_in"       , func: C.EaseCircIn        },
    int(EasingTypes.ease_circ_out)      : Easing { name: "ease_circ_out"      , func: C.EaseCircOut       },
    int(EasingTypes.ease_circ_in_out)   : Easing { name: "ease_circ_in_out"   , func: C.EaseCircInOut     },
    int(EasingTypes.ease_cubic_in)      : Easing { name: "ease_cubic_in"      , func: C.EaseCubicIn       },
    int(EasingTypes.ease_cubic_out)     : Easing { name: "ease_cubic_out"     , func: C.EaseCubicOut      },
    int(EasingTypes.ease_cubic_in_out)  : Easing { name: "ease_cubic_in_out"  , func: C.EaseCubicInOut    },
    int(EasingTypes.ease_quad_in)       : Easing { name: "ease_quad_in"       , func: C.EaseQuadIn        },
    int(EasingTypes.ease_quad_out)      : Easing { name: "ease_quad_out"      , func: C.EaseQuadOut       },
    int(EasingTypes.ease_quad_in_out)   : Easing { name: "ease_quad_in_out"   , func: C.EaseQuadInOut     },
    int(EasingTypes.ease_expo_in)       : Easing { name: "ease_expo_in"       , func: C.EaseExpoIn        },
    int(EasingTypes.ease_expo_out)      : Easing { name: "ease_expo_out"      , func: C.EaseExpoOut       },
    int(EasingTypes.ease_expo_in_out)   : Easing { name: "ease_expo_in_out"   , func: C.EaseExpoInOut     },
    int(EasingTypes.ease_back_in)       : Easing { name: "ease_back_in"       , func: C.EaseBackIn        },
    int(EasingTypes.ease_back_out)      : Easing { name: "ease_back_out"      , func: C.EaseBackOut       },
    int(EasingTypes.ease_back_in_out)   : Easing { name: "ease_back_in_out"   , func: C.EaseBackInOut     },
    int(EasingTypes.ease_bounce_out)    : Easing { name: "ease_bounce_out"    , func: C.EaseBounceOut     },
    int(EasingTypes.ease_bounce_in)     : Easing { name: "ease_bounce_in"     , func: C.EaseBounceIn      },
    int(EasingTypes.ease_bounce_in_out) : Easing { name: "ease_bounce_in_out" , func: C.EaseBounceInOut   },
    int(EasingTypes.ease_elastic_in)    : Easing { name: "ease_elastic_in"    , func: C.EaseElasticIn     },
    int(EasingTypes.ease_elastic_out)   : Easing { name: "ease_elastic_out"   , func: C.EaseElasticOut    },
    int(EasingTypes.ease_elastic_in_out): Easing { name: "ease_elastic_in_out", func: C.EaseElasticInOut  },
    int(EasingTypes.ease_linear_none)   : Easing { name: "ease_linear_none"   , func: C.EaseLinearNone    },
  // int(EasingTypes.ease_linear_none)   : Easing { name: "ease_linear_none"   , func: ease_linear_none    },
}

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, "raylib [easings] example - easings testbed")
    defer { rl.close_window() }

    mut ball_position := rl.Vector2 { 100.0, 100.0 }

    mut t         := f32(0.0)   // Current time (in any unit measure, but same unit as duration)
    mut d         := f32(300.0) // Total time it should take to complete (duration)
    mut paused    := true
    mut bounded_t := true       // If true, t will stop when d >= td, otherwise t will keep adding td to its value every loop

    mut easing_x := int(EasingTypes.ease_none)  // Easing selected for x axis
    mut easing_y := int(EasingTypes.ease_none)  // Easing selected for y axis

    rl.set_target_fps(60)

    //--------------------------------------------------------------------------------------
    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        if rl.is_key_pressed(rl.key_t) {
            bounded_t = !bounded_t
        }

        // Choose easing for the X axis
        if rl.is_key_pressed(rl.key_right) {
            easing_x++
            if easing_x > int(EasingTypes.ease_linear_none) { easing_x = 0 }
        } else if rl.is_key_pressed(rl.key_left) {
            if easing_x == 0 { easing_x = int(EasingTypes.ease_linear_none) }
            else             { easing_x-- }
        }

        // Choose easing for the Y axis
        if rl.is_key_pressed(rl.key_down) {
            easing_y++
            if easing_y > int(EasingTypes.ease_linear_none) { easing_y = 0 }
        } else if rl.is_key_pressed(rl.key_up) {
            if easing_y == 0 { easing_y = int(EasingTypes.ease_linear_none) }
            else             { easing_y-- }
        }

        // Change d (duration) value
        if      rl.is_key_pressed(rl.key_w) && d < d_max - d_step { d += d_step }
        else if rl.is_key_pressed(rl.key_q) && d > d_min + d_step { d -= d_step }

        if      rl.is_key_down(rl.key_s) && d < d_max - d_step_fine { d += d_step_fine }
        else if rl.is_key_down(rl.key_a) && d > d_min + d_step_fine { d -= d_step_fine }

        // Play, pause and restart controls
        if (rl.is_key_pressed(rl.key_space) || rl.is_key_pressed(rl.key_t)    ||
            rl.is_key_pressed(rl.key_right) || rl.is_key_pressed(rl.key_left) ||
            rl.is_key_pressed(rl.key_down)  || rl.is_key_pressed(rl.key_up)   ||
            rl.is_key_pressed(rl.key_w)     || rl.is_key_pressed(rl.key_q)    ||
            rl.is_key_down(rl.key_s)        || rl.is_key_down(rl.key_a)       ||
            rl.is_key_pressed(rl.key_enter)) &&
            ((bounded_t == true) && (t >= d))
        {
            t               = 0.0
            ball_position.x = 100.0
            ball_position.y = 100.0
            paused          = true
        }

        if rl.is_key_pressed(rl.key_enter) { paused = !paused }

        // Movement computation
        if (!paused && (bounded_t && t < d)) || !bounded_t {
            unsafe {
                ball_position.x = easings[easing_x].func(t, 100.0, 700.0 - 170.0, d)
                ball_position.y = easings[easing_y].func(t, 100.0, 400.0 - 170.0, d)
            }
            t += 1.0
        }

        //----------------------------------------------------------------------------------
        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            // Draw information text
            unsafe {
                rl.draw_text("Easing x: ${easings[easing_x].name}", 20, font_size,   font_size, rl.black)
                rl.draw_text("Easing y: ${easings[easing_y].name}", 20, font_size*2, font_size, rl.black)
            }
            vl := if bounded_t {'b'} else {'u'}
            rl.draw_text("t (${vl}) = t = d", 20, font_size*3, font_size, rl.black)

            // Draw instructions text
            rl.draw_text("Use ENTER to play or pause movement, use SPACE to restart", 20, rl.get_screen_height()-font_size*2, font_size, rl.black)
            rl.draw_text("Use Q and W or A and S keys to change duration", 20, rl.get_screen_height()-font_size*3, font_size, rl.black)
            rl.draw_text("Use LEFT or RIGHT keys to choose easing for the x axis", 20, rl.get_screen_height()-font_size*4, font_size, rl.black)
            rl.draw_text("Use UP or DOWN keys to choose easing for the y axis", 20, rl.get_screen_height()-font_size*5, font_size, rl.black)

            // Draw ball
            rl.draw_circle_v(ball_position, 16.0, rl.maroon)

        rl.end_drawing()
    }
}
