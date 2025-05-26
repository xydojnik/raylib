module raylib


// Material map index
pub const material_map_albedo     = C.MATERIAL_MAP_ALBEDO         // Albedo material (same as: MATERIAL_MAP_DIFFUSE)
pub const material_map_metalness  = C.MATERIAL_MAP_METALNESS      // Metalness material (same as: MATERIAL_MAP_SPECULAR)
pub const material_map_normal     = C.MATERIAL_MAP_NORMAL         // Normal material
pub const material_map_roughness  = C.MATERIAL_MAP_ROUGHNESS      // Roughness material
pub const material_map_occlusion  = C.MATERIAL_MAP_OCCLUSION      // Ambient occlusion material
pub const material_map_emission   = C.MATERIAL_MAP_EMISSION       // Emission material
pub const material_map_height     = C.MATERIAL_MAP_HEIGHT         // Heightmap material
pub const material_map_cubemap    = C.MATERIAL_MAP_CUBEMAP        // Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
pub const material_map_irradiance = C.MATERIAL_MAP_IRRADIANCE     // Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
pub const material_map_prefilter  = C.MATERIAL_MAP_PREFILTER      // Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
pub const material_map_brdf       = C.MATERIAL_MAP_BRDF           // Brdf material

pub const material_map_diffuse    = C.MATERIAL_MAP_ALBEDO
pub const material_map_specular   = C.MATERIAL_MAP_METALNESS

pub const max_material_map_count  = int(32)

// MaterialMap
@[typedef]
struct C.MaterialMap {
pub mut:
	texture Texture           // Material map texture
	color   Color             // Material map color
	value   f32               // Material map value
}

pub type MaterialMap = C.MaterialMap


pub fn (maps &MaterialMap) get(index int) MaterialMap {
    assert index >= 0 && index <= max_material_map_count
    return unsafe { maps[index ] }
}

// Material, includes shader and maps
@[typedef]
struct C.Material {
pub mut:
	shader Shader             // Material shader
	maps   &MaterialMap       // Material maps array (MAX_MATERIAL_MAPS)
	params [4]f32             // Material generic parameters (if required)
}

pub type Material = C.Material


@[inline]
pub fn (mut mat Material) set_shader(shader Shader) {
    mat.shader = shader
}

@[inline]
pub fn (mut mat Material) set_texture(map_ind int, texture Texture) {
    unsafe { mat.maps[map_ind].texture = texture }
}

@[inline]
pub fn Material.get_default() Material {
    return load_material_default()
}
