/*******************************************************************************************
*
*   rcamera - Basic camera system with support for multiple camera modes
*
*   CONFIGURATION:
*       #define RCAMERA_IMPLEMENTATION
*           Generates the implementation of the library into the included file.
*           If not defined, the library is in header only mode and can be included in other headers
*           or source files without problems. But only ONE file should hold the implementation.
*
*       #define RCAMERA_STANDALONE
*           If defined, the library can be used as standalone as a camera system but some
*           functions must be redefined to manage inputs accordingly.
*
*   CONTRIBUTORS:
*       Ramon Santamaria:   Supervision, review, update and maintenance
*       Christoph Wagner:   Complete redesign, using raymath (2022)
*       Marc Palau:         Initial implementation (2014)
*
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2022-2023 Christoph Wagner (@Crydsch) & Ramon Santamaria (@raysan5)
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

#include "@VMODROOT/thirdparty/raylib/src/rcamera.h"


/***********************************************************************************
*
*   CAMERA CONSTS
*
************************************************************************************/

pub const camera_cull_distance_near                      = C.CAMERA_CULL_DISTANCE_NEAR
pub const camera_cull_distance_far                       = C.CAMERA_CULL_DISTANCE_FAR

// Camera projection
pub const camera_perspective                             = C.CAMERA_PERSPECTIVE  // Perspective projection
pub const camera_orthographic                            = C.CAMERA_ORTHOGRAPHIC // Orthographic projection

// // Camera system modes
pub const camera_custom                                  = C.CAMERA_CUSTOM       // Camera custom, controlled by user (update_camera() does nothing)
pub const camera_free                                    = C.CAMERA_FREE         // Camera free mode
pub const camera_orbital                                 = C.CAMERA_ORBITAL      // Camera orbital, around target, zoom supported
pub const camera_first_person                            = C.CAMERA_FIRST_PERSON // Camera first person
pub const camera_third_person                            = C.CAMERA_THIRD_PERSON // Camera third person

pub const camera_move_speed                              = C.CAMERA_MOVE_SPEED
pub const camera_rotation_speed                          = C.CAMERA_ROTATION_SPEED
pub const camera_pan_speed                               = C.CAMERA_PAN_SPEED

// Camera mouse movement sensitivity
pub const camera_mouse_move_sensitivity                  = C.CAMERA_MOUSE_MOVE_SENSITIVITY
pub const camera_mouse_scroll_sensitivity                = C.CAMERA_MOUSE_SCROLL_SENSITIVITY

pub const camera_orbital_speed                           = C.CAMERA_ORBITAL_SPEED // Radians per second

pub const camera_first_person_step_trigonometric_divider = C.CAMERA_FIRST_PERSON_STEP_TRIGONOMETRIC_DIVIDER
pub const camera_first_person_step_divider               = C.CAMERA_FIRST_PERSON_STEP_DIVIDER
pub const camera_first_person_waving_divider             = C.CAMERA_FIRST_PERSON_WAVING_DIVIDER

// PLAYER (used by camera)
pub const player_movement_sensitivity                    = C.PLAYER_MOVEMENT_SENSITIVITY


/***********************************************************************************
*
* Module specific Functions Declaration
*
************************************************************************************/

// Camera movement
fn C.CameraMoveForward(camera &Camera, distance f32, move_in_world_plane bool)
fn C.CameraMoveUp(camera &Camera, distance f32)
fn C.CameraMoveRight(camera &Camera, distance f32, move_in_world_plane bool)
fn C.CameraMoveToTarget(camera &Camera, delta f32)

// Camera rotation
fn C.CameraYaw(camera &Camera, angle f32, rotate_around_target bool)
fn C.CameraPitch(camera &Camera, angle f32, lock_view bool, rotate_around_target bool, rotate_up bool)
fn C.CameraRoll(camera &Camera, angle f32)

fn C.GetCameraViewMatrix(camera &Camera) Matrix 
fn C.GetCameraProjectionMatrix(camera &Camera, aspect f32) Matrix

fn C.UpdateCamera(camera &Camera, mode int)
fn C.UpdateCameraPro(camera &Camera, movement Vector3, rotation Vector3, zoom f32)

fn C.GetCameraForward(camera &Camera) Vector3
fn C.GetCameraUp(camera &Camera) Vector3
fn C.GetCameraRight(camera &Camera) Vector3



//----------------------------------------------------------------------------------
// Module Functions Definition
//----------------------------------------------------------------------------------
// Returns the cameras up vector (normalized)
// Note: The up vector might not be perpendicular to the forward vector
@[inline]
pub fn get_camera_up(camera &Camera) Vector3 {
    return C.GetCameraUp(camera)
}

// Returns the cameras right vector (normalized)
@[inline]
pub fn get_camera_right(camera &Camera) Vector3 {
    return C.GetCameraRight(camera)
}

// Moves the camera in its forward direction
@[inline]
pub fn camera_move_forward(mut camera Camera, distance f32, move_in_world_plane bool) {
    C.CameraMoveForward(camera, distance, move_in_world_plane)
}

// Moves the camera in its up direction
@[inline]
pub fn camera_move_up(mut camera Camera, distance f32) {
    C.CameraMoveUp(camera, distance)
}

// Moves the camera target in its current right direction
@[inline]
pub fn camera_move_right(mut camera Camera, distance f32, move_in_world_plane bool) {
    C.CameraMoveRight(camera, distance, move_in_world_plane)
}

// Moves the camera position closer/farther to/from the camera target
@[inline]
pub fn camera_move_to_target(mut camera Camera, delta f32) {
    C.CameraMoveToTarget(camera, delta)
}

// Rotates the camera around its up vector
// Yaw is "looking left and right"
// If rotate_around_target is false, the camera rotates around its position
// Note: angle must be provided in radians
pub fn camera_yaw(mut camera Camera, angle f32, rotate_around_target bool) {
    C.CameraYaw(camera, angle, rotate_around_target)
}

// Rotates the camera around its right vector, pitch is "looking up and down"
//  - lock_view prevents camera overrotation (aka "somersaults")
//  - rotate_around_target defines if rotation is around target or around its position
//  - rotate_up rotates the up direction as well (typically only usefull in camera_free)
// NOTE: angle must be provided in radians
@[inline]
pub fn camera_pitch(mut camera Camera, angle f32, lock_view bool, rotate_around_target bool, rotate_up bool) {
    C.CameraPitch(camera, angle, lock_view, rotate_around_target, rotate_up)
}

// Rotates the camera around its forward vector
// Roll is "turning your head sideways to the left or right"
// Note: angle must be provided in radians
@[inline]
pub fn camera_roll(mut camera Camera, angle f32) {
    C.CameraRoll(camera, angle)
}

// Returns the camera view matrix
@[inline]
pub fn get_camera_view_matrix(camera &Camera) Matrix {
    return C.GetCameraViewMatrix(camera)
}

// Returns the camera projection matrix
@[inline]
pub fn get_camera_projection_matrix(camera &Camera, aspect f32) Matrix {
    return C.GetCameraProjectionMatrix(camera, aspect)
}

// Update camera movement, movement/rotation values should be provided by user
pub fn update_camera_pro(mut camera Camera, movement Vector3, rotation Vector3, zoom f32) {
    C.UpdateCameraPro(camera, movement, rotation, zoom)
}
