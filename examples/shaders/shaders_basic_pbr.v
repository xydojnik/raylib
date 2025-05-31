// /*******************************************************************************************
// *
// *   raylib [shaders] example - Basic PBR
// *
// *   Example originally created with raylib 5.0, last time updated with raylib 5.1-dev
// *
// *   Example contributed by Afan OLOVCIC (@_DevDad) and reviewed by Ramon Santamaria (@raysan5)
// *
// *   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
// *   BSD-like license that allows static linking with closed source software
// *
// *   Copyright           (c) 2023-2024 Afan OLOVCIC     (@_DevDad)
// *   Translated&Modified (c) 2025      Fedorov Alexandr (@xydojnik)
// *
// *   Model: 'Old Rusty Car' (https://skfb.ly/LxRy) by Renafox, 
// *   licensed under Creative Commons Attribution-NonCommercial 
// *   (http://creativecommons.org/licenses/by-nc/4.0/)
// *
// ********************************************************************************************/

import raylib  as rl

import term
import os
import json


const asset_path = $if USE_RAYLIB_PATH ? {
    @VMODROOT+'/thirdparty/raylib/examples/shaders/resources/'
} $else {
    'resources/'
}

const max_lights = $if USE_RAYLIB_PATH ? { 4 } $else { 5 } // Max dynamic lights supported by shader


//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
// Light type
enum LightType as int {
    light_directional = 0
    light_point
    light_spot
}

// Light data
struct Light {
pub:
    type          LightType
    // Shader light parameters locations
    type_loc      int
    enabled_loc   int
    position_loc  int
    target_loc    int
    color_loc     int
    intensity_loc int
pub mut:
    enabled   bool
    position  rl.Vector3
    target    rl.Vector3
    color     rl.Color
    intensity f32
    size      f32
}

// Create light with provided data
fn Light.create(position rl.Vector3, color rl.Color, shader rl.Shader, light_index int) Light {
    assert light_index < max_lights

    light := Light {
        enabled:   true,
        type:      .light_point,
        position:  position,
        target:    rl.Vector3{},
        color:     color,
        intensity: 10,

        enabled_loc:   shader.get_loc('lights[${light_index}].enabled'),
        type_loc:      shader.get_loc('lights[${light_index}].type'),
        position_loc:  shader.get_loc('lights[${light_index}].position'),
        target_loc:    shader.get_loc('lights[${light_index}].target'),
        color_loc:     shader.get_loc('lights[${light_index}].color'),
        intensity_loc: shader.get_loc('lights[${light_index}].intensity')
    }
    
    // NOTE: rl.Shader parameters names for lights must match the requested ones
    // light.update(shader)

    return light
}

// Send light properties to shader
// NOTE: Light shader locations should be available
fn (light Light) update(shader rl.Shader) {
    shader.set_value(light.enabled_loc, &light.enabled, rl.shader_uniform_int)
    shader.set_value(light.type_loc,    &light.type,    rl.shader_uniform_int)

    // Send to shader light position values
    shader.set_value(light.position_loc, &light.position, rl.shader_uniform_vec3)
    
    // Send to shader light target position values
    shader.set_value(light.target_loc,    &light.target,    rl.shader_uniform_vec3)
    shader.set_value(light.intensity_loc, &light.intensity, rl.shader_uniform_float)

    color := rl.Vector4.divide_value(light.color.to_vec4(), 255).to_arr()
    
    shader.set_value(light.color_loc, color, rl.shader_uniform_vec4)
}


fn (mut lights []Light) add(position rl.Vector3, color rl.Color, shader rl.Shader) {
    lights << Light.create(position, color, shader, lights.len)
}


fn (lights []Light) update(shader rl.Shader) {
    for light in lights { light.update(shader) }
}



struct Texture {
    texture rl.Texture
    name    string 
}


fn (texture Texture) str() string {
    return 'TEXTURE: ('+ term.bold(term.green('${texture.texture.id}'))+
            ') : [ '   + term.bold(term.green('${texture.name}'))+' ]'
}


fn Texture.load(file_path string) Texture {
    texture := Texture {
        texture: rl.Texture.load(file_path),
        name:    rl.get_file_name(file_path)
    }
    println('${texture} '+term.bold(term.green('Loaded.')))
    return texture
}

@[inline]
fn (texture Texture) unload() {
    println('${texture} '+term.bold(term.red(' Unloaded.')))
    texture.texture.unload()
}


fn (mut tarr []Texture) load(file_path string) rl.Texture {
    texture := Texture.load(file_path)
    tarr << texture
    return texture.texture
}

fn (mut tarr []Texture) foreach(fe fn(Texture)) {
    for texture in tarr { fe(texture) }
}

fn (mut tarr []Texture) unload() {
    tarr.foreach(fn(texture Texture) { texture.unload() })
}


// JSON DATA
struct TextureData {
    path    string
    filter  string
    wrap    string
    mipmaps bool
}

struct ShaderData {
    vs_path string
    fs_path string
}

struct MaterialMap {
    type   string
    texture TextureData
    value   f32
    color   rl.Color
}

struct MaterialData {
    shader ShaderData
    maps   []MaterialMap
}

// fn (md MaterialData) to_materials() []rl.Material {
//     return []rl.Material
// }

struct TransformData {
    position rl.Vector3
    rotation rl.Vector3
    scale    rl.Vector3
}

fn (td TransformData) to_rl_matrix() rl.Matrix {
    translation := rl.Matrix.translate(td.position) 
    rotation    := rl.Matrix.rotate_xyz(td.rotation) 
    scale       := rl.Matrix.scale(td.scale.x, td.scale.y, td.scale.z) 
    return rl.Matrix.multiply(translation, rl.Matrix.multiply(rotation, scale))
}

struct ModelData {
    path      string
    transform TransformData
    materials []MaterialData
}


// NOTE 1: Filtering considers mipmaps if available in the texture
// NOTE 2: Filter is accordingly set for minification and magnification
const tex_filter_ids = {
    'point':           rl.texture_filter_point
    'bilinear':        rl.texture_filter_bilinear
    'trilinear':       rl.texture_filter_trilinear
    'anisotropic_4x':  rl.texture_filter_anisotropic_4x
    'anisotropic_8x':  rl.texture_filter_anisotropic_8x
    'anisotropic_16x': rl.texture_filter_anisotropic_16x
}

// Texture parameters: wrap mode
const tex_wrap_ids = {
    'repeat':        rl.texture_wrap_repeat
    'clamp':         rl.texture_wrap_clamp
    'mirror_repeat': rl.texture_wrap_mirror_repeat
    'mirror_clamp':  rl.texture_wrap_mirror_clamp
}

// Material map index
const mat_map_ids = {
    'albedo':     rl.material_map_albedo,
    'metalness':  rl.material_map_metalness,
    'normal':     rl.material_map_normal,
    'roughness':  rl.material_map_roughness,
    'occlusion':  rl.material_map_occlusion,
    'emission':   rl.material_map_emission,
    'height':     rl.material_map_height,
    'cubemap':    rl.material_map_cubemap,
    'irradiance': rl.material_map_irradiance,
    'prefilter':  rl.material_map_prefilter,
    'brdf':       rl.material_map_brdf,
    'diffuse':    rl.material_map_diffuse,
    'specular':   rl.material_map_specular
}

fn (mut res_arr []Texture) load_json_model(json_path string, shader rl.Shader) !rl.Model {
    js_model_data := json.decode(ModelData, os.read_file(json_path)!)!
    assert js_model_data.path != ''

    // Model.
    mut model := rl.Model.load(js_model_data.path)
    assert model.is_valid()

    // Transform
    model.transform = js_model_data.transform.to_rl_matrix()

    // Set shader
    model.set_shader(0, shader)

    // Materials
    for mi, mat in js_model_data.materials {

        // TODO: Update shader params:
        //    1. Get all attributes.
        //    2. Get all active uniforms.
        //    3. Bind all attribs and uniforms.
        //    ets. 
        // { 
        //     vs_str := if mat.shader.vs_path == "" { voidptr(0) } else { mat.shader.vs_path.str }
        //     fs_str := if mat.shader.fs_path == "" { voidptr(0) } else { mat.shader.fs_path.str }
        //     new_shader := rl.load_shader(vs_str, fs_str)
        //     assert new_shader.is_valid()
        //     println('INFO: SHADER: [ID ${new_shader.id}] : [ '+term.green('${rl.get_file_name(mat.shader.vs_path)}')+', '+term.green('${rl.get_file_name(mat.shader.fs_path)}')+' ]')
        //     model.set_shader(mi, new_shader)
        //     println('SHADER: [ '+term.green('${mat.shader.vs_path}, ${mat.shader.fs_path}')+' ] is'+term.green(' Loaded'))
        // }
        
        for mp in 0..mat.maps.len {
            js_mat_map := mat.maps[mp]
            map_id     := mat_map_ids[js_mat_map.type]

            if js_mat_map.texture.path != "" {
                js_tex_dat := js_mat_map.texture
                
                // mut texture := rl.Texture.load(js_tex_dat.path)
                mut texture := res_arr.load(js_tex_dat.path)

                is_texture_valid := texture.is_valid()
                if !is_texture_valid {
                    println('TEXTURE: ERROR. Could not load texture ${js_tex_dat.path}')
                    img_w     := int(256)
                    img_h     := int(256)
                    txt       := 'ERROR!'
                    txt_size := 40
                    txt_width := rl.measure_text(txt.str, 40)
                    // mut img := rl.Image.gen_color(img_w, img_h, rl.red)
                    mut img := rl.Image.gen_checked(img_w, img_h, 16, 16, rl.yellow, rl.red)
                    defer { img.unload() }

                    rl.begin_drawing()
                        img.draw_rectangle((img_w/2-txt_width/2)-10, img_h/2-25, txt_width+25, txt_size, rl.red)
                        img.draw_text(txt, img_w/2-txt_width/2, img_h/2-20, txt_size, rl.white)
                    rl.end_drawing()

                    texture = img.to_texture()
                }
                if is_texture_valid {
                    if js_tex_dat.filter != "" {
                        texture.set_filter(tex_filter_ids[js_tex_dat.filter])
                    }
                    if js_tex_dat.wrap != "" {
                        texture.set_wrap(tex_wrap_ids[js_tex_dat.wrap])
                    }
                    if js_tex_dat.mipmaps {
                        texture.gen_mipmaps()
                    }
                }
                model.set_texture(mi, map_id, texture)
                    
            }
            model.set_value(mi, map_id, js_mat_map.value)
            model.set_color(mi, map_id, js_mat_map.color)
        }
        // TODO: Update shader
    }
    return model
}


struct ResManager {
mut:
    textures map[string]rl.Texture = map[string]rl.Texture{}
    shaders  map[string]rl.Shader  = map[string]rl.Shader {}
}

// fn (mut rm ResManager) load_texture(tex_path string) rl.Texture {
//     mut file_name := rl.get_file_name(tex_path)

//     return rm.textures[file_name] or {
//         mut texture := rl.load_texture(tex_path)
//         println('MU TEXTUER: ${texture.id}. ${file_name}, w: ${texture.width}, h: ${texture.height}')
//         if texture.width ==0 && texture.height == 0 {
//             println('TEXTUER: ERROR. Loading DEFAULT')
//             texture = rm.textures['DEFAULT'] or {
//                 img_w     := int(256)
//                 img_h     := img_w
//                 font_size := int(20)
//                 txt       := 'ERROR!'

//                 txt_width := rl.measure_text(txt.str, font_size)

//                 mut img := rl.Image.gen_checked(img_w, img_h, 16, 16, rl.red, rl.yellow)
//                 defer { img.unload() }

//                 rl.begin_drawing()
//                     img.draw_text(txt, img_w/2-txt_width/2, img_h-font_size, font_size, rl.red) 
//                 rl.end_drawing()

//                 // texture   = rl.Texture.load_from_image(img)
//                 file_name = 'DEFAULT'
//                 texture   = img.to_texture()
//                 texture
//             }
//         }
//         rm.textures[file_name] = texture
//         return texture
//     }
// }

// fn (rm ResManager) get_texture(tex_name string) ?rl.Texture {
//     return rm.textures[tex_name]
// }

// fn (rm ResManager) get_texture_index(tex_ind int) rl.Texture {
//     assert tex_ind >= 0 && tex_ind < rm.textures.len
//     return rm.textures.values()[tex_ind]
// }

// fn (mut rm ResManager) load_shader(vs_path &u8, fs_path &u8) rl.Shader {
//     fs_file_name := if vs_path != voidptr(0) { rl.get_file_name(unsafe { vs_path.vstring() }) } else { '' }
//     vs_file_name := if fs_path != voidptr(0) { rl.get_file_name(unsafe { fs_path.vstring() }) } else { '' }

//     file_name := if fs_file_name == '' && vs_file_name == '' {
//         'default'
//     } else {
//         fs_file_name+vs_file_name
//     }
    
//     return rm.shaders[file_name] or {
//         shader := if file_name == 'default' {
//             rl.Shader.get_default()
//         } else {
//             rl.load_shader(vs_path, fs_path)
//         }
//         rm.shaders[file_name] = shader
//         return shader
//     }
// }

// fn (rm ResManager) get_shader(shader_name string) ?rl.Shader {
//     return rm.shaders[shader_name] or { none }
// }

//----------------------------------------------------------------------------------
// Main Entry Point
//----------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    width  := 800*2
    height := 450*2

    // rl.set_config_flags(rl.flag_msaa_4x_hint)
    rl.init_window(width, height, 'raylib [shaders] example - basic pbr')
    
    rl.disable_cursor()
    rl.set_target_fps(120)                        // Set our game to run at 60 frames-per-second
    // //---------------------------------------------------------------------------------------

    // Define the camera to look into our 3d world
    mut camera := rl.Camera  {
        position:    rl.Vector3{ 2.0, 2.0, 6.0 } // Camera position
        target:      rl.Vector3{ 0.0, 0.5, 0.0 } // Camera looking at point
        up:          rl.Vector3{ 0.0, 1.0, 0.0 } // Camera up vector (rotation towards target)
        fovy:        45.0                        // Camera field-of-view Y
        projection:  rl.camera_perspective       // Camera projection type
    }

    // Load PBR shader and setup all required locations
    mut shader := rl.Shader.load(
        (asset_path+'shaders/glsl330/pbr.vs').str,
        (asset_path+'shaders/glsl330/pbr.fs').str
    )!
    
    shader.set_loc(rl.shader_loc_map_albedo,    'albedoMap')
    // WARNING: Metalness, roughness, and ambient occlusion are all packed into a MRA texture
    // They are passed as to the rl.shader_loc_map_metalness location for convenience,
    // shader already takes care of it accordingly
    shader.set_loc(rl.shader_loc_map_metalness, 'mraMap')
    shader.set_loc(rl.shader_loc_map_normal,    'normalMap')
    // WARNING: Similar to the MRA map, the emissive map packs different information 
    // into a single texture: it stores height and emission data
    // It is binded to rl.shader_loc_map_emission location an properly processed on shader
    shader.set_loc(rl.shader_loc_map_emission,  'emissiveMap')
    shader.set_loc(rl.shader_loc_color_diffuse, 'albedoColor')
    // Setup additional required shader locations, including lights data
    shader.set_loc(rl.shader_loc_vector_view,   'viewPos')

    light_count_loc := shader.get_loc('numOfLights')
    max_light_count := max_lights;
    shader.set_value(light_count_loc, &max_light_count, rl.shader_uniform_int)

    // Setup ambient color and intensity parameters
    ambient_intensity        := f32(0.02)
    ambient_color            := rl.Color{ 26, 32, 135, 255 }
    ambient_color_normalized := rl.Vector3{
        f32(ambient_color.r)/255.0,
        f32(ambient_color.g)/255.0,
        f32(ambient_color.b)/255.0
    }

    shader.set_value(shader.get_loc('ambient_color'), &ambient_color_normalized, rl.shader_uniform_vec3)
    shader.set_value(shader.get_loc('ambient'),       &ambient_intensity,        rl.shader_uniform_float)

    // Get location for shader parameters that can be modified in real time
    emissive_intensity_loc := shader.get_loc('emissivePower');
    emissive_color_loc     := shader.get_loc('emissiveColor')
    texture_tiling_loc     := shader.get_loc('tiling')

    mut res_arr := []Texture{ cap: 30 }
    // Load old car model using PBR maps and shader
    // WARNING: We know this model consists of a single model.meshes[0] and
    // that model.materials[0] is by default assigned to that mesh
    // There could be more complex models consisting of multiple meshes and
    // multiple materials defined for those meshes... but always 1 mesh = 1 material
    car := $if USE_RAYLIB_PATH ? {
        mut m := rl.Model.load(asset_path+'models/old_car_new.glb')
        m.set_shader(0, shader)
        m.set_texture(0, rl.material_map_albedo,    res_arr.load(asset_path+'old_car_d.png'))
        m.set_texture(0, rl.material_map_normal,    res_arr.load(asset_path+'old_car_n.png'))
        m.set_texture(0, rl.material_map_emission,  res_arr.load(asset_path+'old_car_e.png'))
        m.set_texture(0, rl.material_map_metalness, res_arr.load(asset_path+'old_car_mra.png'))
        m
    } $else {
        res_arr.load_json_model(asset_path+'models/old_car.json', shader)!
    }

    // Load floor model mesh and assign material parameters
    // NOTE: A basic plane shape can be generated instead of being loaded from a model file
    // mut floor_mesh := rl.gen_mesh_plane(10, 10, 10, 10)
    // rl.gen_mesh_tangents(&floor_mesh)      // TODO: Review tangents generation
    // reset_mesh(mut floor_mesh)
    // floor := rl.load_model_from_mesh(floor_mesh)

    // Assign material shader for our floor model, same PBR shader 
    floor := $if USE_RAYLIB_PATH ? {
        mut m := rl.Model.load(asset_path+'models/plane.glb')
        m.set_shader(0, shader)
        m.set_texture(0, rl.material_map_albedo,    res_arr.load(asset_path+'road_a.png'))
        m.set_texture(0, rl.material_map_metalness, res_arr.load(asset_path+'road_mra.png'))
        m.set_texture(0, rl.material_map_normal,    res_arr.load(asset_path+'road_n.png'))
        m
    } $else {
        res_arr.load_json_model(asset_path+'models/floor.json', shader)!
    }
    
    // Models texture tiling parameter can be stored in the Material struct if required (CURRENTLY NOT USED)
    // NOTE: Material.params[4] are available for generic parameters storage (f32)
    car_texture_tiling   := rl.Vector2{ 0.5, 0.5 }
    floor_texture_tiling := rl.Vector2{ 0.5, 0.5 }

    light_colors := [
        rl.red,
        rl.green,
        rl.blue,
        rl.yellow,
        rl.Color.lerp(rl.yellow, rl.white, 0.3)
    ]
    light_positions := [
        rl.Vector3{ -2.0, 1.0,  1.0 },
        rl.Vector3{  2.0, 1.0,  1.0 },
        rl.Vector3{  1.0, 1.0, -2.0 },
        rl.Vector3{ -1.0, 1.0, -2.0 }
        rl.Vector3{ 0.65, 0.6,  2.4 }
    ]

    // Create some lights
    mut lights := []Light{ cap: max_light_count }
    for i in 0..lights.cap {
        lights.add(light_positions[i], light_colors[i], shader)
    }
    
    mut car_light := unsafe { &lights[lights.len-1] }
    $if USE_RAYLIB_PATH ? {
        car_light.position = light_positions[light_positions.len-1]
    }
    car_light.intensity = 0.3
    
    // max_light_count := max_lights;
    shader.set_value(light_count_loc, &lights.len, rl.shader_uniform_int)

    // Setup material texture maps usage in shader
    // NOTE: By default, the texture maps are always used
    mut usage := int(1)
    shader.set_value(shader.get_loc('useTexAlbedo'),   &usage, rl.shader_uniform_int)
    shader.set_value(shader.get_loc('useTexNormal'),   &usage, rl.shader_uniform_int)
    shader.set_value(shader.get_loc('useTexMRA'),      &usage, rl.shader_uniform_int)
    shader.set_value(shader.get_loc('useTexEmissive'), &usage, rl.shader_uniform_int)
    
    camera_mode_names := [
        'FREE',
        'ORBITAL',
        'FIRST PERSON',
        'THIRD PERSON'
    ]
    camera_modes := [
        rl.camera_free,
        rl.camera_orbital,
        rl.camera_first_person,
        rl.camera_third_person
    ]
    mut camera_mode := camera_modes[0]

    // t := res_arr[0]
    // img := rl.Image.load_from_texture(t.texture)
    // img := rl.Texture.to_image(t.texture)
    // img.export('Image.png')
    
    // Main game loop
    for !rl.window_should_close() {  // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        time := f32(rl.get_time())

        if camera_modes[camera_mode] == rl.camera_orbital ||
           camera_modes[camera_mode] == rl.camera_third_person
        {
           camera.target = rl.Vector3{ y:0.3 }
        }
        rl.update_camera(&camera, camera_modes[camera_mode])

        if rl.is_key_pressed(rl.key_c) {
            camera_mode = (camera_mode+1)%camera_modes.len
        }

        shader.set_value(shader.get_loc_index(rl.shader_loc_vector_view), &camera.position, rl.shader_uniform_vec3)

        // Check key inputs to enable/disable lights
        if rl.is_key_pressed(rl.key_r) { lights[0].enabled = !lights[0].enabled }
        if rl.is_key_pressed(rl.key_g) { lights[1].enabled = !lights[1].enabled }
        if rl.is_key_pressed(rl.key_b) { lights[2].enabled = !lights[2].enabled }
        if rl.is_key_pressed(rl.key_y) { lights[3].enabled = !lights[3].enabled }

        if rl.is_key_pressed(rl.key_l) { car_light.enabled = !car_light.enabled }

        // Update light values on shader (actually, only enable/disable them)
        emissive_intensity := (rl.sinf(time*4)*rl.sinf(time*10)+1)*0.5  //f32(0.01)
        car_light.intensity = emissive_intensity
        lights.update(shader) // for light in lights { light.update(shader) }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()
            rl.clear_background(rl.black)
            rl.begin_mode_3d(camera)
                // Set floor model texture tiling and emissive color parameters on shader
                shader.set_value(texture_tiling_loc, &floor_texture_tiling, rl.shader_uniform_vec2)

                $if USE_RAYLIB_PATH ? {
                    ambient := rl.fmaxf(ambient_intensity * lights.filter(it.enabled).len, 0.001)
                    shader.set_value(shader.get_loc('ambient'), &ambient, rl.shader_uniform_float) 
                }
        
                floor_emissive_color := unsafe {
                    rl.Color.normalize(floor.materials[0].maps[rl.material_map_emission].color)
                }
                // shader.set_value(emissive_color_loc, &floor_emissive_color, rl.shader_uniform_vec4)
                shader.set_value(emissive_color_loc, &floor_emissive_color, rl.shader_uniform_vec4)
                
                floor.draw(rl.Vector3 {}, 5.0, rl.white)   // Draw floor model

                // // Set old car model texture tiling, emissive color and emissive intensity parameters on shader
                shader.set_value(texture_tiling_loc, &car_texture_tiling, rl.shader_uniform_vec2)

                if car_light.enabled {
                    car_emissive_color := unsafe {
                        rl.Color.normalize(car.materials[0].maps[rl.material_map_emission].color)
                    }
                    shader.set_value(emissive_color_loc,     &car_emissive_color, rl.shader_uniform_vec4)
                    shader.set_value(emissive_intensity_loc, &emissive_intensity, rl.shader_uniform_float)   
                }
        
                // rl.draw_model(car, rl.Vector3 {}, 0.25, rl.white)   // Draw car model
                car.draw(rl.Vector3 {}, 0.25, rl.white)   // Draw car model

                // Draw spheres to show the lights positions
                for i, mut light in lights[0..lights.len-1] {
                    if !light.enabled { continue }
                    
                    light_sin := (rl.sinf(time+i)+1)*.5
                    
                    light.intensity = light_sin*10.0
                    light.color     = rl.Color.alpha(light.color, light_sin)
                    light.size      = (light_sin+1)*0.05

                    color, radius := if light.enabled {
                        light.color, light.size
                    } else {
                        rl.Color.alpha(light.color, 0.1), f32(0.1)
                    }
                    rl.draw_sphere_ex(light.position, radius, 8, 8, color)
                }
        
            rl.end_mode_3d()
            {
                cam_pos := camera.position
                rl.draw_text(
                    'CAMERA: Mode: ${camera_mode_names[camera_mode]} | Pos: [ ${cam_pos.x:.2}, ${cam_pos.y:.2}, ${cam_pos.z:.2} ]',
                    20, height-40, 20, rl.white
                )
            }
        
            { // rl.draw_text('Toggle lights: [R][G][B][Y]', 10, 40, 20, rl.lightgray)
                txt         := "Toggle lights: "
                txt_size    := 20
                txt_width   := rl.measure_text(txt.str, txt_size)
                txt_pos_x   := 10
                txt_pos_y   := 40
                
                leters      := [ "[R] ", "[G] ", "[B] ", "[Y] " ]
                leter_width := rl.measure_text(leters[0].str, txt_size)
                txt_offset  := txt_pos_x+txt_width
                
                rl.draw_text(txt, txt_pos_x, txt_pos_y, txt_size, rl.lightgray)
                
                for i, leter in leters {
                    color := if lights[i].enabled { light_colors[i] } else { rl.lightgray }
                    rl.draw_text(leter, txt_offset+(leter_width*i), txt_pos_y, txt_size, color)
                }
                {
                    mut light_radius := f32(txt_size)

                    car_light_color, car_leter_color := if car_light.enabled {
                        light_radius *= emissive_intensity
                        rl.Color.lerp(rl.Color.fade(rl.gray, 0.2), car_light.color, emissive_intensity), rl.red
                    } else {
                        rl.Color.fade(rl.gray, 0.2), rl.black
                    }

                    rl.draw_circle(txt_pos_x+int(f32(leter_width)*0.35), txt_pos_y+int(f32(leter_width)*1.25), light_radius, car_light_color)
                    rl.draw_text(' L ', txt_pos_x, txt_pos_y + txt_size + 10, txt_size, car_leter_color)
                    rl.draw_text(' : Car Light', txt_pos_x + leter_width, txt_pos_y + txt_size + 10, txt_size, car_light_color)
                }
            }
            {
                txt := $if USE_RAYLIB_PATH ? {
                    '(c) Old Rusty Car model by Renafox (https://skfb.ly/LxRy).'
                } $else {
                    '(c) Old Rusty Car model by Renafox (https://skfb.ly/LxRy) | Modified by Fedorov (xydojnik).'
                }
                txt_width := rl.measure_text(txt.str, 10)
                rl.draw_text(txt, width-txt_width-20, height-20, 10, rl.lightgray)

            }
            rl.draw_fps(10, 10)

        rl.end_drawing()
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    // Unbind (disconnect) shader from car.material[0] 
    // to avoid rl.unload_material() trying to unload it automatically
    unsafe {
        car.materials[0].shader = rl.Shader {}
        // rl.unload_material(car.materials[0])
        car.materials[0].unload()
        car.materials[0].maps   = nil

        floor.materials[0].shader = rl.Shader{}
        // rl.unload_material(floor.materials[0])
        floor.materials[0].unload()
        floor.materials[0].maps   = nil
    }

    floor.unload()
    car.unload()
    shader.unload()                // Unload rl.Shader
    res_arr.unload()
    
    rl.close_window()              // Close window and OpenGL context
}
