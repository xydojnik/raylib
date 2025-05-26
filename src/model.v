module raylib


// Bone, skeletal animation bone
@[typedef]
struct C.BoneInfo {
pub mut:
	name   [32]char           // Bone name
	parent int                // Bone parent
}
pub type BoneInfo = C.BoneInfo

@[inline]
pub fn (bi BoneInfo) get_name() string {
    return unsafe { (&bi.name[0]).vstring() }
}

// Model, meshes, materials and animation data
@[typedef]
struct C.Model {
pub mut:
	transform     Matrix      // Local transform matrix

	meshCount     int         // Number of meshes
	materialCount int         // Number of materials
	meshes        &Mesh       // Meshes array
	materials     &Material   // Materials array
	meshMaterial  &int        // Mesh material number   

    // Animation data
	boneCount     int         // Number of bones
	bones         &BoneInfo   // Bones information (skeleton)
	bindPose      &Transform  // Bones base transformation (pose)
}
pub type Model = C.Model

@[inline]
pub fn (m Model) get_materials() []Material {
    return ptr_arr_to_varr[Material] (m.materials, m.materialCount)
}

@[inline]
pub fn (m Model) get_meshes() []Mesh {
    return ptr_arr_to_varr[Mesh] (m.meshes, m.meshCount)
}

@[inline]
pub fn Model.load(file_name string) Model {
	return C.LoadModel(file_name.str)
}

@[inline]
pub fn (model Model) is_valid() bool {
	return model.meshCount > 0
}

@[inline]
pub fn (m Model) update(anim ModelAnimation, frame int) {
	C.UpdateModelAnimation(m, anim, frame)
}

@[inline]
pub fn (m Model) is_animation_valid(anim ModelAnimation) bool {
	return C.IsModelAnimationValid(m, anim)
}

@[inline]
pub fn Model.load_from_mesh(mesh Mesh) Model {
	return C.LoadModelFromMesh(mesh)
}

@[inline]
pub fn (m Model) unload() {
	C.UnloadModel(m)
}

pub fn (mut m Model) set_texture(mat_index int, map_id int, texture Texture) {
    assert mat_index >= 0 && mat_index < m.materialCount
    unsafe { m.materials[mat_index].maps[map_id].texture = texture }
}

pub fn (mut m Model) set_value(mat_index int, map_id int, value f32) {
    assert mat_index >= 0 && mat_index < m.materialCount
    unsafe { m.materials[mat_index].maps[map_id].value = value }
}

pub fn (mut m Model) set_color(mat_index int, map_id int, color Color) {
    assert mat_index >= 0 && mat_index < m.materialCount
    unsafe { m.materials[mat_index].maps[map_id].color = color }
}

pub fn (mut m Model) set_shader(mat_index int, shader Shader) {
    assert mat_index >= 0 &&  mat_index < m.materialCount
    unsafe { m.materials[mat_index].shader = shader }
}

pub fn (m Model) get_mesh(mesh_index int) Mesh {
    assert mesh_index >= 0 && mesh_index < m.meshCount
    return unsafe { m.meshes[mesh_index] }
}


@[inline]
pub fn (m Model) get_bounding_box() BoundingBox {
	return C.GetModelBoundingBox(m)
}


// Draw Model functions
@[inline]
pub fn (m Model) draw(position Vector3, scale f32, tint Color) {
	C.DrawModel(m, position, scale, tint)
}

@[inline]
pub fn (m Model) draw_ex(position Vector3, rotation_axis Vector3, rotation_angle f32, scale Vector3, tint Color) {
	C.DrawModelEx(m, position, rotation_axis, rotation_angle, scale, tint)
}

@[inline]
pub fn (m Model) draw_wires(position Vector3, scale f32, tint Color) {
	C.DrawModelWires(m, position, scale, tint)
}

@[inline]
pub fn (m Model) draw_wires_ex(position Vector3, rotation_axis Vector3, rotation_angle f32, scale Vector3, tint Color) {
	C.DrawModelWiresEx(m, position, rotation_axis, rotation_angle, scale, tint)
}

pub fn (model Model) draw_uv(mesh_ind int, uv_ind int, use_indices_if_exist bool, draw_rec Rectangle, thick f32, color Color) {
    assert mesh_ind >= 0 && mesh_ind < model.meshCount
    mesh := unsafe { model.meshes[mesh_ind] }
    mesh.draw_uv(uv_ind, use_indices_if_exist, draw_rec, thick, color)
}

// ModelAnimation
@[typedef]
struct C.ModelAnimation {
pub mut:
	boneCount  int            // Number of bones
	frameCount int            // Number of animation frames
	bones      &BoneInfo      // Bones information (skeleton)
	framePoses &&Transform    // Poses array by frame
    name       [32]char       // Animation name
}
pub type ModelAnimation = C.ModelAnimation

@[inline]
pub fn (ma ModelAnimation) get_bones() []BoneInfo {
    return ptr_arr_to_varr[BoneInfo](ma.bones, ma.boneCount)
}

@[inline]
pub fn (ma ModelAnimation) get_name() string {
    return unsafe { (&ma.name[0]).vstring() }
}

// For test
pub fn ModelAnimation.load(file_name string) []ModelAnimation {
    anim_count := u32(0)
    cma := C.LoadModelAnimations(file_name.str, &anim_count)
    return ptr_arr_to_varr[ModelAnimation] (cma, int(anim_count))
}

@[inline]
pub fn ModelAnimation.c_load(file_name string) (&ModelAnimation, u32) {
    anim_count := u32(0)
    cma := C.LoadModelAnimations(file_name.str, &anim_count)
    return cma, anim_count
}

@[inline]
pub fn (anim ModelAnimation) unload() {
	C.UnloadModelAnimation(anim)
}

// pub fn (anim ModelAnimation) foreach(for_each fn(int)) {
//     for frame in 0..anim.frameCount { for_each(frame) }
// }

@[inline]
pub fn (anim ModelAnimation) update(model Model, frame int) {
	C.UpdateModelAnimation(model, anim, frame)
}

@[inline]
pub fn (ma_arr []ModelAnimation) unload() {
	C.UnloadModelAnimations(ma_arr.data, ma_arr.len)
}

// pub fn (ma_arr []ModelAnimation) foreach(for_each fn(int, ModelAnimation)) {
    // for i, anim in ma_arr { for_each(i, anim) }
// }

// ModelAnimation
