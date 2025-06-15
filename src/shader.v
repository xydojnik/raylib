module raylib


pub const max_shader_locations = C.RL_MAX_SHADER_LOCATIONS

// Shader location index
pub const shader_loc_vertex_position    = C.SHADER_LOC_VERTEX_POSITION    // Shader location: vertex attribute: position
pub const shader_loc_vertex_texcoord01  = C.SHADER_LOC_VERTEX_TEXCOORD01  // Shader location: vertex attribute: texcoord01
pub const shader_loc_vertex_texcoord02  = C.SHADER_LOC_VERTEX_TEXCOORD02  // Shader location: vertex attribute: texcoord02
pub const shader_loc_vertex_normal      = C.SHADER_LOC_VERTEX_NORMAL      // Shader location: vertex attribute: normal
pub const shader_loc_vertex_tangent     = C.SHADER_LOC_VERTEX_TANGENT     // Shader location: vertex attribute: tangent
pub const shader_loc_vertex_color       = C.SHADER_LOC_VERTEX_COLOR       // Shader location: vertex attribute: color
pub const shader_loc_matrix_mvp         = C.SHADER_LOC_MATRIX_MVP         // Shader location: matrix uniform: model-view-projection
pub const shader_loc_matrix_view        = C.SHADER_LOC_MATRIX_VIEW        // Shader location: matrix uniform: view (camera transform)
pub const shader_loc_matrix_projection  = C.SHADER_LOC_MATRIX_PROJECTION  // Shader location: matrix uniform: projection
pub const shader_loc_matrix_model       = C.SHADER_LOC_MATRIX_MODEL       // Shader location: matrix uniform: model (transform)
pub const shader_loc_matrix_normal      = C.SHADER_LOC_MATRIX_NORMAL      // Shader location: matrix uniform: normal
pub const shader_loc_vector_view        = C.SHADER_LOC_VECTOR_VIEW        // Shader location: vector uniform: view
pub const shader_loc_color_diffuse      = C.SHADER_LOC_COLOR_DIFFUSE      // Shader location: vector uniform: diffuse color
pub const shader_loc_color_specular     = C.SHADER_LOC_COLOR_SPECULAR     // Shader location: vector uniform: specular color
pub const shader_loc_color_ambient      = C.SHADER_LOC_COLOR_AMBIENT      // Shader location: vector uniform: ambient color
pub const shader_loc_map_albedo         = C.SHADER_LOC_MAP_ALBEDO         // Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
pub const shader_loc_map_metalness      = C.SHADER_LOC_MAP_METALNESS      // Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
pub const shader_loc_map_normal         = C.SHADER_LOC_MAP_NORMAL         // Shader location: sampler2d texture: normal
pub const shader_loc_map_roughness      = C.SHADER_LOC_MAP_ROUGHNESS      // Shader location: sampler2d texture: roughness
pub const shader_loc_map_occlusion      = C.SHADER_LOC_MAP_OCCLUSION      // Shader location: sampler2d texture: occlusion
pub const shader_loc_map_emission       = C.SHADER_LOC_MAP_EMISSION       // Shader location: sampler2d texture: emission
pub const shader_loc_map_height         = C.SHADER_LOC_MAP_HEIGHT         // Shader location: sampler2d texture: height
pub const shader_loc_map_cubemap        = C.SHADER_LOC_MAP_CUBEMAP        // Shader location: samplerCube texture: cubemap
pub const shader_loc_map_irradiance     = C.SHADER_LOC_MAP_IRRADIANCE     // Shader location: samplerCube texture: irradiance
pub const shader_loc_map_prefilter      = C.SHADER_LOC_MAP_PREFILTER      // Shader location: samplerCube texture: prefilter
pub const shader_loc_map_brdf           = C.SHADER_LOC_MAP_BRDF           // Shader location: sampler2d texture: brdf
pub const shader_loc_vertex_boneids     = C.SHADER_LOC_VERTEX_BONEIDS     // Shader location: vertex attribute: boneIds
pub const shader_loc_vertex_boneweights = C.SHADER_LOC_VERTEX_BONEWEIGHTS // Shader location: vertex attribute: boneWeights
pub const shader_loc_bone_matrices      = C.SHADER_LOC_BONE_MATRICES      // Shader location: array of matrices uniform: boneMatrices

pub const shader_loc_map_diffuse        = C.SHADER_LOC_MAP_ALBEDO
pub const shader_loc_map_specular       = C.SHADER_LOC_MAP_METALNESS


// Shader uniform data type
pub const shader_uniform_float       = C.SHADER_UNIFORM_FLOAT     // Shader uniform type: float
pub const shader_uniform_vec2        = C.SHADER_UNIFORM_VEC2      // Shader uniform type: vec2 (2 float)
pub const shader_uniform_vec3        = C.SHADER_UNIFORM_VEC3      // Shader uniform type: vec3 (3 float)
pub const shader_uniform_vec4        = C.SHADER_UNIFORM_VEC4      // Shader uniform type: vec4 (4 float)
pub const shader_uniform_int         = C.SHADER_UNIFORM_INT       // Shader uniform type: int
pub const shader_uniform_ivec2       = C.SHADER_UNIFORM_IVEC2     // Shader uniform type: ivec2 (2 int)
pub const shader_uniform_ivec3       = C.SHADER_UNIFORM_IVEC3     // Shader uniform type: ivec3 (3 int)
pub const shader_uniform_ivec4       = C.SHADER_UNIFORM_IVEC4     // Shader uniform type: ivec4 (4 int)
pub const shader_uniform_sampler_2d  = C.SHADER_UNIFORM_SAMPLER2D // Shader uniform type: sampler2d

// pub enum ShaderUniformType as int {
//     float       = C.SHADER_UNIFORM_FLOAT     // Shader uniform type: float
//     vec2        = C.SHADER_UNIFORM_VEC2      // Shader uniform type: vec2 (2 float)
//     vec3        = C.SHADER_UNIFORM_VEC3      // Shader uniform type: vec3 (3 float)
//     vec4        = C.SHADER_UNIFORM_VEC4      // Shader uniform type: vec4 (4 float)
//     integer     = C.SHADER_UNIFORM_INT       // Shader uniform type: int
//     ivec2       = C.SHADER_UNIFORM_IVEC2     // Shader uniform type: ivec2 (2 int)
//     ivec3       = C.SHADER_UNIFORM_IVEC3     // Shader uniform type: ivec3 (3 int)
//     ivec4       = C.SHADER_UNIFORM_IVEC4     // Shader uniform type: ivec4 (4 int)
//     sampler_2d  = C.SHADER_UNIFORM_SAMPLER2D // Shader uniform type: sampler2d
// }

// Shader attribute data types
pub const shader_attrib_float = C.SHADER_ATTRIB_FLOAT // Shader attribute type: float
pub const shader_attrib_vec2  = C.SHADER_ATTRIB_VEC2  // Shader attribute type: vec2 (2 float)
pub const shader_attrib_vec3  = C.SHADER_ATTRIB_VEC3  // Shader attribute type: vec3 (3 float)
pub const shader_attrib_vec4  = C.SHADER_ATTRIB_VEC4  // Shader attribute type: vec4 (4 float)

// pub enum ShaderAttribType as int {
//     float = C.SHADER_ATTRIB_FLOAT // Shader attribute type: float
//     vec2  = C.SHADER_ATTRIB_VEC2  // Shader attribute type: vec2 (2 float)
//     vec3  = C.SHADER_ATTRIB_VEC3  // Shader attribute type: vec3 (3 float)
//     vec4  = C.SHADER_ATTRIB_VEC4  // Shader attribute type: vec4 (4 float)
// }

// Shader
@[typedef]
struct C.Shader {
pub mut:
	id   u32                  // Shader program id
	locs &int                 // Shader locations array (rl_max_shader_locations)
}
pub type Shader = C.Shader

pub fn (s Shader) operator [] (index int) int {
    assert index >= 0 && index < max_shader_locations
    return unsafe { s.locs[index] }
}

@[inline]
pub fn Shader.load(vs_file_name &char, fs_file_name &char) !Shader {
	sh := C.LoadShader(vs_file_name, fs_file_name)
    if !sh.is_valid() {
        return error('SHADER: Is not valid [${vs_file_name}, ${fs_file_name}]')
    }
    return sh
}

@[inline]
pub fn Shader.load_from_memory(vs_code &char, fs_code &char) Shader {
	return C.LoadShaderFromMemory(vs_code, fs_code)
}

@[inline]
pub fn Shader.get_default() Shader {    // Load default shader
    return Shader {
        id:   rl_get_shader_id_default()
        locs: rl_get_shader_locs_default()
    }
}

@[inline] pub fn (s Shader) unload() { C.UnloadShader(s) }

@[inline] pub fn (s Shader) enable()     { rl_enable_shader(s.id) }
@[inline] pub fn (s Shader) disable()    { rl_disable_shader()    }

@[inline] pub fn Shader.enable(s Shader) { rl_enable_shader(s.id) }
@[inline] pub fn Shader.disable()        { rl_disable_shader()    }


@[inline]
pub fn (s Shader) set_sampler(uniform_name string, index u32) {
    rl_set_uniform_sampler(s.get_loc(uniform_name), index)
}
                                                    
pub fn (mut s Shader) set_loc(loc_index int, uniform_name string) {
    assert loc_index >= 0 && loc_index < max_shader_locations
    unsafe { s.locs[loc_index] = s.get_loc(uniform_name) }
}

pub fn (mut s Shader) set_loc_attrib(loc_index int, attrib_name string) {
    assert loc_index <= max_shader_locations
    unsafe { s.locs[loc_index] = s.get_loc_attrib(attrib_name) }
}

@[inline]
pub fn (s Shader) set_value(loc_index int, value voidptr, uniform_type int) {
	C.SetShaderValue(s, loc_index, value, uniform_type)
}

@[inline]
pub fn (s Shader) set_value_1i(loc int, val int) {
	s.set_value(loc, &val, rl_shader_uniform_int)
}

@[inline]
pub fn (s Shader) set_value_1f(loc int, val f32) {
	s.set_value(loc, &val, rl_shader_uniform_float)
}

@[inline]
pub fn (s Shader) set_value_v(loc_index int, value voidptr, uniform_type int, count int) {
	C.SetShaderValueV(s, loc_index, value, uniform_type, count)
}

@[inline]
pub fn (s Shader) set_value_matrix(loc_index int, mat Matrix) {
	C.SetShaderValueMatrix(s, loc_index, mat)
}

@[inline]
pub fn (s Shader) set_value_texture(loc_index int, texture Texture) {
	C.SetShaderValueTexture(s, loc_index, texture)
}

@[inline]
pub fn (s Shader) get_loc(uniform_name string) int {
    return rl_get_location_uniform(s.id, uniform_name.str)
}

@[inline]
pub fn (s Shader) get_loc_index(index int) int {
    assert index >= 0 && index < max_shader_locations
    return unsafe { s.locs[index] }
}

@[inline]
// pub fn (s Shader) get_location_attrib(attrib_name charptr) int {
pub fn (s Shader) get_loc_attrib(attrib_name string) int {
	return C.GetShaderLocationAttrib(s, attrib_name.str)
}

fn C.IsShaderValid(s Shader) bool  // Check if a shader is valid (loaded on GPU)
@[inline]
pub fn (s Shader) is_valid() bool {
    return C.IsShaderValid(s)
}
