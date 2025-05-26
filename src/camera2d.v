module raylib


// Camera2D, defines position/orientation in 2d space
@[typedef]
struct C.Camera2D {
pub mut:
	offset   Vector2        // Camera offset (displacement from target)
	target   Vector2        // Camera target (rotation and zoom origin)
	rotation f32            // Camera rotation in degrees
	zoom     f32            // Camera zoom (scaling), should be 1.0f by default
}

pub type Camera2D = C.Camera2D


@[inline]
pub fn (c Camera2D) get_matrix() Matrix {
	return C.GetCameraMatrix2D(c)
}
