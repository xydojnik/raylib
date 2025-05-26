/**********************************************************************************************
*
*   raymath v1.5 - Math functions to work with Vector2, Vector3, Matrix and Quaternions
*
*   CONVENTIONS:
*     - Matrix structure is defined as row-major (memory layout) but parameters naming AND all
*       math operations performed by the library consider the structure as it was column-major
*       It is like transposed versions of the matrices are used for all the maths
*       It benefits some functions making them cache-friendly and also avoids matrix
*       transpositions sometimes required by OpenGL
*       Example: In memory order, row0 is [m0 m4 m8 m12] but in semantic math row0 is [m0 m1 m2 m3]
*     - Functions are always self-contained, no function use another raymath function inside,
*       required code is directly re-implemented inside
*     - Functions input parameters are always received by value (2 unavoidable exceptions)
*     - Functions use always a "result" variable for return
*     - Functions are always defined inline
*     - Angles are always in radians (DEG2RAD/RAD2DEG macros provided for convenience)
*     - No compound literals used to make sure libray is compatible with C++
*
*   CONFIGURATION:
*       #define RAYMATH_IMPLEMENTATION
*           Generates the implementation of the library into the included file.
*           If not defined, the library is in header only mode and can be included in other headers
*           or source files without problems. But only ONE file should hold the implementation.
*
*       #define RAYMATH_STATIC_INLINE
*           Define static inline functions code, so #include header suffices for use.
*           This may use up lots of memory.
*
*
*   LICENSE: zlib/libpng
*
*   Copyright           (c) 2015-2023 Ramon Santamaria  (@raysan5)
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

import rand

#include <math.h>
#include "@VMODROOT/thirdparty/raylib/src/raymath.h"


//----------------------------------------------------------------------------------
// Constants Definition
//----------------------------------------------------------------------------------
pub const pi      = C.PI      // 3.14159265358979323846
pub const epsilon = C.EPSILON // 0.000001

pub const to_rad = pi/f32(180.0)
pub const to_deg = f32(180.0)/pi
//----------------------------------------------------------------------------------
// Pub Structures Definition
//----------------------------------------------------------------------------------

// Vector2, 2 components
@[typedef; params]
pub struct C.Vector2 {
pub mut:
	x f32       // Vector x component
	y f32       // Vector y component
}
pub type Vector2 = C.Vector2

// Vector3, 3 components
@[typedef; params]
pub struct C.Vector3 {
pub mut:
	x f32       // Vector x component
	y f32       // Vector y component
	z f32       // Vector z component
}
pub type Vector3 = C.Vector3

// Vector4, 4 components
@[typedef; params]
pub struct C.Vector4 {
pub mut:
	x f32       // Vector x component
	y f32       // Vector y component
	z f32       // Vector z component
	w f32       // Vector w component
}
pub type Vector4    = C.Vector4
pub type Quaternion = C.Vector4
                                                    
// Matrix, 4x4 components, column major, OpenGL style, right-handed
@[typedef]
pub struct C.Matrix {
pub mut:
	m0  f32 m4  f32 m8  f32 m12 f32     // Matrix first row (4 components)
	m1  f32 m5  f32 m9  f32 m13 f32     // Matrix second row (4 components)
	m2  f32 m6  f32 m10 f32 m14 f32     // Matrix third row (4 components)
	m3  f32 m7  f32 m11 f32 m15 f32     // Matrix fourth row (4 components)
}
pub type Matrix = C.Matrix



fn C.ceilf(f32) f32
fn C.fmodf(f32, f32) f32
fn C.tan(f32) f32
fn C.atan2f(f32, f32) f32
fn C.sqrtf(f32) f32
fn C.sinf(f32) f32
fn C.asinf(f32) f32
fn C.acosf(f32) f32
fn C.cosf(f32) f32
fn C.fabsf(f32) f32
fn C.fminf(f32, f32) f32
fn C.fmaxf(f32, f32) f32
fn C.powf(f32, f32) f32

// Clamp float value
fn C.Clamp(f32, f32, f32) f32
// Calculate linear interpolation between two floats
fn C.Lerp(f32, f32, f32) f32
// Normalize input value within input range
fn C.Normalize(f32, f32, f32) f32
// Remap input value within input range to output range
fn C.Remap(f32, f32, f32, f32, f32) f32
// Wrap input value from min to max
fn C.Wrap(f32, f32, f32) f32
// Check whether two given floats are almost equal
fn C.FloatEquals(f32, f32) bool

//----------------------------------------------------------------------------------
// Module Functions Definition -c.Vector2 math
//----------------------------------------------------------------------------------
// Vector with components value 0.0f, same asc.Vector2{
// Add two vectors (v1 + v2)
fn C.Vector2Add(Vector2, Vector2) Vector2
    
// Add vector and float value
fn C.Vector2AddValue(Vector2, f32) Vector2
    
// Subtract two vectors (v1 - v2)
fn C.Vector2Subtract(Vector2, Vector2) Vector2
    
// Subtract vector by float value
fn C.Vector2SubtractValue(Vector2, f32) Vector2
    
// Calculate vector length
fn C.Vector2Length(Vector2) f32
    
// Calculate vector square length
fn C.Vector2LengthSqr(Vector2) f32
    
// Calculate two vectors dot product
fn C.Vector2DotProduct(Vector2, Vector2) f32
    
// Calculate distance between two vectors
fn C.Vector2Distance(Vector2, Vector2) f32
    
// Calculate square distance between two vectors
fn C.Vector2DistanceSqr(Vector2, Vector2) f32
    
// Calculate angle between two vectors
// NOTE: Angle is calculated from origin point (0, 0)
fn C.Vector2Angle(Vector2, Vector2) f32
    
// Calculate angle defined by a two vectors line
// NOTE: Parameters need to be normalized
// Current implementation should be aligned with glm::angle
fn C.Vector2LineAngle(Vector2, Vector2) f32 // TODO(10/9/2023): Currently angles move clockwise, determine if this is wanted behavior
    
// Scale vector (multiply by value)
fn C.Vector2Scale(Vector2, f32) Vector2
    
// Multiply vector by vector
fn C.Vector2Multiply(Vector2, Vector2) Vector2
    
// Negate vector
fn C.Vector2Negate(Vector2) Vector2
    
// Divide vector by vector
fn C.Vector2Divide(Vector2, Vector2) Vector2
    
// Normalize provided vector
fn C.Vector2Normalize(Vector2) Vector2
    
// Transforms a Vector2 by a given  Matrix
fn C.Vector2Transform(Vector2,  Matrix) Vector2
    
// Calculate linear interpolation between two vectors
fn C.Vector2Lerp(Vector2, Vector2, f32) Vector2
    
// Calculate reflected vector to normal
fn C.Vector2Reflect(Vector2, Vector2) Vector2
    
// Rotate vector by angle
fn C.Vector2Rotate(Vector2, f32) Vector2
    
// Move Vector towards target
fn C.Vector2MoveTowards(Vector2, Vector2, f32) Vector2
    
// Invert the given vector
fn C.Vector2Invert(Vector2) Vector2
    
// Clamp the components of the vector between
// min and max values specified by the given vectors
fn C.Vector2Clamp(Vector2, Vector2, Vector2) Vector2
    
// Clamp the magnitude of the vector between two min and max values
fn C.Vector2ClampValue(Vector2, f32, f32) Vector2
    
// Check whether two given vectors are almost equal
fn C.Vector2Equals(Vector2, Vector2) bool
 
//----------------------------------------------------------------------------------
// Module Functions Definition -  Vector3 math
//----------------------------------------------------------------------------------
// Vector with components value 0.0f
// Add two vectors
fn C.Vector3Add(Vector3, Vector3) Vector3
  
// Add vector and float value
fn C.Vector3AddValue(Vector3, f32) Vector3
  
// Subtract two vectors
fn C.Vector3Subtract(Vector3, Vector3) Vector3
  
// Subtract vector by float value
fn C.Vector3SubtractValue(Vector3, f32) Vector3
  
// Multiply vector by scalar
fn C.Vector3Scale(Vector3, f32) Vector3
  
// Multiply vector by vector
fn C.Vector3Multiply(Vector3, Vector3) Vector3
 
// Divide vector by vector
fn C.Vector3Divide(Vector3, Vector3) Vector3
  
// Calculate two vectors cross product
fn C.Vector3CrossProduct(Vector3, Vector3) Vector3
 
// Calculate one vector perpendicular vector
fn C.Vector3Perpendicular(Vector3) Vector3
 
// Calculate vector length
fn C.Vector3Length(Vector3) f32
 
// Calculate vector square length
fn C.Vector3LengthSqr(Vector3) f32
 
// Calculate two vectors dot product
fn C.Vector3DotProduct(Vector3, Vector3) f32
 
// Calculate distance between two vectors
fn C.Vector3Distance(Vector3, Vector3) f32
 
 
// Calculate square distance between two vectors
fn C.Vector3DistanceSqr(Vector3, Vector3) f32
 
// Calculate angle between two vectors
fn C.Vector3Angle(Vector3, Vector3) f32
 
// Negate provided vector (invert direction)
fn C.Vector3Negate(Vector3) Vector3
 
// Normalize provided vector
fn C.Vector3Normalize(Vector3) Vector3
    
//Calculate the projection of the vector v1 on to v2
fn C.Vector3Project(Vector3, Vector3) Vector3
    
//Calculate the rejection of the vector v1 on to v2
fn C.Vector3Reject(Vector3, Vector3) Vector3
    
// Orthonormalize provided vectors
// Makes vectors normalized and orthogonal to each other
// Gram-Schmidt function implementation
fn C.Vector3OrthoNormalize(mut Vector3, mut Vector3)

// Transforms a  Vector3 by a given  Matrix
fn C.Vector3Transform(Vector3, Matrix)  Vector3
    
// Transform a vector by quaternion rotation
fn C.Vector3RotateByQuaternion(Vector3, Quaternion) Vector3
    
// Rotates a vector around an axis
fn C.Vector3RotateByAxisAngle(Vector3, Vector3, f32) Vector3
    
// Move Vector towards target
fn C.Vector3MoveTowards(Vector3, Vector3, f32) Vector3
    
// Calculate linear interpolation between two vectors
fn C.Vector3Lerp(Vector3, Vector3, f32) Vector3
    
// Calculate reflected vector to normal
fn C.Vector3Reflect(Vector3, Vector3) Vector3
    
// Get min value for each pair of components
fn C.Vector3Min(Vector3, Vector3) Vector3
    
// Get max value for each pair of components
fn C.Vector3Max(Vector3, Vector3) Vector3
    
// Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
// NOTE: Assumes P is on the plane of the triangle
fn C.Vector3Barycenter(Vector3, Vector3, Vector3, Vector3) Vector3
    
// Projects a  Vector3 from screen space into object space
// NOTE: We are avoiding calling other raymath functions despite available
fn C.Vector3Unproject(Vector3, Matrix, Matrix) Vector3
    
// Invert the given vector
fn C.Vector3Invert(Vector3) Vector3
    
// Clamp the components of the vector between
// min and max values specified by the given vectors
fn C.Vector3Clamp(Vector3, Vector3, Vector3) Vector3
    
// Clamp the magnitude of the vector between two values
fn C.Vector3ClampValue(Vector3, f32, f32)  Vector3
    
// Check whether two given vectors are almost equal
fn C.Vector3Equals(Vector3, Vector3) bool
    
// Compute the direction of a refracted ray
// v: normalized direction of the incoming ray
// n: normalized normal vector of the interface of two optical media
// r: ratio of the refractive index of the medium from where the ray comes
//    to the refractive index of the medium on the other side of the surface
fn C.Vector3Refract(Vector3, Vector3, f32) Vector3

// Get Vector3 as float array
fn C.Vector3ToFloatV(v Vector3) Vector3 


//----------------------------------------------------------------------------------
// Module Functions Definition -  Vector4 math
//----------------------------------------------------------------------------------
// Vector with components value 0.0f
// Add two vectors
fn C.Vector4Add(Vector4, Vector4) Vector4
  
// Add vector and float value
fn C.Vector4AddValue(Vector4, f32) Vector4
  
// Subtract two vectors
fn C.Vector4Subtract(Vector4, Vector4) Vector4
  
// Subtract vector by float value
fn C.Vector4SubtractValue(Vector4, f32) Vector4
  
// Multiply vector by scalar
fn C.Vector4Scale(Vector4, f32) Vector4
  
// Multiply vector by vector
fn C.Vector4Multiply(Vector4, Vector4) Vector4
 
// Divide vector by vector
fn C.Vector4Divide(Vector4, Vector4) Vector4
  
// Calculate two vectors cross product
fn C.Vector4CrossProduct(Vector4, Vector4) Vector4
 
// Calculate one vector perpendicular vector
fn C.Vector4Perpendicular(Vector4) Vector4
 
// Calculate vector length
fn C.Vector4Length(Vector4) f32
 
// Calculate vector square length
fn C.Vector4LengthSqr(Vector4) f32
 
// Calculate two vectors dot product
fn C.Vector4DotProduct(Vector4, Vector4) f32
 
// Calculate distance between two vectors
fn C.Vector4Distance(Vector4, Vector4) f32
 
 
// Calculate square distance between two vectors
fn C.Vector4DistanceSqr(Vector4, Vector4) f32
 
// Calculate angle between two vectors
fn C.Vector4Angle(Vector4, Vector4) f32
 
// Negate provided vector (invert direction)
fn C.Vector4Negate(Vector4) Vector4
 
// Normalize provided vector
fn C.Vector4Normalize(Vector4) Vector4
    
//Calculate the projection of the vector v1 on to v2
fn C.Vector4Project(Vector4, Vector4) Vector4
    
//Calculate the rejection of the vector v1 on to v2
fn C.Vector4Reject(Vector4, Vector4) Vector4
    
// Orthonormalize provided vectors
// Makes vectors normalized and orthogonal to each other
// Gram-Schmidt function implementation
fn C.Vector4OrthoNormalize(mut Vector4, mut Vector4)

// Transforms a  Vector4 by a given  Matrix
fn C.Vector4Transform(Vector4, Matrix)  Vector4
    
// Transform a vector by quaternion rotation
fn C.Vector4RotateByQuaternion(Vector4, Quaternion) Vector4
    
// Rotates a vector around an axis
fn C.Vector4RotateByAxisAngle(Vector4, Vector4, f32) Vector4
    
// Move Vector towards target
fn C.Vector4MoveTowards(Vector4, Vector4, f32) Vector4
    
// Calculate linear interpolation between two vectors
fn C.Vector4Lerp(Vector4, Vector4, f32) Vector4
    
// Calculate reflected vector to normal
fn C.Vector4Reflect(Vector4, Vector4) Vector4
    
// Get min value for each pair of components
fn C.Vector4Min(Vector4, Vector4) Vector4
    
// Get max value for each pair of components
fn C.Vector4Max(Vector4, Vector4) Vector4
    
// Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
// NOTE: Assumes P is on the plane of the triangle
fn C.Vector4Barycenter(Vector4, Vector4, Vector4, Vector4) Vector4
    
// Projects a  Vector4 from screen space into object space
// NOTE: We are avoiding calling other raymath functions despite available
fn C.Vector4Unproject(Vector4, Matrix, Matrix) Vector4
    
// Invert the given vector
fn C.Vector4Invert(Vector4) Vector4
    
// Clamp the components of the vector between
// min and max values specified by the given vectors
fn C.Vector4Clamp(Vector4, Vector4, Vector4) Vector4
    
// Clamp the magnitude of the vector between two values
fn C.Vector4ClampValue(Vector4, f32, f32)  Vector4
    
// Check whether two given vectors are almost equal
fn C.Vector4Equals(Vector4, Vector4) bool
    
// Compute the direction of a refracted ray
// v: normalized direction of the incoming ray
// n: normalized normal vector of the interface of two optical media
// r: ratio of the refractive index of the medium from where the ray comes
//    to the refractive index of the medium on the other side of the surface
fn C.Vector4Refract(Vector4, Vector4, f32) Vector4

// Get Vector4 as float array
fn C.Vector4ToFloatV(v Vector4) Vector4 


//----------------------------------------------------------------------------------
// Module Functions Definition -  Matrix math
//----------------------------------------------------------------------------------
// Compute matrix determinant
fn C.MatrixDeterminant(Matrix) f32
  
// Get the trace of the matrix (sum of the values along the diagonal)
fn C.MatrixTrace(Matrix) f32
  
// Transposes provided matrix
fn C.MatrixTranspose(Matrix) Matrix
  
// Invert provided matrix
fn C.MatrixInvert(Matrix) Matrix
  
// Get identity matrix
fn C.MatrixIdentity() Matrix
  
// Add two matrices
fn C.MatrixAdd(Matrix, Matrix) Matrix
  
// Subtract two matrices (left - right)
fn C.MatrixSubtract(Matrix, Matrix) Matrix
  
// Get two matrix multiplication
// NOTE: When multiplying matrices... the order matters!
fn C.MatrixMultiply(Matrix, Matrix) Matrix
  
// Get translation matrix
fn C.MatrixTranslate(f32, f32, f32) Matrix
  
// Create rotation matrix from axis and angle
// NOTE: Angle should be provided in radians
fn C.MatrixRotate(Vector3, f32) Matrix
  
// Get x-rotation matrix
// NOTE: Angle must be provided in radians
fn C.MatrixRotateX(f32) Matrix
  
// Get y-rotation matrix
// NOTE: Angle must be provided in radians
fn C.MatrixRotateY(f32) Matrix
  
// Get z-rotation matrix
// NOTE: Angle must be provided in radians
fn C.MatrixRotateZ(f32) Matrix
  
// Get xyz-rotation matrix
// NOTE: Angle must be provided in radians
fn C.MatrixRotateXYZ(Vector3) Matrix
  
// Get zyx-rotation matrix
// NOTE: Angle must be provided in radians
fn C.MatrixRotateZYX(Vector3) Matrix
  
// Get scaling matrix
fn C.MatrixScale(f32, f32, f32) Matrix
  
// Get perspective projection matrix
fn C.MatrixFrustum(f64, f64, f64, f64, f64, f64) Matrix
  
// Get perspective projection matrix
// NOTE: Fovy angle must be provided in radians
fn C.MatrixPerspective(f64, f64, f64, f64) Matrix
  
// Get orthographic projection matrix
fn C.MatrixOrtho(f64, f64, f64, f64, f64, f64) Matrix
  
// Get camera look-at matrix (view matrix)
fn C.MatrixLookAt( Vector3, Vector3, Vector3) Matrix

// Get float array of matrix data
// fn C.MatrixToFloatV(mat Matrix) [16]f32 
//----------------------------------------------------------------------------------
// Module Functions Definition - Quaternion math
//----------------------------------------------------------------------------------
// Add two quaternions
fn C.QuaternionAdd(Quaternion, Quaternion) Quaternion
    
// Add quaternion and float value
fn C.QuaternionAddValue(Quaternion, f32) Quaternion
    
// Subtract two quaternions
fn C.QuaternionSubtract(Quaternion, Quaternion) Quaternion
    
// Subtract quaternion and float value
fn C.QuaternionSubtractValue(Quaternion, f32) Quaternion
    
// Get identity quaternion
fn C.QuaternionIdentity() Quaternion
    
// Computes the length of a quaternion
fn C.QuaternionLength(Quaternion) f32
    
// Normalize provided quaternion
fn C.QuaternionNormalize(Quaternion) Quaternion
    
// Invert provided quaternion
fn C.QuaternionInvert(Quaternion) Quaternion
    
// Calculate two quaternion multiplication
fn C.QuaternionMultiply(Quaternion, Quaternion) Quaternion
    
// Scale quaternion by float value
fn C.QuaternionScale(Quaternion, f32) Quaternion
    
// Divide two quaternions
fn C.QuaternionDivide(Quaternion, Quaternion) Quaternion
    
// Calculate linear interpolation between two quaternions
fn C.QuaternionLerp(Quaternion, Quaternion, f32) Quaternion
    
// Calculate slerp-optimized interpolation between two quaternions
fn C.QuaternionNLerp(Quaternion, Quaternion, f32) Quaternion
    
// Calculates spherical linear interpolation between two quaternions
fn C.QuaternionSLerp(Quaternion, Quaternion, f32) Quaternion
    
// Calculate quaternion based on the rotation from one vector to another
fn C.QuaternionFromVector3ToVector3(Vector3,  Vector3) Quaternion
    
// Get a quaternion for a given rotation matrix
fn C.QuaternionFromMatrix(Matrix) Quaternion
 
// Get a matrix for a given quaternion
fn C.QuaternionToMatrix(Quaternion) Matrix
 
// Get rotation quaternion for an angle and axis
// NOTE: Angle must be provided in radians
fn C.QuaternionFromAxisAngle(Vector3, f32) Quaternion
 
// Get the rotation angle and axis for a given quaternion
fn C.QuaternionToAxisAngle(Quaternion, &Vector3, &f32)
// Get the quaternion equivalent to Euler angles
// NOTE: Rotation order is ZYX
fn C.QuaternionFromEuler(f32, f32, f32) Quaternion
 
// Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
// NOTE: Angles are returned in a Vector3 pub struct in radians
fn C.QuaternionToEuler(Quaternion) Vector3
 
// Transform a quaternion given a transformation matrix
fn C.QuaternionTransform(Quaternion, Matrix) Quaternion
 
// Check whether two given quaternions are almost equal
fn C.QuaternionEquals(Quaternion, Quaternion) bool




// //----------------------------------------------------------------------------------
// // Module Functions - Utils math
// //----------------------------------------------------------------------------------
@[inline] pub fn ceilf(v f32) f32             { return C.ceilf(v)          }
@[inline] pub fn randf() f32                  { return rand.f32()          }
@[inline] pub fn randnf(v f32) f32            { return rand.f32n(v)or{0.0} }
@[inline] pub fn fmodf(v1 f32, v2 f32) f32    { return C.fmodf(v1, v2)     }
@[inline] pub fn deg2rad(degrees f32) f32     { return degrees*to_rad     }
@[inline] pub fn rad2deg(radians f32) f32     { return radians*to_deg     }
@[inline] pub fn tan(value f32) f32           { return C.tan(value)       }
@[inline] pub fn atan2f(det f32, dot f32) f32 { return C.atan2f(det, dot) }
@[inline] pub fn sqrtf(value f32) f32         { return C.sqrtf(value)     }
@[inline] pub fn sinf(value f32) f32          { return C.sinf(value)      }
@[inline] pub fn asinf(value f32) f32         { return C.asinf(value)     }
@[inline] pub fn acosf(value f32) f32         { return C.acosf(value)     }
@[inline] pub fn cosf(value f32) f32          { return C.cosf(value)      }
@[inline] pub fn fabsf(value f32) f32         { return C.fabsf(value)     }
@[inline] pub fn fminf(v1 f32, v2 f32) f32    { return C.fminf(v1, v2)    }
@[inline] pub fn fmaxf(v1 f32, v2 f32) f32    { return C.fmaxf(v1, v2)    }
@[inline] pub fn powf(v1 f32, v2 f32) f32     { return C.powf(v1, v2)     }

// Clamp float value
@[inline] pub fn clamp(value f32, min f32, max f32) f32 { return C.Clamp(value, min, max) }
// Calculate linear interpolation between two floats
@[inline] pub fn lerp(start f32, end f32, amount f32) f32 { return C.Lerp(start, end, amount) }
// Normalize input value within input range
@[inline] pub fn normalize(value f32, start f32, end f32) f32 { return C.Normalize(value, start, end) }
// Remap input value within input range to output range
@[inline]
pub fn remap(value f32, input_start f32, input_end f32, output_start f32, output_end f32) f32 {
    return C.Remap(value, input_start, input_end, output_start, output_end)
}
// Wrap input value from min to max
@[inline] pub fn wrap(value f32, min f32, max f32) f32 { return C.Wrap(value, min, max) }
// Check whether two given floats are almost equal
@[inline] pub fn float_equals(x f32, y f32) bool { return C.FloatEquals(x, y) }


//----------------------------------------------------------------------------------
// Module Functions - Vector2 math
//----------------------------------------------------------------------------------
// Vector with components value 0.0f, same as c.Vector2{}
// Add two vectors (v1 + v2)
@[inline]
pub fn Vector2.add(v1 Vector2, v2 Vector2) Vector2 {
    return C.Vector2Add(v1, v2)
}
// Add vector and float value
@[inline]
pub fn Vector2.add_value(v1 Vector2, value f32) Vector2 {
    return C.Vector2AddValue(v1, value)
}
// Subtract two vectors (v1 - v2)
@[inline]
pub fn Vector2.subtract(v1 Vector2, v2 Vector2) Vector2 {
    return C.Vector2Subtract(v1, v2)
}
// Subtract vector by float value
@[inline]
pub fn Vector2.sub_value(v1 Vector2, value f32) Vector2 {
    return C.Vector2SubtractValue(v1, value)
}
// Calculate vector length
@[inline]
pub fn Vector2.length(vec Vector2) f32 {
    return C.Vector2Length(vec)
}
// Calculate vector square length
@[inline]
pub fn Vector2.length_sqrt(vec Vector2) f32 {
    return C.Vector2LengthSqr(vec)
}
// Calculate two vectors dot product
@[inline]
pub fn Vector2.dot(v1 Vector2, v2 Vector2) f32 {
    return C.Vector2DotProduct(v1, v2)
}
// Calculate distance between two vectors
@[inline]
pub fn Vector2.distance(v1 Vector2, v2 Vector2) f32 {
    return C.Vector2Distance(v1, v2)
}
// Calculate square distance between two vectors
@[inline]
pub fn Vector2.distance_sqr(v1 Vector2, v2 Vector2) f32 {
    return C.Vector2DistanceSqr(v1, v2)
}
// Calculate angle between two vectors
// NOTE: Angle is calculated from origin point (0, 0)
@[inline]
pub fn Vector2.angle(v1 Vector2, v2 Vector2) f32 {
    return C.Vector2Angle(v1, v2)
}
// Calculate angle defined by a two vectors line
// NOTE: Parameters need to be normalized
// Current implementation should be aligned with glm::angle
@[inline]
pub fn Vector2.line_angle(start Vector2, end Vector2) f32 {
    // TODO(10/9/2023): Currently angles move clockwise, determine if this is wanted behavior
    return C.Vector2LineAngle(start, end)
}
// Scale vector (multiply by value)
@[inline]
pub fn Vector2.scale(vec Vector2, scale f32) Vector2 {
    return C.Vector2Scale(vec, scale)
}
// Multiply vector by vector
@[inline]
pub fn Vector2.multiply(v1 Vector2, v2 Vector2) Vector2 {
    return C.Vector2Multiply(v1, v2)
}
// Negate vector
@[inline]
pub fn Vector2.negative(v Vector2) Vector2 {
    return C.Vector2Negate(v)
}
// Divide vector by vector
@[inline]
pub fn Vector2.divide(v1 Vector2, v2 Vector2) Vector2 {
    return C.Vector2Divide(v1, v2)
}
// Normalize provided vector
@[inline]
pub fn Vector2.normalize(v Vector2) Vector2 {
    return C.Vector2Normalize(v)
}
// Transforms a Vector2 by a given Matrix
@[inline]
pub fn Vector2.transform(v Vector2, mat Matrix) Vector2 {
    return C.Vector2Transform(v, mat)
}
// Calculate linear interpolation between two vectors
@[inline]
pub fn Vector2.lerp(v1 Vector2, v2 Vector2, amount f32) Vector2 {
    return C.Vector2Lerp(v1, v2, amount)
}
// Calculate reflected vector to normal
pub fn Vector2.reflect(v Vector2, normal Vector2) Vector2 {
    return C.Vector2Reflect(v, normal)
}
// Rotate vector by angle
@[inline]
pub fn Vector2.rotate(v Vector2, angle f32) Vector2 {
    return C.Vector2Rotate(v, angle)
}
// Move Vector towards target
pub fn Vector2.move_towards(v Vector2, target Vector2, max_distance f32) Vector2 {
    return C.Vector2MoveTowards(v, target, max_distance)
}
// Invert the given vector
@[inline]
pub fn Vector2.invert(vec Vector2) Vector2 {
    return C.Vector2Invert(vec)
}
// Clamp the components of the vector between
// min and max values specified by the given vectors
@[inline]
pub fn Vector2.clamp(v Vector2, min Vector2, max Vector2) Vector2 {
    return C.Vector2Clamp(v, min, max)
}
// Clamp the magnitude of the vector between two min and max values
@[inline]
pub fn Vector2.clamp_value(v Vector2, min f32, max f32) Vector2 {
    return C.Vector2ClampValue(v, min, max)
}
// Check whether two given vectors are almost equal
@[inline]
pub fn Vector2.equals(a Vector2, b Vector2) bool {
    return C.Vector2Equals(a, b)
}

@[inline]
pub fn (v Vector2) to_arr() [2]f32 {
    return [v.x, v.y]!
}

@[inline]
pub fn Vector2.to_float(v Vector2) [2]f32 {
    return v.to_arr()
}


//----------------------------------------------------------------------------------
// Module Functions - Vector3 math
//----------------------------------------------------------------------------------
// Vector with components value 0.0f
// Add two vectors
@[inline]
pub fn Vector3.add(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3Add(v1, v2)
}
// Add vector and float value
@[inline]
pub fn Vector3.add_value(v Vector3, add f32) Vector3 {
    return C.Vector3AddValue(v, add)
}
// Subtract two vectors
@[inline]
pub fn Vector3.subtract(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3Subtract(v1, v2)
}
// Subtract vector by float value
@[inline]
pub fn Vector3.subtract_value(v Vector3, sub f32) Vector3 {
    return C.Vector3SubtractValue(v, sub)
}
// Multiply vector by scalar
@[inline]
pub fn Vector3.scale(v Vector3, scalar f32) Vector3 {
    return C.Vector3Scale(v, scalar)
}
// Multiply vector by vector
@[inline]
pub fn Vector3.multiply(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3Multiply(v1, v2)
}
// Divide vector by vector
@[inline]
pub fn Vector3.divide(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3Divide(v1, v2)
}

@[inline]
pub fn Vector3.divide_value(v1 Vector3, value f32) Vector3 {
    assert value != 0.0
    return Vector3{ v1.x/value, v1.y/value, v1.z/value}
}
// Calculate two vectors cross product
@[inline]
pub fn Vector3.cross(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3CrossProduct(v1, v2)
}
// Calculate one vector perpendicular vector
@[inline]
pub fn Vector3.perpendicular(v Vector3) Vector3 {
    return C.Vector3Perpendicular(v)
}
// Calculate vector length
@[inline]
pub fn Vector3.length(v Vector3) f32 {
    return C.Vector3Length(v)
}
// Calculate vector square length
@[inline]
pub fn Vector3.length_sqr(v Vector3) f32 {
    return C.Vector3LengthSqr(v)
}
// Calculate two vectors dot product
@[inline]
pub fn Vector3.dot(v1 Vector3, v2 Vector3) f32 {
    return C.Vector3DotProduct(v1, v2)
}
// Calculate distance between two vectors
@[inline]
pub fn Vector3.distance(v1 Vector3, v2 Vector3) f32 {
    return C.Vector3Distance(v1, v2)
}
    
// Calculate square distance between two vectors
@[inline]
pub fn Vector3.distance_sqr(v1 Vector3, v2 Vector3) f32 {
    return C.Vector3DistanceSqr(v1, v2)
}
// Calculate angle between two vectors
@[inline]
pub fn Vector3.angle(v1 Vector3, v2 Vector3) f32 {
    return C.Vector3Angle(v1, v2)
}
// Negate provided vector (invert direction)
@[inline]
pub fn Vector3.negate(v Vector3) Vector3 {
    return C.Vector3Negate(v)
}
// Normalize provided vector
@[inline]
pub fn Vector3.normalize(v Vector3) Vector3 {
    return C.Vector3Normalize(v)
}
//Calculate the projection of the vector v1 on to v2
@[inline]
pub fn Vector3.project(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3Project(v1, v2)
}
//Calculate the rejection of the vector v1 on to v2
@[inline]
pub fn Vector3.reject(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3Reject(v1, v2)
}
// Orthonormalize provided vectors
// Makes vectors normalized and orthogonal to each other
// Gram-Schmidt function implementation
@[inline]
pub fn Vector3.ortho_normalize(mut v1 Vector3, mut v2 Vector3) {
    C.Vector3OrthoNormalize(mut v1, mut v2)
}
// Transforms a Vector3 by a given Matrix
@[inline]
pub fn Vector3.transform(v Vector3, mat Matrix) Vector3 {
    return C.Vector3Transform(v, mat)
}
// Transform a vector by quaternion rotation
@[inline]
pub fn Vector3.rotate_by_quaternion(v Vector3, q Quaternion) Vector3 {
    return C.Vector3RotateByQuaternion(v, q)
}
// Rotates a vector around an axis
@[inline]
pub fn Vector3.rotate_by_axis_angle(v Vector3, axis Vector3, angle f32) Vector3 {
    return C.Vector3RotateByAxisAngle(v, axis, angle)
}
// Move Vector towards target
@[inline]
pub fn Vector3.move_towards(v Vector3, target Vector3, max_distance f32) Vector3 {
    return C.Vector3MoveTowards(v, target, max_distance)
}
// Calculate linear interpolation between two vectors
@[inline]
pub fn Vector3.lerp(v1 Vector3, v2 Vector3, amount f32) Vector3 {
    return C.Vector3Lerp(v1, v2, amount)
}
// Calculate reflected vector to normal
@[inline]
pub fn Vector3.reflect(v Vector3, normal Vector3) Vector3 {
    return C.Vector3Reflect(v, normal)
}
// Get min value for each pair of components
@[inline]
pub fn Vector3.min(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3Min(v1, v2)
}
// Get max value for each pair of components
@[inline]
pub fn Vector3.max(v1 Vector3, v2 Vector3) Vector3 {
    return C.Vector3Max(v1, v2)
}
// Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
// NOTE: Assumes P is on the plane of the triangle
@[inline]
pub fn Vector3.barycenter(p Vector3, a Vector3, b Vector3, c Vector3) Vector3 {
    return C.Vector3Barycenter(p, a, b, c)
}
// Projects a Vector3 from screen space into object space
// NOTE: We are avoiding calling other raymath functions despite available
@[inline]
pub fn Vector3.unproject(source Vector3, projection Matrix, view Matrix) Vector3 {
    return C.Vector3Unproject(source, projection, view)
}
// Invert the given vector
@[inline]
pub fn Vector3.invert(v Vector3) Vector3 {
    return C.Vector3Invert(v)
}
// Clamp the components of the vector between
// min and max values specified by the given vectors
@[inline]
pub fn Vector3.clamp(v Vector3, min Vector3, max Vector3) Vector3 {
    return C.Vector3Clamp(v, min, max)
}
// Clamp the magnitude of the vector between two values
@[inline]
pub fn Vector3.clamp_value(v Vector3, min f32, max f32) Vector3 {
    return C.Vector3ClampValue(v, min, max)
}
// Check whether two given vectors are almost equal
@[inline]
pub fn Vector3.equals(p Vector3, q Vector3) bool {
    return C.Vector3Equals(p, q)
}
// Compute the direction of a refracted ray
// v: normalized direction of the incoming ray
// n: normalized normal vector of the interface of two optical media
// r: ratio of the refractive index of the medium from where the ray comes
//    to the refractive index of the medium on the other side of the surface
@[inline]
pub fn Vector3.refract(v Vector3, n Vector3, r f32) Vector3 {
    return C.Vector3Refract(v, n, r)
}

@[inline]
pub fn (v Vector3) to_arr() [3]f32 {
    return [v.x, v.y, v.z]!
}

@[inline]
pub fn Vector3.to_float(v Vector3) [3]f32 {
    return v.to_arr()
}



//----------------------------------------------------------------------------------
// Module Functions - Vector4 math
//----------------------------------------------------------------------------------
// Vector with components value 0.0f
// Add two vectors
@[inline]
pub fn Vector4.add(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4Add(v1, v2)
}
// Add vector and float value
@[inline]
pub fn Vector4.add_value(v Vector4, add f32) Vector4 {
    return C.Vector4AddValue(v, add)
}
// Subtract two vectors
@[inline]
pub fn Vector4.subtract(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4Subtract(v1, v2)
}
// Subtract vector by float value
@[inline]
pub fn Vector4.subtract_value(v Vector4, sub f32) Vector4 {
    return C.Vector4SubtractValue(v, sub)
}
// Multiply vector by scalar
@[inline]
pub fn Vector4.scale(v Vector4, scalar f32) Vector4 {
    return C.Vector4Scale(v, scalar)
}
// Multiply vector by vector
@[inline]
pub fn Vector4.multiply(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4Multiply(v1, v2)
}
// Divide vector by vector
@[inline]
pub fn Vector4.divide(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4Divide(v1, v2)
}

@[inline]
pub fn Vector4.divide_value(v1 Vector4, value f32) Vector4 {
    assert value != 0.0
    return Vector4{ v1.x/value, v1.y/value, v1.z/value, v1.w/value}
}
// Calculate two vectors cross product
@[inline]
pub fn Vector4.cross(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4CrossProduct(v1, v2)
}
// Calculate one vector perpendicular vector
@[inline]
pub fn Vector4.perpendicular(v Vector4) Vector4 {
    return C.Vector4Perpendicular(v)
}
// Calculate vector length
@[inline]
pub fn Vector4.length(v Vector4) f32 {
    return C.Vector4Length(v)
}
// Calculate vector square length
@[inline]
pub fn Vector4.length_sqr(v Vector4) f32 {
    return C.Vector4LengthSqr(v)
}
// Calculate two vectors dot product
@[inline]
pub fn Vector4.dot(v1 Vector4, v2 Vector4) f32 {
    return C.Vector4DotProduct(v1, v2)
}
// Calculate distance between two vectors
@[inline]
pub fn Vector4.distance(v1 Vector4, v2 Vector4) f32 {
    return C.Vector4Distance(v1, v2)
}
    
// Calculate square distance between two vectors
@[inline]
pub fn Vector4.distance_sqr(v1 Vector4, v2 Vector4) f32 {
    return C.Vector4DistanceSqr(v1, v2)
}
// Calculate angle between two vectors
@[inline]
pub fn Vector4.angle(v1 Vector4, v2 Vector4) f32 {
    return C.Vector4Angle(v1, v2)
}
// Negate provided vector (invert direction)
@[inline]
pub fn Vector4.negate(v Vector4) Vector4 {
    return C.Vector4Negate(v)
}
// Normalize provided vector
@[inline]
pub fn Vector4.normalize(v Vector4) Vector4 {
    return C.Vector4Normalize(v)
}
//Calculate the projection of the vector v1 on to v2
@[inline]
pub fn Vector4.project(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4Project(v1, v2)
}
//Calculate the rejection of the vector v1 on to v2
@[inline]
pub fn Vector4.reject(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4Reject(v1, v2)
}
// Orthonormalize provided vectors
// Makes vectors normalized and orthogonal to each other
// Gram-Schmidt function implementation
@[inline]
pub fn Vector4.ortho_normalize(mut v1 Vector4, mut v2 Vector4) {
    C.Vector4OrthoNormalize(mut v1, mut v2)
}
// Transforms a Vector4 by a given Matrix
@[inline]
pub fn Vector4.transform(v Vector4, mat Matrix) Vector4 {
    return C.Vector4Transform(v, mat)
}
// Transform a vector by quaternion rotation
@[inline]
pub fn Vector4.rotate_by_quaternion(v Vector4, q Quaternion) Vector4 {
    return C.Vector4RotateByQuaternion(v, q)
}
// Rotates a vector around an axis
@[inline]
pub fn Vector4.rotate_by_axis_angle(v Vector4, axis Vector4, angle f32) Vector4 {
    return C.Vector4RotateByAxisAngle(v, axis, angle)
}
// Move Vector towards target
@[inline]
pub fn Vector4.move_towards(v Vector4, target Vector4, max_distance f32) Vector4 {
    return C.Vector4MoveTowards(v, target, max_distance)
}
// Calculate linear interpolation between two vectors
@[inline]
pub fn Vector4.lerp(v1 Vector4, v2 Vector4, amount f32) Vector4 {
    return C.Vector4Lerp(v1, v2, amount)
}
// Calculate reflected vector to normal
@[inline]
pub fn Vector4.reflect(v Vector4, normal Vector4) Vector4 {
    return C.Vector4Reflect(v, normal)
}
// Get min value for each pair of components
@[inline]
pub fn Vector4.min(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4Min(v1, v2)
}
// Get max value for each pair of components
@[inline]
pub fn Vector4.max(v1 Vector4, v2 Vector4) Vector4 {
    return C.Vector4Max(v1, v2)
}
// Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
// NOTE: Assumes P is on the plane of the triangle
@[inline]
pub fn Vector4.barycenter(p Vector4, a Vector4, b Vector4, c Vector4) Vector4 {
    return C.Vector4Barycenter(p, a, b, c)
}
// Projects a Vector4 from screen space into object space
// NOTE: We are avoiding calling other raymath functions despite available
@[inline]
pub fn Vector4.unproject(source Vector4, projection Matrix, view Matrix) Vector4 {
    return C.Vector4Unproject(source, projection, view)
}
// Invert the given vector
@[inline]
pub fn Vector4.invert(v Vector4) Vector4 {
    return C.Vector4Invert(v)
}
// Clamp the components of the vector between
// min and max values specified by the given vectors
@[inline]
pub fn Vector4.clamp(v Vector4, min Vector4, max Vector4) Vector4 {
    return C.Vector4Clamp(v, min, max)
}
// Clamp the magnitude of the vector between two values
@[inline]
pub fn Vector4.clamp_value(v Vector4, min f32, max f32) Vector4 {
    return C.Vector4ClampValue(v, min, max)
}
// Check whether two given vectors are almost equal
@[inline]
pub fn Vector4.equals(p Vector4, q Vector4) bool {
    return C.Vector4Equals(p, q)
}
// Compute the direction of a refracted ray
// v: normalized direction of the incoming ray
// n: normalized normal vector of the interface of two optical media
// r: ratio of the refractive index of the medium from where the ray comes
//    to the refractive index of the medium on the other side of the surface
@[inline]
pub fn Vector4.refract(v Vector4, n Vector4, r f32) Vector4 {
    return C.Vector4Refract(v, n, r)
}

pub fn (v Vector4) to_color() Color {
    nv := Vector4.normalize(v)
    return Color {
        u8(nv.x*255),
        u8(nv.y*255),
        u8(nv.z*255),
        u8(nv.w*255)
    }
}

@[inline]
pub fn (v Vector4) to_arr() [4]f32 {
    return [v.x, v.y, v.z, v.w]!
}

@[inline]
pub fn Vector4.to_float(v Vector4) [4]f32 {
    return v.to_arr()
}


//----------------------------------------------------------------------------------
// Module Functions - Matrix math
//----------------------------------------------------------------------------------
// Compute matrix determinant
@[inline]
pub fn Matrix.determinant(mat Matrix) f32 {
    return C.MatrixDeterminant(mat)
}
// Get the trace of the matrix (sum of the values along the diagonal)
@[inline]
pub fn Matrix.trace(mat Matrix) f32 {
    return C.MatrixTrace(mat)
}
// Transposes provided matrix
@[inline]
pub fn Matrix.transpose(mat Matrix) Matrix {
    return C.MatrixTranspose(mat)
}
// Invert provided matrix
@[inline]
pub fn Matrix.invert(mat Matrix) Matrix {
    return C.MatrixInvert(mat)
}
// Get identity matrix
@[inline]
pub fn Matrix.identity() Matrix {
    return C.MatrixIdentity()
}
// Add two matrices
@[inline]
pub fn Matrix.add(left Matrix, right Matrix) Matrix {
    return C.MatrixAdd(left, right)
}
// Subtract two matrices (left - right)
@[inline]
pub fn Matrix.subtract(left Matrix, right Matrix) Matrix {
    return C.MatrixSubtract(left, right)
}
// Get two matrix multiplication
// NOTE: When multiplying matrices... the order matters!
@[inline]
pub fn Matrix.multiply(left Matrix, right Matrix) Matrix {
    return C.MatrixMultiply(left, right)
}
// Get translation matrix
@[inline]
// pub fn Matrix.translate(x f32, y f32, z f32) Matrix {
pub fn Matrix.translate(pos Vector3) Matrix {
    return C.MatrixTranslate(pos.x, pos.y, pos.z)
}
// Create rotation matrix from axis and angle
// NOTE: Angle should be provided in radians
@[inline]
pub fn Matrix.rotate(axis Vector3, angle f32) Matrix {
    return C.MatrixRotate(axis, angle)
}
// Get x-rotation matrix
// NOTE: Angle must be provided in radians
@[inline]
pub fn Matrix.rotate_x(angle f32) Matrix {
    return C.MatrixRotateX(angle)
}
// Get y-rotation matrix
// NOTE: Angle must be provided in radians
@[inline]
pub fn Matrix.rotate_y(angle f32) Matrix {
    return C.MatrixRotateY(angle)
}
// Get z-rotation matrix
// NOTE: Angle must be provided in radians
@[inline]
pub fn Matrix.rotate_z(angle f32) Matrix {
    return C.MatrixRotateZ(angle)
}

// Get xyz-rotation matrix
// NOTE: Angle must be provided in radians
@[inline]
pub fn Matrix.rotate_xyz(angle Vector3) Matrix {
    return C.MatrixRotateXYZ(angle)
}
// Get zyx-rotation matrix
// NOTE: Angle must be provided in radians
@[inline]
pub fn Matrix.rotate_zyx(angle Vector3) Matrix {
    return C.MatrixRotateZYX(angle)
}
// Get scaling matrix
@[inline]
pub fn Matrix.scale(x f32, y f32, z f32) Matrix {
    return C.MatrixScale(x, y, z)
}
// Get perspective projection matrix
@[inline]
pub fn Matrix.frustum(left f64, right f64, bottom f64, top f64, near f64, far f64) Matrix {
    return C.MatrixFrustum(left, right, bottom, top, near, far)
}
// Get perspective projection matrix
// NOTE: Fovy angle must be provided in radians
@[inline]
pub fn Matrix.perspective(fov_y f64, aspect f64, near_plane f64, far_plane f64) Matrix {
    return C.MatrixPerspective(fov_y, aspect, near_plane, far_plane)
}
// Get orthographic projection matrix
@[inline]
pub fn Matrix.ortho(left f64, right f64, bottom f64, top f64, near_plane f64, far_plane f64) Matrix {
    return C.MatrixOrtho(left, right, bottom, top, near_plane, far_plane)
}
// Get camera look-at matrix (view matrix)
@[inline]
pub fn Matrix.look_at(eye Vector3, target Vector3, up Vector3) Matrix {
    return C.MatrixLookAt(eye, target, up)
}

@[inline]
pub fn (mat Matrix) to_arr() [16]f32 {
    return [mat.m0,  mat.m1,  mat.m2,  mat.m3,
            mat.m4,  mat.m5,  mat.m6,  mat.m7,
            mat.m8,  mat.m9,  mat.m10, mat.m11,
            mat.m12, mat.m13, mat.m14, mat.m15]!
}

@[inline]
pub fn Matrix.to_float(mat Matrix) [16]f32 {
    return mat.to_arr()
}

//----------------------------------------------------------------------------------
// Module Functions - Quaternion math
//----------------------------------------------------------------------------------
// Add two quaternions
@[inline]
pub fn Quaternion.add(q1 Quaternion, q2 Quaternion) Quaternion {
    return C.QuaternionAdd(q1, q2)
}
// Add quaternion and float value
@[inline]
pub fn Quaternion.add_value(q Quaternion, add f32) Quaternion {
    return C.QuaternionAddValue(q, add)
}
// Subtract two quaternions
@[inline]
pub fn Quaternion.subtract(q1 Quaternion, q2 Quaternion) Quaternion {
    return C.QuaternionSubtract(q1, q2)
}
// Subtract quaternion and float value
@[inline]
pub fn Quaternion.subtract_value(q Quaternion, sub f32) Quaternion {
    return C.QuaternionSubtractValue(q, sub)
}
// Get identity quaternion
@[inline]
pub fn Quaternion.identity() Quaternion {
    return C.QuaternionIdentity()
}
// Computes the length of a quaternion
@[inline]
pub fn Quaternion.length(q Quaternion) f32 {
    return C.QuaternionLength(q)
}
// Normalize provided quaternion
@[inline]
pub fn Quaternion.normalize(q Quaternion) Quaternion {
    return C.QuaternionNormalize(q)
}
// Invert provided quaternion
@[inline]
pub fn Quaternion.invert(q Quaternion) Quaternion {
    return C.QuaternionInvert(q)
}
// Calculate two quaternion multiplication
@[inline]
pub fn Quaternion.multiply(q1 Quaternion, q2 Quaternion) Quaternion {
    return C.QuaternionMultiply(q1, q2)
}
// Scale quaternion by float value
@[inline]
pub fn Quaternion.scale(q Quaternion, mul f32) Quaternion {
    return C.QuaternionScale(q, mul)
}
// Divide two quaternions
@[inline]
pub fn Quaternion.divide(q1 Quaternion, q2 Quaternion) Quaternion {
    return C.QuaternionDivide(q1, q2)
}
// Calculate linear interpolation between two quaternions
@[inline]
pub fn Quaternion.lerp(q1 Quaternion, q2 Quaternion, amount f32) Quaternion {
    return C.QuaternionLerp(q1, q2, amount)
}
// Calculate slerp-optimized interpolation between two quaternions
@[inline]
pub fn Quaternion.nlerp(q1 Quaternion, q2 Quaternion, amount f32) Quaternion {
    return C.QuaternionNLerp(q1, q2, amount)
}
// Calculates spherical linear interpolation between two quaternions
@[inline]
pub fn Quaternion.slerp(q1 Quaternion, q2 Quaternion, amount f32) Quaternion {
    return C.QuaternionSLerp(q1, q2, amount)
}
// Calculate quaternion based on the rotation from one vector to another
@[inline]
pub fn Quaternion.from_vector3_to_vector3(from Vector3, to Vector3) Quaternion {
    return C.QuaternionFromVector3ToVector3(from, to)
}
// Get a quaternion for a given rotation matrix
@[inline]
pub fn Quaternion.from_matrix(mat Matrix) Quaternion {
    return C.QuaternionFromMatrix(mat)
}
// Get a matrix for a given quaternion
@[inline]
pub fn Quaternion.to_matrix(q Quaternion) Matrix {
    return C.QuaternionToMatrix(q)
}
// Get rotation quaternion for an angle and axis
// NOTE: Angle must be provided in radians
@[inline]
pub fn Quaternion.from_axis_angle(axis Vector3, angle f32) Quaternion {
    return C.QuaternionFromAxisAngle(axis, angle)
}
// Get the rotation angle and axis for a given quaternion
@[inline]
pub fn Quaternion.to_axis_angle(q Quaternion, out_axis &Vector3, out_angle &f32) {
    C.QuaternionToAxisAngle(q, out_axis, out_angle)
}
// Get the quaternion equivalent to Euler angles
// NOTE: Rotation order is ZYX
@[inline]
pub fn Quaternion.from_euler(pitch f32, yaw f32, roll f32) Quaternion {
    return C.QuaternionFromEuler(pitch, yaw, roll)
}
// Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
// NOTE: Angles are returned in a Vector3 pub struct in radians
@[inline]
pub fn Quaternion.to_euler(q Quaternion) Vector3 {
    return C.QuaternionToEuler(q)
}
// Transform a quaternion given a transformation matrix
@[inline]
pub fn Quaternion.transform(q Quaternion, mat Matrix) Quaternion {
    return C.QuaternionTransform(q, mat)
}
// Check whether two given quaternions are almost equal
@[inline]
pub fn Quaternion.equals(p Quaternion, q Quaternion) bool {
    return C.QuaternionEquals(p, q)
}


























// // //----------------------------------------------------------------------------------
// // // Module Functions Definition - Utils math
// // //----------------------------------------------------------------------------------
// @[inline] pub fn ceilf(v f32) f32             { return C.Ceilf(v)         }
// @[inline] pub fn randf() f32                  { return C.Randf()          }
// @[inline] pub fn randnf(v f32) f32            { return C.Randnf(v)        }
// @[inline] pub fn fmodf(v1 f32, v2 f32) f32    { return C.Fmodf(v1, v2)    }
// @[inline] pub fn deg2rad(degrees f32) f32     { return C.DEG2RAD(degrees) }
// @[inline] pub fn rad2deg(radians f32) f32     { return C.RAD2DEG(radians) }
// @[inline] pub fn tan(value f32) f32           { return C.Tan(value)       }
// @[inline] pub fn atan2f(det f32, dot f32) f32 { return C.Atan2f(det, dot) }
// @[inline] pub fn sqrtf(value f32) f32         { return C.Sqrtf(value)     }
// @[inline] pub fn sinf(value f32) f32          { return C.Sinf(value)      }
// @[inline] pub fn asinf(value f32) f32         { return C.Asinf(value)     }
// @[inline] pub fn acosf(value f32) f32         { return C.Acosf(value)     }
// @[inline] pub fn cosf(value f32) f32          { return C.Cosf(value)      }
// @[inline] pub fn fabsf(value f32) f32         { return C.Fabsf(value)     }
// @[inline] pub fn fminf(v1 f32, v2 f32) f32    { return C.Fminf(v1, v2)    }
// @[inline] pub fn fmaxf(v1 f32, v2 f32) f32    { return C.Fmaxf(v1, v2)    }
// @[inline] pub fn powf(v1 f32, v2 f32) f32     { return C.Powf(v1, v2)     }
// // Clamp float value
// @[inline] pub fn clamp(value f32, min f32, max f32) f32 { return C.Clamp(value, min, max) }
// // Calculate linear interpolation between two floats
// @[inline] pub fn lerp(start f32, end f32, amount f32) f32 { return C.Lerp(start, end, amount) }
// // Normalize input value within input range
// @[inline] pub fn normalize(value f32, start f32, end f32) f32 { return C.Normalize(value, start, end) }


// // //----------------------------------------------------------------------------------
// // // Module Functions Definition - Utils math
// // //----------------------------------------------------------------------------------
// // @[inline]
// // pub fn ceilf(v f32) f32 {
// //     return f32(math.ceil(v))
// // }

// // @[inline]
// // pub fn randf() f32 {
// //     return rand.f32()
// // }

// // @[inline]
// // pub fn randnf(v f32) f32 {
// //     return rand.f32n(v) or { 0.0 }
// // }

// // @[inline]
// // pub fn rand_in_range_f(min f32, max f32) f32 {
// //     return rand.f32_in_range(min, max) or { 0.0 }
// // }


// // @[inline]
// // pub fn fmodf(v1 f32, v2 f32) f32 {
// //     return f32(math.fmod(v1, v2))
// // }

// // @[inline]
// // pub fn deg2rad(degrees f32) f32 {
// //     return f32(math.radians(degrees)) // return (pi/180.0)*degrees
// // }

// // @[inline]
// // pub fn rad2deg(radians f32) f32{
// //     return f32(math.degrees(radians)) // return (180.0/pi)*radians
// // }

// // @[inline]
// // pub fn tan(value f32) f32 {
// //     return f32(math.tan(value))
// // }

// // @[inline]
// // pub fn atan2f(det f32, dot f32) f32 {
// //     return f32(math.atan2(det, dot))
// // }

// // @[inline]
// // pub fn sqrtf(value f32) f32 {
// //     return f32(math.sqrt(value))
// // }

// // @[inline]
// // pub fn sinf(value f32) f32 {
// //     return f32(math.sin(value))
// // }

// // @[inline]
// // pub fn asinf(value f32) f32 {
// //     return f32(math.asin(value))
// // }


// // @[inline]
// // pub fn acosf(value f32) f32 {
// //     return f32(math.acos(value))
// // }

// // @[inline]
// // pub fn cosf(value f32) f32 {
// //     return f32(math.cos(value))
// // }

// // @[inline]
// // pub fn fabsf(value f32) f32 {
// //     return f32(math.abs(value))
// // }

// // @[inline]
// // pub fn fminf(one f32, two f32) f32 {
// //     return math.min(one, two)
// // }

// // @[inline]
// // pub fn fmaxf(v1 f32, v2 f32) f32 {
// //     return math.max(v1, v2)
// // }

// // @[inline]
// // pub fn powf(v1 f32, v2 f32) f32 {
// //     return f32(math.pow(v1, v2))
// // }

// // // Clamp float value
// // @[inline]
// // pub fn clamp(value f32, min f32, max f32) f32 {
// //     return f32(math.clamp(value, min, max))
// // }

// // // Calculate linear interpolation between two floats
// // @[inline]
// // pub fn lerp(start f32, end f32, amount f32) f32 {
// //     return start + amount * (end - start)
// // }

// // // Normalize input value within input range
// // @[inline]
// // pub fn normalize(value f32, start f32, end f32) f32 {
// //     return (value - start)/(end - start)
// // }

// // // Remap input value within input range to output range
// // @[inline]
// // pub fn remap(value f32, input_start f32, input_end f32, output_start f32, output_end f32) f32 {
// //     return (value - input_start)/(input_end - input_start)*(output_end - output_start) + output_start
// // }

// // // Wrap input value from min to max
// // @[inline]
// // pub fn wrap(value f32, min f32, max f32) f32 {
// //     return value - (max - min)* f32(math.floor((value - min)/(max - min)))
// // }

// // // Check whether two given floats are almost equal
// // @[inline]
// // pub fn float_equals(x f32, y f32) bool {
// //     return (fabsf(x - y)) <= (epsilon*fmaxf(1.0, fmaxf(fabsf(x), fabsf(y))))
// // }


// //----------------------------------------------------------------------------------
// // Structures Definition
// //----------------------------------------------------------------------------------

// // Vector2, 2 components
// @[typedef]
// struct C.Vector2 {
// pub mut:
// 	x f32       // Vector x component
// 	y f32       // Vector y component
// }
// pub type Vector2 = C.Vector2

// // Vector3, 3 components
// @[typedef]
// struct C.Vector3 {
// pub mut:
// 	x f32       // Vector x component
// 	y f32       // Vector y component
// 	z f32       // Vector z component
// }
// pub type Vector3 = C.Vector3

// // Vector4, 4 components
// @[typedef]
// struct C.Vector4 {
// pub mut:
// 	x f32       // Vector x component
// 	y f32       // Vector y component
// 	z f32       // Vector z component
// 	w f32       // Vector w component
// }
// pub type Vector4    = C.Vector4
// pub type Quaternion = C.Vector4
                                                    
// // Matrix, 4x4 components, column major, OpenGL style, right-handed
// @[typedef]
// struct C.Matrix {
// pub mut:
// 	m0  f32 m4  f32 m8  f32 m12 f32     // Matrix first row (4 components)
// 	m1  f32 m5  f32 m9  f32 m13 f32     // Matrix second row (4 components)
// 	m2  f32 m6  f32 m10 f32 m14 f32     // Matrix third row (4 components)
// 	m3  f32 m7  f32 m11 f32 m15 f32     // Matrix fourth row (4 components)
// }
// pub type Matrix = C.Matrix


// //----------------------------------------------------------------------------------
// // Module Functions Definition - Vector2 math
// //----------------------------------------------------------------------------------

// // Vector with components value 0.0f, same as Vector2{}
// @[inline]
// pub fn Vector2.zero() Vector2 {
//     return Vector2{}
// }

// // Vector with components value 1.0f
// @[inline]
// pub fn Vector2.one() Vector2 {
//     return Vector2{ 1, 1 }
// }

// // Add two vectors (v1 + v2)
// @[inline]
// pub fn Vector2.add(v1 Vector2, v2 Vector2) Vector2 {
//     return Vector2 {
//         v1.x + v2.x,
//         v1.y + v2.y
//     }
// }

// pub fn (v1 Vector2) + (v2 Vector2) Vector2 {
//     return Vector2.add(v1, v2)
// }

// // Add vector and float value
// @[inline]
// pub fn Vector2.add_value(v1 Vector2, value f32) Vector2 {
//     return Vector2 {
//         v1.x + value,
//         v1.y + value
//     }
// }

// // Subtract two vectors (v1 - v2)
// @[inline]
// pub fn Vector2.subtract(v1 Vector2, v2 Vector2) Vector2 {
//     return Vector2 { v1.x - v2.x, v1.y - v2.y }
// }

// // Subtract two vectors (v1 - v2)
// pub fn (v1 Vector2) - (v2 Vector2) Vector2 {
//     return Vector2.subtract(v1, v2)
// }

// // Subtract vector by float value
// @[inline]
// pub fn Vector2.sub_value(v1 Vector2, value f32) Vector2 {
//     return Vector2 {
//         v1.x - value,
//         v1.y - value
//     }
// }

// // Calculate vector length
// @[inline]
// pub fn Vector2.length(vec Vector2) f32 {
//     // return f32(math.sqrt(vec.x*vec.x + vec.y*vec.y))
//     return sqrtf(vec.x*vec.x + vec.y*vec.y)
// }

// // Calculate vector square length
// @[inline]
// pub fn Vector2.length_sqrt(vec Vector2) f32 {
//     return (vec.x*vec.x + vec.y*vec.y)
// }

// // Calculate two vectors dot product
// @[inline]
// pub fn Vector2.dot(v1 Vector2, v2 Vector2) f32 {
//     return (v1.x*v2.x + v1.y*v2.y)
// }

// // Calculate distance between two vectors
// @[inline]
// pub fn Vector2.distance(v1 Vector2, v2 Vector2) f32 {
//     return sqrtf((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y))
// }

// // Calculate square distance between two vectors
// @[inline]
// pub fn Vector2.distance_sqr(v1 Vector2, v2 Vector2) f32 {
//     return ((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y))
// }

// // Calculate angle between two vectors
// // NOTE: Angle is calculated from origin point (0, 0)
// pub fn Vector2.angle(v1 Vector2, v2 Vector2) f32 {
//     dot := v1.x*v2.x + v1.y*v2.y
//     det := v1.x*v2.y - v1.y*v2.x

//     return atan2f(det, dot)
// }

// // Calculate angle defined by a two vectors line
// // NOTE: Parameters need to be normalized
// // Current implementation should be aligned with glm::angle
// pub fn Vector2.line_angle(start Vector2, end Vector2) f32 {
//     // TODO(10/9/2023): Currently angles move clockwise, determine if this is wanted behavior
//     return -atan2f(end.y - start.y, end.x - start.x)
// }

// // Scale vector (multiply by value)
// @[inline]
// pub fn Vector2.scale(vec Vector2, scale f32) Vector2 {
//     return Vector2 {
//         vec.x * scale,
//         vec.y * scale
//     }
// }

// // Multiply vector by vector
// @[inline]
// pub fn Vector2.multiply(v1 Vector2, v2 Vector2) Vector2 {
//     return Vector2 { v1.x * v2.x, v1.y * v2.y }
// }

// // Multiply vector by vector
// pub fn (v1 Vector2) * (v2 Vector2) Vector2 {
//     return Vector2.multiply(v1, v2)
// }

// // Multiply vector by value | sace as Vector2.scale
// @[inline]
// pub fn Vector2.multiply_value(v1 Vector2, value f32) Vector2 {
//     return Vector2 { v1.x * value, v1.y * value }
// }

// // Negate vector
// @[inline]
// pub fn Vector2.negative(v Vector2) Vector2 {
//     return Vector2{ -v.x, -v.y }
// }

// // Divide vector by vector
// @[inline]
// pub fn Vector2.divide(v1 Vector2, v2 Vector2) Vector2 {
//     return Vector2 { v1.x / v2.x, v1.y / v2.y }
// }

// // Divide vector by vector
// pub fn (v1 Vector2) / (v2 Vector2) Vector2 {
//     return Vector2.divide(v1, v2)
// }

// // Divide vector by value
// @[inline]
// pub fn Vector2.divide_value(v1 Vector2, value f32) Vector2 {
//     return Vector2 { v1.x / value, v1.y / value }
// }

// // Normalize provided vector
// pub fn Vector2.normalize(v Vector2) Vector2 {
//     mut result := Vector2{}
//     mut length := Vector2.length(v)
    
//     if length > 0 {
//         length = 1.0/length
//         result.x = v.x*length
//         result.y = v.y*length
//     }

//     return result
// }

// // Transforms a Vector2 by a given Matrix
// pub fn Vector2.transform(v Vector2, mat Matrix) Vector2 {
//     x := v.x
//     y := v.y
//     z := f32(0.0)

//     return Vector2 {
//         mat.m0*x + mat.m4*y + mat.m8*z + mat.m12,
//         mat.m1*x + mat.m5*y + mat.m9*z + mat.m13
//     }
// }

// // Calculate linear interpolation between two vectors
// @[inline]
// pub fn Vector2.lerp(v1 Vector2, v2 Vector2, amount f32) Vector2 {
//     return Vector2 {
//         v1.x + amount*(v2.x - v1.x)
//         v1.y + amount*(v2.y - v1.y)
//     }
// }

// // Calculate reflected vector to normal
// pub fn Vector2.reflect(v Vector2, normal Vector2) Vector2 {
//     dot := Vector2.dot(v, normal)

//     return Vector2 {
//         v.x - (2.0*normal.x)*dot
//         v.y - (2.0*normal.y)*dot
//     }
// }

// // Rotate vector by angle
// pub fn Vector2.rotate(v Vector2, angle f32) Vector2 {
//     cosres := cosf(angle)
//     sinres := sinf(angle)

//     return Vector2 {
//         v.x*cosres - v.y*sinres
//         v.x*sinres + v.y*cosres
//     }
// }

// // Move Vector towards target
// pub fn Vector2.move_towards(v Vector2, target Vector2, max_distance f32) Vector2 {
//     dx    := target.x - v.x
//     dy    := target.y - v.y
//     value := (dx*dx) + (dy*dy)

//     if (value == 0) || ((max_distance >= 0) && (value <= max_distance*max_distance)) {
//         return target
//     }

//     dist := sqrtf(value)

//     return Vector2 {
//         v.x + dx/dist*max_distance,
//         v.y + dy/dist*max_distance
//     }
// }

// // Invert the given vector
// @[inline]
// pub fn Vector2.invert(vec Vector2) Vector2 {
//     return Vector2 { 1.0/vec.x, 1.0/vec.y }
// }

// // Clamp the components of the vector between
// // min and max values specified by the given vectors
// @[inline]
// pub fn Vector2.clamp(v Vector2, min Vector2, max Vector2) Vector2 {
//     return Vector2 {
//         fminf(max.x, fmaxf(min.x, v.x))
//         fminf(max.y, fmaxf(min.y, v.y))
//     }
// }

// // Clamp the magnitude of the vector between two min and max values
// pub fn Vector2.clamp_value(v Vector2, min f32, max f32) Vector2 {
//     mut result := Vector2{}
//     mut length := Vector2.length(v)
    
//     if length > 0.0 {
//         length = sqrtf(length)

//         if length < min {
//             scale := min/length
            
//             result.x = v.x*scale
//             result.y = v.y*scale
//         } else if length > max {
//             scale := max/length
            
//             result.x = v.x*scale
//             result.y = v.y*scale
//         }
//     }
//     return result
// }

// // Check whether two given vectors are almost equal
// @[inline]
// pub fn Vector2.equals(p Vector2, q Vector2) bool {
//     return ((fabsf(p.x - q.x)) <= (epsilon*fmaxf(1.0, fmaxf(fabsf(p.x), fabsf(q.x))))) &&
//            ((fabsf(p.y - q.y)) <= (epsilon*fmaxf(1.0, fmaxf(fabsf(p.y), fabsf(q.y)))))
// }

// // Check whether two given vectors are almost equal
// pub fn (v1 Vector2) == (v2 Vector2) bool {
//     return Vector2.equals(v1, v2)
// }


// //----------------------------------------------------------------------------------
// // Module Functions Definition - Vector3 math
// //----------------------------------------------------------------------------------

// // Vector with components value 0.0f
// @[inline]
// pub fn Vector3.zero() Vector3 {
//     return Vector3 { 0.0, 0.0, 0.0 }
// }

// // Vector with components value 1.0f
// @[inline]
// pub fn Vector3.one() Vector3 {
//     return Vector3 { 1.0, 1.0, 1.0 }
// }

// // Add two vectors
// @[inline]
// pub fn Vector3.add(v1 Vector3, v2 Vector3) Vector3 {
//     return Vector3 { v1.x + v2.x, v1.y + v2.y, v1.z + v2.z }
// }

// // Add two vectors
// pub fn (v1 Vector3) + (v2 Vector3) Vector3 {
//     return Vector3.add(v1, v2)
// }

// // Add vector and float value
// @[inline]
// pub fn Vector3.add_value(v Vector3, add f32) Vector3 {
//     return Vector3 { v.x + add, v.y + add, v.z + add }
// }

// // Subtract two vectors
// pub fn Vector3.subtract(v1 Vector3, v2 Vector3) Vector3 {
//     return Vector3 { v1.x - v2.x, v1.y - v2.y, v1.z - v2.z }
// }

// // Subtract two vectors
// pub fn (v1 Vector3) - (v2 Vector3) Vector3 {
//     return Vector3.add(v1, v2)
// }

// // Subtract vector by float value
// @[inline]
// pub fn Vector3.subtract_value(v Vector3, sub f32) Vector3 {
//     return Vector3 { v.x - sub, v.y - sub, v.z - sub }
// }

// // Multiply vector by scalar
// @[inline]
// pub fn Vector3.scale(v Vector3, scalar f32) Vector3 {
//     return Vector3 { v.x*scalar, v.y*scalar, v.z*scalar }
// }

// // Multiply vector by vector
// @[inline]
// pub fn Vector3.multiply(v1 Vector3, v2 Vector3) Vector3 {
//     return Vector3 { v1.x*v2.x, v1.y*v2.y, v1.z*v2.z }
// }

// // Multiply vector by vector
// pub fn (v1 Vector3) * (v2 Vector3) Vector3 {
//     return Vector3.multiply(v1, v2)
// }

// // Multiply vector by vector
// @[inline]
// pub fn Vector3.multiply_value(v1 Vector3, value f32) Vector3 {
//     return Vector3 { v1.x*value, v1.y*value, v1.z*value }
// }

// // Calculate two vectors cross product
// @[inline]
// pub fn Vector3.cross(v1 Vector3, v2 Vector3) Vector3 {
//     return Vector3 { v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x }
// }

// // Calculate one vector perpendicular vector
// pub fn Vector3.perpendicular(v Vector3) Vector3 {
//     mut min           := fabsf(v.x)
//     mut cardinal_axis := Vector3 { 1.0, 0.0, 0.0 }

//     if fabsf(v.y) < min {
//         min = abs(v.y)
//         cardinal_axis = Vector3 { 0.0, 1.0, 0.0 }
//     }

//     if fabsf(v.z) < min {
//         cardinal_axis =  Vector3 { 0.0, 0.0, 1.0 }
//     }

//     // Cross product between vectors
//     return Vector3 {
//         v.y*cardinal_axis.z - v.z*cardinal_axis.y,
//         v.z*cardinal_axis.x - v.x*cardinal_axis.z,
//         v.x*cardinal_axis.y - v.y*cardinal_axis.x
//     }
// }

// // Calculate vector length
// @[inline]
// pub fn Vector3.length(v Vector3) f32 {
//     return f32(math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z))
// }

// // Calculate vector square length
// @[inline]
// pub fn Vector3.length_sqr(v Vector3) f32 {
//     return v.x*v.x+ v.y*v.y + v.z*v.z
// }

// // Calculate two vectors dot product
// @[inline]
// pub fn Vector3.dot(v1 Vector3, v2 Vector3) f32 {
//     return (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z)
// }

// // Calculate distance between two vectors
// pub fn Vector3.distance(v1 Vector3, v2 Vector3) f32 {
//     dx := v2.x - v1.x
//     dy := v2.y - v1.y
//     dz := v2.z - v1.z

//     return f32(math.sqrt(dx*dx + dy*dy + dz*dz))
// }

// // Calculate square distance between two vectors
// pub fn Vector3.distance_sqr(v1 Vector3, v2 Vector3) f32 {
//     dx := v2.x - v1.x
//     dy := v2.y - v1.y
//     dz := v2.z - v1.z

//     return dx*dx + dy*dy + dz*dz
// }

// // Calculate angle between two vectors
// pub fn Vector3.angle(v1 Vector3, v2 Vector3) f32 {
//     cross := Vector3.cross(v1, v2)
//     len   := f32(math.sqrt(cross.x*cross.x + cross.y*cross.y + cross.z*cross.z))
//     dot   := (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z)

//     return atan2f(len, dot)
// }

// // Negate provided vector (invert direction)
// @[inline]
// pub fn Vector3.negate(v Vector3) Vector3 {
//     return Vector3 { -v.x, -v.y, -v.z }
// }

// // Divide vector by vector
// @[inline]
// pub fn Vector3.divide(v1 Vector3, v2 Vector3) Vector3 {
//     return Vector3 { v1.x/v2.x, v1.y/v2.y, v1.z/v2.z }
// }

// pub fn (v1 Vector3) / (v2 Vector3) Vector3 {
//     return Vector3.divide(v1, v2)
// }

// // Normalize provided vector
// pub fn Vector3.normalize(v Vector3) Vector3 {
//     mut result := v

//     // mut length := f32(math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z))
//     mut length := Vector3.length(v)
//     if length != 0.0 {
//         length = 1.0/length

//         result.x *= length
//         result.y *= length
//         result.z *= length
//     }
//     return result
// }

// //Calculate the projection of the vector v1 on to v2
// pub fn Vector3.project(v1 Vector3, v2 Vector3) Vector3 {
//     v1dv2 := (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z)
//     v2dv2 := (v2.x*v2.x + v2.y*v2.y + v2.z*v2.z)

//     mag := v1dv2/v2dv2

//     return Vector3 {
//         v2.x*mag
//         v2.y*mag
//         v2.z*mag
//     }
// }

// //Calculate the rejection of the vector v1 on to v2
// pub fn Vector3.reject(v1 Vector3, v2 Vector3) Vector3 {
//     v1dv2 := (v1.x*v2.x + v1.y*v2.y + v1.z*v2.z)
//     v2dv2 := (v2.x*v2.x + v2.y*v2.y + v2.z*v2.z)

//     mag := v1dv2/v2dv2

//     return Vector3 {
//         v1.x - (v2.x*mag)
//         v1.y - (v2.y*mag)
//         v1.z - (v2.z*mag)
//     }
// }

// // Orthonormalize provided vectors
// // Makes vectors normalized and orthogonal to each other
// // Gram-Schmidt function implementation
// pub fn Vector3.ortho_normalize(mut v1 Vector3, mut v2 Vector3) {
//     mut length  := f32(0.0)
//     mut ilength := f32(0.0)

//     // Vector3Normalize(*v1);
//     length = f32(math.sqrt(v1.x*v1.x + v1.y*v1.y + v1.z*v1.z))
//     if length == 0.0 { length = 1.0 }
    
//     ilength = 1.0/length
//     v1.x *= ilength
//     v1.y *= ilength
//     v1.z *= ilength

//     // Vector3CrossProduct(*v1, *v2)
//     mut vn1 := Vector3 { v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x }

//     // Vector3Normalize(vn1);
//     v1 = vn1
//     length = f32(math.sqrt(v1.x*v1.x + v1.y*v1.y + v1.z*v1.z))
//     if length == 0.0 { length = 1.0 }
    
//     ilength = 1.0/length
//     vn1.x *= ilength
//     vn1.y *= ilength
//     vn1.z *= ilength

//     // Vector3CrossProduct(vn1, *v1)
//     v2.x = vn1.y*v1.z - vn1.z*v1.y
//     v2.y = vn1.z*v1.x - vn1.x*v1.z
//     v2.z = vn1.x*v1.y - vn1.y*v1.x
// }

// // Transforms a Vector3 by a given Matrix
// pub fn Vector3.transform(v Vector3, mat Matrix) Vector3 {
//     x := v.x
//     y := v.y
//     z := v.z

//     return Vector3 {
//         mat.m0*x + mat.m4*y + mat.m8*z  + mat.m12
//         mat.m1*x + mat.m5*y + mat.m9*z  + mat.m13
//         mat.m2*x + mat.m6*y + mat.m10*z + mat.m14
//     }
// }

// // Transform a vector by quaternion rotation
// pub fn Vector3.rotate_by_quaternion(v Vector3, q Quaternion) Vector3 {
//     return Vector3 {
//         v.x*(q.x*q.x + q.w*q.w - q.y*q.y - q.z*q.z) + v.y*(2*q.x*q.y - 2*q.w*q.z) + v.z*(2*q.x*q.z + 2*q.w*q.y)
//         v.x*(2*q.w*q.z + 2*q.x*q.y) + v.y*(q.w*q.w - q.x*q.x + q.y*q.y - q.z*q.z) + v.z*(-2*q.w*q.x + 2*q.y*q.z)
//         v.x*(-2*q.w*q.y + 2*q.x*q.z) + v.y*(2*q.w*q.x + 2*q.y*q.z)+ v.z*(q.w*q.w - q.x*q.x - q.y*q.y + q.z*q.z)
//     }
// }

// // Rotates a vector around an axis
// pub fn Vector3.rotate_by_axis_angle(v Vector3, axis Vector3, angle f32) Vector3 {
//     // Using Euler-Rodrigues Formula
//     // Ref.: https://en.wikipedia.org/w/index.php?title=Euler%E2%80%93Rodrigues_formula

//     mut result    := v
//     mut new_axis  := axis
//     mut new_angle := angle / 2.0

//     // Vector3Normalize(axis);
//     mut length := f32(math.sqrt(axis.x*axis.x + axis.y*axis.y + axis.z*axis.z))
//     if length == 0.0 { length = 1.0 }
//     mut ilength := 1.0 / length
    
//     new_axis.x *= ilength
//     new_axis.y *= ilength
//     new_axis.z *= ilength
    
//     mut a := sinf(new_angle)
//     b := new_axis.x*a
//     c := new_axis.y*a
//     d := new_axis.z*a
//     a  = cosf(new_angle)
    
//     w := Vector3 { b, c, d }

//     // Vector3CrossProduct(w, v)
//     mut wv := Vector3 { w.y*v.z - w.z*v.y, w.z*v.x - w.x*v.z, w.x*v.y - w.y*v.x }

//     // Vector3CrossProduct(w, wv)
//     mut wwv := Vector3 { w.y*wv.z - w.z*wv.y, w.z*wv.x - w.x*wv.z, w.x*wv.y - w.y*wv.x }

//     // Vector3Scale(wv, 2*a)
//     a    *= 2
//     wv.x *= a
//     wv.y *= a
//     wv.z *= a

//     // Vector3Scale(wwv, 2)
//     wwv.x *= 2
//     wwv.y *= 2
//     wwv.z *= 2

//     result.x += wv.x
//     result.y += wv.y
//     result.z += wv.z

//     result.x += wwv.x
//     result.y += wwv.y
//     result.z += wwv.z

//     return result
// }

// // Move Vector towards target
// pub fn Vector3.move_towards(v Vector3, target Vector3, max_distance f32) Vector3 {
//     mut result := Vector3 {}

//     dx    := target.x - v.x
//     dy    := target.y - v.y
//     dz    := target.z - v.z
//     value := (dx*dx) + (dy*dy) + (dz*dz)

//     if (value == 0) || ((max_distance >= 0) && (value <= max_distance*max_distance)) {
//         return target    
//     }

//     dist := sqrtf(value)

//     result.x = v.x + dx/dist*max_distance
//     result.y = v.y + dy/dist*max_distance
//     result.z = v.z + dz/dist*max_distance

//     return result
// }

// // Calculate linear interpolation between two vectors
// @[inline]
// pub fn Vector3.lerp(v1 Vector3, v2 Vector3, amount f32) Vector3 {
//     return Vector3 {
//         v1.x + amount*(v2.x - v1.x),
//         v1.y + amount*(v2.y - v1.y),
//         v1.z + amount*(v2.z - v1.z)
//     }
// }

// // Calculate reflected vector to normal
// pub fn Vector3.reflect(v Vector3, normal Vector3) Vector3 {
//     dot := Vector3.dot(v, normal)

//     return Vector3 {
//         v.x - (2.0*normal.x)*dot
//         v.y - (2.0*normal.y)*dot
//         v.z - (2.0*normal.z)*dot
//     }
// }

// // Get min value for each pair of components
// pub fn Vector3.min(v1 Vector3, v2 Vector3) Vector3 {
//     return Vector3 {
//         fminf(v1.x, v2.x),
//         fminf(v1.y, v2.y),
//         fminf(v1.z, v2.z)
//     }
// }

// // Get max value for each pair of components
// pub fn Vector3.max(v1 Vector3, v2 Vector3) Vector3 {
//     return Vector3 {
//         fmaxf(v1.x, v2.x),
//         fmaxf(v1.y, v2.y),
//         fmaxf(v1.z, v2.z)
//     }
// }

// // Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
// // NOTE: Assumes P is on the plane of the triangle
// pub fn Vector3.barycenter(p Vector3, a Vector3, b Vector3, c Vector3) Vector3 {
//     // Vector3 result = { 0 }
//     v0 := Vector3 { b.x - a.x, b.y - a.y, b.z - a.z } // Vector3Subtract(b, a)
//     v1 := Vector3 { c.x - a.x, c.y - a.y, c.z - a.z } // Vector3Subtract(c, a)
//     v2 := Vector3 { p.x - a.x, p.y - a.y, p.z - a.z } // Vector3Subtract(p, a)

//     d00 := (v0.x*v0.x + v0.y*v0.y + v0.z*v0.z)        // Vector3DotProduct(v0, v0)
//     d01 := (v0.x*v1.x + v0.y*v1.y + v0.z*v1.z)        // Vector3DotProduct(v0, v1)
//     d11 := (v1.x*v1.x + v1.y*v1.y + v1.z*v1.z)        // Vector3DotProduct(v1, v1)
//     d20 := (v2.x*v0.x + v2.y*v0.y + v2.z*v0.z)        // Vector3DotProduct(v2, v0)
//     d21 := (v2.x*v1.x + v2.y*v1.y + v2.z*v1.z)        // Vector3DotProduct(v2, v1)

//     denom := d00*d11 - d01*d01

//     return Vector3 {
//         (d11*d20 - d01*d21)/denom,
//         (d00*d21 - d01*d20)/denom,
//         1.0 // 1.0f - (result.z + result.y)
//     }
// }

// // Projects a Vector3 from screen space into object space
// // NOTE: We are avoiding calling other raymath functions despite available
// pub fn Vector3.unproject(source Vector3, projection Matrix, view Matrix) Vector3 {
//     // Calculate unprojected matrix (multiply view matrix by projection matrix) and invert it
//     mat_view_proj := Matrix {      // MatrixMultiply(view, projection);
//         view.m0*projection.m0  + view.m1*projection.m4  + view.m2*projection.m8   + view.m3*projection.m12,
//         view.m0*projection.m1  + view.m1*projection.m5  + view.m2*projection.m9   + view.m3*projection.m13,
//         view.m0*projection.m2  + view.m1*projection.m6  + view.m2*projection.m10  + view.m3*projection.m14,
//         view.m0*projection.m3  + view.m1*projection.m7  + view.m2*projection.m11  + view.m3*projection.m15,
//         view.m4*projection.m0  + view.m5*projection.m4  + view.m6*projection.m8   + view.m7*projection.m12,
//         view.m4*projection.m1  + view.m5*projection.m5  + view.m6*projection.m9   + view.m7*projection.m13,
//         view.m4*projection.m2  + view.m5*projection.m6  + view.m6*projection.m10  + view.m7*projection.m14,
//         view.m4*projection.m3  + view.m5*projection.m7  + view.m6*projection.m11  + view.m7*projection.m15,
//         view.m8*projection.m0  + view.m9*projection.m4  + view.m10*projection.m8  + view.m11*projection.m12,
//         view.m8*projection.m1  + view.m9*projection.m5  + view.m10*projection.m9  + view.m11*projection.m13,
//         view.m8*projection.m2  + view.m9*projection.m6  + view.m10*projection.m10 + view.m11*projection.m14,
//         view.m8*projection.m3  + view.m9*projection.m7  + view.m10*projection.m11 + view.m11*projection.m15,
//         view.m12*projection.m0 + view.m13*projection.m4 + view.m14*projection.m8  + view.m15*projection.m12,
//         view.m12*projection.m1 + view.m13*projection.m5 + view.m14*projection.m9  + view.m15*projection.m13,
//         view.m12*projection.m2 + view.m13*projection.m6 + view.m14*projection.m10 + view.m15*projection.m14,
//         view.m12*projection.m3 + view.m13*projection.m7 + view.m14*projection.m11 + view.m15*projection.m15
//     }

//     // Calculate inverted matrix -> MatrixInvert(mat_view_proj);
//     // Cache the matrix values (speed optimization)
//     a00 := mat_view_proj.m0        a01 := mat_view_proj.m1       a02 := mat_view_proj.m2       a03 := mat_view_proj.m3
//     a10 := mat_view_proj.m4        a11 := mat_view_proj.m5       a12 := mat_view_proj.m6       a13 := mat_view_proj.m7
//     a20 := mat_view_proj.m8        a21 := mat_view_proj.m9       a22 := mat_view_proj.m10      a23 := mat_view_proj.m11
//     a30 := mat_view_proj.m12       a31 := mat_view_proj.m13      a32 := mat_view_proj.m14      a33 := mat_view_proj.m15

//     b00 := a00*a11 - a01*a10
//     b01 := a00*a12 - a02*a10
//     b02 := a00*a13 - a03*a10
//     b03 := a01*a12 - a02*a11
//     b04 := a01*a13 - a03*a11
//     b05 := a02*a13 - a03*a12
//     b06 := a20*a31 - a21*a30
//     b07 := a20*a32 - a22*a30
//     b08 := a20*a33 - a23*a30
//     b09 := a21*a32 - a22*a31
//     b10 := a21*a33 - a23*a31
//     b11 := a22*a33 - a23*a32

//     // Calculate the invert determinant (inlined to avoid double-caching)
//     inv_det := 1.0/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06)

//     mat_view_proj_inv := Matrix {
//         ( a11*b11 - a12*b10 + a13*b09)*inv_det,
//         (-a01*b11 + a02*b10 - a03*b09)*inv_det,
//         ( a31*b05 - a32*b04 + a33*b03)*inv_det,
//         (-a21*b05 + a22*b04 - a23*b03)*inv_det,
//         (-a10*b11 + a12*b08 - a13*b07)*inv_det,
//         ( a00*b11 - a02*b08 + a03*b07)*inv_det,
//         (-a30*b05 + a32*b02 - a33*b01)*inv_det,
//         ( a20*b05 - a22*b02 + a23*b01)*inv_det,
//         ( a10*b10 - a11*b08 + a13*b06)*inv_det,
//         (-a00*b10 + a01*b08 - a03*b06)*inv_det,
//         ( a30*b04 - a31*b02 + a33*b00)*inv_det,
//         (-a20*b04 + a21*b02 - a23*b00)*inv_det,
//         (-a10*b09 + a11*b07 - a12*b06)*inv_det,
//         ( a00*b09 - a01*b07 + a02*b06)*inv_det,
//         (-a30*b03 + a31*b01 - a32*b00)*inv_det,
//         ( a20*b03 - a21*b01 + a22*b00)*inv_det
//     }
    
//     // Create quaternion from source point
//     quat := Quaternion { source.x, source.y, source.z, 1.0 }

//     // Multiply quat point by unprojecte matrix
//     qtransformed := Quaternion {     // QuaternionTransform(quat, mat_view_proj_inv)
//         mat_view_proj_inv.m0*quat.x + mat_view_proj_inv.m4*quat.y + mat_view_proj_inv.m8*quat.z + mat_view_proj_inv.m12*quat.w,
//         mat_view_proj_inv.m1*quat.x + mat_view_proj_inv.m5*quat.y + mat_view_proj_inv.m9*quat.z + mat_view_proj_inv.m13*quat.w,
//         mat_view_proj_inv.m2*quat.x + mat_view_proj_inv.m6*quat.y + mat_view_proj_inv.m10*quat.z + mat_view_proj_inv.m14*quat.w,
//         mat_view_proj_inv.m3*quat.x + mat_view_proj_inv.m7*quat.y + mat_view_proj_inv.m11*quat.z + mat_view_proj_inv.m15*quat.w }

//     // Normalized world points in vectors
//     return Vector3 {
//         qtransformed.x/qtransformed.w
//         qtransformed.y/qtransformed.w
//         qtransformed.z/qtransformed.w
//     }
// }

// // Get Vector3 as float array
// @[inline]
// pub fn Vector3.to_float_v(v Vector3) [3]f32 {
//     return [v.x, v.y, v.z]!
// }

// // Invert the given vector
// @[inline]
// pub fn Vector3.invert(v Vector3) Vector3 {
//     return Vector3 { 1.0/v.x, 1.0/v.y, 1.0/v.z }
// }

// // Clamp the components of the vector between
// // min and max values specified by the given vectors
// pub fn Vector3.clamp(v Vector3, min Vector3, max Vector3) Vector3 {
//     return Vector3 {
//         fminf(max.x, fmaxf(min.x, v.x)),
//         fminf(max.y, fmaxf(min.y, v.y)),
//         fminf(max.z, fmaxf(min.z, v.z))
//     }
// }

// // Clamp the magnitude of the vector between two values
// pub fn Vector3.clamp_value(v Vector3, min f32, max f32) Vector3 {
//     mut result := v
//     mut length := (v.x*v.x) + (v.y*v.y) + (v.z*v.z)
//     if length > 0.0 {
//         length = f32(math.sqrt(length))

//         if length < min {
//             scale := min/length
//             result.x = v.x*scale
//             result.y = v.y*scale
//             result.z = v.z*scale
//         } else if length > max {
//             scale := max/length
//             result.x = v.x*scale
//             result.y = v.y*scale
//             result.z = v.z*scale
//         }
//     }
//     return result
// }

// // Check whether two given vectors are almost equal
// pub fn Vector3.equals(p Vector3, q Vector3) bool {
//     return ((fabsf(p.x - q.x)) <= (epsilon*fmaxf(1.0, fmaxf(fabsf(p.x), fabsf(q.x))))) &&
//            ((fabsf(p.y - q.y)) <= (epsilon*fmaxf(1.0, fmaxf(fabsf(p.y), fabsf(q.y))))) &&
//            ((fabsf(p.z - q.z)) <= (epsilon*fmaxf(1.0, fmaxf(fabsf(p.z), fabsf(q.z)))))
// }

// pub fn (q1 Vector3) == (q2 Vector3) bool {
//     return Vector3.equals(q1, q2)
// }


// // Compute the direction of a refracted ray
// // v: normalized direction of the incoming ray
// // n: normalized normal vector of the interface of two optical media
// // r: ratio of the refractive index of the medium from where the ray comes
// //    to the refractive index of the medium on the other side of the surface
// pub fn Vector3.refract(v Vector3, n Vector3, r f32) Vector3 {
//     mut result := Vector3 {}
//     dot := v.x*n.x + v.y*n.y + v.z*n.z
//     mut d := 1.0 - r*r*(1.0 - dot*dot)

//     if d >= 0.0 {
//         d = f32(math.sqrt(d))
//         result.x = r*v.x - (r*dot + d)*n.x
//         result.y = r*v.y - (r*dot + d)*n.y
//         result.z = r*v.z - (r*dot + d)*n.z
//     }

//     return result
// }


// //----------------------------------------------------------------------------------
// // Module Functions Definition - Matrix math
// //----------------------------------------------------------------------------------

// // Compute matrix determinant
// pub fn Matrix.determinant(mat Matrix) f32 {
//     // Cache the matrix values (speed optimization)
//     a00 := mat.m0       a01 := mat.m1       a02 := mat.m2        a03 := mat.m3
//     a10 := mat.m4       a11 := mat.m5       a12 := mat.m6        a13 := mat.m7
//     a20 := mat.m8       a21 := mat.m9       a22 := mat.m10       a23 := mat.m11
//     a30 := mat.m12      a31 := mat.m13      a32 := mat.m14       a33 := mat.m15

//     return a30*a21*a12*a03 - a20*a31*a12*a03 - a30*a11*a22*a03 + a10*a31*a22*a03 +
//            a20*a11*a32*a03 - a10*a21*a32*a03 - a30*a21*a02*a13 + a20*a31*a02*a13 +
//            a30*a01*a22*a13 - a00*a31*a22*a13 - a20*a01*a32*a13 + a00*a21*a32*a13 +
//            a30*a11*a02*a23 - a10*a31*a02*a23 - a30*a01*a12*a23 + a00*a31*a12*a23 +
//            a10*a01*a32*a23 - a00*a11*a32*a23 - a20*a11*a02*a33 + a10*a21*a02*a33 +
//            a20*a01*a12*a33 - a00*a21*a12*a33 - a10*a01*a22*a33 + a00*a11*a22*a33
// }

// // Get the trace of the matrix (sum of the values along the diagonal)
// @[inline]
// pub fn Matrix.trace(mat Matrix) f32 {
//     return (mat.m0 + mat.m5 + mat.m10 + mat.m15)
// }

// // Transposes provided matrix
// @[inline]
// pub fn Matrix.transpose(mat Matrix) Matrix {
//     return Matrix {
//         mat.m0      mat.m4       mat.m8         mat.m12
//         mat.m1      mat.m5       mat.m9         mat.m13
//         mat.m2      mat.m6       mat.m10        mat.m14
//         mat.m3      mat.m7       mat.m11        mat.m15
//     }
// }

// // Invert provided matrix
// pub fn Matrix.invert(mat Matrix) Matrix {
//     // Cache the matrix values (speed optimization)
//     a00 := mat.m0       a01 := mat.m1       a02 := mat.m2       a03 := mat.m3
//     a10 := mat.m4       a11 := mat.m5       a12 := mat.m6       a13 := mat.m7
//     a20 := mat.m8       a21 := mat.m9       a22 := mat.m10      a23 := mat.m11
//     a30 := mat.m12      a31 := mat.m13      a32 := mat.m14      a33 := mat.m15

//     b00 := a00*a11 - a01*a10
//     b01 := a00*a12 - a02*a10
//     b02 := a00*a13 - a03*a10
//     b03 := a01*a12 - a02*a11
//     b04 := a01*a13 - a03*a11
//     b05 := a02*a13 - a03*a12
//     b06 := a20*a31 - a21*a30
//     b07 := a20*a32 - a22*a30
//     b08 := a20*a33 - a23*a30
//     b09 := a21*a32 - a22*a31
//     b10 := a21*a33 - a23*a31
//     b11 := a22*a33 - a23*a32

//     // Calculate the invert determinant (inlined to avoid double-caching)
//     inv_det := 1.0/(b00*b11 - b01*b10 + b02*b09 + b03*b08 - b04*b07 + b05*b06)

//     return Matrix {
//         ( a11*b11 - a12*b10 + a13*b09)*inv_det,
//         (-a01*b11 + a02*b10 - a03*b09)*inv_det,
//         ( a31*b05 - a32*b04 + a33*b03)*inv_det,
//         (-a21*b05 + a22*b04 - a23*b03)*inv_det,
//         (-a10*b11 + a12*b08 - a13*b07)*inv_det,
//         ( a00*b11 - a02*b08 + a03*b07)*inv_det,
//         (-a30*b05 + a32*b02 - a33*b01)*inv_det,
//         ( a20*b05 - a22*b02 + a23*b01)*inv_det,
//         ( a10*b10 - a11*b08 + a13*b06)*inv_det,
//         (-a00*b10 + a01*b08 - a03*b06)*inv_det,
//         ( a30*b04 - a31*b02 + a33*b00)*inv_det,
//         (-a20*b04 + a21*b02 - a23*b00)*inv_det,
//         (-a10*b09 + a11*b07 - a12*b06)*inv_det,
//         ( a00*b09 - a01*b07 + a02*b06)*inv_det,
//         (-a30*b03 + a31*b01 - a32*b00)*inv_det,
//         ( a20*b03 - a21*b01 + a22*b00)*inv_det
//     }
// }

// // Get identity matrix
// @[inline]
// pub fn Matrix.identity() Matrix {
//     return Matrix {
//         1.0, 0.0, 0.0, 0.0,
//         0.0, 1.0, 0.0, 0.0,
//         0.0, 0.0, 1.0, 0.0,
//         0.0, 0.0, 0.0, 1.0
//     }
// }

// // Add two matrices
// pub fn Matrix.add(left Matrix, right Matrix) Matrix {
//     return Matrix {
//         left.m0  + right.m0,
//         left.m1  + right.m1,
//         left.m2  + right.m2,
//         left.m3  + right.m3,
//         left.m4  + right.m4,
//         left.m5  + right.m5,
//         left.m6  + right.m6,
//         left.m7  + right.m7,
//         left.m8  + right.m8,
//         left.m9  + right.m9,
//         left.m10 + right.m10,
//         left.m11 + right.m11,
//         left.m12 + right.m12,
//         left.m13 + right.m13,
//         left.m14 + right.m14,
//         left.m15 + right.m15
//     }
// }

// pub fn (m1 Matrix) + (m2 Matrix) Matrix {
//     return Matrix.add(m1, m2)
// }


// // Subtract two matrices (left - right)
// pub fn Matrix.subtract(left Matrix, right Matrix) Matrix {
//     return Matrix {
//         left.m0  - right.m0,
//         left.m1  - right.m1,
//         left.m2  - right.m2,
//         left.m3  - right.m3,
//         left.m4  - right.m4,
//         left.m5  - right.m5,
//         left.m6  - right.m6,
//         left.m7  - right.m7,
//         left.m8  - right.m8,
//         left.m9  - right.m9,
//         left.m10 - right.m10,
//         left.m11 - right.m11,
//         left.m12 - right.m12,
//         left.m13 - right.m13,
//         left.m14 - right.m14,
//         left.m15 - right.m15
//     }
// }

// pub fn (m1 Matrix) - (m2 Matrix) Matrix {
//     return Matrix.subtract(m1, m2)
// }

// // Get two matrix multiplication
// // NOTE: When multiplying matrices... the order matters!
// @[inline]
// pub fn Matrix.multiply(left Matrix, right Matrix) Matrix {
//     mut result := Matrix {}

//     result.m0  = left.m0*right.m0  + left.m1*right.m4  + left.m2*right.m8   + left.m3*right.m12
//     result.m1  = left.m0*right.m1  + left.m1*right.m5  + left.m2*right.m9   + left.m3*right.m13
//     result.m2  = left.m0*right.m2  + left.m1*right.m6  + left.m2*right.m10  + left.m3*right.m14
//     result.m3  = left.m0*right.m3  + left.m1*right.m7  + left.m2*right.m11  + left.m3*right.m15
//     result.m4  = left.m4*right.m0  + left.m5*right.m4  + left.m6*right.m8   + left.m7*right.m12
//     result.m5  = left.m4*right.m1  + left.m5*right.m5  + left.m6*right.m9   + left.m7*right.m13
//     result.m6  = left.m4*right.m2  + left.m5*right.m6  + left.m6*right.m10  + left.m7*right.m14
//     result.m7  = left.m4*right.m3  + left.m5*right.m7  + left.m6*right.m11  + left.m7*right.m15
//     result.m8  = left.m8*right.m0  + left.m9*right.m4  + left.m10*right.m8  + left.m11*right.m12
//     result.m9  = left.m8*right.m1  + left.m9*right.m5  + left.m10*right.m9  + left.m11*right.m13
//     result.m10 = left.m8*right.m2  + left.m9*right.m6  + left.m10*right.m10 + left.m11*right.m14
//     result.m11 = left.m8*right.m3  + left.m9*right.m7  + left.m10*right.m11 + left.m11*right.m15
//     result.m12 = left.m12*right.m0 + left.m13*right.m4 + left.m14*right.m8  + left.m15*right.m12
//     result.m13 = left.m12*right.m1 + left.m13*right.m5 + left.m14*right.m9  + left.m15*right.m13
//     result.m14 = left.m12*right.m2 + left.m13*right.m6 + left.m14*right.m10 + left.m15*right.m14
//     result.m15 = left.m12*right.m3 + left.m13*right.m7 + left.m14*right.m11 + left.m15*right.m15

//     return result
// }

// pub fn (m1 Matrix) * (m2 Matrix) Matrix {
//     return Matrix.multiply(m1, m2)
// }

// // Get translation matrix
// @[inline]
// pub fn Matrix.translate(x f32, y f32, z f32) Matrix {
//     return Matrix {
//         1.0, 0.0, 0.0, x,
//         0.0, 1.0, 0.0, y,
//         0.0, 0.0, 1.0, z,
//         0.0, 0.0, 0.0, 1.0
//     }
// }

// // Create rotation matrix from axis and angle
// // NOTE: Angle should be provided in radians
// pub fn Matrix.rotate(axis Vector3, angle f32) Matrix {
//     mut result := Matrix {}

//     mut x := axis.x
//     mut y := axis.y
//     mut z := axis.z

//     length_squared := x*x + y*y + z*z

//     if (length_squared != 1.0) && (length_squared != 0.0) {
//         ilength := 1.0/f32(math.sqrt(length_squared))
//         x *= ilength
//         y *= ilength
//         z *= ilength
//     }

//     sinres := sinf(angle)
//     cosres := cosf(angle)
//     t      := 1.0 - cosres

//     result.m0  = x*x*t + cosres
//     result.m1  = y*x*t + z*sinres
//     result.m2  = z*x*t - y*sinres
//     result.m3  = 0.0

//     result.m4  = x*y*t - z*sinres
//     result.m5  = y*y*t + cosres
//     result.m6  = z*y*t + x*sinres
//     result.m7  = 0.0

//     result.m8  = x*z*t + y*sinres
//     result.m9  = y*z*t - x*sinres
//     result.m10 = z*z*t + cosres
//     result.m11 = 0.0

//     result.m12 = 0.0
//     result.m13 = 0.0
//     result.m14 = 0.0
//     result.m15 = 1.0

//     return result
// }

// // Get x-rotation matrix
// // NOTE: Angle must be provided in radians
// pub fn Matrix.rotate_x(angle f32) Matrix {
//     mut result := Matrix.identity() // MatrixIdentity()

//     cosres := cosf(angle)
//     sinres := sinf(angle)

//     result.m5  =  cosres
//     result.m6  =  sinres
//     result.m9  = -sinres
//     result.m10 =  cosres

//     return result
// }

// // Get y-rotation matrix
// // NOTE: Angle must be provided in radians
// pub fn Matrix.rotate_y(angle f32) Matrix {
//     mut result := Matrix.identity()  // MatrixIdentity()

//     cosres := cosf(angle)
//     sinres := sinf(angle)

//     result.m0  =  cosres
//     result.m2  = -sinres
//     result.m8  =  sinres
//     result.m10 =  cosres

//     return result
// }

// // Get z-rotation matrix
// // NOTE: Angle must be provided in radians
// pub fn Matrix.rotate_z(angle f32) Matrix {
//     mut result := Matrix.identity()  // MatrixIdentity()

//     cosres := cosf(angle)
//     sinres := sinf(angle)

//     result.m0 =  cosres
//     result.m1 =  sinres
//     result.m4 = -sinres
//     result.m5 =  cosres

//     return result
// }


// // Get xyz-rotation matrix
// // NOTE: Angle must be provided in radians
// pub fn Matrix.rotate_xyz(angle Vector3) Matrix {
//     mut result := Matrix.identity()  // MatrixIdentity()

//     cosz := cosf(-angle.z)
//     sinz := sinf(-angle.z)
//     cosy := cosf(-angle.y)
//     siny := sinf(-angle.y)
//     cosx := cosf(-angle.x)
//     sinx := sinf(-angle.x)

//     result.m0  = cosz*cosy
//     result.m1  = (cosz*siny*sinx) - (sinz*cosx)
//     result.m2  = (cosz*siny*cosx) + (sinz*sinx)

//     result.m4  = sinz*cosy
//     result.m5  = (sinz*siny*sinx) + (cosz*cosx)
//     result.m6  = (sinz*siny*cosx) - (cosz*sinx)

//     result.m8  = -siny
//     result.m9  = cosy*sinx
//     result.m10 = cosy*cosx

//     return result
// }

// // Get zyx-rotation matrix
// // NOTE: Angle must be provided in radians
// pub fn Matrix.rotate_zyx(angle Vector3) Matrix {
//     mut result := Matrix{}

//     cz := cosf(angle.z)
//     sz := sinf(angle.z)
//     cy := cosf(angle.y)
//     sy := sinf(angle.y)
//     cx := cosf(angle.x)
//     sx := sinf(angle.x)

//     result.m0  = cz*cy
//     result.m4  = cz*sy*sx - cx*sz
//     result.m8  = sz*sx + cz*cx*sy
//     result.m12 = 0

//     result.m1  = cy*sz
//     result.m5  = cz*cx + sz*sy*sx
//     result.m9  = cx*sz*sy - cz*sx
//     result.m13 = 0

//     result.m2  = -sy
//     result.m6  = cy*sx
//     result.m10 = cy*cx
//     result.m14 = 0

//     result.m3  = 0
//     result.m7  = 0
//     result.m11 = 0
//     result.m15 = 1

//     return result
// }

// // Get scaling matrix
// pub fn Matrix.scale(x f32, y f32, z f32) Matrix { 
//     return Matrix {
//         x,   0.0, 0.0, 0.0,
//         0.0, y,   0.0, 0.0,
//         0.0, 0.0, z,   0.0,
//         0.0, 0.0, 0.0, 1.0
//     }
// }

// // Get perspective projection matrix
// pub fn Matrix.frustum(left f64, right f64, bottom f64, top f64, near f64, far f64) Matrix {
//     mut result := Matrix {}

//     rt_lf := f32(right - left)
//     tp_bt := f32(top   - bottom)
//     fr_nr := f32(far   - near)

//     result.m0 = (f32(near)*2.0)/rt_lf
//     result.m1 = 0.0
//     result.m2 = 0.0
//     result.m3 = 0.0

//     result.m4 = 0.0
//     result.m5 = f32(near)*2.0/tp_bt
//     result.m6 = 0.0
//     result.m7 = 0.0

//     result.m8  =  (f32(right) + f32(left))  /rt_lf
//     result.m9  =  (f32(top)   + f32(bottom))/tp_bt
//     result.m10 = -(f32(far)   + f32(near))  /fr_nr
//     result.m11 = -1.0

//     result.m12 = 0.0
//     result.m13 = 0.0
//     result.m14 = -(f32(far)*f32(near)*2.0)/fr_nr
//     result.m15 = 0.0

//     return result
// }

// // Get perspective projection matrix
// // NOTE: Fovy angle must be provided in radians
// pub fn Matrix.perspective(fov_y f64, aspect f64, near_plane f64, far_plane f64) Matrix {
//     mut result := Matrix {}

//     top    := near_plane*tan(f32(fov_y*0.5))
//     bottom := -top
//     right  := top*aspect
//     left   := -right

//     // MatrixFrustum(-right, right, -top, top, near, far)
//     rt_lt := f32(right     - left)
//     tp_bt := f32(top       - bottom)
//     fr_nr := f32(far_plane - near_plane)

//     result.m0 = (f32(near_plane)*2.0)/rt_lt
//     result.m5 = (f32(near_plane)*2.0)/tp_bt
//     result.m8 = (f32(right) + f32(left))/rt_lt
//     result.m9 = (f32(top)   + f32(bottom))/tp_bt
//     result.m10 = -(f32(far_plane) + f32(near_plane))/fr_nr
//     result.m11 = -1.0
//     result.m14 = -(f32(far_plane)*f32(near_plane)*2.0)/fr_nr

//     return result
// }

// // Get orthographic projection matrix
// pub fn Matrix.ortho(left f64, right f64, bottom f64, top f64, near_plane f64, far_plane f64) Matrix {
//     mut result := Matrix {}

//     rt_lt := f32(right     - left)
//     tp_bt := f32(top       - bottom)
//     fr_nr := f32(far_plane - near_plane)

//     result.m0  =  2.0/rt_lt
//     result.m1  =  0.0
//     result.m2  =  0.0
//     result.m3  =  0.0
//     result.m4  =  0.0
//     result.m5  =  2.0/tp_bt
//     result.m6  =  0.0
//     result.m7  =  0.0
//     result.m8  =  0.0
//     result.m9  =  0.0
//     result.m10 = -2.0/fr_nr
//     result.m11 =  0.0
//     result.m12 = -(f32(left) + f32(right))/rt_lt
//     result.m13 = -(f32(top) + f32(bottom))/tp_bt
//     result.m14 = -(f32(far_plane) + f32(near_plane))/fr_nr
//     result.m15 = 1.0

//     return result
// }

// // Get camera look-at matrix (view matrix)
// pub fn Matrix.look_at(eye Vector3, target Vector3, up Vector3) Matrix {
//     mut result := Matrix {}

//     mut length  := f32(0.0)
//     mut ilength := f32(0.0)

//     // Vector3Subtract(eye, target)
//     mut vz := Vector3 { eye.x - target.x, eye.y - target.y, eye.z - target.z }

//     // Vector3Normalize(vz)
//     mut v := vz
//     length = sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
//     if length == 0.0 { length = 1.0 }
//     ilength = 1.0/length

//     vz.x *= ilength
//     vz.y *= ilength
//     vz.z *= ilength

//     // Vector3CrossProduct(up, vz)
//     mut vx := Vector3 { up.y*vz.z - up.z*vz.y, up.z*vz.x - up.x*vz.z, up.x*vz.y - up.y*vz.x }

//     // Vector3Normalize(x)
//     v = vx
//     length = sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
//     if length == 0.0 { length = 1.0 }
//     ilength = 1.0/length
//     vx.x *= ilength
//     vx.y *= ilength
//     vx.z *= ilength

//     // Vector3CrossProduct(vz, vx)
//     vy := Vector3 { vz.y*vx.z - vz.z*vx.y, vz.z*vx.x - vz.x*vx.z, vz.x*vx.y - vz.y*vx.x }

//     result.m0  = vx.x
//     result.m1  = vy.x
//     result.m2  = vz.x
//     result.m3  = 0.0
//     result.m4  = vx.y
//     result.m5  = vy.y
//     result.m6  = vz.y
//     result.m7  = 0.0
//     result.m8  = vx.z
//     result.m9  = vy.z
//     result.m10 = vz.z
//     result.m11 = 0.0
//     result.m12 = -(vx.x*eye.x + vx.y*eye.y + vx.z*eye.z)   // Vector3DotProduct(vx, eye)
//     result.m13 = -(vy.x*eye.x + vy.y*eye.y + vy.z*eye.z)   // Vector3DotProduct(vy, eye)
//     result.m14 = -(vz.x*eye.x + vz.y*eye.y + vz.z*eye.z)   // Vector3DotProduct(vz, eye)
//     result.m15 = 1.0

//     return result
// }

// // Get float array of matrix data
// pub fn Matrix.to_float_v(mat Matrix) [16]f32 {
//     mut result := [16]f32{}

//     result[0]  = mat.m0
//     result[1]  = mat.m1
//     result[2]  = mat.m2
//     result[3]  = mat.m3
//     result[4]  = mat.m4
//     result[5]  = mat.m5
//     result[6]  = mat.m6
//     result[7]  = mat.m7
//     result[8]  = mat.m8
//     result[9]  = mat.m9
//     result[10] = mat.m10
//     result[11] = mat.m11
//     result[12] = mat.m12
//     result[13] = mat.m13
//     result[14] = mat.m14
//     result[15] = mat.m15

//     return result
// }



// //----------------------------------------------------------------------------------
// // Module Functions Definition - Quaternion math
// //----------------------------------------------------------------------------------

// // Add two quaternions
// @[inline]
// pub fn Quaternion.add(q1 Quaternion, q2 Quaternion) Quaternion {
//     return Quaternion { q1.x + q2.x, q1.y + q2.y, q1.z + q2.z, q1.w + q2.w }
// }

// pub fn (q1 Quaternion) + (q2 Quaternion) Quaternion {
//     return Quaternion.add(q1, q2)
// }

// // Add quaternion and float value
// @[inline]
// pub fn Quaternion.add_value(q Quaternion, add f32) Quaternion {
//     return Quaternion { q.x + add, q.y + add, q.z + add, q.w + add }
// }

// // Subtract two quaternions
// @[inline]
// pub fn Quaternion.subtract(q1 Quaternion, q2 Quaternion) Quaternion {
//     return Quaternion { q1.x - q2.x, q1.y - q2.y, q1.z - q2.z, q1.w - q2.w }
// }

// pub fn (q1 Quaternion) - (q2 Quaternion) Quaternion {
//     return Quaternion.subtract(q1, q2)
// }

// // Subtract quaternion and float value
// @[inline]
// pub fn Quaternion.subtract_value(q Quaternion, sub f32) Quaternion {
//     return Quaternion { q.x - sub, q.y - sub, q.z - sub, q.w - sub }
// }

// // Get identity quaternion
// @[inline]
// pub fn Quaternion.identity() Quaternion {
//     return Quaternion { 0.0, 0.0, 0.0, 1.0 }
// }

// // Computes the length of a quaternion
// @[inline]
// pub fn Quaternion.length(q Quaternion) f32 {
//     return sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
// }

// // Normalize provided quaternion
// pub fn Quaternion.normalize(q Quaternion) Quaternion {
//     mut result := Quaternion {}
//     mut length := sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
    
//     if length == 0.0 { length = 1.0 }
//     ilength := 1.0/length

//     result.x = q.x*ilength
//     result.y = q.y*ilength
//     result.z = q.z*ilength
//     result.w = q.w*ilength

//     return result
// }

// // Invert provided quaternion
// pub fn Quaternion.invert(q Quaternion) Quaternion {
//     mut result := q

//     length_sq := q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w

//     if length_sq != 0.0 {
//         inv_length := 1.0/length_sq

//         result.x *= -inv_length
//         result.y *= -inv_length
//         result.z *= -inv_length
//         result.w *=  inv_length
//     }

//     return result
// }

// // Calculate two quaternion multiplication
// pub fn Quaternion.multiply(q1 Quaternion, q2 Quaternion) Quaternion {
//     mut result := Quaternion {}

//     qax := q1.x     qay := q1.y     qaz := q1.z     qaw := q1.w
//     qbx := q2.x     qby := q2.y     qbz := q2.z     qbw := q2.w

//     result.x = qax*qbw + qaw*qbx + qay*qbz - qaz*qby
//     result.y = qay*qbw + qaw*qby + qaz*qbx - qax*qbz
//     result.z = qaz*qbw + qaw*qbz + qax*qby - qay*qbx
//     result.w = qaw*qbw - qax*qbx - qay*qby - qaz*qbz

//     return result
// }

// pub fn (q1 Quaternion) * (q2 Quaternion) Quaternion {
//     return Quaternion.multiply(q1, q2)
// }


// // Scale quaternion by float value
// pub fn Quaternion.scale(q Quaternion, mul f32) Quaternion {
//     mut result := Quaternion {}

//     result.x = q.x*mul
//     result.y = q.y*mul
//     result.z = q.z*mul
//     result.w = q.w*mul

//     return result
// }

// // Divide two quaternions
// pub fn Quaternion.divide(q1 Quaternion, q2 Quaternion) Quaternion {
//     return Quaternion { q1.x/q2.x, q1.y/q2.y, q1.z/q2.z, q1.w/q2.w }
// }

// pub fn (q1 Quaternion) / (q2 Quaternion) Quaternion {
//     return Quaternion.divide(q1, q2)
// }

// // Calculate linear interpolation between two quaternions
// pub fn Quaternion.lerp(q1 Quaternion, q2 Quaternion, amount f32) Quaternion {
//     mut result := Quaternion {}

//     result.x = q1.x + amount*(q2.x - q1.x)
//     result.y = q1.y + amount*(q2.y - q1.y)
//     result.z = q1.z + amount*(q2.z - q1.z)
//     result.w = q1.w + amount*(q2.w - q1.w)

//     return result
// }

// // Calculate slerp-optimized interpolation between two quaternions
// pub fn Quaternion.nlerp(q1 Quaternion, q2 Quaternion, amount f32) Quaternion {
//     mut result := Quaternion {}

//     // QuaternionLerp(q1, q2, amount)
//     result.x = q1.x + amount*(q2.x - q1.x)
//     result.y = q1.y + amount*(q2.y - q1.y)
//     result.z = q1.z + amount*(q2.z - q1.z)
//     result.w = q1.w + amount*(q2.w - q1.w)

//     // QuaternionNormalize(q)
//     q := result
//     mut length := sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
//     if length == 0.0 { length = 1.0 }
//     ilength := 1.0/length

//     result.x = q.x*ilength
//     result.y = q.y*ilength
//     result.z = q.z*ilength
//     result.w = q.w*ilength

//     return result
// }

// // Calculates spherical linear interpolation between two quaternions
// pub fn Quaternion.slerp(q1 Quaternion, q2 Quaternion, amount f32) Quaternion {
//     mut result         := Quaternion {}
//     mut cos_half_theta := q1.x*q2.x + q1.y*q2.y + q1.z*q2.z + q1.w*q2.w
//     mut new_q2         := q2
    
//     if cos_half_theta < 0 {
//         // new_q2         = Quaternion.negative(new_q2)
//         new_q2 = Quaternion { -q2.x, -q2.y, -q2.z, -q2.w }
//         cos_half_theta = -cos_half_theta
//     }

//     if fabsf(cos_half_theta) >= 1.0 { result = q1 }
//     else if cos_half_theta > 0.95   { result = Quaternion.nlerp(q1, new_q2, amount) }
//     else {
//         half_theta     := acosf(cos_half_theta)
//         sin_half_theta := sqrtf(1.0 - cos_half_theta*cos_half_theta)

//         if fabsf(sin_half_theta) < epsilon {
//             result.x = (q1.x*0.5 + new_q2.x*0.5)
//             result.y = (q1.y*0.5 + new_q2.y*0.5)
//             result.z = (q1.z*0.5 + new_q2.z*0.5)
//             result.w = (q1.w*0.5 + new_q2.w*0.5)
//         } else {
//             ratio_a := sinf((1 - amount)*half_theta)/sin_half_theta
//             ratio_b := sinf(amount*half_theta)/sin_half_theta

//             result.x = (q1.x*ratio_a + new_q2.x*ratio_b)
//             result.y = (q1.y*ratio_a + new_q2.y*ratio_b)
//             result.z = (q1.z*ratio_a + new_q2.z*ratio_b)
//             result.w = (q1.w*ratio_a + new_q2.w*ratio_b)
//         }
//     }

//     return result
// }

// // Calculate quaternion based on the rotation from one vector to another
// pub fn Quaternion.from_vector3_to_vector3(from Vector3, to Vector3) Quaternion {
//     mut result := Quaternion {}

//     cos_2_theta := (from.x*to.x + from.y*to.y + from.z*to.z)                                                   // Vector3DotProduct(from, to)
//     cross       := Vector3 { from.y*to.z - from.z*to.y, from.z*to.x - from.x*to.z, from.x*to.y - from.y*to.x } // Vector3CrossProduct(from, to)

//     result.x = cross.x
//     result.y = cross.y
//     result.z = cross.z
//     result.w = 1.0 + cos_2_theta

//     // QuaternionNormalize(q)
//     // NOTE: Normalize to essentially nlerp the original and identity to 0.5
//     q := result
//     mut length := sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
//     if length == 0.0 { length = 1.0 }
//     ilength := 1.0/length

//     result.x = q.x*ilength
//     result.y = q.y*ilength
//     result.z = q.z*ilength
//     result.w = q.w*ilength

//     return result
// }

// // Get a quaternion for a given rotation matrix
// pub fn Quaternion.from_matrix(mat Matrix) Quaternion {
//     mut result := Quaternion {}

//     four_w_squared_minus_1 := mat.m0  + mat.m5 + mat.m10
//     four_x_squared_minus_1 := mat.m0  - mat.m5 - mat.m10
//     four_y_squared_minus_1 := mat.m5  - mat.m0 - mat.m10
//     four_z_squared_minus_1 := mat.m10 - mat.m0 - mat.m5

//     mut biggest_index                := int(0)
//     mut four_biggest_squared_minus_1 := four_w_squared_minus_1
//     if four_x_squared_minus_1 > four_biggest_squared_minus_1 {
//         four_biggest_squared_minus_1 = four_x_squared_minus_1
//         biggest_index                = 1
//     }

//     if four_y_squared_minus_1 > four_biggest_squared_minus_1 {
//         four_biggest_squared_minus_1 = four_y_squared_minus_1
//         biggest_index                = 2
//     }

//     if four_z_squared_minus_1 > four_biggest_squared_minus_1 {
//         four_biggest_squared_minus_1 = four_z_squared_minus_1
//         biggest_index                = 3
//     }

//     biggest_val := sqrtf(four_biggest_squared_minus_1 + 1.0)*0.5
//     mult        := 0.25 / biggest_val

//     match biggest_index {
//         0  {
//             result.w = biggest_val
//             result.x = (mat.m6 - mat.m9)*mult
//             result.y = (mat.m8 - mat.m2)*mult
//             result.z = (mat.m1 - mat.m4)*mult
//         }
//         1  {
//             result.x = biggest_val
//             result.w = (mat.m6 - mat.m9)*mult
//             result.y = (mat.m1 + mat.m4)*mult
//             result.z = (mat.m8 + mat.m2)*mult
//         }
//         2  {
//             result.y = biggest_val
//             result.w = (mat.m8 - mat.m2)*mult
//             result.x = (mat.m1 + mat.m4)*mult
//             result.z = (mat.m6 + mat.m9)*mult
//         }
//         3  {
//             result.z = biggest_val
//             result.w = (mat.m1 - mat.m4)*mult
//             result.x = (mat.m8 + mat.m2)*mult
//             result.y = (mat.m6 + mat.m9)*mult
//         }
//         else {}
//     }

//     return result
// }

// // Get a matrix for a given quaternion
// pub fn Quaternion.to_matrix(q Quaternion) Matrix {
//     mut result := Matrix.identity() // MatrixIdentity()

//     a2 := q.x*q.x
//     b2 := q.y*q.y
//     c2 := q.z*q.z
//     ac := q.x*q.z
//     ab := q.x*q.y
//     bc := q.y*q.z
//     ad := q.w*q.x
//     bd := q.w*q.y
//     cd := q.w*q.z

//     result.m0 = 1 - 2*(b2 + c2)
//     result.m1 = 2*(ab + cd)
//     result.m2 = 2*(ac - bd)

//     result.m4 = 2*(ab - cd)
//     result.m5 = 1 - 2*(a2 + c2)
//     result.m6 = 2*(bc + ad)

//     result.m8 = 2*(ac + bd)
//     result.m9 = 2*(bc - ad)
//     result.m10 = 1 - 2*(a2 + b2)

//     return result
// }

// // Get rotation quaternion for an angle and axis
// // NOTE: Angle must be provided in radians
// pub fn Quaternion.from_axis_angle(axis Vector3, angle f32) Quaternion {
//     mut result   := Quaternion { 0.0, 0.0, 0.0, 1.0 }
//     mut new_axis := axis

//     axis_length := sqrtf(axis.x*axis.x + axis.y*axis.y + axis.z*axis.z)

//     if axis_length != 0.0 {
//         half_angle  := angle * 0.5
//         // angle *= 0.5

//         mut length  := f32(0.0)
//         mut ilength := f32(0.0)

//         // Vector3Normalize(axis)
//         v := axis
//         length = sqrtf(v.x*v.x + v.y*v.y + v.z*v.z)
//         if length == 0.0 { length = 1.0 }
//         ilength = 1.0/length
        
//         new_axis.x *= ilength
//         new_axis.y *= ilength
//         new_axis.z *= ilength

//         sinres := sinf(half_angle)
//         cosres := cosf(half_angle)

//         result.x = new_axis.x*sinres
//         result.y = new_axis.y*sinres
//         result.z = new_axis.z*sinres
//         result.w = cosres

//         // QuaternionNormalize(q)
//         q := result
//         length = sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
//         if length == 0.0 { length = 1.0 }
//         ilength = 1.0/length
        
//         result.x = q.x*ilength
//         result.y = q.y*ilength
//         result.z = q.z*ilength
//         result.w = q.w*ilength
//     }

//     return result
// }

// // Get the rotation angle and axis for a given quaternion
// pub fn Quaternion.to_axis_angle(q Quaternion, mut out_axis &Vector3, mut out_angle &f32) {
//     mut new_q := q
//     if fabsf(q.w) > 1.0 {
//         // QuaternionNormalize(q)
//         mut length := sqrtf(q.x*q.x + q.y*q.y + q.z*q.z + q.w*q.w)
//         if length == 0.0 { length = 1.0 }
//         ilength := 1.0/length

//         new_q.x = new_q.x*ilength
//         new_q.y = new_q.y*ilength
//         new_q.z = new_q.z*ilength
//         new_q.w = new_q.w*ilength
//     }

//     mut res_axis  := Vector3 { 0.0, 0.0, 0.0 }
//     res_angle := 2.0*acosf(new_q.w)
//     den       := sqrtf(1.0 - new_q.w*new_q.w)

//     if den > epsilon {
//         res_axis.x = new_q.x/den
//         res_axis.y = new_q.y/den
//         res_axis.z = new_q.z/den
//     } else {
//         // This occurs when the angle is zero.
//         // Not a problem: just set an arbitrary normalized axis.
//         res_axis.x = 1.0
//     }

//     unsafe {
//         *out_axis  = res_axis
//         *out_angle = res_angle
//     }
// }

// // Get the quaternion equivalent to Euler angles
// // NOTE: Rotation order is ZYX
// pub fn Quaternion.from_euler(pitch f32, yaw f32, roll f32) Quaternion {
//     mut result := Quaternion {}

//     x0 := cosf(pitch*0.5)
//     x1 := sinf(pitch*0.5)
//     y0 := cosf(yaw  *0.5)
//     y1 := sinf(yaw  *0.5)
//     z0 := cosf(roll *0.5)
//     z1 := sinf(roll *0.5)

//     result.x = x1*y0*z0 - x0*y1*z1
//     result.y = x0*y1*z0 + x1*y0*z1
//     result.z = x0*y0*z1 - x1*y1*z0
//     result.w = x0*y0*z0 + x1*y1*z1

//     return result
// }

// // Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
// // NOTE: Angles are returned in a Vector3 struct in radians
// pub fn Quaternion.to_euler(q Quaternion) Vector3 {
//     mut result := Vector3 {}

//     // Roll (x-axis rotation)
//     x0 := 2.0 * (q.w*q.x + q.y*q.z)
//     x1 := 1.0 - 2.0*(q.x*q.x + q.y*q.y)
//     result.x = atan2f(x0, x1)

//     // Pitch (y-axis rotation)
//     mut y0 := 2.0*(q.w*q.y - q.z*q.x)
//     y0 = if y0 >  1.0 {  1.0 } // y0 := y0 >  1.0 ?  1.0 : y0
//     else if y0 < -1.0 { -1.0 } // y0 := y0 < -1.0 ? -1.0 : y0
//     else              {   y0 }

//     result.y = asinf(y0)

//     // Yaw (z-axis rotation)
//     z0 := 2.0*(q.w*q.z + q.x*q.y)
//     z1 := 1.0 - 2.0*(q.y*q.y + q.z*q.z)
//     result.z = atan2f(z0, z1)

//     return result
// }

// // Transform a quaternion given a transformation matrix
// pub fn Quaternion.transform(q Quaternion, mat Matrix) Quaternion {
//     mut result := Quaternion {}

//     result.x = mat.m0*q.x + mat.m4*q.y + mat.m8*q.z  + mat.m12*q.w
//     result.y = mat.m1*q.x + mat.m5*q.y + mat.m9*q.z  + mat.m13*q.w
//     result.z = mat.m2*q.x + mat.m6*q.y + mat.m10*q.z + mat.m14*q.w
//     result.w = mat.m3*q.x + mat.m7*q.y + mat.m11*q.z + mat.m15*q.w

//     return result
// }

// // Check whether two given quaternions are almost equal
// pub fn Quaternion.equals(p Quaternion, q Quaternion) bool {
//     return ((( fabsf(p.x - q.x)) <= (epsilon *fmaxf(1.0, fmaxf(fabsf(p.x), fabsf(q.x))) )) &&
//             (( fabsf(p.y - q.y)) <= (epsilon *fmaxf(1.0, fmaxf(fabsf(p.y), fabsf(q.y))) )) &&
//             (( fabsf(p.z - q.z)) <= (epsilon *fmaxf(1.0, fmaxf(fabsf(p.z), fabsf(q.z))) )) &&
//             (( fabsf(p.w - q.w)) <= (epsilon *fmaxf(1.0, fmaxf(fabsf(p.w), fabsf(q.w))) ))
//            ) ||
//            ((( fabsf(p.x + q.x)) <= (epsilon *fmaxf(1.0, fmaxf(fabsf(p.x), fabsf(q.x))) )) &&
//             (( fabsf(p.y + q.y)) <= (epsilon *fmaxf(1.0, fmaxf(fabsf(p.y), fabsf(q.y))) )) &&
//             (( fabsf(p.z + q.z)) <= (epsilon *fmaxf(1.0, fmaxf(fabsf(p.z), fabsf(q.z))) )) &&
//             (( fabsf(p.w + q.w)) <= (epsilon *fmaxf(1.0, fmaxf(fabsf(p.w), fabsf(q.w))) ))
//            )
// }

// pub fn (q1 Quaternion) == (q2 Quaternion) bool {
//     return Quaternion.equals(q1, q2)
// }

// // RAYMATH_H
