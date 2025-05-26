/**********************************************************************************************
pnp
*   rlgl v4.5 - A multi-OpenGL abstraction layer with an immediate-mode style API
*
*   DESCRIPTION:
*       An abstraction layer for multiple OpenGL versions (1.1, 2.1, 3.3 Core, 4.3 Core, ES 2.0)
*       that provides a pseudo-OpenGL 1.1 immediate-mode style API (rlVertex, rlTranslate, rlRotate...)
*
*   ADDITIONAL NOTES:
*       When choosing an OpenGL backend different than OpenGL 1.1, some internal buffer are
*       initialized on rlglInit() to accumulate vertex data.
*
*       When an internal state change is required all the stored vertex data is renderer in batch,
*       additionally, rlDrawRenderBatchActive() could be called to force flushing of the batch.
*
*       Some resources are also loaded for convenience, here the complete list:
*          - Default batch (RLGL.defaultBatch): RenderBatch system to accumulate vertex data
*          - Default texture (RLGL.defaultTextureId): 1x1 white pixel R8G8B8A8
*          - Default shader (RLGL.State.defaultShaderId, RLGL.State.defaultShaderLocs)
*
*       Internal buffer (and resources) must be manually unloaded calling rlglClose().
*
*   CONFIGURATION:
*       #define GRAPHICS_API_OPENGL_11
*       #define GRAPHICS_API_OPENGL_21
*       #define GRAPHICS_API_OPENGL_33
*       #define GRAPHICS_API_OPENGL_43
*       #define GRAPHICS_API_OPENGL_ES2
*       #define GRAPHICS_API_OPENGL_ES3
*           Use selected OpenGL graphics backend, should be supported by platform
*           Those preprocessor defines are only used on rlgl module, if OpenGL version is
*           required by any other module, use rlGetVersion() to check it
*
*       #define RLGL_IMPLEMENTATION
*           Generates the implementation of the library into the included file.
*           If not defined, the library is in header only mode and can be included in other headers
*           or source files without problems. But only ONE file should hold the implementation.
*
*       #define RLGL_RENDER_TEXTURES_HINT
*           Enable framebuffer objects (fbo) support (enabled by default)
*           Some GPUs could not support them despite the OpenGL version
*
*       #define RLGL_SHOW_GL_DETAILS_INFO
*           Show OpenGL extensions and capabilities detailed logs on init
*
*       #define RLGL_ENABLE_OPENGL_DEBUG_CONTEXT
*           Enable debug context (only available on OpenGL 4.3)
*
*       rlgl capabilities could be customized just defining some internal
*       values before library inclusion (default values listed):
*
*       #define rl_default_batch_buffer_elements   8192    // Default internal render batch elements limits
*       #define RL_DEFAULT_BATCH_BUFFERS              1    // Default number of batch buffers (multi-buffering)
*       #define RL_DEFAULT_BATCH_DRAWCALLS          256    // Default number of batch draw calls (by state changes: mode, texture)
*       #define RL_DEFAULT_BATCH_MAX_TEXTURE_UNITS    4    // Maximum number of textures units that can be activated on batch drawing (SetShaderValueTexture())
*
*       #define RL_MAX_MATRIX_STACK_SIZE             32    // Maximum size of internal Matrix stack
*       #define RL_MAX_SHADER_LOCATIONS              32    // Maximum number of shader locations supported
*       #define RL_CULL_DISTANCE_NEAR              0.01    // Default projection matrix near cull distance
*       #define RL_CULL_DISTANCE_FAR             1000.0    // Default projection matrix far cull distance
*
*       When loading a shader, the following vertex attributes and uniform
*       location names are tried to be set automatically:
*
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_POSITION     "vertexPosition"    // Bound by default to shader location: 0
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_TEXCOORD     "vertexTexCoord"    // Bound by default to shader location: 1
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_NORMAL       "vertexNormal"      // Bound by default to shader location: 2
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_COLOR        "vertexColor"       // Bound by default to shader location: 3
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_TANGENT      "vertexTangent"     // Bound by default to shader location: 4
*       #define RL_DEFAULT_SHADER_ATTRIB_NAME_TEXCOORD2    "vertexTexCoord2"   // Bound by default to shader location: 5
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_MVP         "mvp"               // model-view-projection matrix
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_VIEW        "matView"           // view matrix
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_PROJECTION  "matProjection"     // projection matrix
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_MODEL       "matModel"          // model matrix
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_NORMAL      "matNormal"         // normal matrix (transpose(inverse(matModelView))
*       #define RL_DEFAULT_SHADER_UNIFORM_NAME_COLOR       "colDiffuse"        // color diffuse (base tint color, multiplied by texture color)
*       #define RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE0  "texture0"          // texture0 (texture slot active 0)
*       #define RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE1  "texture1"          // texture1 (texture slot active 1)
*       #define RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE2  "texture2"          // texture2 (texture slot active 2)
*
*   DEPENDENCIES:
*      - OpenGL libraries (depending on platform and OpenGL version selected)
*      - GLAD OpenGL extensions loading library (only for OpenGL 3.3 Core, 4.3 Core)
*
*
*   LICENSE: zlib/libpng
*
*   Copyright           (c) 2014-2023 Ramon Santamaria  (@raysan5)
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

#include "@VMODROOT/thirdparty/raylib/src/rlgl.h"


pub const rl_default_batch_buffer_elements = $if GRAPHICS_API_OPENGL_11 ? || GRAPHICS_API_OPENGL_33 ?  {
//     // This is the maximum amount of elements (quads) per batch
//     // NOTE: Be careful with text, every letter maps to a quad
    8192
} $else $if GRAPHICS_API_OPENGL_ES2 ? {
//     // We reduce memory sizes for embedded systems (RPI and HTML5)
//     // NOTE: On HTML5 (emscripten) this is allocated on heap,
//     // by default it's only 16MB!...just take care...
    2048
} $else {
	8192
}

pub const rl_default_batch_buffers           = 1      // Default number of batch buffers (multi-buffering)
pub const rl_default_batch_drawcalls         = 256    // Default number of batch draw calls (by state changes: mode, texture)
pub const rl_default_batch_max_texture_units = 4      // Maximum number of textures units that can be activated on batch drawing (SetShaderValueTexture())

pub const rl_max_matrix_stack_size           = 32     // Maximum size of Matrix stack

// Shader limits
pub const rl_max_shader_locations            = 32     // Maximum number of shader locations supported

// Projection matrix culling
pub const rl_cull_distance_near              = 0.01   // Default near cull distance
pub const rl_cull_distance_far               = 1000.0 // Default far cull distance


pub const rl_texture_wrap_s                    =  C.RL_TEXTURE_WRAP_S                   // GL_TEXTURE_WRAP_S
pub const rl_texture_wrap_t                    =  C.RL_TEXTURE_WRAP_T                   // GL_TEXTURE_WRAP_T
pub const rl_texture_mag_filter                =  C.RL_TEXTURE_MAG_FILTER               // GL_TEXTURE_MAG_FILTER
pub const rl_texture_min_filter                =  C.RL_TEXTURE_MIN_FILTER               // GL_TEXTURE_MIN_FILTER

pub const rl_texture_filter_nearest            = C.RL_TEXTURE_FILTER_NEAREST            // GL_NEAREST
pub const rl_texture_filter_linear             = C.RL_TEXTURE_FILTER_LINEAR             // GL_LINEAR
pub const rl_texture_filter_mip_nearest        = C.RL_TEXTURE_FILTER_MIP_NEAREST        // GL_NEAREST_MIPMAP_NEAREST
pub const rl_texture_filter_nearest_mip_linear = C.RL_TEXTURE_FILTER_NEAREST_MIP_LINEAR // GL_NEAREST_MIPMAP_LINEAR
pub const rl_texture_filter_linear_mip_nearest = C.RL_TEXTURE_FILTER_LINEAR_MIP_NEAREST // GL_LINEAR_MIPMAP_NEAREST
pub const rl_texture_filter_mip_linear         = C.RL_TEXTURE_FILTER_MIP_LINEAR         // GL_LINEAR_MIPMAP_LINEAR
pub const rl_texture_filter_anisotropic        = C.RL_TEXTURE_FILTER_ANISOTROPIC        // Anisotropic filter (custom identifier)
pub const rl_texture_mipmap_bias_ratio         = C.RL_TEXTURE_MIPMAP_BIAS_RATIO         // Texture mipmap bias, percentage ratio (custom identifier)

pub const rl_texture_wrap_repeat               = C.RL_TEXTURE_WRAP_REPEAT               // GL_REPEAT
pub const rl_texture_wrap_clamp                = C.RL_TEXTURE_WRAP_CLAMP                // GL_CLAMP_TO_EDGE
pub const rl_texture_wrap_mirror_repeat        = C.RL_TEXTURE_WRAP_MIRROR_REPEAT        // GL_MIRRORED_REPEAT
pub const rl_texture_wrap_mirror_clamp         = C.RL_TEXTURE_WRAP_MIRROR_CLAMP         // GL_MIRROR_CLAMP_EXT

// Matrix modes (equivalent to OpenGL)
pub const rl_modelview                         = C.RL_MODELVIEW                         // GL_MODELVIEW
pub const rl_projection                        = C.RL_PROJECTION                        // GL_PROJECTION
pub const rl_texture                           = C.RL_TEXTURE                           // GL_TEXTURE

// Primitive assembly draw modes
pub const rl_lines                             = C.RL_LINES                             // GL_LINES
pub const rl_triangles                         = C.RL_TRIANGLES                         // GL_TRIANGLES
pub const rl_quads                             = C.RL_QUADS                             // GL_QUADS

// GL equivalent data types
pub const rl_unsigned_byte                     = C.RL_UNSIGNED_BYTE                     // GL_UNSIGNED_BYTE
pub const rl_float                             = C.RL_FLOAT                             // GL_FLOAT

// GL buffer usage hint
pub const rl_stream_draw                       = C.RL_STREAM_DRAW                       // GL_STREAM_DRAW
pub const rl_stream_read                       = C.RL_STREAM_READ                       // GL_STREAM_READ
pub const rl_stream_copy                       = C.RL_STREAM_COPY                       // GL_STREAM_COPY
pub const rl_static_draw                       = C.RL_STATIC_DRAW                       // GL_STATIC_DRAW
pub const rl_static_read                       = C.RL_STATIC_READ                       // GL_STATIC_READ
pub const rl_static_copy                       = C.RL_STATIC_COPY                       // GL_STATIC_COPY
pub const rl_dynamic_draw                      = C.RL_DYNAMIC_DRAW                      // GL_DYNAMIC_DRAW
pub const rl_dynamic_read                      = C.RL_DYNAMIC_READ                      // GL_DYNAMIC_READ
pub const rl_dynamic_copy                      = C.RL_DYNAMIC_COPY                      // GL_DYNAMIC_COPY

// GL Shader type
pub const rl_fragment_shader                   = C.RL_FRAGMENT_SHADER                   // GL_FRAGMENT_SHADER
pub const rl_vertex_shader                     = C.RL_VERTEX_SHADER                     // GL_VERTEX_SHADER
pub const rl_compute_shader                    = C.RL_COMPUTE_SHADER                    // GL_COMPUTE_SHADER
                                                                                         
// GL blending factors
pub const rl_zero                              = C.RL_ZERO                              // GL_ZERO
pub const rl_one                               = C.RL_ONE                               // GL_ONE
pub const rl_src_color                         = C.RL_SRC_COLOR                         // GL_SRC_COLOR
pub const rl_one_minus_src_color               = C.RL_ONE_MINUS_SRC_COLOR               // GL_ONE_MINUS_SRC_COLOR
pub const rl_src_alpha                         = C.RL_SRC_ALPHA                         // GL_SRC_ALPHA
pub const rl_one_minus_src_alpha               = C.RL_ONE_MINUS_SRC_ALPHA               // GL_ONE_MINUS_SRC_ALPHA
pub const rl_dst_alpha                         = C.RL_DST_ALPHA                         // GL_DST_ALPHA
pub const rl_one_minus_dst_alpha               = C.RL_ONE_MINUS_DST_ALPHA               // GL_ONE_MINUS_DST_ALPHA
pub const rl_dst_color                         = C.RL_DST_COLOR                         // GL_DST_COLOR
pub const rl_one_minus_dst_color               = C.RL_ONE_MINUS_DST_COLOR               // GL_ONE_MINUS_DST_COLOR
pub const rl_src_alpha_saturate                = C.RL_SRC_ALPHA_SATURATE                // GL_SRC_ALPHA_SATURATE
pub const rl_constant_color                    = C.RL_CONSTANT_COLOR                    // GL_CONSTANT_COLOR
pub const rl_one_minus_constant_color          = C.RL_ONE_MINUS_CONSTANT_COLOR          // GL_ONE_MINUS_CONSTANT_COLOR
pub const rl_constant_alpha                    = C.RL_CONSTANT_ALPHA                    // GL_CONSTANT_ALPHA
pub const rl_one_minus_constant_alpha          = C.RL_ONE_MINUS_CONSTANT_ALPHA          // GL_ONE_MINUS_CONSTANT_ALPHA

                                                                                        // GL blending functions/equations
pub const rl_func_add                          = C.RL_FUNC_ADD                          // GL_FUNC_ADD
pub const rl_min                               = C.RL_MIN                               // GL_MIN
pub const rl_max                               = C.RL_MAX                               // GL_MAX
pub const rl_func_subtract                     = C.RL_FUNC_SUBTRACT                     // GL_FUNC_SUBTRACT
pub const rl_func_reverse_subtract             = C.RL_FUNC_REVERSE_SUBTRACT             // GL_FUNC_REVERSE_SUBTRACT
pub const rl_blend_equation                    = C.RL_BLEND_EQUATION                    // GL_BLEND_EQUATION
pub const rl_blend_equation_rgb                = C.RL_BLEND_EQUATION_RGB                // GL_BLEND_EQUATION_RGB // (Same as BLEND_EQUATION)
pub const rl_blend_equation_alpha              = C.RL_BLEND_EQUATION_ALPHA              // GL_BLEND_EQUATION_ALPHA
pub const rl_blend_dst_rgb                     = C.RL_BLEND_DST_RGB                     // GL_BLEND_DST_RGB
pub const rl_blend_src_rgb                     = C.RL_BLEND_SRC_RGB                     // GL_BLEND_SRC_RGB
pub const rl_blend_dst_alpha                   = C.RL_BLEND_DST_ALPHA                   // GL_BLEND_DST_ALPHA
pub const rl_blend_src_alpha                   = C.RL_BLEND_SRC_ALPHA                   // GL_BLEND_SRC_ALPHA
pub const rl_blend_color                       = C.RL_BLEND_COLOR                       // GL_BLEND_COLOR

pub const rl_read_framebuffer                  = u32(C.RL_READ_FRAMEBUFFER)                 // GL_READ_FRAMEBUFFER
pub const rl_draw_framebuffer                  = u32(C.RL_DRAW_FRAMEBUFFER)                 // GL_DRAW_FRAMEBUFFER

// Dynamic vertex buffers (position + texcoords + colors + indices arrays)
@[typedef]
struct C.rlVertexBuffer {
    elementCount int               // Number of elements in the buffer (QUADS)

    vertices      &f32              // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    texcoords     &f32              // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    colors        &u8               // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)

    indices       &u32              // Vertex indices (in case vertex data comes indexed) (6 indices per quad)
// $if GRAPHICS_API_OPENGL_11 ? || GRAPHICS_API_OPENGL_33 ? {
//     indices       &u32              // Vertex indices (in case vertex data comes indexed) (6 indices per quad)
// } $else $if GRAPHICS_API_OPENGL_ES2 {
//     indices       &u16              // Vertex indices (in case vertex data comes indexed) (6 indices per quad)
// }
    vaoId        u32               // OpenGL Vertex Array Object id
    vboId        [4]u32            // OpenGL Vertex Buffer Objects id (4 types of vertex data)
}
pub type VertexBuffer = C.rlVertexBuffer

// Draw call type
// NOTE: Only texture changes register a new draw, other state-change-related elements are not
// used at this moment (vaoId, shader_id, matrices), raylib just forces a batch draw call if any
// of those state-change happens (this is done in core module)
@[typedef]
struct C.rlDrawCall {
    mode            int         // Drawing mode: LINES, TRIANGLES, QUADS
    vertexCount     int         // Number of vertex of the draw
    vertexAlignment int         // Number of vertex required for index alignment (LINES, TRIANGLES)
    texture_id      u32         // Texture id to be used on the draw -> Use to create new draw call if changes
}
pub type DrawCall = C.rlDrawCall

// RenderBatch type
@[typedef]
struct C.rlRenderBatch {
    bufferCount   int           // Number of vertex buffers (multi-buffering support)
    currentBuffer int           // Current buffer tracking in case of multi-buffering
    vertexBuffer  &VertexBuffer // Dynamic buffer(s) for vertex data

    draws         &DrawCall      // Draw calls array, depends on texture_id
    drawCounter   int            // Draw calls counter
    currentDepth  f32            // Current depth value for next draw
}
pub type RenderBatch = C.rlRenderBatch


// OpenGL version
// pub enum GlVersion as int {
pub const rl_opengl_11    = C.RL_OPENGL_11        // OpenGL 1.1
pub const rl_opengl_21    = C.RL_OPENGL_21        // OpenGL 2.1 (GLSL 120)
pub const rl_opengl_33    = C.RL_OPENGL_33        // OpenGL 3.3 (GLSL 330)
pub const rl_opengl_43    = C.RL_OPENGL_43        // OpenGL 4.3 (using GLSL 330)
pub const rl_opengl_es_20 = C.RL_OPENGL_ES_20     // OpenGL ES 2.0 (GLSL 100)
pub const rl_opengl_es_30 = C.RL_OPENGL_ES_30     // OpenGL ES 3.0 (GLSL 300 es)
// }

// Trace log level
// NOTE: Organized by priority level
// pub enum TraceLogLevel as int {
pub const rl_log_all     = C.RL_LOG_ALL         // Display all logs
pub const rl_log_trace   = C.RL_LOG_TRACE       // Trace logging, intended for internal use only
pub const rl_log_debug   = C.RL_LOG_DEBUG       // Debug logging, used for internal debugging, it should be disabled on release builds
pub const rl_log_info    = C.RL_LOG_INFO        // Info logging, used for program execution info
pub const rl_log_warning = C.RL_LOG_WARNING     // Warning logging, used on recoverable failures
pub const rl_log_error   = C.RL_LOG_ERROR       // Error logging, used on unrecoverable failures
pub const rl_log_fatal   = C.RL_LOG_FATAL       // Fatal logging, used to abort program: exit(EXIT_FAILURE)
pub const rl_log_none    = C.RL_LOG_NONE        // Disable logging
// }


// Texture pixel formats
// NOTE: Support depends on OpenGL version
// pub enum  PixelFormat as int {
pub const rl_pixelformat_uncompressed_grayscale    = C.RL_PIXELFORMAT_UNCOMPRESSED_GRAYSCALE    // 8 bit per pixel (no alpha)
pub const rl_pixelformat_uncompressed_gray_alpha   = C.RL_PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA   // 8*2 bpp (2 channels)
pub const rl_pixelformat_uncompressed_r5g6b5       = C.RL_PIXELFORMAT_UNCOMPRESSED_R5G6B5       // 16 bpp
pub const rl_pixelformat_uncompressed_r8g8b8       = C.RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8       // 24 bpp
pub const rl_pixelformat_uncompressed_r5g5b5a1     = C.RL_PIXELFORMAT_UNCOMPRESSED_R5G5B5A1     // 16 bpp (1 bit alpha)
pub const rl_pixelformat_uncompressed_r4g4b4a4     = C.RL_PIXELFORMAT_UNCOMPRESSED_R4G4B4A4     // 16 bpp (4 bit alpha)
pub const rl_pixelformat_uncompressed_r8g8b8a8     = C.RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8A8     // 32 bpp
pub const rl_pixelformat_uncompressed_r32          = C.RL_PIXELFORMAT_UNCOMPRESSED_R32          // 32 bpp (1 channel - float)
pub const rl_pixelformat_uncompressed_r32g32b32    = C.RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32    // 32*3 bpp (3 channels - float)
pub const rl_pixelformat_uncompressed_r32g32b32a32 = C.RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 // 32*4 bpp (4 channels - float)
pub const rl_pixelformat_uncompressed_r16          = C.RL_PIXELFORMAT_UNCOMPRESSED_R16          // 16 bpp (1 channel - half float)
pub const rl_pixelformat_uncompressed_r16g16b16    = C.RL_PIXELFORMAT_UNCOMPRESSED_R16G16B16    // 16*3 bpp (3 channels - half float)
pub const rl_pixelformat_uncompressed_r16g16b16a16 = C.RL_PIXELFORMAT_UNCOMPRESSED_R16G16B16A16 // 16*4 bpp (4 channels - half float)
pub const rl_pixelformat_compressed_dxt1_rgb       = C.RL_PIXELFORMAT_COMPRESSED_DXT1_RGB       // 4 bpp (no alpha)
pub const rl_pixelformat_compressed_dxt1_rgba      = C.RL_PIXELFORMAT_COMPRESSED_DXT1_RGBA      // 4 bpp (1 bit alpha)
pub const rl_pixelformat_compressed_dxt3_rgba      = C.RL_PIXELFORMAT_COMPRESSED_DXT3_RGBA      // 8 bpp
pub const rl_pixelformat_compressed_dxt5_rgba      = C.RL_PIXELFORMAT_COMPRESSED_DXT5_RGBA      // 8 bpp
pub const rl_pixelformat_compressed_etc1_rgb       = C.RL_PIXELFORMAT_COMPRESSED_ETC1_RGB       // 4 bpp
pub const rl_pixelformat_compressed_etc2_rgb       = C.RL_PIXELFORMAT_COMPRESSED_ETC2_RGB       // 4 bpp
pub const rl_pixelformat_compressed_etc2_eac_rgba  = C.RL_PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA  // 8 bpp
pub const rl_pixelformat_compressed_pvrt_rgb       = C.RL_PIXELFORMAT_COMPRESSED_PVRT_RGB       // 4 bpp
pub const rl_pixelformat_compressed_pvrt_rgba      = C.RL_PIXELFORMAT_COMPRESSED_PVRT_RGBA      // 4 bpp
pub const rl_pixelformat_compressed_astc_4x4_rgba  = C.RL_PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA  // 8 bpp
pub const rl_pixelformat_compressed_astc_8x8_rgba  = C.RL_PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA  // 2 bpp
// }

// Texture parameters: filter mode
// NOTE 1: Filtering considers mipmaps if available in the texture
// NOTE 2: Filter is accordingly set for minification and magnification
// pub enum TextureFilter as int {
pub const rl_texture_filter_point           = C.RL_TEXTURE_FILTER_POINT           // No filter, just pixel approximation
pub const rl_texture_filter_bilinear        = C.RL_TEXTURE_FILTER_BILINEAR        // Linear filtering
pub const rl_texture_filter_trilinear       = C.RL_TEXTURE_FILTER_TRILINEAR       // Trilinear filtering (linear with mipmaps)
pub const rl_texture_filter_anisotropic_4x  = C.RL_TEXTURE_FILTER_ANISOTROPIC_4X  // Anisotropic filtering 4x
pub const rl_texture_filter_anisotropic_8x  = C.RL_TEXTURE_FILTER_ANISOTROPIC_8X  // Anisotropic filtering 8x
pub const rl_texture_filter_anisotropic_16x = C.RL_TEXTURE_FILTER_ANISOTROPIC_16X // Anisotropic filtering 16x
// }

// Color blending modes (pre-defined)
// pub enum BlendMode as int {
pub const rl_blend_alpha             = C.RL_BLEND_ALPHA             // Blend textures considering alpha (default)
pub const rl_blend_additive          = C.RL_BLEND_ADDITIVE          // Blend textures adding colors
pub const rl_blend_multiplied        = C.RL_BLEND_MULTIPLIED        // Blend textures multiplying colors
pub const rl_blend_add_colors        = C.RL_BLEND_ADD_COLORS        // Blend textures adding colors (alternative)
pub const rl_blend_subtract_colors   = C.RL_BLEND_SUBTRACT_COLORS   // Blend textures subtracting colors (alternative)
pub const rl_blend_alpha_premultiply = C.RL_BLEND_ALPHA_PREMULTIPLY // Blend premultiplied textures considering alpha
pub const rl_blend_custom            = C.RL_BLEND_CUSTOM            // Blend textures using custom src/dst factors (use rlSetBlendFactors())
pub const rl_blend_custom_separate   = C.RL_BLEND_CUSTOM_SEPARATE   // Blend textures using custom src/dst factors (use rlSetBlendFactorsSeparate())
// }

// Shader location point type
// pub enum ShaderLocationIndex as int {
pub const rl_shader_loc_vertex_position      = C.RL_SHADER_LOC_VERTEX_POSITION   // Shader location: vertex attribute: position
pub const rl_shader_loc_vertex_texcoord01    = C.RL_SHADER_LOC_VERTEX_TEXCOORD01 // Shader location: vertex attribute: texcoord01
pub const rl_shader_loc_vertex_texcoord02    = C.RL_SHADER_LOC_VERTEX_TEXCOORD02 // Shader location: vertex attribute: texcoord02
pub const rl_shader_loc_vertex_normal        = C.RL_SHADER_LOC_VERTEX_NORMAL     // Shader location: vertex attribute: normal
pub const rl_shader_loc_vertex_tangent       = C.RL_SHADER_LOC_VERTEX_TANGENT    // Shader location: vertex attribute: tangent
pub const rl_shader_loc_vertex_color         = C.RL_SHADER_LOC_VERTEX_COLOR      // Shader location: vertex attribute: color
pub const rl_shader_loc_matrix_mvp           = C.RL_SHADER_LOC_MATRIX_MVP        // Shader location: matrix uniform: model-view-projection
pub const rl_shader_loc_matrix_view          = C.RL_SHADER_LOC_MATRIX_VIEW       // Shader location: matrix uniform: view (camera transform)
pub const rl_shader_loc_matrix_projection    = C.RL_SHADER_LOC_MATRIX_PROJECTION // Shader location: matrix uniform: projection
pub const rl_shader_loc_matrix_model         = C.RL_SHADER_LOC_MATRIX_MODEL      // Shader location: matrix uniform: model (transform)
pub const rl_shader_loc_matrix_normal        = C.RL_SHADER_LOC_MATRIX_NORMAL     // Shader location: matrix uniform: normal
pub const rl_shader_loc_vector_view          = C.RL_SHADER_LOC_VECTOR_VIEW       // Shader location: vector uniform: view
pub const rl_shader_loc_color_diffuse        = C.RL_SHADER_LOC_COLOR_DIFFUSE     // Shader location: vector uniform: diffuse color
pub const rl_shader_loc_color_albedo         = C.RL_SHADER_LOC_COLOR_DIFFUSE     // Shader location: vector uniform: albedo color
pub const rl_shader_loc_color_specular       = C.RL_SHADER_LOC_COLOR_SPECULAR    // Shader location: vector uniform: specular color
pub const rl_shader_loc_color_metalness      = C.RL_SHADER_LOC_COLOR_SPECULAR    // Shader location: vector uniform: metalnes color
pub const rl_shader_loc_color_ambient        = C.RL_SHADER_LOC_COLOR_AMBIENT     // Shader location: vector uniform: ambient color
pub const rl_shader_loc_map_albedo           = C.RL_SHADER_LOC_MAP_ALBEDO        // Shader location: sampler2d texture: albedo (same as: RL_SHADER_LOC_MAP_DIFFUSE)
pub const rl_shader_loc_map_metalness        = C.RL_SHADER_LOC_MAP_METALNESS     // Shader location: sampler2d texture: metalness (same as: RL_SHADER_LOC_MAP_SPECULAR)
pub const rl_shader_loc_map_normal           = C.RL_SHADER_LOC_MAP_NORMAL        // Shader location: sampler2d texture: normal
pub const rl_shader_loc_map_roughness        = C.RL_SHADER_LOC_MAP_ROUGHNESS     // Shader location: sampler2d texture: roughness
pub const rl_shader_loc_map_occlusion        = C.RL_SHADER_LOC_MAP_OCCLUSION     // Shader location: sampler2d texture: occlusion
pub const rl_shader_loc_map_emission         = C.RL_SHADER_LOC_MAP_EMISSION      // Shader location: sampler2d texture: emission
pub const rl_shader_loc_map_height           = C.RL_SHADER_LOC_MAP_HEIGHT        // Shader location: sampler2d texture: height
pub const rl_shader_loc_map_cubemap          = C.RL_SHADER_LOC_MAP_CUBEMAP       // Shader location: samplerCube texture: cubemap
pub const rl_shader_loc_map_irradiance       = C.RL_SHADER_LOC_MAP_IRRADIANCE    // Shader location: samplerCube texture: irradiance
pub const rl_shader_loc_map_prefilter        = C.RL_SHADER_LOC_MAP_PREFILTER     // Shader location: samplerCube texture: prefilter
pub const rl_shader_loc_map_brdf             = C.RL_SHADER_LOC_MAP_BRDF          // Shader location: sampler2d texture: brdf
// }


// Shader uniform data type
// pub enum ShaderUniformDataType as int {
pub const rl_shader_uniform_float     = C.RL_SHADER_UNIFORM_FLOAT     // Shader uniform type: float
pub const rl_shader_uniform_vec2      = C.RL_SHADER_UNIFORM_VEC2      // Shader uniform type: vec2 (2 float)
pub const rl_shader_uniform_vec3      = C.RL_SHADER_UNIFORM_VEC3      // Shader uniform type: vec3 (3 float)
pub const rl_shader_uniform_vec4      = C.RL_SHADER_UNIFORM_VEC4      // Shader uniform type: vec4 (4 float)
pub const rl_shader_uniform_int       = C.RL_SHADER_UNIFORM_INT       // Shader uniform type: int
pub const rl_shader_uniform_ivec2     = C.RL_SHADER_UNIFORM_IVEC2     // Shader uniform type: ivec2 (2 int)
pub const rl_shader_uniform_ivec3     = C.RL_SHADER_UNIFORM_IVEC3     // Shader uniform type: ivec3 (3 int)
pub const rl_shader_uniform_ivec4     = C.RL_SHADER_UNIFORM_IVEC4     // Shader uniform type: ivec4 (4 int)
pub const rl_shader_uniform_sampler2d = C.RL_SHADER_UNIFORM_SAMPLER2D // Shader uniform type: sampler2d
// }

// Shader attribute data types
// pub enum ShaderAttributeDataType as int {
pub const rl_shader_attrib_float = C.RL_SHADER_ATTRIB_FLOAT // Shader attribute type: float
pub const rl_shader_attrib_vec2  = C.RL_SHADER_ATTRIB_VEC2  // Shader attribute type: vec2 (2 float)
pub const rl_shader_attrib_vec3  = C.RL_SHADER_ATTRIB_VEC3  // Shader attribute type: vec3 (3 float)
pub const rl_shader_attrib_vec4  = C.RL_SHADER_ATTRIB_VEC4  // Shader attribute type: vec4 (4 float)
// }

// Framebuffer attachment type
// NOTE: By default up to 8 color channels defined, but it can be more
// pub enum FramebufferAttachType as int {
pub const rl_attachment_color_channel0 = C.RL_ATTACHMENT_COLOR_CHANNEL0 // Framebuffer attachment type: color 0
pub const rl_attachment_color_channel1 = C.RL_ATTACHMENT_COLOR_CHANNEL1 // Framebuffer attachment type: color 1
pub const rl_attachment_color_channel2 = C.RL_ATTACHMENT_COLOR_CHANNEL2 // Framebuffer attachment type: color 2
pub const rl_attachment_color_channel3 = C.RL_ATTACHMENT_COLOR_CHANNEL3 // Framebuffer attachment type: color 3
pub const rl_attachment_color_channel4 = C.RL_ATTACHMENT_COLOR_CHANNEL4 // Framebuffer attachment type: color 4
pub const rl_attachment_color_channel5 = C.RL_ATTACHMENT_COLOR_CHANNEL5 // Framebuffer attachment type: color 5
pub const rl_attachment_color_channel6 = C.RL_ATTACHMENT_COLOR_CHANNEL6 // Framebuffer attachment type: color 6
pub const rl_attachment_color_channel7 = C.RL_ATTACHMENT_COLOR_CHANNEL7 // Framebuffer attachment type: color 7
pub const rl_attachment_depth          = C.RL_ATTACHMENT_DEPTH          // Framebuffer attachment type: depth
pub const rl_attachment_stencil        = C.RL_ATTACHMENT_STENCIL        // Framebuffer attachment type: stencil
// }


// Framebuffer texture attachment type
// pub enum FramebufferAttachTextureType as int {
pub const rl_attachment_cubemap_positive_x = C.RL_ATTACHMENT_CUBEMAP_POSITIVE_X // Framebuffer texture attachment type: cubemap, +X side
pub const rl_attachment_cubemap_negative_x = C.RL_ATTACHMENT_CUBEMAP_NEGATIVE_X // Framebuffer texture attachment type: cubemap, -X side
pub const rl_attachment_cubemap_positive_y = C.RL_ATTACHMENT_CUBEMAP_POSITIVE_Y // Framebuffer texture attachment type: cubemap, +Y side
pub const rl_attachment_cubemap_negative_y = C.RL_ATTACHMENT_CUBEMAP_NEGATIVE_Y // Framebuffer texture attachment type: cubemap, -Y side
pub const rl_attachment_cubemap_positive_z = C.RL_ATTACHMENT_CUBEMAP_POSITIVE_Z // Framebuffer texture attachment type: cubemap, +Z side
pub const rl_attachment_cubemap_negative_z = C.RL_ATTACHMENT_CUBEMAP_NEGATIVE_Z // Framebuffer texture attachment type: cubemap, -Z side
pub const rl_attachment_texture_2d         = C.RL_ATTACHMENT_TEXTURE2D          // Framebuffer texture attachment type: texture2d
pub const rl_attachment_renderbuffer       = C.RL_ATTACHMENT_RENDERBUFFER       // Framebuffer texture attachment type: renderbuffer
// }

// Face culling mode
// pub enum CullMode as int {
pub const rl_cull_face_front = C.RL_CULL_FACE_FRONT
pub const rl_cull_face_back  = C.RL_CULL_FACE_BACK
// }

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
// $if GRAPHICS_API_OPENGL_3 || GRAPHICS_API_OPENGL_ES2 {
// @[typedef]
struct C.State {
    vertexCounter  int                      // Current active render batch vertex counter (generic, used for all batches)
    texcoordx      f32
    texcoordy      f32                      // Current active texture coordinate (added on glVertex*())
    normal         Vector3                  // Current active normal (added on glVertex*())
    color          Color                    // Current active color (added on glVertex*())

    currentMatrixMode int                   // Current matrix mode
    currentMatrix     &Matrix               // Current matrix pointer
    modelview         Matrix                // Default modelview matrix
    projection        Matrix                // Default projection matrix
    transform         Matrix                // Transform matrix to be used with rlTranslate, rlRotate, rlScale
    transformRequired  bool                 // Require transform matrix application to current draw-call vertex (if required)
    stack [rl_max_matrix_stack_size]Matrix  // Matrix stack for push/pop
    stackCounter       int                  // Matrix stack counter

    defaultTextureId  u32                   // Default texture used on shapes/poly drawing (required by shader)
    activeTextureId   [rl_default_batch_max_texture_units]u32    // Active texture ids to be enabled on batch drawing (0 active by default)
    defaultVShaderId  u32                   // Default vertex shader id (used by default shader program)
    defaultFShaderId  u32                   // Default fragment shader id (used by default shader program)
    defaultShaderId   u32                   // Default shader program id, supports vertex color and diffuse texture
    defaultShaderLocs &int                  // Default shader locations pointer to be used on rendering
    currentShaderId   u32                   // Current shader id to be used on rendering (by default, default_shader_id)
    currentShaderLocs &int                  // Current shader locations pointer to be used on rendering (by default, default_shader_locs)

    stereoRender      bool                  // Stereo rendering flag
    projectionStereo  [2]Matrix             // VR stereo rendering eyes projection matrices
    viewOffsetStereo  [2]Matrix             // VR stereo rendering eyes view offset matrices

    // Blending variables
    currentBlendMode          int           // Blending mode active
    glBlendSrcFactor          int           // Blending source factor
    glBlendDstFactor          int           // Blending destination factor
    glBlendEquation           int           // Blending equation
    glBlendSrcFactorRGB       int           // Blending source RGB factor
    glBlendDestFactorRGB      int           // Blending destination RGB factor
    glBlendSrcFactorAlpha     int           // Blending source alpha factor
    glBlendDestFactorAlpha    int           // Blending destination alpha factor
    glBlendEquationRGB        int           // Blending equation for RGB
    glBlendEquationAlpha      int           // Blending equation for alpha
    glCustomBlendModeModified bool          // Custom blending factor and equation modification status

    framebufferWidth  int                   // Current framebuffer width
    framebufferHeight int                   // Current framebuffer height

}// Renderer state
pub type State = C.State

// @[typedef]
struct C.ExtSupported {
    vao                bool   // VAO support (OpenGL ES2 could not support VAO extension) (GL_ARB_vertex_array_object)
    instancing         bool   // Instancing supported (GL_ANGLE_instanced_arrays, GL_EXT_draw_instanced + GL_EXT_instanced_arrays)
    texNpot            bool   // NPOT textures full support (GL_ARB_texture_non_power_of_two, GL_OES_texture_npot)
    texDepth           bool   // Depth textures supported (GL_ARB_depth_texture, GL_OES_depth_texture)
    texDepthWebGl      bool   // Depth textures supported WebGL specific (GL_WEBGL_depth_texture)
    texFloat32         bool   // float textures support (32 bit per channel) (GL_OES_texture_float)
    texFloat16         bool   // half float textures support (16 bit per channel) (GL_OES_texture_half_float)
    texCompDxt         bool   // DDS texture compression support (GL_EXT_texture_compression_s3tc, GL_WEBGL_compressed_texture_s3tc, GL_WEBKIT_WEBGL_compressed_texture_s3tc)
    texCompEtc1        bool   // ETC1 texture compression support (GL_OES_compressed_ETC1_RGB8_texture, GL_WEBGL_compressed_texture_etc1)
    texCompEtc2        bool   // ETC2/EAC texture compression support (GL_ARB_ES3_compatibility)
    texCompPvrt        bool   // PVR texture compression support (GL_IMG_texture_compression_pvrtc)
    texCompAstc        bool   // ASTC texture compression support (GL_KHR_texture_compression_astc_hdr, GL_KHR_texture_compression_astc_ldr)
    texMirrorClamp     bool   // Clamp mirror wrap mode supported (GL_EXT_texture_mirror_clamp)
    texAnisoFilter     bool   // Anisotropic texture filtering support (GL_EXT_texture_filter_anisotropic)
    computeShader      bool   // Compute shaders support (GL_ARB_compute_shader)
    ssbo               bool   // Shader storage buffer object support (GL_ARB_shader_storage_buffer_object)

    maxAnisotropyLevel f32    // Maximum anisotropy level supported (minimum is 2.0f)
    maxDepthBits       int    // Maximum bits for depth component
} // Extensions supported flags
pub type ExtSupported = C.ExtSupported

// @[typedef]
struct C.rlglData {
    currentBatch &RenderBatch // Current render batch
    defaultBatch  RenderBatch // Default internal render batch
    state         State
    extSupport    ExtSupported
}
pub type RlglData = C.rlglData
// }

//------------------------------------------------------------------------------------
// Functions Declaration - Matrix operations
//------------------------------------------------------------------------------------
fn C.rlMatrixMode(mode int)                    // Choose the current matrix to be transformed
@[inline] pub fn rl_matrix_mode(mode int) {
    C.rlMatrixMode(mode)
}

fn C.rlPushMatrix()                            // Push the current matrix to stack
@[inline] pub fn rl_push_matrix() {
    C.rlPushMatrix()
}

fn C.rlPopMatrix()                             // Pop latest inserted matrix from stack
@[inline] pub fn rl_pop_matrix() {
    C.rlPopMatrix()
}

fn C.rlLoadIdentity()                          // Reset current matrix to identity matrix
@[inline] pub fn rl_load_identity() {
    C.rlLoadIdentity()
}

fn C.rlTranslatef(x f32, y f32, z f32)         // Multiply the current matrix by a translation matrix
@[inline] pub fn rl_translatef(x f32, y f32, z f32) {
    C.rlTranslatef(x, y, z)
}

fn C.rlRotatef(angle f32, x f32, y f32, z f32) // Multiply the current matrix by a rotation matrix
@[inline] pub fn rl_rotatef(angle f32, x f32, y f32, z f32) {
    C.rlRotatef(angle, x, y, z)
}

fn C.rlScalef(x f32, y f32, z f32)             // Multiply the current matrix by a scaling matrix
@[inline] pub fn rl_scalef(x f32, y f32, z f32) {
    C.rlScalef(x, y, z)
}

fn C.rlMultMatrixf(matf &f32)                  // Multiply the current matrix by another matrix
@[inline] pub fn rl_mult_matrixf(matf &f32) {
    C.rlMultMatrixf(matf)
}

fn C.rlFrustum(left f64, right f64, bottom f64, top f64, znear f64, zfar f64)
@[inline]
pub fn rl_frustum(left f64, right f64, bottom f64, top f64, znear f64, zfar f64) {
    C.rlFrustum(left, right, bottom, top, znear, zfar)
}

fn C.rlOrtho(left f64, right f64, bottom f64, top f64, znear f64, zfar f64)
@[inline]
pub fn rl_ortho(left f64, right f64, bottom f64, top f64, znear f64, zfar f64) {
    C.rlOrtho(left, right, bottom, top, znear, zfar)
}

fn C.rlViewport(x int, y int, width int, height int) // Set the viewport area
@[inline]
pub fn rl_viewport(x int, y int, width int, height int) {
    C.rlViewport(x, y, width, height)
}


//------------------------------------------------------------------------------------
// Functions Declaration - Vertex level operations
//------------------------------------------------------------------------------------
fn C.rlBegin(mode int)                     // Initialize drawing mode (how to organize vertex)
@[inline] pub fn rl_begin(mode int) { C.rlBegin(mode) }

fn C.rlEnd()                               // Finish vertex providing
@[inline] pub fn rl_end() { C.rlEnd() }

fn C.rlVertex2i(x int, y int)              // Define one vertex (position) - 2 int
@[inline]
pub fn rl_vertex2i(x int, y int) {
    C.rlVertex2i(x, y)                     // Define one vertex (position) - 2 int
}

fn C.rlVertex2f(x f32, y f32)              // Define one vertex (position) - 2 f32
@[inline]
pub fn rl_vertex2f(x f32, y f32) {
    C.rlVertex2f(x, y)
}

fn C.rlVertex3f(x f32, y f32, z f32)       // Define one vertex (position) - 3 f32
@[inline]
pub fn rl_vertex3f(x f32, y f32, z f32) {
    C.rlVertex3f(x, y, z)
}

fn C.rlTexCoord2f(x f32, y f32)            // Define one vertex (texture coordinate) - 2 f32
@[inline]
pub fn rl_tex_coord2f(x f32, y f32) {
    C.rlTexCoord2f(x, y)
}

fn C.rlNormal3f(x f32, y f32, z f32)       // Define one vertex (normal) - 3 f32
@[inline]
pub fn rl_normal3f(x f32, y f32, z f32) {
    C.rlNormal3f(x, y, z)
}

fn C.rlColor4ub(r u8, g u8, b u8, a u8)    // Define one vertex (color) - 4 byte
@[inline]
pub fn rl_color4ub(r u8, g u8, b u8, a u8) {
    C.rlColor4ub(r, g, b, a)
}

fn C.rlColor3f(x f32, y f32, z f32)        // Define one vertex (color) - 3 f32
@[inline]
pub fn rl_color3f(x f32, y f32, z f32) {
    C.rlColor3f(x, y, z)
}

fn C.rlColor4f(x f32, y f32, z f32, w f32) // Define one vertex (color) - 4 f32
@[inline]
pub fn rl_color4f(x f32, y f32, z f32, w f32) {
    C.rlColor4f(x, y, z, w)
}


//------------------------------------------------------------------------------------
// Functions Declaration - OpenGL style functions (common to 1.1, 3.3+, ES2)
// NOTE: This functions are used to completely abstract raylib code from OpenGL layer,
// some of them are direct wrappers over OpenGL calls, some others are custom
//------------------------------------------------------------------------------------

// Vertex buffers state
fn C.rlEnableVertexArray(vao_id u32) bool // Enable vertex array (VAO, if supported)
@[inline]
pub fn rl_enable_vertex_array(vao_id u32) bool {
    return C.rlEnableVertexArray(vao_id)
}

fn C.rlDisableVertexArray()                  // Disable vertex array (VAO, if supported)
@[inline]
pub fn rl_disable_vertex_array() {
    C.rlDisableVertexArray()
}

fn C.rlEnableVertexBuffer(id u32)            // Enable vertex buffer (VBO)
@[inline]
pub fn rl_enable_vertex_buffer(id u32) {
    C.rlEnableVertexBuffer(id)
}

fn C.rlDisableVertexBuffer()                 // Disable vertex buffer (VBO)
@[inline]
pub fn rl_disable_vertex_buffer() {
    C.rlDisableVertexBuffer()
}

fn C.rlEnableVertexBufferElement(id u32)     // Enable vertex buffer element (VBO element)
@[inline]
pub fn rl_enable_vertex_buffer_element(id u32) {
    C.rlEnableVertexBufferElement(id)
}

fn C.rlDisableVertexBufferElement()          // Disable vertex buffer element (VBO element)
@[inline]
pub fn rl_disable_vertex_buffer_element() {
    C.rlDisableVertexBufferElement()
}

fn C.rlEnableVertexAttribute(index u32)      // Enable vertex attribute index
@[inline]
pub fn rl_enable_vertex_attribute(index u32) {
    C.rlEnableVertexAttribute(index)
}

fn C.rlDisableVertexAttribute(index u32)     // Disable vertex attribute index
@[inline]
pub fn rl_disable_vertex_attribute(index u32) {
    C.rlDisableVertexAttribute(index)
}


// $if GRAPHICS_API_OPENGL_11 ? {
//     fn C.rlEnableStatePointer(vertex_attrib_type int, buffer voidptr)    // Enable attribute state pointer
//     @[inline]
//     pub fn rl_enable_state_pointer(vertex_attrib_type int, buffer voidptr) {
//         C.rlEnableStatePointer(vertex_attrib_type, buffer)
//     }

//     fn C.rlDisableStatePointer(vertex_attrib_type int)                 // Disable attribute state pointer
//     @[inline]
//     pub fn rl_disable_state_pointer(vertex_attrib_type int) {
//         C.rlDisableStatePointer(vertex_attrib_type)
//     }
// }

// Textures state
fn C.rlActiveTextureSlot(slot int)                     // Select and active a texture slot
@[inline]
pub fn rl_active_texture_slot(slot int) {
    C.rlActiveTextureSlot(slot)
}

fn C.rlEnableTexture(id u32)                           // Enable texture
@[inline]
pub fn rl_enable_texture(id u32) {
    C.rlEnableTexture(id)
}

fn C.rlDisableTexture()                                // Disable texture
@[inline]
pub fn rl_disable_texture() {
    C.rlDisableTexture()
}

fn C.rlEnableTextureCubemap(id u32)                    // Enable texture cubemap
@[inline]
pub fn rl_enable_texture_cubemap(id u32) {
    C.rlEnableTextureCubemap(id)
}

fn C.rlDisableTextureCubemap()                         // Disable texture cubemap
@[inline]
pub fn rl_disable_texture_cubemap() {
    C.rlDisableTextureCubemap()
}

fn C.rlTextureParameters(id u32, param int, value int) // Set texture parameters (wrap mode/filter mode)
@[inline]
pub fn rl_texture_parameters(id u32, param int, value int) {
    C.rlTextureParameters(id, param, value)
}

fn C.rlCubemapParameters(id u32, param int, value int) // Set cubemap parameters (wrap mode/filter mode)
@[inline]
pub fn rl_cubemap_parameters(id u32, param int, value int) {
    C.rlCubemapParameters(id, param, value)
}


// Shader state
fn C.rlEnableShader(id u32)                            // Enable shader program
@[inline]
pub fn rl_enable_shader(id u32) {
    C.rlEnableShader(id)
}

fn C.rlDisableShader()                                 // Disable shader program
@[inline]
pub fn rl_disable_shader() {
    C.rlDisableShader()
}


// Framebuffer state
fn C.rlEnableFramebuffer(id u32)            // Enable render texture (fbo)
@[inline]
pub fn rl_enable_framebuffer(id u32) {
    C.rlEnableFramebuffer(id)
}

fn C.rlDisableFramebuffer()                 // Disable render texture (fbo), return to default framebuffer
@[inline]
pub fn rl_disable_framebuffer() {
    C.rlDisableFramebuffer()
}

@[inline]
fn C.rlBindFramebuffer(target u32, framebuffer u32)
pub fn rl_bind_framebuffer(target u32, framebuffer u32) {
    C.rlBindFramebuffer(target, framebuffer)
}

fn C.rlActiveDrawBuffers(count int)         // Activate multiple draw color buffers
@[inline]
pub fn rl_active_draw_buffers(count int) {
    C.rlActiveDrawBuffers(count)
}

fn C.rlBlitFramebuffer(src_x int, src_y int, src_width int, src_height int, dst_x int, dst_y int, dst_width int, dst_height int, buffer_mask int) // Blit active framebuffer to main framebuffer
@[inline]
pub fn rl_blit_framebuffer(src_x int, src_y int, src_width int, src_height int, dst_x int, dst_y int, dst_width int, dst_height int, buffer_mask int) {
    C.rlBlitFramebuffer(src_x, src_y, src_width, src_height, dst_x, dst_y, dst_width, dst_height, buffer_mask)
}



// General render state
fn C.rlEnableColorBlend()                           // Enable color blending
@[inline]
pub fn rl_enable_color_blend() {
    C.rlEnableColorBlend()
}

fn C.rlDisableColorBlend()                          // Disable color blending
@[inline]
pub fn rl_disable_color_blend() {
    C.rlDisableColorBlend()
}

fn C.rlEnableDepthTest()                            // Enable depth test
@[inline]
pub fn rl_enable_depth_test() {
    C.rlEnableDepthTest()
}

fn C.rlDisableDepthTest()                           // Disable depth test
@[inline]
pub fn rl_disable_depth_test() {
    C.rlDisableDepthTest()
}

fn C.rlEnableDepthMask()                            // Enable depth write
@[inline]
pub fn rl_enable_depth_mask() {
    C.rlEnableDepthMask()
}

fn C.rlDisableDepthMask()                           // Disable depth write
@[inline]
pub fn rl_disable_depth_mask() {
    C.rlDisableDepthMask()
}

fn C.rlEnableBackfaceCulling()                      // Enable backface culling
@[inline]
pub fn rl_enable_backface_culling() {
    C.rlEnableBackfaceCulling()
}

fn C.rlDisableBackfaceCulling()                     // Disable backface culling
@[inline]
pub fn rl_disable_backface_culling() {
    C.rlDisableBackfaceCulling()
}

fn C.rlSetCullFace(mode int)                        // Set face culling mode
@[inline]
pub fn rl_set_cull_face(mode int) {
    C.rlSetCullFace(mode)
}

fn C.rlEnableScissorTest()                          // Enable scissor test
@[inline]
pub fn rl_enable_scissor_test() {
    C.rlEnableScissorTest()
}

fn C.rlDisableScissorTest()                         // Disable scissor test
@[inline]
pub fn rl_disable_scissor_test() {
    C.rlDisableScissorTest()
}

fn C.rlScissor(x int, y int, width int, height int) // Scissor test
@[inline]
pub fn rl_scissor(x int, y int, width int, height int) {
    C.rlScissor(x, y, width, height)
}

fn C.rlEnableWireMode()                             // Enable wire mode
@[inline]
pub fn rl_enable_wire_mode() {
    C.rlEnableWireMode()
}

fn C.rlEnablePointMode()                            //  Enable point mode
@[inline]
pub fn rl_enable_point_mode() {
    C.rlEnablePointMode()
}

fn C.rlDisableWireMode()                            // Disable wire mode ( and point ) maybe rename
@[inline]
pub fn rl_disable_wire_mode() {
    C.rlDisableWireMode()
}

fn C.rlSetLineWidth(width f32)                      // Set the line drawing width
@[inline]
pub fn rl_set_line_width(width f32) {
    C.rlSetLineWidth(width)
}

fn C.rlGetLineWidth() f32                           // Get the line drawing width
@[inline]
pub fn rl_get_line_width() {
    C.rlGetLineWidth()
}

fn C.rlEnableSmoothLines()                          // Enable line aliasing
@[inline]
pub fn rl_enable_smooth_lines() {
    C.rlEnableSmoothLines()
}

fn C.rlDisableSmoothLines()                         // Disable line aliasing
@[inline]
pub fn rl_disable_smooth_lines() {
    C.rlDisableSmoothLines()
}

fn C.rlEnableStereoRender()                         // Enable stereo rendering
@[inline]
pub fn rl_enable_stereo_render() {
    C.rlEnableStereoRender()
}

fn C.rlDisableStereoRender()                        // Disable stereo rendering
@[inline]
pub fn rl_disable_stereo_render() {
    C.rlDisableStereoRender()
}

fn C.rlIsStereoRenderEnabled() bool                 // Check if stereo render is enabled
@[inline]
pub fn rl_is_stereo_render_enabled() bool {
    return C.rlIsStereoRenderEnabled()
}



fn C.rlClearColor(r u8, g u8, b u8, a u8) // Clear color buffer with color
@[inline]
pub fn rl_clear_color(r u8, g u8, b u8, a u8) {
    C.rlClearColor(r, g, b, a)
}

fn C.rlClearScreenBuffers()                  // Clear used screen buffers (color and depth)
@[inline]
pub fn rl_clear_screen_buffers() {
    C.rlClearScreenBuffers()
}

fn C.rlCheckErrors()                         // Check and log OpenGL error codes
@[inline]
pub fn rl_check_errors() {
    C.rlCheckErrors()
}

fn C.rlSetBlendMode(mode int)                    // Set blending mode
@[inline]
pub fn rl_set_blend_mode(mode int) {
    C.rlSetBlendMode(mode)
}

fn C.rlSetBlendFactors(gl_src_factor int, gl_dst_factor int, gl_equation int) // Set blending mode factor and equation (using OpenGL factors)
@[inline]
pub fn rl_set_blend_factors(gl_src_factor int, gl_dst_factor int, gl_equation int) {
    C.rlSetBlendFactors(gl_src_factor, gl_dst_factor, gl_equation)
}

fn C.rlSetBlendFactorsSeparate(gl_src_rgb int, gl_dst_rgb int, gl_src_alpha int, gl_dst_alpha int, gl_eq_rgb int, gl_eq_alpha int) // Set blending mode factors and equations separately (using OpenGL factors)
@[inline]
pub fn rl_set_blend_factors_separate(gl_src_rgb int, gl_dst_rgb int, gl_src_alpha int, gl_dst_alpha int, gl_eq_rgb int, gl_eq_alpha int) {
    C.rlSetBlendFactorsSeparate(gl_src_rgb, gl_dst_rgb, gl_src_alpha, gl_dst_alpha, gl_eq_rgb, gl_eq_alpha)
}



//------------------------------------------------------------------------------------
// Functions Declaration - rlgl functionality
//------------------------------------------------------------------------------------
fn C.rlglInit(width int, height int)             // Initialize rlgl (buffers, shaders, textures, states)
@[inline]
pub fn rlgl_init(width int, height int) { C.rlglInit(width, height) }
fn C.rlglClose()                             // De-initialize rlgl (buffers, shaders, textures)
@[inline]
pub fn rlgl_close() { C.rlglClose() }


fn C.rlLoadExtensions(loader voidptr)              // Load OpenGL extensions (loader function required)
@[inline]
pub fn rl_load_extensions(loader voidptr) {
    C.rlLoadExtensions(loader)
}

fn C.rlGetVersion() int                            // Get current OpenGL version
@[inline]
pub fn rl_get_version() int {
    return C.rlGetVersion()
}

fn C.rlSetFramebufferWidth(width int)            // Set current framebuffer width
@[inline]
pub fn rl_set_framebuffer_width(width int) {
    C.rlSetFramebufferWidth(width)
}

fn C.rlSetFramebufferHeight(height int)          // Set current framebuffer height
@[inline]
pub fn rl_set_framebuffer_height(height int) {
    C.rlSetFramebufferHeight(height)
}

fn C.rlGetFramebufferWidth() int                // Get default framebuffer width
@[inline]
pub fn rl_get_framebuffer_width() int {
    return C.rlGetFramebufferWidth()
}

fn C.rlGetFramebufferHeight() int                // Get default framebuffer height
@[inline]
pub fn rl_get_framebuffer_height() int {
    return C.rlGetFramebufferHeight()
}



fn C.rlGetTextureIdDefault() u32   // Get default texture id
@[inline]
pub fn rl_get_texture_id_default() u32 {
    return C.rlGetTextureIdDefault()
}

fn C.rlGetShaderIdDefault()  u32   // Get default shader id
@[inline]
pub fn rl_get_shader_id_default() u32 {
    return C.rlGetShaderIdDefault()
}

fn C.rlGetShaderLocsDefault() &int // Get default shader locations
@[inline]
pub fn rl_get_shader_locs_default() &int {
    return C.rlGetShaderLocsDefault()
}


// Render batch management
// NOTE: rlgl provides a default render batch to behave like OpenGL 1.1 immediate mode
// but this render batch API is exposed in case of custom batches are required

fn C.rlLoadRenderBatch(num_buffers int, buffer_elements int) RenderBatch // Load a render batch system
@[inline]
pub fn rl_load_render_batch(num_buffers int, buffer_elements int) RenderBatch {
    return C.rlLoadRenderBatch(num_buffers, buffer_elements)
}

fn C.rlUnloadRenderBatch(batch RenderBatch)                              // Unload render batch system
@[inline]
pub fn rl_unload_render_batch(batch RenderBatch) {
    C.rlUnloadRenderBatch(batch)
}

fn C.rlDrawRenderBatch(batch &RenderBatch)                               // Draw render batch data (Update->Draw->Reset)
@[inline]
pub fn rl_draw_render_batch(batch &RenderBatch) {
    C.rlDrawRenderBatch(batch)
}

fn C.rlSetRenderBatchActive(batch &RenderBatch)                          // Set the active render batch for rlgl (NULL for default internal)
@[inline]
pub fn rl_set_render_batch_active(batch &RenderBatch) {
    C.rlSetRenderBatchActive(batch)                                      // Set the active render batch for rlgl (NULL for default internal)
}
fn C.rlDrawRenderBatchActive()                                           // Update and draw internal render batch
@[inline]
pub fn rl_draw_render_batch_active() {
    C.rlDrawRenderBatchActive()
}

fn C.rlCheckRenderBatchLimit(v_count int) bool                           // Check internal buffer overflow for a given number of vertex
@[inline]
pub fn rl_check_render_batch_limit(v_count int) bool {
    return C.rlCheckRenderBatchLimit(v_count)
}


fn C.rlSetTexture(id u32)               // Set current texture for render batch and check buffers limits
@[inline]
pub fn rl_set_texture(id u32) { C.rlSetTexture(id) }

//------------------------------------------------------------------------------------------------------------------------

// Vertex buffers management
fn C.rlLoadVertexArray() u32                               // Load vertex array (vao) if supported
@[inline]
pub fn load_vertex_array() u32 {;
    return C.rlLoadVertexArray()
}

fn C.rlLoadVertexBuffer(buffer voidptr, size int, dynamic bool) u32             // Load a vertex buffer attribute
@[inline]
pub fn load_vertex_buffer(buffer voidptr, size int, dynamic bool) u32 {
    return C.rlLoadVertexBuffer(buffer, size, dynamic)
}

fn C.rlLoadVertexBufferElement(buffer voidptr, size int, dynamic bool) u32     // Load a new attributes element buffer
@[inline]
pub fn load_vertex_buffer_element(buffer voidptr, size int, dynamic bool) {
    C.rlLoadVertexBufferElement(buffer, size, dynamic)
}

fn C.rlUpdateVertexBuffer(buffer_id u32, data voidptr, data_size int, offset int)     // Update GPU buffer with new data
@[inline]
pub fn update_vertex_buffer(buffer_id u32, data voidptr, data_size int, offset int) {
    C.rlUpdateVertexBuffer(buffer_id, data, data_size, offset)
}

fn C.rlUpdateVertexBufferElements(id u32, data voidptr, data_size int, offset int)   // Update vertex buffer elements with new data
@[inline]
pub fn update_vertex_buffer_elements(id u32, data voidptr, data_size int, offset int) {
    C.rlUpdateVertexBufferElements(id, data, data_size, offset)
}

fn C.rlUnloadVertexArray(vao_id u32)
@[inline]
pub fn unload_vertex_array(vao_id u32) {
    C.rlUnloadVertexArray(vao_id)    
}

fn C.rlUnloadVertexBuffer(vbo_id u32)
@[inline]
pub fn unload_vertex_buffer(vbo_id u32) {
    C.rlUnloadVertexBuffer(vbo_id)    
}

fn C.rlSetVertexAttribute(index u32, comp_size int, @type int, normalized bool, stride int, pointer voidptr)
@[inline]
pub fn set_vertex_attribute(index u32, comp_size int, @type int, normalized bool, stride int, pointer voidptr) {
    C.rlSetVertexAttribute(index, comp_size, @type, normalized, stride, pointer)
}

fn C.rlDrawVertexArray(offset int, count int)
@[inline]
pub fn draw_vertex_array(offset int, count int) {
    C.rlDrawVertexArray(offset, count)    
}

fn C.rlDrawVertexArrayElements(offset int, count int, buffer voidptr)
@[inline]
pub fn draw_vertex_array_elements(offset int, count int, buffer voidptr) {
    C.rlDrawVertexArrayElements(offset, count, buffer)    
}

fn C.rlDrawVertexArrayElementsInstanced(offset int, count int, buffer voidptr, instances int)
@[inline]
pub fn draw_vertex_array_elements_instanced(offset int, count int, buffer voidptr, instances int) {
    C.rlDrawVertexArrayElementsInstanced(offset, count, buffer, instances)
}



// Textures management
fn C.glGenTextures(int, &u32)
pub fn rl_gen_texture() u32 {
    id := u32(0)
    C.glGenTextures(1, &id)
    return id
}
pub fn rl_gen_textures(count int, id &u32) {
    C.glGenTextures(count, id)
}

fn C.rlLoadTexture(data voidptr, width int, height int, format int, mipmap_count int) u32 
@[inline]
pub fn rl_load_texture(data voidptr, width int, height int, format int, mipmap_count int) u32 {
    return C.rlLoadTexture(data, width, height, format, mipmap_count)
}

fn C.rlLoadTextureDepth(width int, height int, use_render_buffer bool) u32 // Load depth texture/renderbuffer (to be attached to fbo)
@[inline]
pub fn rl_load_texture_depth(width int, height int, use_render_buffer bool) u32 {
    return C.rlLoadTextureDepth(width, height, use_render_buffer)
}

fn C.rlLoadTextureCubemap(data voidptr, size int, format int, mipmap_count int) u32          // Load texture cubemap
@[inline]
pub fn rl_load_texture_cubemap(data voidptr, size int, format int, mipmap_count int) u32 {
    return C.rlLoadTextureCubemap(data, size, format, mipmap_count)
}


fn C.rlUpdateTexture(id u32, offset_x int, offset_y int, width int, height int, format int, data voidptr)  // Update GPU texture with new data
@[inline]
pub fn rl_update_texture(id u32, offset_x int, offset_y int, width int, height int, format int, data voidptr) {
    C.rlUpdateTexture(id, offset_x, offset_y, width, height, format, data)
}

fn C.rlGetGlTextureFormats(format int, gl_internal_format &u32, gl_format &u32, gl_type &u32)  // Get OpenGL internal formats
@[inline]
pub fn rl_get_gl_texture_formats(format int, gl_internal_format &u32, gl_format &u32, gl_type &u32) {
    C.rlGetGlTextureFormats(format, gl_internal_format, gl_format, gl_type)
}

fn C.rlGetPixelFormatName(format u32) &char              // Get name string for pixel format
@[inline]
pub fn rl_get_pixel_format_name(format u32) &char {
    return C.rlGetPixelFormatName(format)
}

fn C.rlUnloadTexture(id u32)                              // Unload texture from GPU memory
@[inline]
pub fn rl_unload_texture(id u32) {
    C.rlUnloadTexture(id)
}

fn C.rlGenTextureMipmaps(id u32, width int, height int, format int, mipmaps &int) // Generate mipmap data for selected texture
@[inline]
pub fn rl_gen_texture_mipmaps(id u32, width int, height int, format int, mipmaps &int) {
    C.rlGenTextureMipmaps(id, width, height, format, mipmaps)
}

fn C.rlReadTexturePixels(id u32, width int, height int, format int) voidptr             // Read texture pixel data
@[inline]
pub fn rl_read_texture_pixels(id u32, width int, height int, format int) voidptr {
    return C.rlReadTexturePixels(id, width, height, format)
}

fn C.rlReadScreenPixels(width int, height int) &u8           // Read screen pixel data (color buffer)
@[inline]
pub fn rl_read_screen_pixels(width int, height int) &u8 {
    return C.rlReadScreenPixels(width, height)
}


// // Framebuffer management (fbo)
// fn C.rlLoadFramebuffer(width int, height int) u32 // Load an empty framebuffer
// @[inline]
// pub fn rl_load_framebuffer(width int, height int) u32 {
//     return C.rlLoadFramebuffer(width, height)
// }
// Framebuffer management (fbo)
fn C.rlLoadFramebuffer() u32 // Load an empty framebuffer
@[inline]
pub fn rl_load_framebuffer() u32 {
    return C.rlLoadFramebuffer()
}



fn C.rlFramebufferAttach(fbo_id u32, tex_id u32, attach_type int, tex_type int, mip_level int)  // Attach texture/renderbuffer to a framebuffer
@[inline]
pub fn rl_framebuffer_attach(fbo_id u32, tex_id u32, attach_type int, tex_type int, mip_level int) {
    C.rlFramebufferAttach(fbo_id, tex_id, attach_type, tex_type, mip_level)
}

fn C.rlFramebufferComplete(id u32) bool     // Verify framebuffer is complete
@[inline]
pub fn rl_framebuffer_complete(id u32) bool {
    return C.rlFramebufferComplete(id)
}

fn C.rlUnloadFramebuffer(id u32)            // Delete framebuffer from GPU
@[inline]
pub fn rl_unload_framebuffer(id u32) {
    C.rlUnloadFramebuffer(id)
}



// Shaders management
fn C.rlLoadShaderCode(vs_code &char, fs_code &char) u32                      // Load shader from code strings
@[inline]
pub fn rl_load_shader_code(vs_code &char, fs_code &char) u32 {
    return C.rlLoadShaderCode(vs_code, fs_code)
}

fn C.rlCompileShader(shader_code &char, shader_type int) u32                 // Compile custom shader and return shader id (shader_type: RL_VERTEX_SHADER, RL_FRAGMENT_SHADER, RL_COMPUTE_SHADER)
@[inline]
pub fn rl_compile_shader(shader_code &char, shader_type int) u32 {
    return C.rlCompileShader(shader_code, shader_type)
}

fn C.rlLoadShaderProgram(v_shader_id u32, f_shader_id u32) u32               // Load custom shader program
@[inline]
pub fn rl_load_shader_program(v_shader_id u32, f_shader_id u32) u32 {
    return C.rlLoadShaderProgram(v_shader_id, f_shader_id)
}

fn C.rlUnloadShaderProgram(id u32)                                           // Unload shader program
@[inline]
pub fn rl_unload_shader_program(id u32) {
    C.rlUnloadShaderProgram(id)
}

fn C.rlGetLocationUniform(shader_id u32, uniform_name &char) int             // Get shader location uniform
@[inline]
pub fn rl_get_location_uniform(shader_id u32, uniform_name &char) int {
    return C.rlGetLocationUniform(shader_id, uniform_name)
}

fn C.rlGetLocationAttrib(shader_id u32, attrib_name &char) int               // Get shader location attribute
@[inline]
pub fn rl_get_location_attrib(shader_id u32, attrib_name &char) int {
    return C.rlGetLocationAttrib(shader_id, attrib_name)
}

fn C.rlSetUniform(loc_index int, value voidptr, uniform_type int, count int) // Set shader value uniform
@[inline]
pub fn rl_set_uniform(loc_index int, value voidptr, uniform_type int, count int) {
    C.rlSetUniform(loc_index, value, uniform_type, count)
}

fn C.rlSetUniformMatrix(loc_index int, mat Matrix)                           // Set shader value matrix
@[inline]
pub fn rl_set_uniform_matrix(loc_index int, mat Matrix) {
    C.rlSetUniformMatrix(loc_index, mat)
}

fn C.rlSetUniformSampler(loc_index int, texture_id u32)                      // Set shader value sampler
@[inline]
pub fn rl_set_uniform_sampler(loc_index int, texture_id u32) {
    C.rlSetUniformSampler(loc_index, texture_id)
}

fn C.rlSetShader(id u32, locs &int)                                          // Set shader currently active (id and locations)
@[inline]
pub fn rl_set_shader(id u32, locs &int) {
    C.rlSetShader(id, locs)
}


// Compute shader management
fn C.rlLoadComputeShaderProgram(shader_id u32) u32                   // Load compute shader program
@[inline]
pub fn rl_load_compute_shader_program(shader_id u32) u32 {
    return C.rlLoadComputeShaderProgram(shader_id)
}

fn C.rlComputeShaderDispatch(group_x u32, group_y u32, group_z u32)  // Dispatch compute shader (equivalent to *draw* for graphics pipeline)
@[inline]
pub fn rl_compute_shader_dispatch(group_x u32, group_y u32, group_z u32) {
    C.rlComputeShaderDispatch(group_x, group_y, group_z)  // Dispatch compute shader (equivalent to *draw* for graphics pipeline)
}



// Shader buffer storage object management (ssbo)
fn C.rlLoadShaderBuffer(size u32, data voidptr, usage_hint int) u32                          // Load shader storage buffer object (SSBO)
@[inline]
pub fn rl_load_shader_buffer(size u32, data voidptr, usage_hint int) u32 {
    return C.rlLoadShaderBuffer(size, data, usage_hint)
}

fn C.rlUnloadShaderBuffer(ssbo_id u32)                                                       // Unload shader storage buffer object (SSBO)
@[inline]
pub fn rl_unload_shader_buffer(ssbo_id u32) {
    C.rlUnloadShaderBuffer(ssbo_id)
}

fn C.rlUpdateShaderBuffer(id u32, data voidptr, data_size u32, offset u32)                   // Update SSBO buffer data
@[inline]
pub fn rl_update_shader_buffer(id u32, data voidptr, data_size u32, offset u32) {
    C.rlUpdateShaderBuffer(id, data, data_size, offset)
}

fn C.rlBindShaderBuffer(id u32, index u32)                                                   // Bind SSBO buffer
@[inline]
pub fn rl_bind_shader_buffer(id u32, index u32) {
    C.rlBindShaderBuffer(id, index)
}

fn C.rlReadShaderBuffer(id u32, dest voidptr, count u32, offset u32)                         // Read SSBO buffer data (GPU->CPU)
@[inline]
pub fn rl_read_shader_buffer(id u32, dest voidptr, count u32, offset u32) {
    C.rlReadShaderBuffer(id, dest, count, offset)
}

fn C.rlCopyShaderBuffer(dest_id u32, src_id u32, dest_offset u32, src_offset u32, count u32) // Copy SSBO data between buffers
@[inline]
pub fn rl_copy_shader_buffer(dest_id u32, src_id u32, dest_offset u32, src_offset u32, count u32) {
    C.rlCopyShaderBuffer(dest_id, src_id, dest_offset, src_offset, count)
}

fn C.rlGetShaderBufferSize(id u32) u32                                                       // Get SSBO buffer size
@[inline]
pub fn rl_get_shader_buffer_size(id u32) u32 {
    return C.rlGetShaderBufferSize(id)
}



// Buffer management
fn C.rlBindImageTexture(id u32, index u32, format int, readonly bool)  // Bind image texture
@[inline]
pub fn rl_bind_image_texture(id u32, index u32, format int, readonly bool) {
    C.rlBindImageTexture(id, index, format, readonly)
}



// Matrix state management
fn C.rlGetMatrixModelview() Matrix                          // Get internal modelview matrix
@[inline]
pub fn rl_get_matrix_modelview() Matrix {
    return C.rlGetMatrixModelview()
}

fn C.rlGetMatrixProjection() Matrix                         // Get internal projection matrix
@[inline]
pub fn rl_get_matrix_projection() Matrix {
    return C.rlGetMatrixProjection()
}

fn C.rlGetMatrixTransform() Matrix                          // Get internal accumulated transform matrix
@[inline]
pub fn rl_get_matrix_transform() Matrix {
    return C.rlGetMatrixTransform()
}

fn C.rlGetMatrixProjectionStereo(eye int) Matrix            // Get internal projection matrix for stereo render (selected eye)
@[inline]
pub fn rl_get_matrix_projection_stereo(eye int) Matrix {
    return C.rlGetMatrixProjectionStereo(eye)
}

fn C.rlGetMatrixViewOffsetStereo(eye int) Matrix            // Get internal view offset matrix for stereo render (selected eye)
@[inline]
pub fn rl_get_matrix_view_offset_stereo(eye int ) Matrix {
    return C.rlGetMatrixViewOffsetStereo(eye)
}

fn C.rlSetMatrixProjection(proj Matrix)                     // Set a custom projection matrix (replaces internal projection matrix)
@[inline]
pub fn rl_set_matrix_projection(proj Matrix) {
    C.rlSetMatrixProjection(proj)
}

fn C.rlSetMatrixModelview(view Matrix)                      // Set a custom modelview matrix (replaces internal modelview matrix)
@[inline]
pub fn rl_set_matrix_modelview(view Matrix) {
    C.rlSetMatrixModelview(view)
}

fn C.rlSetMatrixProjectionStereo(right Matrix, left Matrix) // Set eyes projection matrices for stereo rendering
@[inline]
pub fn rl_set_matrix_projection_stereo(right Matrix, left Matrix) {
    C.rlSetMatrixProjectionStereo(right, left)
}

fn C.rlSetMatrixViewOffsetStereo(right Matrix, left Matrix) // Set eyes view offsets matrices for stereo rendering
@[inline]
pub fn rl_set_matrix_view_offset_stereo(right Matrix, left Matrix) {
    C.rlSetMatrixViewOffsetStereo(right, left)
}



// Quick and dirty cube/quad buffers load->draw->unload
fn C.rlLoadDrawCube()     // Load and draw a cube
@[inline] pub fn rl_load_draw_cube() { C.rlLoadDrawCube() }

fn C.rlLoadDrawQuad()     // Load and draw a quad
@[inline] pub fn rl_load_draw_quad() { C.rlLoadDrawQuad() }





/***********************************************************************************
*
*   RLGL IMPLEMENTATION
*
************************************************************************************/

// fn C.rlGetLocationUniform(shader_id u32, uniform_name &char) int // Get shader location uniform
// @[inline]
// pub fn get_location_uniform(shader_id u32, uniform_name string) int {
//     return C.rlGetLocationUniform(shader_id, uniform_name.str)
// }

// fn C.rlGetLocationAttrib(shader_id u32, attrib_name &char) int // Get shader location attribute
// @[inline]
// pub fn get_location_attrib(shader_id u32, attrib_name string) int {
//     return C.rlGetLocationAttrib(shader_id, attrib_name.str)
// }

// fn C.rlSetUniform(loc_index int, value voidptr, uniform_type int, count int)   // Set shader value uniform
// @[inline]
// pub fn set_uniform(loc_index int, value voidptr, uniform_type int, count int) {
//     C.rlSetUniform(loc_index, value, uniform_type, count)
// }

// fn C.rlSetUniformMatrix(loc_index int, mat Matrix)                        // Set shader value matrix
// @[inline]
// pub fn set_uniform_matrix(loc_index int, mat Matrix) {
//     C.rlSetUniformMatrix(loc_index, mat)
// }

// fn C.rlSetUniformSampler(loc_index int, texture_id int)           // Set shader value sampler
// @[inline]
// pub fn set_uniform_sampler(loc_index int, texture_id int) {
//     C.rlSetUniformSampler(loc_index, texture_id)
// }

// fn C.rlSetShader(id u32, locs &int)                             // Set shader currently active (id and locations)
// @[inline]
// pub fn set_shader(id u32, locs &int) {
//     C.rlSetShader(id, locs)
// }
