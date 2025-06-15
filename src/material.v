module raylib


// Material map index
pub const material_map_albedo     = C.MATERIAL_MAP_ALBEDO         // Albedo mat (same as: MATERIAL_MAP_DIFFUSE)
pub const material_map_metalness  = C.MATERIAL_MAP_METALNESS      // Metalness mat (same as: MATERIAL_MAP_SPECULAR)
pub const material_map_normal     = C.MATERIAL_MAP_NORMAL         // Normal mat
pub const material_map_roughness  = C.MATERIAL_MAP_ROUGHNESS      // Roughness mat
pub const material_map_occlusion  = C.MATERIAL_MAP_OCCLUSION      // Ambient occlusion mat
pub const material_map_emission   = C.MATERIAL_MAP_EMISSION       // Emission mat
pub const material_map_height     = C.MATERIAL_MAP_HEIGHT         // Heightmap mat
pub const material_map_cubemap    = C.MATERIAL_MAP_CUBEMAP        // Cubemap mat (NOTE: Uses GL_TEXTURE_CUBE_MAP)
pub const material_map_irradiance = C.MATERIAL_MAP_IRRADIANCE     // Irradiance mat (NOTE: Uses GL_TEXTURE_CUBE_MAP)
pub const material_map_prefilter  = C.MATERIAL_MAP_PREFILTER      // Prefilter mat (NOTE: Uses GL_TEXTURE_CUBE_MAP)
pub const material_map_brdf       = C.MATERIAL_MAP_BRDF           // Brdf mat

pub const material_map_diffuse    = C.MATERIAL_MAP_ALBEDO
pub const material_map_specular   = C.MATERIAL_MAP_METALNESS

pub const max_material_map_count  = int(32)



pub enum MaterialMaps as int {
    albedo     = C.MATERIAL_MAP_ALBEDO         // Albedo mat (same as: MATERIAL_MAP_DIFFUSE)
    metalness  = C.MATERIAL_MAP_METALNESS      // Metalness mat (same as: MATERIAL_MAP_SPECULAR)
    normal     = C.MATERIAL_MAP_NORMAL         // Normal mat
    roughness  = C.MATERIAL_MAP_ROUGHNESS      // Roughness mat
    occlusion  = C.MATERIAL_MAP_OCCLUSION      // Ambient occlusion mat
    emission   = C.MATERIAL_MAP_EMISSION       // Emission mat
    height     = C.MATERIAL_MAP_HEIGHT         // Heightmap mat
    cubemap    = C.MATERIAL_MAP_CUBEMAP        // Cubemap mat (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    irradiance = C.MATERIAL_MAP_IRRADIANCE     // Irradiance mat (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    prefilter  = C.MATERIAL_MAP_PREFILTER      // Prefilter mat (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    brdf       = C.MATERIAL_MAP_BRDF           // Brdf mat
    
    diffuse    = C.MATERIAL_MAP_ALBEDO
    specular   = C.MATERIAL_MAP_METALNESS
}

pub fn (mm MaterialMaps) to_int() int {
    return int(mm)
}

// MaterialMap
@[typedef]
struct C.MaterialMap {
pub mut:
	texture Texture           // Material map texture
	color   Color             // Material map color
	value   f32               // Material map value
}
pub type MaterialMap = C.MaterialMap


pub fn (maps &MaterialMap) get(index int) &MaterialMap {
    assert index >= 0 && index <= max_material_map_count
    return unsafe { &maps[index] }
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



fn C.LoadMaterials(file_name &char, mat_count &int) &Material
@[inline]
pub fn load_materials(file_name string, mat_count &int) &Material {
	return C.LoadMaterials(file_name.str, mat_count)
}

fn C.LoadMaterialDefault() Material
@[inline]
pub fn load_material_default() Material {
	return C.LoadMaterialDefault()
}

fn C.UnloadMaterial(mat Material)
@[inline]
pub fn unload_material(mat Material) {
	C.UnloadMaterial(mat)
}

fn C.SetMaterialTexture(mat &Material, map_type int, texture Texture)
@[inline]
pub fn set_material_texture(mat &Material, map_type int, texture Texture) {
	C.SetMaterialTexture(mat, map_type, texture)
}

fn C.SetModelMeshMaterial(model &Model, mesh_id int, material_id int)
@[inline]
pub fn set_model_mesh_material(model &Model, mesh_id int, material_id int) {
	C.SetModelMeshMaterial(model, mesh_id, material_id)
}

// Methods.
pub fn Material.load(file_name string) []Material {
    mut mat_count := int(0)
	cmats := C.LoadMaterials(file_name.str, mat_count)
    return ptr_arr_to_varr[Material](cmats, mat_count)
}

pub fn (mats []Material) unload()  {
    for mat in mats { C.UnloadMaterial(mat) }
}

@[inline]
pub fn (mut mat Material) set_texture(map_ind int, texture Texture) {
    C.SetMaterialTexture(mat, map_ind, texture)
}

@[inline]
pub fn Material.get_default() Material {
	return C.LoadMaterialDefault()
}

@[inline]
pub fn (mat Material) unload() {
	C.UnloadMaterial(mat)
}
