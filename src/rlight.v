/**********************************************************************************************
*
*   raylib.lights - Some useful functions to deal with lights data
*
*   CONFIGURATION:
*
*   #define RLIGHTS_IMPLEMENTATION
*       Generates the implementation of the library into the included file.
*       If not defined, the library is in header only mode and can be included in other headers 
*       or source files without problems. But only ONE file should hold the implementation.
*
*   LICENSE: zlib/libpng
*
*   Copyright           (c) 2017-2023 Victor Fisac      (@victorfisac) and Ramon Santamaria (@raysan5)
*   Translated&Modified (c) 2024      Fedorov Aleksandr (@xydojnik)
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented; you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*
**********************************************************************************************/


module raylib

pub const max_lights = 4

pub const light_directional = 0
pub const light_point       = 1


//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
// Light data
pub struct Light {
    // Shader locations
    enabled_loc     int
    type_loc        int
    position_loc    int
    target_loc      int
    color_loc       int
    attenuation_loc int
pub mut:
    ltype        int
    enabled      bool
    position     Vector3
    target       Vector3
    color        Color
    attenuation  f32
}


//----------------------------------------------------------------------------------
// Module Functions Definition
//----------------------------------------------------------------------------------
// Create a light and get shader locations
pub fn Light.create(ltype int, position Vector3, target Vector3, color Color, shader Shader, light_index int) Light {
    assert light_index < max_lights

    // NOTE: Lighting shader naming must be the provided ones
    enabled_loc  := get_shader_location(shader, 'lights[${light_index}].enabled')
    type_loc     := get_shader_location(shader, 'lights[${light_index}].type')
    position_loc := get_shader_location(shader, 'lights[${light_index}].position')
    target_loc   := get_shader_location(shader, 'lights[${light_index}].target')
    color_loc    := get_shader_location(shader, 'lights[${light_index}].color')

    light := Light {
        enabled_loc:  enabled_loc
        type_loc:     type_loc
        position_loc: position_loc
        target_loc:   target_loc
        color_loc:    color_loc
        
        enabled:      true
        ltype:        ltype
        position:     position
        target:       target
        color:        color
    }

    light.update_values(shader)

    return light
}

// Send light properties to shader
// NOTE: Light shader locations should be available 
pub fn (light Light) update_values(shader Shader) {
    // Send to shader light enabled state and type
    set_shader_value(shader, light.enabled_loc,  &light.enabled,  shader_uniform_int)
    set_shader_value(shader, light.type_loc,     &light.ltype,    shader_uniform_int)
    set_shader_value(shader, light.target_loc,   &light.target,   shader_uniform_vec3)
    set_shader_value(shader, light.position_loc, &light.position, shader_uniform_vec3)

    // Send to shader light color values | 0.0 - 1.0 : floats
    color := [
        f32(light.color.r)/f32(255),
        f32(light.color.g)/f32(255), 
        f32(light.color.b)/f32(255),
        f32(light.color.a)/f32(255)
    ]
    set_shader_value(shader, light.color_loc, color.data, shader_uniform_vec4)
}
