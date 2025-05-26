module raylib


// Camera, defines position/orientation in 3d space
@[typedef]
struct C.Camera3D {
pub mut:
	position   Vector3                // Camera position
	target     Vector3                // Camera target it looks-at
	up         Vector3 = Vector3{y:1} // Camera up vector (rotation over its axis)
	fovy       f32     = 45.0         // Camera field-of-view aperture in Y (degrees) in perspective, used as near plane width in orthographic
	projection int                    // Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
}


pub type Camera3D = C.Camera3D  // Camera type fallback, defaults to Camera3D
pub type Camera   = C.Camera3D


// Returns the cameras forward vector (normalized)
@[inline]
pub fn (c &Camera) get_forward() Vector3 {
    return C.GetCameraForward(c)
}

@[inline]
pub fn (c Camera) get_matrix() Matrix {
    return C.GetCameraMatrix(c)
}

@[inline]
fn (mut camera Camera) move_forward(distance f32, move_in_world_plane bool) {
    C.CameraMoveForward(camera, distance, move_in_world_plane)
}

@[inline]
pub fn (mut camera Camera) move_up(distance f32) {
    C.CameraMoveUp(camera, distance)
}

// Moves the camera target in its current right direction
@[inline]
pub fn (mut camera Camera) move_right(distance f32, move_in_world_plane bool) {
    C.CameraMoveRight(camera, distance, move_in_world_plane)
}

// Moves the camera position closer/farther to/from the camera target
@[inline]
pub fn (mut camera Camera) move_to_target(delta f32) {
    C.CameraMoveToTarget(camera, delta)
}

@[inline]
pub fn (mut camera Camera) yaw(angle f32, rotate_around_target bool) {
    C.CameraYaw(camera, angle, rotate_around_target)
}

@[inline]
pub fn (mut camera Camera) pitch(angle f32, lock_view bool, rotate_around_target bool, rotate_up bool) {
    C.CameraPitch(camera, angle, lock_view, rotate_around_target, rotate_up)
}

@[inline] pub fn (mut camera Camera) roll(angle f32) {
    C.CameraRoll(camera, angle)
}

pub fn (camera &Camera) get_view_matrix() Matrix {
    return C.GetCameraViewMatrix(camera)
}

// Returns the camera projection matrix
@[inline]
pub fn (camera &Camera) get_projection_matrix(aspect f32) Matrix {
    return C.GetCameraProjectionMatrix(camera, aspect)
}

@[inline]
pub fn (mut camera Camera) update(mode int) {
    C.UpdateCamera(camera, mode)
}

@[inline]
pub fn (mut camera Camera) update_pro(movement Vector3, rotation Vector3, zoom f32) {
    C.UpdateCameraPro(camera, movement, rotation, zoom)
}
