import raylib as rl


import term
// import os
// import json

// // JSON DATA
// pub struct TextureData {
// pub:
//     path    string
//     filter  string
//     wrap    string
//     mipmaps bool
// }

// pub struct ShaderData {
// pub:
//     vs_path string
//     fs_path string
// }

// pub struct MaterialMap {
// pub:
//     type   string
//     texture TextureData
//     value   f32
//     color   rl.Color
// }

// pub struct MaterialData {
// pub:
//     shader ShaderData
//     maps   []MaterialMap
// }

// // fn (md MaterialData) to_materials() []rl.Material {
// //     return []rl.Material
// // }

// pub struct TransformData {
// pub:
//     position rl.Vector3
//     rotation rl.Vector3
//     scale    rl.Vector3
// }

// pub fn (td TransformData) to_matrix() rl.Matrix {
//     translation := rl.Matrix.translate(td.position) 
//     rotation    := rl.Matrix.rotate_xyz(td.rotation) 
//     scale       := rl.Matrix.scale(td.scale.x, td.scale.y, td.scale.z) 
//     return rl.Matrix.multiply(translation, rl.Matrix.multiply(rotation, scale))
// }

// pub struct ModelData {
//     path      string
//     transform TransformData
//     materials []MaterialData
// }

// pub struct Texture {
// pub:
//     texture rl.Texture
//     name    string 
// }

// fn (texture Texture) str() string {
//     return 'TEXTURE: ('+ term.bold(term.green('${texture.texture.id}'))+
//             ') : [ '   + term.bold(term.green('${texture.name}'))+' ]'
// }

// fn Texture.load(file_path string) Texture {
//     texture := Texture {
//         texture: rl.load_texture(file_path),
//         name:    rl.get_file_name(file_path)
//     }
//     println('${texture} '+term.bold(term.green('Loaded.')))
//     return texture
// }

// @[inline]
// fn (texture Texture) unload() {
//     println('${texture} '+term.bold(term.red(' Unloaded.')))
//     texture.texture.unload()
// }


// @[inline]
// fn (mut tarr []Texture) load(file_path string) rl.Texture {
//     texture := Texture.load(file_path)
//     tarr << texture
//     return texture.texture
// }

// @[inline]
// fn (mut tarr []Texture) foreach(fe fn(Texture)) {
//     for texture in tarr { fe(texture) }
// }

// fn (mut tarr []Texture) unload() {
//     tarr.foreach(fn(texture Texture) { texture.unload() })
//     unsafe { tarr.free() }
// }

// pub fn (mut tex_arr []Texture) load_json_model(json_path string, shader rl.Shader) !rl.Model {
//     js_model_data := json.decode(ModelData, os.read_file(json_path)!)!
//     assert js_model_data.path != ''

//     // Model.
//     mut model := rl.load_model(js_model_data.path)
//     assert model.is_valid()
    
//     // Transform
//     model.transform = js_model_data.transform.to_matrix()

//     // Set shader
//     model.set_shader(0, shader)
    
//     // Materials
//     for mi, mat in js_model_data.materials {
//         // TODO: Update shader params:
//         //    1. Get all uniforms.
//         //    2. Bind all attribs and uniforms.
//         //    ets. 
//         // { 
//         //     vs_str := if mat.shader.vs_path == "" { voidptr(0) } else { mat.shader.vs_path.str }
//         //     fs_str := if mat.shader.fs_path == "" { voidptr(0) } else { mat.shader.fs_path.str }

//         //     new_shader := rl.load_shader(vs_str, fs_str)
//         //     assert new_shader.is_valid()
//         //     println('INFO: SHADER: [ID ${new_shader.id}] : [ '+term.green('${rl.get_file_name(mat.shader.vs_path)}')+', '+term.green('${rl.get_file_name(mat.shader.fs_path)}')+' ]')
//         //     model.set_shader(mi, new_shader)
//         //     println('SHADER: [ '+term.green('${mat.shader.vs_path}, ${mat.shader.fs_path}')+' ] is'+term.green(' Loaded'))
//         // }
        
//         for mp in 0..mat.maps.len {
//             js_mat_map := mat.maps[mp]
//             map_id     := mat_map_ids[js_mat_map.type]

//             if js_mat_map.texture.path != "" {
//                 js_tex_dat := js_mat_map.texture
                
//                 mut texture := tex_arr.load(js_tex_dat.path)
//                 if js_tex_dat.filter != "" {
//                     texture.set_filter(tex_filter_ids[js_tex_dat.filter])
//                 }
//                 if js_tex_dat.wrap != "" {
//                     texture.set_wrap(tex_wrap_ids[js_tex_dat.wrap])
//                 }
//                 if js_tex_dat.mipmaps {
//                     texture.gen_mipmaps()
//                 }
//                 model.set_texture(mi, map_id, texture)
//             }
//             model.set_value(mi, map_id, js_mat_map.value)
//             model.set_color(mi, map_id, js_mat_map.color)
//         }
//         // TODO: Update shader
//     }
//     return model
// }



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


pub struct Resource[T] {
pub:
    data  T
pub mut:
    used bool = true
}

pub fn Resource.load[T](path string, load fn() ?T) ?T { return load() }

pub fn (res Resource[T]) unload[T](path string, unload fn(T)) { unload(res.data) }

pub fn (res1 Resource[T]) compare(res2 Resource[T], comp_fn fn(a Resource[T], b Resource[T])bool) bool {
    return comp_fn(res1, res2)
}

pub struct ResManager {
pub mut:
    textures map[string]Resource[rl.Texture]
    // shaders  map[string]Resource[rl.Shader]
}

pub fn (mut rm ResManager) load_texture(path string) rl.Texture {
    file_name := rl.get_file_name(path)

    if file_name in rm.textures {
        println('TEXTURE: [ '+term.green('${file_name}')+' ] '+term.yellow('Allready loaded.'))
    }
    
    res  := rm.textures[file_name] or {
        mut texture := rl.load_texture(path)

        if texture.is_valid() {
            res := Resource{texture, true}
            rm.textures[file_name] = res
            println(term.green('TEXTURE')+': [ID ${res.data.id}] [ '+term.green('${file_name}')+' ] '+term.green('Loaded.'))
            res
        } else {
            println(term.yellow('TEXTURE')+': Could not open file [ '+term.red('${path}')+' ]. Return '+term.yellow('"DEFAULT"'))
            rm.textures['DEFAULT'] or {
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
                
                tex := img.to_texture()

                res_def := Resource{ tex, true }
                rm.textures['DEFAULT'] = res_def
                res_def
            }
        }
    }
    return res.data
}

pub fn (rm ResManager) get_texture(index int) (rl.Texture, string) {
    assert index >= 0 && index < rm.textures.len
    texture := rm.textures.values()[index].data
    name    := rm.textures.keys()[index]
    return texture, name
}

pub fn (mut rm ResManager) unload_unused_textures() {
    for name, tex_res in rm.textures {
        if !tex_res.used {
            print(term.green('TEXTURE')+': [ID ${tex_res.data.id}] [ '+term.green('${name}')+' ] ')
            rm.textures.delete(name)
            println(term.green('Unloaded.'))
        }
    }
}

pub fn (mut rm ResManager) unload_all_textures() {
    for name, tex_res in rm.textures {
        rl.unload_texture(tex_res.data)
        print(term.green('TEXTURE')+': [ID ${tex_res.data.id}] [ '+term.green('${name}')+' ] ')
        rm.textures.delete(name)
        println(term.green('Unloaded.'))
    }
}

pub fn (mut rm ResManager) unload() {
    rm.unload_all_textures()
}


// pub fn (mut rm ResManager) load_texture(tex_path string) rl.Texture {
//     file_name := rl.get_file_name(tex_path)
//     return rm.textures[file_name] or {
//         texture := rl.load_texture(tex_path)
//         rm.textures[file_name] = texture
//         return texture
//     }
// }

// pub fn (rm ResManager) get_texture(tex_name string) ?rl.Texture {
//     return rm.textures[tex_name]
// }

// pub fn (mut rm ResManager) load_shader(vs_path &u8, fs_path &u8) rl.Shader {
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

// pub fn (rm ResManager) get_shader(shader_name string) ?rl.Shader {
//     return rm.shaders[shader_name]
// }

// pub fn (mut rm ResManager) unload() {
//     for k, t in rm.textures {
//         rl.unload_texture(t)
//         println('TEXTURE: [ ${k} ] Unloaded.')
//     }
//     for k, s in rm.shaders  {
//         rl.unload_shader(s)
//         println('SHADER: [ ${k} ] Unloaded.')
//     }

//     unsafe {
//         rm.textures.free()
//         rm.shaders.free()
//     }
// }




fn main() {
    width  := 1000
    height := width

    rl.set_config_flags(rl.flag_msaa_4x_hint)
    rl.init_window(width, height, 'resources manager')
    defer { rl.close_window() }

    rl.set_target_fps(120)

    mut res_man := ResManager{}
    defer { res_man.unload() }

    res_man.load_texture('resources/old_car_d.pnngg') // it returns default, red one
    res_man.load_texture('resources/old_car_d.png')
    res_man.load_texture('resources/old_car_mra.png')
    res_man.load_texture('resources/old_car_n.png')
    res_man.load_texture('resources/old_car_e.png')

    tex_count := res_man.textures.len

    car := rl.load_model('resources/models/old_car_new.obj')
    assert car.is_valid()
    
    defer { car.unload() }

    car_mesh := unsafe { car.meshes[0] }


    for !rl.window_should_close() {
        tex_ind := int(rl.get_time()*0.5) % tex_count
        tex, name := res_man.get_texture(tex_ind)

        rl.begin_drawing()
            rl.clear_background(rl.white)

            // Draw textures
            tex.draw_pro(
                rl.Rectangle{0, 0, tex.width, tex.height},
                rl.Rectangle{0, 0, width, height},
                rl.Vector2{}, 0, rl.gray
            )
            // Draw mesh uv 1 or 2 if exist
            car_mesh.draw_uv(0, false, width, height, 0, 0.3, rl.Color.fade(rl.white, 0.1))
        
            rl.draw_text('(${tex_ind}) : [ ${name} ]', 20, 20, 20, rl.white)
        rl.end_drawing()
    }
}
