module raylib


// Mesh, vertex data and vao/vbo
@[typedef]
struct C.Mesh {
pub mut:
	vertexCount   int         // Number of vertices stored in arrays
	triangleCount int         // Number of triangles stored (indexed or not)

    // Vertex attributes data
	vertices      &f32        // Vertex position                   (XYZ  - 3 components per vertex) (shader -location = 0)
	texcoords     &f32        // Vertex texture coordinates        (UV   - 2 components per vertex) (shader -location = 1)
	texcoords2    &f32        // Vertex texture second coordinates (UV   - 2 components per vertex) (shader -location = 5)
	normals       &f32        // Vertex normals                    (XYZ  - 3 components per vertex) (shader -location = 2)
	tangents      &f32        // Vertex tangents                   (XYZW - 4 components per vertex) (shader -location = 4)
	colors        &u8         // Vertex colors                     (RGBA - 4 components per vertex) (shader -location = 3)
	indices       &u16        // Vertex indices (in case vertex data comes indexed)

    // Animation vertex data
	animVertices  &f32        // Animated vertex positions (after bones transformations)
	animNormals   &f32        // Animated normals (after bones transformations)
	boneIds       &u8         // Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning) (shader-location = 6)
	boneWeights   &f32        // Vertex bone weight, up to 4 bones influence by vertex (skinning) (shader-location = 7)
    boneMatrices  &Matrix     // Bones animated transformation matrices
    boneCount     int         // Number of bones

    // OpenGL identifiers
	vaoId         u32         // OpenGL Vertex Array Object id
	vboId         &u32        // OpenGL Vertex Buffer Objects id (default vertex data)2
}
pub type Mesh = C.Mesh


@[inline]
pub fn (mesh Mesh) get_vertices() []f32 {
    return ptr_arr_to_varr[f32](mesh.vertices, mesh.vertexCount*3) // float x, y, z
}

@[inline]
pub fn (mesh Mesh) get_vertices_vec3() []Vector3 {
    return ptr_arr_to_varr[Vector3](mesh.vertices, mesh.vertexCount)
}

@[inline]
pub fn (mesh Mesh) get_texcoords() []f32 {
    assert mesh.texcoords != voidptr(0)
    return ptr_arr_to_varr[f32](mesh.texcoords, mesh.vertexCount*2) // float u, v
}

@[inline]
pub fn (mesh Mesh) get_texcoords_vec2() []Vector2 {
    assert mesh.texcoords != voidptr(0)
    return ptr_arr_to_varr[Vector2](mesh.texcoords, mesh.vertexCount)
}

@[inline]
pub fn (mesh Mesh) get_texcoords2() []f32 {
    assert mesh.texcoords2 != voidptr(0)
    return ptr_arr_to_varr[f32](mesh.texcoords2, mesh.vertexCount*2) // float u, v
}

@[inline]
pub fn (mesh Mesh) get_texcoords2_vec2() []Vector2 {
    assert mesh.texcoords2 != voidptr(0)
    return ptr_arr_to_varr[Vector2](mesh.texcoords2, mesh.vertexCount)
}

@[inline]
pub fn (mesh Mesh) unload() {
	C.UnloadMesh(mesh)
}

@[inline]
pub fn (mut mesh Mesh) upload(dynamic bool) {
	C.UploadMesh(mesh, dynamic)
}

@[inline]
pub fn (mesh Mesh) update_buffer(index int, data voidptr, data_size int, offset int) {
	C.UpdateMeshBuffer(mesh, index, data, data_size, offset)
}

pub fn (mut mesh Mesh) reset() {
    unload_vertex_buffer(mesh.vboId)
    unsafe { *mesh.vboId = 0 }
    unload_vertex_array(mesh.vaoId)
    mesh.vaoId = 0
    upload_mesh(mesh, true)
}

// Draw functions.
@[inline]
pub fn (mesh Mesh) draw(material Material, transform Matrix) {
	C.DrawMesh(mesh, material, transform)
}

pub fn (mesh Mesh) draw_uv(uv_ind int, use_inds bool, draw_rec Rectangle, thick f32, color Color) {
    texcoords := if uv_ind == 0 {
        mesh.get_texcoords_vec2()
    } else if uv_ind == 1 {
        mesh.get_texcoords2_vec2()
    } else {
        panic('Texture coordinate index should be 0-1. Current ${uv_ind}')
    }
    
    xy := Vector2 { f32(draw_rec.x),     f32(draw_rec.y)      }
    wh := Vector2 { f32(draw_rec.width), f32(draw_rec.height) }

    mut index1 := int(0)
    mut index2 := int(0)
    mut index3 := int(0)

    mut uv1 := Vector2{}
    mut uv2 := Vector2{}
    mut uv3 := Vector2{}
    
    use_indices := use_inds && mesh.indices != voidptr(0)

    for i := int(0); i < mesh.vertexCount; i += 3 {
        if use_indices {
            unsafe {
                index1 = mesh.indices[i+0]
                index2 = mesh.indices[i+1]
                index3 = mesh.indices[i+2]
            }
        } else {
            index1 = i+0
            index2 = i+1
            index3 = i+2
        }
        
        uv1 = texcoords[index1]
        uv2 = texcoords[index2]
        uv3 = texcoords[index3]

        // Rectangle space.
        uv1 = Vector2.add(Vector2.multiply(uv1, wh), xy)
        uv2 = Vector2.add(Vector2.multiply(uv2, wh), xy)
        uv3 = Vector2.add(Vector2.multiply(uv3, wh), xy)

        draw_triangle_lines(uv1, uv2, uv3, color);
    }
}

@[inline]
pub fn (mesh Mesh) draw_instanced(material Material, transforms []Matrix) {
	C.DrawMeshInstanced(mesh, material, transforms.data, transforms.len)
}
// Draw functions.


@[inline]
pub fn (mesh Mesh) export(file_name string) bool {
	return C.ExportMesh(mesh, file_name.str)
}

@[inline]
pub fn (mesh Mesh) get_bounding_box() BoundingBox {
	return C.GetMeshBoundingBox(mesh)
}

@[inline]
pub fn (mesh &Mesh) gen_tangents() {
	C.GenMeshTangents(mesh)
}


// Gen Mesh functions
@[inline]
pub fn Mesh.gen_poly(sides int, radius f32) Mesh {
	return C.GenMeshPoly(sides, radius)
}

@[inline]
pub fn Mesh.gen_plane(width f32, length f32, res_x int, res_z int) Mesh {
	return C.GenMeshPlane(width, length, res_x, res_z)
}

@[inline]
pub fn Mesh.gen_cube(width f32, height f32, length f32) Mesh {
	return C.GenMeshCube(width, height, length)
}

@[inline]
pub fn Mesh.gen_sphere(radius f32, rings int, slices int) Mesh {
	return C.GenMeshSphere(radius, rings, slices)
}

@[inline]
pub fn Mesh.gen_hemi_sphere(radius f32, rings int, slices int) Mesh {
	return C.GenMeshHemiSphere(radius, rings, slices)
}

@[inline]
pub fn Mesh.gen_cylinder(radius f32, height f32, slices int) Mesh {
	return C.GenMeshCylinder(radius, height, slices)
}

@[inline]
pub fn Mesh.gen_cone(radius f32, height f32, slices int) Mesh {
	return C.GenMeshCone(radius, height, slices)
}

@[inline]
pub fn Mesh.gen_torus(radius f32, size f32, rad_seg int, sides int) Mesh {
	return C.GenMeshTorus(radius, size, rad_seg, sides)
}

@[inline]
pub fn Mesh.gen_knot(radius f32, size f32, rad_seg int, sides int) Mesh {
	return C.GenMeshKnot(radius, size, rad_seg, sides)
}

@[inline]
pub fn Mesh.gen_heightmap(heightmap Image, size Vector3) Mesh {
	return C.GenMeshHeightmap(heightmap, size)
}

@[inline]
pub fn Mesh.gen_cubicmap(cubicmap Image, cube_size Vector3) Mesh {
	return C.GenMeshCubicmap(cubicmap, cube_size)
}

// Gen Mesh functions
