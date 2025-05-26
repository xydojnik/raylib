// /**********************************************************************************************
// *
// *   raylib v5.5- A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
// *
// *   FEATURES:
// *       - NO external dependencies, all required libraries included with raylib
// *       - Multiplatform: Windows, Linux, FreeBSD, OpenBSD, NetBSD, DragonFly,
// *                        MacOS, Haiku, Android, Raspberry Pi, DRM native, HTML5.
// *       - Written in plain C code (C99) in PascalCase/camelCase notation
// *       - Hardware accelerated with OpenGL (1.1, 2.1, 3.3, 4.3 or ES2 - choose at compile)
// *       - Unique OpenGL abstraction layer (usable as standalone module): [rlgl]
// *       - Multiple Fonts formats supported (TTF, XNA fonts, AngelCode fonts)
// *       - Outstanding texture formats support, including compressed formats (DXT, ETC, ASTC)
// *       - Full 3d support for 3d Shapes, Models, Billboards, Heightmaps and more!
// *       - Flexible Materials system, supporting classic maps and PBR maps
// *       - Animated 3D models supported (skeletal bones animation) (IQM)
// *       - Shaders support, including Model shaders and Postprocessing shaders
// *       - Powerful math module for Vector, Matrix and Quaternion operations: [raymath]
// *       - Audio loading and playing with streaming support (WAV, OGG, MP3, FLAC, XM, MOD)
// *       - VR stereo rendering with configurable HMD device parameters
// *       - Bindings to multiple programming languages available!
// *
// *   NOTES:
// *       - One default Font is loaded on InitWindow()->LoadFontDefault() [core, text]
// *       - One default Texture is loaded on rlglInit(), 1x1 white pixel R8G8B8A8 [rlgl] (OpenGL 3.3 or ES2)
// *       - One default Shader is loaded on rlglInit()->rlLoadShaderDefault() [rlgl] (OpenGL 3.3 or ES2)
// *       - One default RenderBatch is loaded on rlglInit()->rlLoadRenderBatch() [rlgl] (OpenGL 3.3 or ES2)
// *
// *   DEPENDENCIES (included):
// *       [rcore] rglfw (Camilla Löwy - github.com/glfw/glfw) for window/context management and input (PLATFORM_DESKTOP)
// *       [rlgl] glad (David Herberth - github.com/Dav1dde/glad) for OpenGL 3.3 extensions loading (PLATFORM_DESKTOP)
// *       [raudio] miniaudio (David Reid - github.com/mackron/miniaudio) for audio device/context management
// *
// *   OPTIONAL DEPENDENCIES (included):
// *       [rcore] msf_gif (Miles Fogle) for GIF recording
// *       [rcore] sinfl (Micha Mettke) for DEFLATE decompression algorithm
// *       [rcore] sdefl (Micha Mettke) for DEFLATE compression algorithm
// *       [rtextures] stb_image (Sean Barret) for images loading (BMP, TGA, PNG, JPEG, HDR...)
// *       [rtextures] stb_image_write (Sean Barret) for image writing (BMP, TGA, PNG, JPG)
// *       [rtextures] stb_image_resize (Sean Barret) for image resizing algorithms
// *       [rtext] stb_truetype (Sean Barret) for ttf fonts loading
// *       [rtext] stb_rect_pack (Sean Barret) for rectangles packing
// *       [rmodels] par_shapes (Philip Rideout) for parametric 3d shapes generation
// *       [rmodels] tinyobj_loader_c (Syoyo Fujita) for models loading (OBJ, MTL)
// *       [rmodels] cgltf (Johannes Kuhlmann) for models loading (glTF)
// *       [rmodels] Model3D (bzt) for models loading (M3D, https://bztsrc.gitlab.io/model3d)
// *       [raudio] dr_wav (David Reid) for WAV audio file loading
// *       [raudio] dr_flac (David Reid) for FLAC audio file loading
// *       [raudio] dr_mp3 (David Reid) for MP3 audio file loading
// *       [raudio] stb_vorbis (Sean Barret) for OGG audio loading
// *       [raudio] jar_xm (Joshua Reisenauer) for XM audio module loading
// *       [raudio] jar_mod (Joshua Reisenauer) for MOD audio module loading
// *
// *
// *   LICENSE: zlib/libpng
// *
// *   raylib is licensed under an unmodified zlib/libpng license, which is an OSI-certified,
// *   BSD-like license that allows static linking with closed source software:
// *
// *   Copyright           (c) 2013-2024 Ramon Santamaria  (@raysan5)
// *   Translated&Modified (c) 2024      Fedorov Aleksandr (@xydojnik)
// *
// *   This software is provided "as-is", without any express or implied warranty. In no event
// *   will the authors be held liable for any damages arising from the use of this software.
// *
// *   Permission is granted to anyone to use this software for any purpose, including commercial
// *   applications, and to alter it and redistribute it freely, subject to the following restrictions:
// *
// *     1. The origin of this software must not be misrepresented; you must not claim that you
// *     wrote the original software. If you use this software in a product, an acknowledgment
// *     in the product documentation would be appreciated but is not required.
// *
// *     2. Altered source versions must be plainly marked as such, and must not be misrepresented
// *     as being the original software.
// *
// *     3. This notice may not be removed or altered from any source distribution.
// *
// **********************************************************************************************/
                                                    
module raylib


import c as _
                                                    
//----------------------------------------------------------------------------------
// Enumerators Definition
//----------------------------------------------------------------------------------
// System/Window config flags
// NOTE: Every bit registers one state (use it with bit masks)
// By default all flags are set to 0
pub const flag_vsync_hint                 = C.FLAG_VSYNC_HINT               // Set to try enabling V-Sync on GPU
pub const flag_fullscreen_mode            = C.FLAG_FULLSCREEN_MODE          // Set to run program in fullscreen
pub const flag_window_resizable           = C.FLAG_WINDOW_RESIZABLE         // Set to allow resizable window
pub const flag_window_undecorated         = C.FLAG_WINDOW_UNDECORATED       // Set to disable window decoration (frame and buttons)
pub const flag_window_hidden              = C.FLAG_WINDOW_HIDDEN            // Set to hide window
pub const flag_window_minimized           = C.FLAG_WINDOW_MINIMIZED         // Set to minimize window (iconify)
pub const flag_window_maximized           = C.FLAG_WINDOW_MAXIMIZED         // Set to maximize window (expanded to monitor)
pub const flag_window_unfocused           = C.FLAG_WINDOW_UNFOCUSED         // Set to window non focused
pub const flag_window_topmost             = C.FLAG_WINDOW_TOPMOST           // Set to window always on top
pub const flag_window_always_run          = C.FLAG_WINDOW_ALWAYS_RUN        // Set to allow windows running while minimized
pub const flag_window_transparent         = C.FLAG_WINDOW_TRANSPARENT       // Set to allow transparent framebuffer
pub const flag_window_highdpi             = C.FLAG_WINDOW_HIGHDPI           // Set to support HighDPI
pub const flag_window_mouse_passthrough   = C.FLAG_WINDOW_MOUSE_PASSTHROUGH // Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
pub const flag_borderless_windowed_mode   = C.FLAG_BORDERLESS_WINDOWED_MODE // Set to run program in borderless windowed mode
pub const flag_msaa_4x_hint               = C.FLAG_MSAA_4X_HINT             // Set to try enabling MSAA 4X
pub const flag_interlaced_hint            = C.FLAG_INTERLACED_HINT          // Set to try enabling interlaced video format (for V3D)




// Keyboard keys (US keyboard layout)
// NOTE: Use GetKeyPressed() to allow redefining
// required keys for alternative layouts
pub const key_null          = C.KEY_NULL          // Key: NULL, used for no key pressed
// Alphanumeric keys
pub const key_apostrophe    = C.KEY_APOSTROPHE    // Key: '
pub const key_comma         = C.KEY_COMMA         // Key: ,
pub const key_minus         = C.KEY_MINUS         // Key: -
pub const key_period        = C.KEY_PERIOD        // Key: .
pub const key_slash         = C.KEY_SLASH         // Key: /
pub const key_zero          = C.KEY_ZERO          // Key: 0
pub const key_one           = C.KEY_ONE           // Key: 1
pub const key_two           = C.KEY_TWO           // Key: 2
pub const key_three         = C.KEY_THREE         // Key: 3
pub const key_four          = C.KEY_FOUR          // Key: 4
pub const key_five          = C.KEY_FIVE          // Key: 5
pub const key_six           = C.KEY_SIX           // Key: 6
pub const key_seven         = C.KEY_SEVEN         // Key: 7
pub const key_eight         = C.KEY_EIGHT         // Key: 8
pub const key_nine          = C.KEY_NINE          // Key: 9
pub const key_semicolon     = C.KEY_SEMICOLON     // Key: ;
pub const key_equal         = C.KEY_EQUAL         // Key: =
pub const key_a             = C.KEY_A             // Key: A | a
pub const key_b             = C.KEY_B             // Key: B | b
pub const key_c             = C.KEY_C             // Key: C | c
pub const key_d             = C.KEY_D             // Key: D | d
pub const key_e             = C.KEY_E             // Key: E | e
pub const key_f             = C.KEY_F             // Key: F | f
pub const key_g             = C.KEY_G             // Key: G | g
pub const key_h             = C.KEY_H             // Key: H | h
pub const key_i             = C.KEY_I             // Key: I | i
pub const key_j             = C.KEY_J             // Key: J | j
pub const key_k             = C.KEY_K             // Key: K | k
pub const key_l             = C.KEY_L             // Key: L | l
pub const key_m             = C.KEY_M             // Key: M | m
pub const key_n             = C.KEY_N             // Key: N | n
pub const key_o             = C.KEY_O             // Key: O | o
pub const key_p             = C.KEY_P             // Key: P | p
pub const key_q             = C.KEY_Q             // Key: Q | q
pub const key_r             = C.KEY_R             // Key: R | r
pub const key_s             = C.KEY_S             // Key: S | s
pub const key_t             = C.KEY_T             // Key: T | t
pub const key_u             = C.KEY_U             // Key: U | u
pub const key_v             = C.KEY_V             // Key: V | v
pub const key_w             = C.KEY_W             // Key: W | w
pub const key_x             = C.KEY_X             // Key: X | x
pub const key_y             = C.KEY_Y             // Key: Y | y
pub const key_z             = C.KEY_Z             // Key: Z | z
pub const key_left_bracket  = C.KEY_LEFT_BRACKET  // Key: [
pub const key_backslash     = C.KEY_BACKSLASH     // Key: '\'
pub const key_right_bracket = C.KEY_RIGHT_BRACKET // Key: ]
pub const key_grave         = C.KEY_GRAVE         // Key: `
// Function keys
pub const key_space         = C.KEY_SPACE         // Key: Space
pub const key_escape        = C.KEY_ESCAPE        // Key: Esc
pub const key_enter         = C.KEY_ENTER         // Key: Enter
pub const key_tab           = C.KEY_TAB           // Key: Tab
pub const key_backspace     = C.KEY_BACKSPACE     // Key: Backspace
pub const key_insert        = C.KEY_INSERT        // Key: Ins
pub const key_delete        = C.KEY_DELETE        // Key: Del
pub const key_right         = C.KEY_RIGHT         // Key: Cursor right
pub const key_left          = C.KEY_LEFT          // Key: Cursor left
pub const key_down          = C.KEY_DOWN          // Key: Cursor down
pub const key_up            = C.KEY_UP            // Key: Cursor up
pub const key_page_up       = C.KEY_PAGE_UP       // Key: Page up
pub const key_page_down     = C.KEY_PAGE_DOWN     // Key: Page down
pub const key_home          = C.KEY_HOME          // Key: Home
pub const key_end           = C.KEY_END           // Key: End
pub const key_caps_lock     = C.KEY_CAPS_LOCK     // Key: Caps lock
pub const key_scroll_lock   = C.KEY_SCROLL_LOCK   // Key: Scroll down
pub const key_num_lock      = C.KEY_NUM_LOCK      // Key: Num lock
pub const key_print_screen  = C.KEY_PRINT_SCREEN  // Key: Print screen
pub const key_pause         = C.KEY_PAUSE         // Key: Pause
pub const key_f1            = C.KEY_F1            // Key: F1
pub const key_f2            = C.KEY_F2            // Key: F2
pub const key_f3            = C.KEY_F3            // Key: F3
pub const key_f4            = C.KEY_F4            // Key: F4
pub const key_f5            = C.KEY_F5            // Key: F5
pub const key_f6            = C.KEY_F6            // Key: F6
pub const key_f7            = C.KEY_F7            // Key: F7
pub const key_f8            = C.KEY_F8            // Key: F8
pub const key_f9            = C.KEY_F9            // Key: F9
pub const key_f10           = C.KEY_F10           // Key: F10
pub const key_f11           = C.KEY_F11           // Key: F11
pub const key_f12           = C.KEY_F12           // Key: F12
pub const key_left_shift    = C.KEY_LEFT_SHIFT    // Key: Shift left
pub const key_left_control  = C.KEY_LEFT_CONTROL  // Key: Control left
pub const key_left_alt      = C.KEY_LEFT_ALT      // Key: Alt left
pub const key_left_super    = C.KEY_LEFT_SUPER    // Key: Super left
pub const key_right_shift   = C.KEY_RIGHT_SHIFT   // Key: Shift right
pub const key_right_control = C.KEY_RIGHT_CONTROL // Key: Control right
pub const key_right_alt     = C.KEY_RIGHT_ALT     // Key: Alt right
pub const key_right_super   = C.KEY_RIGHT_SUPER   // Key: Super right
pub const key_kb_menu       = C.KEY_KB_MENU       // Key: KB menu
// Keypad keys
pub const key_kp_0          = C.KEY_KP_0          // Key: Keypad 0
pub const key_kp_1          = C.KEY_KP_1          // Key: Keypad 1
pub const key_kp_2          = C.KEY_KP_2          // Key: Keypad 2
pub const key_kp_3          = C.KEY_KP_3          // Key: Keypad 3
pub const key_kp_4          = C.KEY_KP_4          // Key: Keypad 4
pub const key_kp_5          = C.KEY_KP_5          // Key: Keypad 5
pub const key_kp_6          = C.KEY_KP_6          // Key: Keypad 6
pub const key_kp_7          = C.KEY_KP_7          // Key: Keypad 7
pub const key_kp_8          = C.KEY_KP_8          // Key: Keypad 8
pub const key_kp_9          = C.KEY_KP_9          // Key: Keypad 9
pub const key_kp_decimal    = C.KEY_KP_DECIMAL    // Key: Keypad .
pub const key_kp_divide     = C.KEY_KP_DIVIDE     // Key: Keypad /
pub const key_kp_multiply   = C.KEY_KP_MULTIPLY   // Key: Keypad *
pub const key_kp_subtract   = C.KEY_KP_SUBTRACT   // Key: Keypad -
pub const key_kp_add        = C.KEY_KP_ADD        // Key: Keypad +
pub const key_kp_enter      = C.KEY_KP_ENTER      // Key: Keypad Enter
pub const key_kp_equal      = C.KEY_KP_EQUAL      // Key: Keypad =
// Android key buttons
pub const key_back          = C.KEY_BACK          // Key: Android back button
pub const key_menu          = C.KEY_MENU          // Key: Android menu button
pub const key_volume_up     = C.KEY_VOLUME_UP     // Key: Android volume up button
pub const key_volume_down   = C.KEY_VOLUME_DOWN   // Key: Android volume down button



// Add backwards compatibility support for deprecated names
pub const mouse_button_left    = C.MOUSE_BUTTON_LEFT         // Mouse button left
pub const mouse_button_right   = C.MOUSE_BUTTON_RIGHT        // Mouse button right
pub const mouse_button_middle  = C.MOUSE_BUTTON_MIDDLE       // Mouse button middle (pressed wheel)
pub const mouse_button_side    = C.MOUSE_BUTTON_SIDE         // Mouse button side (advanced mouse device)
pub const mouse_button_extra   = C.MOUSE_BUTTON_EXTRA        // Mouse button extra (advanced mouse device)
pub const mouse_button_forward = C.MOUSE_BUTTON_FORWARD      // Mouse button forward (advanced mouse device)
pub const mouse_button_back    = C.MOUSE_BUTTON_BACK         // Mouse button back (advanced mouse device)

// Add backwards compatibility support for deprecated names
pub const mouse_left_button   = C.MOUSE_BUTTON_LEFT
pub const mouse_right_button  = C.MOUSE_BUTTON_RIGHT
pub const mouse_middle_button = C.MOUSE_BUTTON_MIDDLE


// Mouse cursor
pub const mouse_cursor_default       =  C.MOUSE_CURSOR_DEFAULT          // Default pointer shape
pub const mouse_cursor_arrow         =  C.MOUSE_CURSOR_ARROW            // Arrow shape
pub const mouse_cursor_ibeam         =  C.MOUSE_CURSOR_IBEAM            // Text writing cursor shape
pub const mouse_cursor_crosshair     =  C.MOUSE_CURSOR_CROSSHAIR        // Cross shape
pub const mouse_cursor_pointing_hand =  C.MOUSE_CURSOR_POINTING_HAND    // Pointing hand cursor
pub const mouse_cursor_resize_ew     =  C.MOUSE_CURSOR_RESIZE_EW        // Horizontal resize/move arrow shape
pub const mouse_cursor_resize_ns     =  C.MOUSE_CURSOR_RESIZE_NS        // Vertical resize/move arrow shape
pub const mouse_cursor_resize_nwse   =  C.MOUSE_CURSOR_RESIZE_NWSE      // Top-left to bottom-right diagonal resize/move arrow shape
pub const mouse_cursor_resize_nesw   =  C.MOUSE_CURSOR_RESIZE_NESW      // The top-right to bottom-left diagonal resize/move arrow shape
pub const mouse_cursor_resize_all    =  C.MOUSE_CURSOR_RESIZE_ALL       // The omnidirectional resize/move cursor shape
pub const mouse_cursor_not_allowed   =  C.MOUSE_CURSOR_NOT_ALLOWED      // The operation-not-allowed shape


// Gamepad buttons
pub const gamepad_button_unknown          = C.GAMEPAD_BUTTON_UNKNOWN          // Unknown button, just for error checking
pub const gamepad_button_left_face_up     = C.GAMEPAD_BUTTON_LEFT_FACE_UP     // Gamepad left DPAD up button
pub const gamepad_button_left_face_right  = C.GAMEPAD_BUTTON_LEFT_FACE_RIGHT  // Gamepad left DPAD right button
pub const gamepad_button_left_face_down   = C.GAMEPAD_BUTTON_LEFT_FACE_DOWN   // Gamepad left DPAD down button
pub const gamepad_button_left_face_left   = C.GAMEPAD_BUTTON_LEFT_FACE_LEFT   // Gamepad left DPAD left button
pub const gamepad_button_right_face_up    = C.GAMEPAD_BUTTON_RIGHT_FACE_UP    // Gamepad right button up (i.e. PS3: Triangle, Xbox: Y)
pub const gamepad_button_right_face_right = C.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT // Gamepad right button right (i.e. PS3: Circle, Xbox: B)
pub const gamepad_button_right_face_down  = C.GAMEPAD_BUTTON_RIGHT_FACE_DOWN  // Gamepad right button down (i.e. PS3: Cross, Xbox: A)
pub const gamepad_button_right_face_left  = C.GAMEPAD_BUTTON_RIGHT_FACE_LEFT  // Gamepad right button left (i.e. PS3: Square, Xbox: X)
pub const gamepad_button_left_trigger_1   = C.GAMEPAD_BUTTON_LEFT_TRIGGER_1   // Gamepad top/back trigger left (first), it could be a trailing button
pub const gamepad_button_left_trigger_2   = C.GAMEPAD_BUTTON_LEFT_TRIGGER_2   // Gamepad top/back trigger left (second), it could be a trailing button
pub const gamepad_button_right_trigger_1  = C.GAMEPAD_BUTTON_RIGHT_TRIGGER_1  // Gamepad top/back trigger right (first), it could be a trailing button
pub const gamepad_button_right_trigger_2  = C.GAMEPAD_BUTTON_RIGHT_TRIGGER_2  // Gamepad top/back trigger right (second), it could be a trailing button
pub const gamepad_button_middle_left      = C.GAMEPAD_BUTTON_MIDDLE_LEFT      // Gamepad center buttons, left one (i.e. PS3: Select)
pub const gamepad_button_middle           = C.GAMEPAD_BUTTON_MIDDLE           // Gamepad center buttons, middle one (i.e. PS3: PS, Xbox: XBOX)
pub const gamepad_button_middle_right     = C.GAMEPAD_BUTTON_MIDDLE_RIGHT     // Gamepad center buttons, right one (i.e. PS3: Start)
pub const gamepad_button_left_thumb       = C.GAMEPAD_BUTTON_LEFT_THUMB       // Gamepad joystick pressed button left
pub const gamepad_button_right_thumb      = C.GAMEPAD_BUTTON_RIGHT_THUMB      // Gamepad joystick pressed button right


// Gamepad axis
pub const gamepad_axis_left_x        = C.GAMEPAD_AXIS_LEFT_X           // Gamepad left stick X axis
pub const gamepad_axis_left_y        = C.GAMEPAD_AXIS_LEFT_Y           // Gamepad left stick Y axis
pub const gamepad_axis_right_x       = C.GAMEPAD_AXIS_RIGHT_X          // Gamepad right stick X axis
pub const gamepad_axis_right_y       = C.GAMEPAD_AXIS_RIGHT_Y          // Gamepad right stick Y axis
pub const gamepad_axis_left_trigger  = C.GAMEPAD_AXIS_LEFT_TRIGGER     // Gamepad back trigger left, pressure level: [1..-1]
pub const gamepad_axis_right_trigger = C.GAMEPAD_AXIS_RIGHT_TRIGGER    // Gamepad back trigger right, pressure level: [1..-1]


// Pixel formats
// NOTE: Support depends on OpenGL version and platform
pub const pixelformat_uncompressed_grayscale       = C.PIXELFORMAT_UNCOMPRESSED_GRAYSCALE    // 8 bit per pixel (no alpha)
pub const pixelformat_uncompressed_gray_alpha      = C.PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA   // 8*2 bpp (2 channels)
pub const pixelformat_uncompressed_r5_g6_b5        = C.PIXELFORMAT_UNCOMPRESSED_R5G6B5       // 16 bpp
pub const pixelformat_uncompressed_r8_g8_b8        = C.PIXELFORMAT_UNCOMPRESSED_R8G8B8       // 24 bpp
pub const pixelformat_uncompressed_r5_g5_b5_a1     = C.PIXELFORMAT_UNCOMPRESSED_R5G5B5A1     // 16 bpp (1 bit alpha)
pub const pixelformat_uncompressed_r4_g4_b4_a4     = C.PIXELFORMAT_UNCOMPRESSED_R4G4B4A4     // 16 bpp (4 bit alpha)
pub const pixelformat_uncompressed_r8_g8_b8_a8     = C.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8     // 32 bpp
pub const pixelformat_uncompressed_r32             = C.PIXELFORMAT_UNCOMPRESSED_R32          // 32 bpp (1 channel - float)
pub const pixelformat_uncompressed_r32_g32_b32     = C.PIXELFORMAT_UNCOMPRESSED_R32G32B32    // 32*3 bpp (3 channels - float)
pub const pixelformat_uncompressed_r32_g32_b32_a32 = C.PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 // 32*4 bpp (4 channels - float)
pub const pixelformat_uncompressed_r16             = C.PIXELFORMAT_UNCOMPRESSED_R16          // 16 bpp (1 channel - half float)
pub const pixelformat_uncompressed_r16_g16_b16     = C.PIXELFORMAT_UNCOMPRESSED_R16G16B16    // 16*3 bpp (3 channels - half float)
pub const pixelformat_uncompressed_r16_g16_b16_a16 = C.PIXELFORMAT_UNCOMPRESSED_R16G16B16A16 // 16*4 bpp (4 channels - half float)
pub const pixelformat_compressed_dxt1_rgb          = C.PIXELFORMAT_COMPRESSED_DXT1_RGB       // 4 bpp (no alpha)
pub const pixelformat_compressed_dxt1_rgba         = C.PIXELFORMAT_COMPRESSED_DXT1_RGBA      // 4 bpp (1 bit alpha)
pub const pixelformat_compressed_dxt3_rgba         = C.PIXELFORMAT_COMPRESSED_DXT3_RGBA      // 8 bpp
pub const pixelformat_compressed_dxt5_rgba         = C.PIXELFORMAT_COMPRESSED_DXT5_RGBA      // 8 bpp
pub const pixelformat_compressed_etc1_rgb          = C.PIXELFORMAT_COMPRESSED_ETC1_RGB       // 4 bpp
pub const pixelformat_compressed_etc2_rgb          = C.PIXELFORMAT_COMPRESSED_ETC2_RGB       // 4 bpp
pub const pixelformat_compressed_etc2_eac_rgba     = C.PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA  // 8 bpp
pub const pixelformat_compressed_pvrt_rgb          = C.PIXELFORMAT_COMPRESSED_PVRT_RGB       // 4 bpp
pub const pixelformat_compressed_pvrt_rgba         = C.PIXELFORMAT_COMPRESSED_PVRT_RGBA      // 4 bpp
pub const pixelformat_compressed_astc_4x4_rgba     = C.PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA  // 8 bpp
pub const pixelformat_compressed_astc_8x8_rgba     = C.PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA  // 2 bpp


// Font type, defines generation method
pub const font_default = C.FONT_DEFAULT // Default font generation, anti-aliased
pub const font_bitmap  = C.FONT_BITMAP  // Bitmap font generation, no anti-aliasing
pub const font_sdf     = C.FONT_SDF     // SDF font generation, requires external shader


// Color blending modes (pre-defined)
pub const blend_alpha             = C.BLEND_ALPHA             // Blend textures considering alpha (default)
pub const blend_additive          = C.BLEND_ADDITIVE          // Blend textures adding colors
pub const blend_multiplied        = C.BLEND_MULTIPLIED        // Blend textures multiplying colors
pub const blend_add_colors        = C.BLEND_ADD_COLORS        // Blend textures adding colors (alternative)
pub const blend_subtract_colors   = C.BLEND_SUBTRACT_COLORS   // Blend textures subtracting colors (alternative)
pub const blend_alpha_premultiply = C.BLEND_ALPHA_PREMULTIPLY // Blend premultiplied textures considering alpha
pub const blend_custom            = C.BLEND_CUSTOM            // Blend textures using custom src/dst factors (use rlSetBlendFactors())
pub const blend_custom_separate   = C.BLEND_CUSTOM_SEPARATE   // Blend textures using custom rgb/alpha separate src/dst factors (use rlSetBlendFactorsSeparate())


// // Color blending modes (pre-defined)
// pub enum BlendMode as int {
//     alpha             = C.BLEND_ALPHA
//     additive          = C.BLEND_ADDITIVE
//     multiplied        = C.BLEND_MULTIPLIED
//     add_colors        = C.BLEND_ADD_COLORS
//     subtract_colors   = C.BLEND_SUBTRACT_COLORS
//     alpha_premultiply = C.BLEND_ALPHA_PREMULTIPLY
//     custom            = C.BLEND_CUSTOM
//     custom_separate   = C.BLEND_CUSTOM_SEPARATE
// }


// Gesture
// NOTE: Provided as bit-wise flags to enable only desired gestures
pub const gesture_none        = C.GESTURE_NONE        // No gesture
pub const gesture_tap         = C.GESTURE_TAP         // Tap gesture
pub const gesture_doubletap   = C.GESTURE_DOUBLETAP   // Double tap gesture
pub const gesture_hold        = C.GESTURE_HOLD        // Hold gesture
pub const gesture_drag        = C.GESTURE_DRAG        // Drag gesture
pub const gesture_swipe_right = C.GESTURE_SWIPE_RIGHT // Swipe right gesture
pub const gesture_swipe_left  = C.GESTURE_SWIPE_LEFT  // Swipe left gesture
pub const gesture_swipe_up    = C.GESTURE_SWIPE_UP    // Swipe up gesture
pub const gesture_swipe_down  = C.GESTURE_SWIPE_DOWN  // Swipe down gesture
pub const gesture_pinch_in    = C.GESTURE_PINCH_IN    // Pinch in gesture
pub const gesture_pinch_out   = C.GESTURE_PINCH_OUT   // Pinch out gesture


// N-patch layout
pub const npatch_nine_patch             = C.NPATCH_NINE_PATCH             // Npatch layout: 3x3 tiles
pub const npatch_three_patch_vertical   = C.NPATCH_THREE_PATCH_VERTICAL   // Npatch layout: 1x3 tiles
pub const npatch_three_patch_horizontal = C.NPATCH_THREE_PATCH_HORIZONTAL // Npatch layout: 3x1 tiles


// Rectangle, 4 components
@[typedef]
struct C.Rectangle {
pub mut:
	x      f32      // Rectangle top-left corner position x
	y      f32      // Rectangle top-left corner position y
	width  f32      // Rectangle width
	height f32      // Rectangle height
}
pub type Rectangle = C.Rectangle


// NPatchInfo, n-patch layout info
@[typedef]
struct C.NPatchInfo {
pub mut:
	source Rectangle    // Texture source rectangle
	left   int          // Left border offset
	top    int          // Top border offset
	right  int          // Right border offset
	bottom int          // Bottom border offset
	layout int          // Layout of the n-patch: 3x3, 1x3 or 3x1
}
pub type NPatchInfo = C.NPatchInfo

// GlyphInfo, font characters glyphs info
@[typedef]
struct C.GlyphInfo {
pub mut:
	value    int        // Character value (Unicode)
	offsetX  int        // Character offset X when drawing
	offsetY  int        // Character offset Y when drawing
	advanceX int        // Character advance position X
	image    Image      // Character image data
}
pub type GlyphInfo = C.GlyphInfo


// Font, font texture and GlyphInfo array data
@[typedef]
struct C.Font {
pub mut:
	baseSize     int        // Base size (default chars height)
	glyphCount   int        // Number of glyph characters
	glyphPadding int        // Padding around the glyph characters
	texture      Texture  // Texture atlas containing the glyphs
	recs         &Rectangle // Rectangles in texture for the glyphs
	glyphs       &GlyphInfo // Glyphs info data
}
pub type Font = C.Font


// Transform, vertex transformation data
@[typedef]
struct C.Transform {
pub mut:
	translation Vector3       // Translation
	rotation    Quaternion    // Rotation
	scale       Vector3       // Scale
}
pub type Transform = C.Transform
                                                    

// Ray, ray for raycasting
@[typedef]
struct C.Ray {
pub mut:
	position  Vector3         // Ray position (origin)
	direction Vector3         // Ray direction
}
pub type Ray = C.Ray

// RayCollision, ray hit information
@[typedef]
struct C.RayCollision {
pub mut:
	hit      bool             // Did the ray hit something?
	distance f32              // Distance to the nearest hit
	point    Vector3          // Point of the nearest hit
	normal   Vector3          // Surface normal of hit
}
pub type RayCollision = C.RayCollision

// BoundingBox
@[typedef]
struct C.BoundingBox {
pub mut:
	min Vector3               // Minimum vertex box-corner
	max Vector3               // Maximum vertex box-corner
}
pub type BoundingBox = C.BoundingBox

// Wave, audio wave data
@[typedef]
struct C.Wave {
pub mut:
	frameCount u32            // Total number of frames (considering channels)
	sampleRate u32            // Frequency (samples per second)
	sampleSize u32            // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
	channels   u32            // Number of channels (1-mono, 2-stereo, ...)
	data       voidptr        // Buffer data pointer
}
pub type Wave = C.Wave

// Opaque structs declaration
// NOTE: Actual structs are defined internally in raudio module
// struct AudioBuffer{}
// struct AudioProcessor{}

// AudioStream, custom audio stream
@[typedef]
struct C.AudioStream {
pub mut:
	buffer     voidptr        // rAudioBuffer*    | Pointer to internal data used by the audio system
	processor  voidptr        // rAudioProcessor* | Pointer to internal data processor, useful for audio effects

	sampleRate u32            // Frequency (samples per second)
	sampleSize u32            // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
	channels   u32            // Number of channels (1-mono, 2-stereo, ...)
}
pub type AudioStream = C.AudioStream

// Sound
@[typedef]
struct C.Sound {
pub mut:
	stream     AudioStream    // Audio stream
	frameCount u32            // Total number of frames (considering channels)
}
pub type Sound = C.Sound

// Music, audio stream, anything longer than ~10 seconds should be streamed
@[typedef]
struct C.Music {
pub mut:
	stream     AudioStream    // Audio stream
	frameCount u32            // Total number of frames (considering channels)
	looping    bool           // Music looping enable

	ctxType    int            // Type of music context (audio filetype)
	ctxData    voidptr        // Audio context data, depends on type
}
pub type Music = C.Music

// VrDeviceInfo, Head-Mounted-Display device parameters
@[typedef]
struct C.VrDeviceInfo {
pub mut:
    hResolution            int        // Horizontal resolution in pixels
    vResolution            int        // Vertical resolution in pixels
    hScreenSize            f32        // Horizontal size in meters
    vScreenSize            f32        // Vertical size in meters
    eyeToScreenDistance    f32        // Distance between eye and display in meters
    lensSeparationDistance f32        // Lens separation distance in meters
    interpupillaryDistance f32        // IPD (distance between pupils) in meters
    lensDistortionValues   [4]f32     // Lens distortion constant parameters
    chromaAbCorrection     [4]f32     // Chromatic aberration correction parameters
}
pub type VrDeviceInfo = C.VrDeviceInfo

// VrStereoConfig, VR stereo rendering configuration for simulator
@[typedef]
struct C.VrStereoConfig {
pub mut:
	projection        [2]Matrix // VR projection matrices (per eye)
	view_offset       [2]Matrix // VR view offset matrices (per eye
	leftLensCenter    [2]f32    // VR left lens center
	rightLensCenter   [2]f32    // VR right lens center
	leftScreenCenter  [2]f32    // VR left screen center
	rightScreenCenter [2]f32    // VR right screen center
	scale             [2]f32    // VR distortion scale
	scaleIn           [2]f32    // VR distortion scale in
}
pub type VrStereoConfig = C.VrStereoConfig

// File path list
@[typedef]
struct C.FilePathList {
pub mut:
	capacity u32                // Filepaths max entries
	count    u32                // Filepaths entries count
	paths    &&char             // Filepaths entries
}
pub type FilePathList = C.FilePathList

// Automation event
@[typedef]
pub struct C.AutomationEvent {
    frame  u32                  // Event frame
    @type  u32                  // Event type (AutomationEventType)
    params [4]int               // Event parameters (if required)
}

// Automation event list
@[typedef]
pub struct C.AutomationEventList {
    capacity u32                // Events max entries (MAX_AUTOMATION_EVENTS)
    count    u32                // Events entries count
    events   &C.AutomationEvent // Events entries
}
// end structs
                                                    

                                                    
//----------------------------------------------------------------------------------
// Functions Definition
//----------------------------------------------------------------------------------
// Window-related functions
fn C.InitWindow(width int, height int, title &char) // Initialize window and OpenGL context
@[inline]
pub fn init_window(width int, height int, title string) {
	C.InitWindow(width, height, title.str)
}

fn C.WindowShouldClose() bool       // Check if application should close (KEY_ESCAPE pressed or windows close icon clicked)
@[inline]
pub fn window_should_close() bool {
	return C.WindowShouldClose()
}

fn C.CloseWindow()                  // Close window and unload OpenGL context
@[inline]
pub fn close_window() {
	C.CloseWindow()
}

fn C.IsWindowReady() bool           // Check if window has been initialized successfully
@[inline]
pub fn is_window_ready() bool {
	return C.IsWindowReady()
}

fn C.IsWindowFullscreen() bool      // Check if window is currently fullscreen
@[inline]
pub fn is_window_fullscreen() bool {
	return C.IsWindowFullscreen()
}

fn C.IsWindowHidden() bool          // Check if window is currently hidden (only PLATFORM_DESKTOP)
@[inline]
pub fn is_window_hidden() bool {
	return C.IsWindowHidden()
}

fn C.IsWindowMinimized() bool       // Check if window is currently minimized (only PLATFORM_DESKTOP)
@[inline]
pub fn is_window_minimized() bool {
	return C.IsWindowMinimized()
}

fn C.IsWindowMaximized() bool       // Check if window is currently maximized (only PLATFORM_DESKTOP)
@[inline]
pub fn is_window_maximized() bool {
	return C.IsWindowMaximized()
}

fn C.IsWindowFocused() bool         // Check if window is currently focused (only PLATFORM_DESKTOP)
@[inline]
pub fn is_window_focused() bool {
	return C.IsWindowFocused()
}

fn C.IsWindowResized() bool         // Check if window has been resized last frame
@[inline]
pub fn is_window_resized() bool {
	return C.IsWindowResized()
}

fn C.IsWindowState(flag int) bool   // Check if one specific window flag is enabled
@[inline]
pub fn is_window_state(flag int) bool {
	return C.IsWindowState(flag)
}

fn C.SetWindowState(flags int)      // Set window configuration state using flags (only PLATFORM_DESKTOP)
@[inline]
pub fn set_window_state(flags int) {
	C.SetWindowState(flags)
}

fn C.ClearWindowState(flags int)    // Clear window configuration state flags
@[inline]
pub fn clear_window_state(flags int) {
	C.ClearWindowState(flags)
}

fn C.ToggleFullscreen()             // Toggle window state: fullscreen/windowed [resizes monitor to match window resolution] (only PLATFORM_DESKTOP)
@[inline]
pub fn toggle_fullscreen() {
	C.ToggleFullscreen()
}

fn C.MaximizeWindow()               // Set window state: maximized, if resizable (only PLATFORM_DESKTOP)
@[inline]
pub fn maximize_window() {
	C.MaximizeWindow()
}

fn C.MinimizeWindow()               // Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
@[inline]
pub fn minimize_window() {
	C.MinimizeWindow()
}

fn C.RestoreWindow()                // Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
@[inline]
pub fn restore_window() {
	C.RestoreWindow()
}

fn C.SetWindowIcon(image Image)     // Set icon for window (single image, RGBA 32bit, only PLATFORM_DESKTOP)
@[inline]
pub fn set_window_icon(image Image) {
	C.SetWindowIcon(image)
}

fn C.SetWindowIcons(images &Image, count int) // Set icon for window (multiple images, RGBA 32bit, only PLATFORM_DESKTOP)
@[inline]
pub fn set_window_icons(images []Image) {
    C.SetWindowIcons(images.data, images.len)
}

fn C.SetWindowTitle(title &char)    // Set title for window (only PLATFORM_DESKTOP and PLATFORM_WEB)
@[inline]
pub fn set_window_title(title string) {
	C.SetWindowTitle(title.str)
}

fn C.SetWindowPosition(x int, y int)    // Set icon for window (multiple images, RGBA 32bit, only PLATFORM_DESKTOP)
@[inline]
pub fn set_window_position(x int, y int) {
	C.SetWindowPosition(x, y)
}

fn C.SetWindowMonitor(monitor int)      // Set title for window (only PLATFORM_DESKTOP and PLATFORM_WEB)
@[inline]
pub fn set_window_monitor(monitor int) {
	C.SetWindowMonitor(monitor)
}

fn C.SetWindowMinSize(width int, height int)    // Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
@[inline]
pub fn set_window_min_size(width int, height int) {
	C.SetWindowMinSize(width, height)
}
                                                    
fn C.SetWindowMaxSize(width int, height int)    // Set window maximum dimensions (for FLAG_WINDOW_RESIZABLE)
@[inline]
pub fn set_window_max_size(width int, height int) {
	C.SetWindowMaxSize(width, height)
}

fn C.SetWindowSize(width int, height int)       // Set window dimensions
@[inline]
pub fn set_window_size(width int, height int) {
	C.SetWindowSize(width, height)
}

fn C.SetWindowOpacity(opacity f32)              // Set window opacity [0.0f..1.0f] (only PLATFORM_DESKTOP)
@[inline]
pub fn set_window_opacity(opacity f32) {
	C.SetWindowOpacity(opacity)
}
                                                    
fn C.SetWindowFocused()                         // Set window focused (only PLATFORM_DESKTOP)
@[inline]
pub fn set_window_focused() {
    C.SetWindowFocused()
}

fn C.GetWindowHandle() voidptr                  // Get native window handle
@[inline]
pub fn get_window_handle() voidptr {
	return C.GetWindowHandle()
}

fn C.GetScreenWidth() int                       // Get current screen width
@[inline]
pub fn get_screen_width() int {
	return C.GetScreenWidth()
}

fn C.GetScreenHeight() int                      // Get current screen height
@[inline]
pub fn get_screen_height() int {
	return C.GetScreenHeight()
}

fn C.GetRenderWidth() int                       // Get current render width (it considers HiDPI)
@[inline]
pub fn get_render_width() int {
	return C.GetRenderWidth()
}

fn C.GetRenderHeight() int                      // Get current render height (it considers HiDPI)
@[inline]
pub fn get_render_height() int {
	return C.GetRenderHeight()
}

fn C.GetMonitorCount() int                      // Get number of connected monitors
@[inline]
pub fn get_monitor_count() int {
	return C.GetMonitorCount()
}

fn C.GetCurrentMonitor() int                    // Get current connected monitor
@[inline]
pub fn get_current_monitor() int {
	return C.GetCurrentMonitor()
}

fn C.GetMonitorPosition(monitor int) Vector2    // Get specified monitor position
@[inline]
pub fn get_monitor_position(monitor int) Vector2 {
	return C.GetMonitorPosition(monitor)
}

fn C.GetMonitorWidth(monitor int) int           // Get specified monitor width (current video mode used by monitor)
@[inline]
pub fn get_monitor_width(monitor int) int {
	return C.GetMonitorWidth(monitor)
}

fn C.GetMonitorHeight(monitor int) int          // Get specified monitor height (current video mode used by monitor)
@[inline]
pub fn get_monitor_height(monitor int) int {
	return C.GetMonitorHeight(monitor)
}

fn C.GetMonitorPhysicalWidth(monitor int) int   // Get specified monitor physical width in millimetres
@[inline]
pub fn get_monitor_physical_width(monitor int) int {
	return C.GetMonitorPhysicalWidth(monitor)
}

fn C.GetMonitorPhysicalHeight(monitor int) int  // Get specified monitor physical height in millimetres
@[inline]
pub fn get_monitor_physical_height(monitor int) int {
	return C.GetMonitorPhysicalHeight(monitor)
}

fn C.GetMonitorRefreshRate(monitor int) int     // Get specified monitor refresh rate
@[inline]
pub fn get_monitor_refresh_rate(monitor int) int {
	return C.GetMonitorRefreshRate(monitor)
}

fn C.GetWindowPosition() Vector2                // Get window position XY on monitor
@[inline]
pub fn get_window_position() Vector2 {
	return C.GetWindowPosition()
}

fn C.GetWindowScaleDPI() Vector2                // Get window scale DPI factor
@[inline]
pub fn get_window_scale_dpi() Vector2 {
	return C.GetWindowScaleDPI()
}

fn C.GetMonitorName(monitor int) &char          // Get the human-readable, UTF-8 encoded name of the specified monitor
@[inline]
pub fn get_monitor_name(monitor int) string {
	return unsafe {
        cstring_to_vstring(C.GetMonitorName(monitor))
    }
}

fn C.SetClipboardText(text &char)               // Set clipboard text content
@[inline]
pub fn set_clipboard_text(text string) {
	C.SetClipboardText(text.str)
}

fn C.GetClipboardText() &char                   // Get clipboard text content
@[inline]
pub fn get_clipboard_text() string {
	return unsafe { cstring_to_vstring(C.GetClipboardText()) }
}

fn C.EnableEventWaiting()                       // Enable waiting for events on EndDrawing(), no automatic event polling
@[inline]
pub fn enable_event_waiting() {
	C.EnableEventWaiting()
}

fn C.DisableEventWaiting()                      // Disable waiting for events on EndDrawing(), automatic events polling
@[inline]
pub fn disable_event_waiting() {
	C.DisableEventWaiting()
}

// Cursor-related functions
fn C.ShowCursor()
@[inline]
pub fn show_cursor() {
	C.ShowCursor()
}

fn C.HideCursor()
@[inline]
pub fn hide_cursor() {
	C.HideCursor()
}

fn C.IsCursorHidden() bool
@[inline]
pub fn is_cursor_hidden() bool {
	return C.IsCursorHidden()
}

fn C.EnableCursor()
@[inline]
pub fn enable_cursor() {
	C.EnableCursor()
}

fn C.DisableCursor()
@[inline]
pub fn disable_cursor() {
	C.DisableCursor()
}

fn C.IsCursorOnScreen() bool
@[inline]
pub fn is_cursor_on_screen() bool {
	return C.IsCursorOnScreen()
}

                                                    

// Drawing-related functions
fn C.ClearBackground(color Color)           // Set background color (framebuffer clear color)
@[inline]
pub fn clear_background(color Color) {
	C.ClearBackground(color)
}

fn C.BeginDrawing()                         // Setup canvas (framebuffer) to start drawing
@[inline]
pub fn begin_drawing() {
	C.BeginDrawing()
}

fn C.EndDrawing()                           // End canvas drawing and swap buffers (double buffering)
@[inline]
pub fn end_drawing() {
	C.EndDrawing()
}

fn C.BeginMode2D(camera Camera2D)           // Begin 2D mode with custom camera (2D)
@[inline]
pub fn begin_mode_2d(camera Camera2D) {
	C.BeginMode2D(camera)
}

fn C.EndMode2D()                            // Ends 2D mode with custom camera
@[inline]
pub fn end_mode_2d() {
	C.EndMode2D()
}

fn C.BeginMode3D(camera Camera3D)           // Begin 3D mode with custom camera (3D)
@[inline]
pub fn begin_mode_3d(camera Camera3D) {
	C.BeginMode3D(camera)
}

fn C.EndMode3D()                            // Ends 3D mode and returns to default 2D orthographic mode
@[inline]
pub fn end_mode_3d() {
	C.EndMode3D()
}

fn C.BeginTextureMode(target RenderTexture)   // Begin drawing to render texture
@[inline]
pub fn begin_texture_mode(target RenderTexture) {
	C.BeginTextureMode(target)
}

fn C.EndTextureMode()                           // Ends drawing to render texture
@[inline]
pub fn end_texture_mode() {
	C.EndTextureMode()
}

fn C.BeginShaderMode(shader Shader)             // Begin custom shader drawing
@[inline]
pub fn begin_shader_mode(shader Shader) {
	C.BeginShaderMode(shader)
}

fn C.EndShaderMode()                            // End custom shader drawing (use default shader)
@[inline]
pub fn end_shader_mode() {
	C.EndShaderMode()
}

fn C.BeginBlendMode(mode int)                   // Begin blending mode (alpha, additive, multiplied, subtract, custom)
@[inline]
// pub fn begin_blend_mode(mode BlendMode) {
pub fn begin_blend_mode(mode int) {
	C.BeginBlendMode(mode)
}

fn C.EndBlendMode()                             // End blending mode (reset to default: alpha blending)
@[inline]
pub fn end_blend_mode() {
	C.EndBlendMode()
}

fn C.BeginScissorMode(x int, y int, width int, height int)      // Begin scissor mode (define screen area for following drawing)
@[inline]
pub fn begin_scissor_mode(x int, y int, width int, height int) {
	C.BeginScissorMode(x, y, width, height)
}

fn C.EndScissorMode()                           // End scissor mode
@[inline]
pub fn end_scissor_mode() {
	C.EndScissorMode()
}

fn C.BeginVrStereoMode(config VrStereoConfig)   // Begin stereo rendering (requires VR simulator)
@[inline]
pub fn begin_vr_stereo_mode(config VrStereoConfig) {
	C.BeginVrStereoMode(config)
}

fn C.EndVrStereoMode()                          // End stereo rendering (requires VR simulator)
@[inline]
pub fn end_vr_stereo_mode() {
	C.EndVrStereoMode()
}

// VR stereo config functions for VR simulator
fn C.LoadVrStereoConfig(device VrDeviceInfo) VrStereoConfig      // Load VR stereo config for VR simulator device parameters
@[inline]
pub fn load_vr_stereo_config(device VrDeviceInfo) VrStereoConfig {
    return C.LoadVrStereoConfig(device)
}

fn C.UnloadVrStereoConfig(config VrStereoConfig)           // Unload VR stereo config
@[inline]
pub fn unload_vr_stereo_config(config VrStereoConfig) {
    C.UnloadVrStereoConfig(config)
}


// Shader management functions
// NOTE: Shader functionality is not available on OpenGL 1.1
fn C.LoadShader(vs_file_name &char, fs_file_name &char) Shader      // Load shader from files and bind default locations
@[inline]
pub fn load_shader(vs_file_name &char, fs_file_name &char) Shader {
	return C.LoadShader(vs_file_name, fs_file_name)
}

fn C.LoadShaderFromMemory(vs_code &char, fs_code &char) Shader      // Load shader from code strings and bind default locations
@[inline]
pub fn load_shader_from_memory(vs_code string, fs_code string) Shader {
	return C.LoadShaderFromMemory(vs_code.str, fs_code.str)
}
                                                    
fn C.GetShaderLocation(shader Shader, uniform_name &char) int       // Get shader uniform location
@[inline]
pub fn get_shader_location(shader Shader, uniform_name string) int {
	return C.GetShaderLocation(shader, uniform_name.str)
}

fn C.GetShaderLocationAttrib(shader Shader, attrib_name &char) int  // Get shader attribute location
@[inline]
pub fn get_shader_location_attrib(shader Shader, attrib_name string) int {
	return C.GetShaderLocationAttrib(shader, attrib_name.str)
}

fn C.SetShaderValue(shader Shader, loc_index int, value voidptr, uniform_type int)  // Set shader uniform value
@[inline]
pub fn set_shader_value(shader Shader, loc_index int, value voidptr, uniform_type int) {
	C.SetShaderValue(shader, loc_index, value, uniform_type)
}

@[inline]
pub fn set_shader_value1i(shader Shader, loc int, val int) {
	C.SetShaderValue(shader, loc, &(val), rl_shader_uniform_int)
}


@[inline]
pub fn set_shader_value1f(shader Shader, loc int, val f32) {
	C.SetShaderValue(shader, loc, &(val), rl_shader_uniform_float)
}



fn C.SetShaderValueV(shader Shader, loc_index int, value voidptr, uniform_type int, count int)  // Set shader uniform value vector
@[inline]
pub fn set_shader_value_v(shader Shader, loc_index int, value voidptr, uniform_type int, count int) {
	C.SetShaderValueV(shader, loc_index, value, uniform_type, count)
}

fn C.SetShaderValueMatrix(shader Shader, loc_index int, mat Matrix)         // Set shader uniform value (matrix 4x4)
@[inline]
pub fn set_shader_value_matrix(shader Shader, loc_index int, mat Matrix) {
	C.SetShaderValueMatrix(shader, loc_index, mat)
}

fn C.SetShaderValueTexture(shader Shader, loc_index int, texture Texture) // Set shader uniform value for texture (sampler2d)
@[inline]
pub fn set_shader_value_texture(shader Shader, loc_index int, texture Texture) {
	C.SetShaderValueTexture(shader, loc_index, texture)
}

fn C.UnloadShader(shader Shader)                                            // Unload shader from GPU memory (VRAM)
@[inline]
pub fn unload_shader(shader Shader) {
	C.UnloadShader(shader)
}


// Screen-space-related functions
fn C.GetMouseRay(mouse_position Vector2, camera Camera) Ray              // Compatibility hack for previous raylib versions
@[inline]
pub fn get_mouse_ray(mouse_position Vector2, camera Camera) Ray {
	return C.GetMouseRay(mouse_position, camera)
}

fn C.GetScreenToWorldRay(position Vector2, camera Camera) Ray            // Get a ray trace from screen position (i.e mouse)
@[inline]
pub fn get_screen_to_world_ray(position Vector2, camera Camera) Ray {
    return C.GetScreenToWorldRay(position, camera)
}
                                                    
fn C.GetScreenToWorldRayEx(position Vector2, camera Camera, width int, height int) Ray // Get a ray trace from screen position (i.e mouse) in a viewport
@[inline]
pub fn get_screen_to_world_ray_ex(position Vector2, camera Camera, width int, height int) Ray {
    return C.GetScreenToWorldRayEx(position, camera, width, height)
}
                                                    
fn C.GetWorldToScreen(position Vector3, camera Camera) Vector2
@[inline]
pub fn get_world_to_screen(position Vector3, camera Camera) Vector2 {
    return C.GetWorldToScreen(position, camera)
}
                                                    
fn C.GetWorldToScreen2D(position Vector2, camera Camera2D) Vector2      // Get the screen space position for a 2d camera world space position
@[inline]
pub fn get_world_to_screen_2d(position Vector2, camera Camera2D) Vector2 {
    return C.GetWorldToScreen2D(position, camera)
}
fn C.GetScreenToWorld2D(position Vector2, camera Camera2D) Vector2      // Get the world space position for a 2d camera screen space position
@[inline]
pub fn get_screen_to_world_2d(position Vector2, camera Camera2D) Vector2 {
    return C.GetScreenToWorld2D(position, camera)
}


fn C.GetCameraMatrix(camera Camera) Matrix                              // Get camera transform matrix (view matrix)
@[inline]
pub fn get_camera_matrix(camera Camera) Matrix {
	return C.GetCameraMatrix(camera)
}

fn C.GetCameraMatrix2D(camera Camera2D) Matrix                          // Get camera 2d transform matrix
@[inline]
pub fn get_camera_matrix_2d(camera Camera2D) Matrix {
	return C.GetCameraMatrix2D(camera)
}

                                                    
// Timing-related functions
fn C.SetTargetFPS(fps int)              // Set target FPS (maximum)
@[inline]
pub fn set_target_fps(fps int) {
	C.SetTargetFPS(fps)
}
                                                    
fn C.GetFrameTime() f32                 // Get time in seconds for last frame drawn (delta time)
@[inline]
pub fn get_frame_time() f32 {
	return C.GetFrameTime()
}

fn C.GetTime() f64                      // Get elapsed time in seconds since InitWindow()
@[inline]
pub fn get_time() f64 {
	return C.GetTime()
}

fn C.GetFPS() int                       // Get current FPS
@[inline]
pub fn get_fps() int {
	return C.GetFPS()
}

// Custom frame control functions
// NOTE: Those functions are intended for advanced users that want full control over the frame processing
// By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timing + PollInputEvents()
// To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL
fn C.SwapScreenBuffer()             // Swap back buffer with front buffer (screen drawing)
@[inline]
pub fn swap_screen_buffer() {
	C.SwapScreenBuffer()
}

fn C.PollInputEvents()              // Register all input events
@[inline]
pub fn poll_input_events() {
	C.PollInputEvents()
}

fn C.WaitTime(seconds f64)          // Wait for some time (halt program execution)
@[inline]
pub fn wait_time(seconds f64) {
	C.WaitTime(seconds)
}


// Random values generation functions
fn C.SetRandomSeed(seed u32)                // Set the seed for the random number generator
@[inline]
pub fn set_random_seed(seed u32) {
	C.SetRandomSeed(seed)
}
                                                    
fn C.GetRandomValue(min int, max int) int   // Get a random value between min and max (both included)
@[inline]
pub fn get_random_value(min int, max int) int {
	return C.GetRandomValue(min, max)
}

fn C.LoadRandomSequence(count u32, min int, max int) &int  // Load random values sequence, no values repeated
@[inline]
pub fn load_random_sequence(count u32, min int, max int) &int {
    return C.LoadRandomSequence(count, min, max)
}
                                                    
fn C.UnloadRandomSequence(sequence &int)        // Unload random values sequence
@[inline]
pub fn unload_random_sequence(sequence &int) {
    C.UnloadRandomSequence(sequence)
}

// Misc. functions
fn C.TakeScreenshot(file_name &char)            // Takes a screenshot of current screen (filename extension defines format)
@[inline]
pub fn take_screenshot(file_name string) {
	C.TakeScreenshot(file_name.str)
}

fn C.SetConfigFlags(flags int)                  // Setup init configuration flags (view FLAGS)
@[inline]
pub fn set_config_flags(flags int) {
	C.SetConfigFlags(flags)
}

fn C.OpenURL(url &char)                         // Open URL with default system browser (if available)
@[inline]
pub fn open_url(url string) {
	C.OpenURL(url.str)
}


fn C.MemAlloc(size u32) voidptr
@[inline]
pub fn mem_alloc(size u32) voidptr {
	return C.MemAlloc(size)
}

fn C.MemRealloc(ptr voidptr, size u32) voidptr
@[inline]
pub fn mem_realloc(ptr voidptr, size u32) voidptr {
	return C.MemRealloc(ptr, size)
}

fn C.MemFree(ptr voidptr)
@[inline]
pub fn mem_free(ptr voidptr) {
	C.MemFree(ptr)
}

// Set custom callbacks
// WARNING: Callbacks setup is intended for advanced users
fn C.SetLoadFileDataCallback(callback voidptr)
@[inline]
pub fn set_load_file_data_callback(callback voidptr) {
	C.SetLoadFileDataCallback(callback)
}

fn C.SetSaveFileDataCallback(callback voidptr)
@[inline]
pub fn set_save_file_data_callback(callback voidptr) {
	C.SetSaveFileDataCallback(callback)
}

fn C.SetLoadFileTextCallback(callback voidptr)
@[inline]
pub fn set_load_file_text_callback(callback voidptr) {
	C.SetLoadFileTextCallback(callback)
}

fn C.SetSaveFileTextCallback(callback voidptr)
@[inline]
pub fn set_save_file_text_callback(callback voidptr) {
	C.SetSaveFileTextCallback(callback)
}

// Files management functions
fn C.LoadFileData(file_name &char, bytes_read &int) &u8         // Load file data as byte array (read)
@[inline]
pub fn load_file_data(file_name string, bytes_read &int) &u8 {
	return C.LoadFileData(file_name.str, bytes_read)
}

fn C.UnloadFileData(data &u8)                                 // Unload file data allocated by LoadFileData()
@[inline]
pub fn unload_file_data(data &u8) {
	C.UnloadFileData(data)
}

fn C.SaveFileData(file_name &char, data voidptr, bytes_to_write u32) bool   // Save data to file from byte array (write), returns true on success
@[inline]
pub fn save_file_data(file_name string, data voidptr, bytes_to_write u32) bool {
	return C.SaveFileData(file_name.str, data, bytes_to_write)
}

fn C.ExportDataAsCode(data &i8, data_size int, file_name &char) bool             // Export data to code (.h), returns true on success
@[inline]
pub fn export_data_as_code(data &i8, data_size int, file_name string) bool {
	return C.ExportDataAsCode(data, data_size, file_name.str)
}

fn C.LoadFileText(file_name &char) &char
@[inline]
pub fn load_file_text(file_name string) &char {
	return C.LoadFileText(file_name.str)
}

fn C.UnloadFileText(text &char)
@[inline]
pub fn unload_file_text(text &char) {
	C.UnloadFileText(text)
}

fn C.SaveFileText(file_name &char, text &char) bool
@[inline]
pub fn save_file_text(file_name string, text string) bool {
	return C.SaveFileText(file_name.str, text.str)
}

// File system functions
fn C.FileExists(file_name &char) bool
@[inline]
pub fn file_exists(file_name string) bool {
	return C.FileExists(file_name.str)
}

fn C.DirectoryExists(dir_path &char) bool
@[inline]
pub fn directory_exists(dir_path string) bool {
	return C.DirectoryExists(dir_path.str)
}

fn C.IsFileExtension(file_name &char, ext &char) bool
@[inline]
pub fn is_file_extension(file_name string, ext string) bool {
	return C.IsFileExtension(file_name.str, ext.str)
}

fn C.GetFileLength(file_name &char) int
@[inline]
pub fn get_file_length(file_name string) int {
	return C.GetFileLength(file_name.str)
}

fn C.GetFileExtension(file_name &char) &char
@[inline]
pub fn get_file_extension(file_name string) string {
	return unsafe { cstring_to_vstring(C.GetFileExtension(file_name.str)) }
}

fn C.GetFileName(file_path &char) &char
@[inline]
pub fn get_file_name(file_path string) string {
	return unsafe { cstring_to_vstring(C.GetFileName(file_path.str)) }
}

fn C.GetFileNameWithoutExt(file_path &char) &char
@[inline]
pub fn get_file_name_without_ext(file_path string) string {
	return unsafe { cstring_to_vstring(C.GetFileNameWithoutExt(file_path.str)) }
}

fn C.GetDirectoryPath(file_path &char) &char
@[inline]
pub fn get_directory_path(file_path string) string {
	return unsafe { cstring_to_vstring(C.GetDirectoryPath(file_path.str)) }
}

fn C.GetPrevDirectoryPath(dir_path &char) &char
@[inline]
pub fn get_prev_directory_path(dir_path string) string {
	return unsafe { cstring_to_vstring(C.GetPrevDirectoryPath(dir_path.str)) }
}

fn C.GetWorkingDirectory() &char
@[inline]
pub fn get_working_directory() string {
	return unsafe { cstring_to_vstring(C.GetWorkingDirectory()) }
}

fn C.GetApplicationDirectory() &char
@[inline]
pub fn get_application_directory() string {
	return unsafe { cstring_to_vstring(C.GetApplicationDirectory()) }
}

fn C.ChangeDirectory(dir &char) bool
@[inline]
pub fn change_directory(dir string) bool {
	return C.ChangeDirectory(dir.str)
}

fn C.IsPathFile(path &char) bool
@[inline]
pub fn is_path_file(path string) bool {
	return C.IsPathFile(path.str)
}

fn C.LoadDirectoryFiles(dir_path &char) FilePathList
@[inline]
pub fn load_directory_files(dir_path string) FilePathList {
	return C.LoadDirectoryFiles(dir_path.str)
}

fn C.LoadDirectoryFilesEx(base_path &char, filter &char, scan_subdirs bool) FilePathList
@[inline]
pub fn load_directory_files_ex(base_path string, filter string, scan_subdirs bool) FilePathList {
	return C.LoadDirectoryFilesEx(base_path.str, filter.str, scan_subdirs)
}

fn C.UnloadDirectoryFiles(files FilePathList)
@[inline]
pub fn unload_directory_files(files FilePathList) {
	C.UnloadDirectoryFiles(files)
}

fn C.IsFileDropped() bool
@[inline]
pub fn is_file_dropped() bool {
	return C.IsFileDropped()
}

fn C.LoadDroppedFiles() FilePathList
@[inline]
pub fn load_dropped_files() FilePathList {
	return C.LoadDroppedFiles()
}

fn C.UnloadDroppedFiles(files FilePathList)
@[inline]
pub fn unload_dropped_files(files FilePathList) {
	C.UnloadDroppedFiles(files)
}

fn C.GetFileModTime(file_name &char) i64
@[inline]
pub fn get_file_mod_time(file_name &char) i64 {
	 return C.GetFileModTime(file_name)
}

fn C.CompressData(data &u8, data_size int, comp_data_size &int) &u8
@[inline]
pub fn compress_data(data &u8, data_size int, comp_data_size &int) &u8 {
	return C.CompressData(data, data_size, comp_data_size)
}

fn C.DecompressData(compData &u8, comp_data_size int, data_size &int) &u8
@[inline]
pub fn decompress_data(compData &u8, comp_data_size int, data_size &int) &u8 {
	return C.DecompressData(compData, comp_data_size, data_size)
}

fn C.EncodeDataBase64(data &u8, data_size int, output_size &int) &i8
@[inline]
pub fn encode_data_base_64(data &u8, data_size int, output_size &int) &i8 {
	return C.EncodeDataBase64(data, data_size, output_size)
}

fn C.DecodeDataBase64(data &u8, output_size &int) &u8
@[inline]
pub fn decode_data_base_64(data &u8, output_size &int) &u8 {
	return C.DecodeDataBase64(data, output_size)
}

fn C.IsKeyPressed(key int) bool
@[inline]
pub fn is_key_pressed(key int) bool {
	return C.IsKeyPressed(key)
}

fn C.IsKeyDown(key int) bool
@[inline]
pub fn is_key_down(key int) bool {
	return C.IsKeyDown(key)
}

fn C.IsKeyReleased(key int) bool
@[inline]
pub fn is_key_released(key int) bool {
	return C.IsKeyReleased(key)
}

fn C.IsKeyUp(key int) bool
@[inline]
pub fn is_key_up(key int) bool {
	return C.IsKeyUp(key)
}

fn C.SetExitKey(key int)
@[inline]
pub fn set_exit_key(key int) {
	C.SetExitKey(key)
}

fn C.GetKeyPressed() int
@[inline]
pub fn get_key_pressed() int {
	return C.GetKeyPressed()
}

fn C.GetCharPressed() int
@[inline]
pub fn get_char_pressed() int {
	return C.GetCharPressed()
}

fn C.IsGamepadAvailable(gamepad int) bool
@[inline]
pub fn is_gamepad_available(gamepad int) bool {
	return C.IsGamepadAvailable(gamepad)
}

fn C.GetGamepadName(gamepad int) &char
@[inline]
pub fn get_gamepad_name(gamepad int) string {
	return unsafe { cstring_to_vstring(C.GetGamepadName(gamepad)) }
}

fn C.IsGamepadButtonPressed(gamepad int, button int) bool
@[inline]
pub fn is_gamepad_button_pressed(gamepad int, button int) bool {
	return C.IsGamepadButtonPressed(gamepad, button)
}

fn C.IsGamepadButtonDown(gamepad int, button int) bool
@[inline]
pub fn is_gamepad_button_down(gamepad int, button int) bool {
	return C.IsGamepadButtonDown(gamepad, button)
}

fn C.IsGamepadButtonReleased(gamepad int, button int) bool
@[inline]
pub fn is_gamepad_button_released(gamepad int, button int) bool {
	return C.IsGamepadButtonReleased(gamepad, button)
}

fn C.IsGamepadButtonUp(gamepad int, button int) bool
@[inline]
pub fn is_gamepad_button_up(gamepad int, button int) bool {
	return C.IsGamepadButtonUp(gamepad, button)
}

fn C.GetGamepadButtonPressed() int
@[inline]
pub fn get_gamepad_button_pressed() int {
	return C.GetGamepadButtonPressed()
}

fn C.GetGamepadAxisCount(gamepad int) int
@[inline]
pub fn get_gamepad_axis_count(gamepad int) int {
	return C.GetGamepadAxisCount(gamepad)
}

fn C.GetGamepadAxisMovement(gamepad int, axis int) f32
@[inline]
pub fn get_gamepad_axis_movement(gamepad int, axis int) f32 {
	return C.GetGamepadAxisMovement(gamepad, axis)
}

fn C.SetGamepadMappings(mappings &char) int
@[inline]
pub fn set_gamepad_mappings(mappings string) int {
	return C.SetGamepadMappings(mappings.str)
}

fn C.IsMouseButtonPressed(button int) bool
@[inline]
pub fn is_mouse_button_pressed(button int) bool {
	return C.IsMouseButtonPressed(button)
}

fn C.IsMouseButtonDown(button int) bool
@[inline]
pub fn is_mouse_button_down(button int) bool {
	return C.IsMouseButtonDown(button)
}

fn C.IsMouseButtonReleased(button int) bool
@[inline]
pub fn is_mouse_button_released(button int) bool {
	return C.IsMouseButtonReleased(button)
}

fn C.IsMouseButtonUp(button int) bool
@[inline]
pub fn is_mouse_button_up(button int) bool {
	return C.IsMouseButtonUp(button)
}

fn C.GetMouseX() int
@[inline]
pub fn get_mouse_x() int {
	return C.GetMouseX()
}

fn C.GetMouseY() int
@[inline]
pub fn get_mouse_y() int {
	return C.GetMouseY()
}

fn C.GetMousePosition() Vector2
@[inline]
pub fn get_mouse_position() Vector2 {
	return C.GetMousePosition()
}

fn C.GetMouseDelta() Vector2
@[inline]
pub fn get_mouse_delta() Vector2 {
	return C.GetMouseDelta()
}

fn C.SetMousePosition(x int, y int)
@[inline]
pub fn set_mouse_position(x int, y int) {
	C.SetMousePosition(x, y)
}

fn C.SetMouseOffset(offset_x int, offset_y int)
@[inline]
pub fn set_mouse_offset(offset_x int, offset_y int) {
	C.SetMouseOffset(offset_x, offset_y)
}

fn C.SetMouseScale(scale_x f32, scale_y f32)
@[inline]
pub fn set_mouse_scale(scale_x f32, scale_y f32) {
	C.SetMouseScale(scale_x, scale_y)
}

fn C.GetMouseWheelMove() f32
@[inline]
pub fn get_mouse_wheel_move() f32 {
	return C.GetMouseWheelMove()
}

fn C.GetMouseWheelMoveV() Vector2
@[inline]
pub fn get_mouse_wheel_move_v() Vector2 {
	return C.GetMouseWheelMoveV()
}

fn C.SetMouseCursor(cursor int)
@[inline]
pub fn set_mouse_cursor(cursor int) {
	C.SetMouseCursor(cursor)
}

fn C.GetTouchX() int
@[inline]
pub fn get_touch_x() int {
	return C.GetTouchX()
}

fn C.GetTouchY() int
@[inline]
pub fn get_touch_y() int {
	return C.GetTouchY()
}

fn C.GetTouchPosition(index int) Vector2
@[inline]
pub fn get_touch_position(index int) Vector2 {
	return C.GetTouchPosition(index)
}

fn C.GetTouchPointId(index int) int
@[inline]
pub fn get_touch_point_id(index int) int {
	return C.GetTouchPointId(index)
}

fn C.GetTouchPointCount() int
@[inline]
pub fn get_touch_point_count() int {
	return C.GetTouchPointCount()
}

fn C.SetGesturesEnabled(flags u32)
@[inline]
pub fn set_gestures_enabled(flags u32) {
	C.SetGesturesEnabled(flags)
}

fn C.IsGestureDetected(gesture int) bool
@[inline]
pub fn is_gesture_detected(gesture int) bool {
	return C.IsGestureDetected(gesture)
}

fn C.GetGestureDetected() int
@[inline]
pub fn get_gesture_detected() int {
	return C.GetGestureDetected()
}

fn C.GetGestureHoldDuration() f32
@[inline]
pub fn get_gesture_hold_duration() f32 {
	return C.GetGestureHoldDuration()
}

fn C.GetGestureDragVector() Vector2
@[inline]
pub fn get_gesture_drag_vector() Vector2 {
	return C.GetGestureDragVector()
}

fn C.GetGestureDragAngle() f32
@[inline]
pub fn get_gesture_drag_angle() f32 {
	return C.GetGestureDragAngle()
}

fn C.GetGesturePinchVector() Vector2
@[inline]
pub fn get_gesture_pinch_vector() Vector2 {
	return C.GetGesturePinchVector()
}

fn C.GetGesturePinchAngle() f32
@[inline]
pub fn get_gesture_pinch_angle() f32 {
	return C.GetGesturePinchAngle()
}

fn C.UpdateCamera(camera &Camera, mode int)
@[inline]
pub fn update_camera(camera &Camera, mode int) {
	C.UpdateCamera(camera, mode)
}

// Basic Shapes Drawing Functions (Module: shapes)
//------------------------------------------------------------------------------------
// Set texture and rectangle to be used on shapes drawing
// NOTE: It can be useful when using basic shapes and one single font,
// defining a font char white rectangle would allow drawing everything in a single draw call
fn C.SetShapesTexture(texture Texture, source Rectangle)
@[inline]
pub fn set_shapes_texture(texture Texture, source Rectangle) {
	C.SetShapesTexture(texture, source)
}
// fn C.GetShapesTexture() Texture                    // Get texture that is used for shapes drawing
// @[inline]
// pub fn get_shapes_texture() Texture {
//     return C.GetShapesTexture()
// }

// fn C.GetShapesTextureRectangle() Rectangle           // Get texture source rectangle that is used for shapes drawing
// @[inline]
// pub fn get_shapes_texture_rectangle() Rectangle {
//     return C.GetShapesTextureRectangle()
// }

/*********************************************************************
*                                                                    *
*                        DRAW FUNCTIONS                              *
*                                                                    *
*********************************************************************/

/*********************************************************************
|                          DRAW PIXEL                                |
*********************************************************************/
// Basic shapes drawing functions
fn C.DrawPixel(pos_x int, pos_y int, color Color)   // Draw a pixel using geometry [Can be slow, use with care]

@[inline]
pub fn draw_pixel(pos_x int, pos_y int, color Color) {
	C.DrawPixel(pos_x, pos_y, color)
}

fn C.DrawPixelV(position Vector2, color Color)      // Draw a pixel using geometry (Vector version) [Can be slow, use with care]
@[inline]
pub fn draw_pixel_v(position Vector2, color Color) {
	C.DrawPixelV(position, color)
}

/*********************************************************************
|                          DRAW LINE                                 |
*********************************************************************/
fn C.DrawLine(start_pos_x int, start_pos_y int, end_pos_x int, end_pos_y int, color Color)  // Draw a line
@[inline]
pub fn draw_line(start_pos_x int, start_pos_y int, end_pos_x int, end_pos_y int, color Color) {
	C.DrawLine(start_pos_x, start_pos_y, end_pos_x, end_pos_y, color)
}

fn C.DrawLineV(start_pos Vector2, end_pos Vector2, color Color)                 // Draw a line (using gl lines)
@[inline]
pub fn draw_line_v(start_pos Vector2, end_pos Vector2, color Color) {
	C.DrawLineV(start_pos, end_pos, color)
}

fn C.DrawLineEx(start_pos Vector2, end_pos Vector2, thick f32, color Color)     // Draw a line (using triangles/quads)
@[inline]
pub fn draw_line_ex(start_pos Vector2, end_pos Vector2, thick f32, color Color) {
	C.DrawLineEx(start_pos, end_pos, thick, color)
}

fn C.DrawLineStrip(points &Vector2, point_count int, color Color)               // Draw lines sequence (using gl lines)
@[inline]
pub fn draw_line_strip(points &Vector2, point_count int, color Color) {
	C.DrawLineStrip(points, point_count, color)
}

fn C.DrawLineBezier(start_pos Vector2, end_pos Vector2, thick f32, color Color) // Draw line segment cubic-bezier in-out interpolation
@[inline]
pub fn draw_line_bezier(start_pos Vector2, end_pos Vector2, thick f32, color Color) {
	C.DrawLineBezier(start_pos, end_pos, thick, color)
}

/*********************************************************************
|                          DRAW CIRCLE                               |
*********************************************************************/
fn C.DrawCircle(center_x int, center_y int, radius f32, color Color)            // Draw a color-filled circle
@[inline]
pub fn draw_circle(center_x int, center_y int, radius f32, color Color) {
	C.DrawCircle(center_x, center_y, radius, color)
}

fn C.DrawCircleSector(center Vector2, radius f32, start_angle f32, end_angle f32, segments int, color Color)        // Draw a piece of a circle
@[inline]
pub fn draw_circle_sector(center Vector2, radius f32, start_angle f32, end_angle f32, segments int, color Color) {
	C.DrawCircleSector(center, radius, start_angle, end_angle, segments, color)
}

fn C.DrawCircleSectorLines(center Vector2, radius f32, start_angle f32, end_angle f32, segments int, color Color)   // Draw circle sector outline
@[inline]
pub fn draw_circle_sector_lines(center Vector2, radius f32, start_angle f32, end_angle f32, segments int, color Color) {
	C.DrawCircleSectorLines(center, radius, start_angle, end_angle, segments, color)
}

fn C.DrawCircleGradient(center_x int, center_y int, radius f32, color1 Color, color2 Color)                         // Draw a gradient-filled circle
@[inline]
pub fn draw_circle_gradient(center_x int, center_y int, radius f32, color1 Color, color2 Color) {
	C.DrawCircleGradient(center_x, center_y, radius, color1, color2)
}

fn C.DrawCircleV(center Vector2, radius f32, color Color)                                                           // Draw a color-filled circle (Vector version)
@[inline]
pub fn draw_circle_v(center Vector2, radius f32, color Color) {
	C.DrawCircleV(center, radius, color)
}

fn C.DrawCircleLines(center_x int, center_y int, radius f32, color Color)                                           // Draw circle outline
@[inline]
pub fn draw_circle_lines(center_x int, center_y int, radius f32, color Color) {
	C.DrawCircleLines(center_x, center_y, radius, color)
}

fn C.DrawCircleLinesV(center Vector2, radius f32, color Color)                                                    // Draw circle outline (Vector version)
@[inline]
pub fn draw_circle_lines_v(center Vector2, radius f32, color Color) {
    C.DrawCircleLinesV(center, radius, color)
}

/*********************************************************************
|                         DRAW ELLIPSE                               |
*********************************************************************/
fn C.DrawEllipse(center_x int, center_y int, radius_h f32, radiusV f32, color Color)                                // Draw ellipse
@[inline]
pub fn draw_ellipse(center_x int, center_y int, radius_h f32, radiusV f32, color Color) {
	C.DrawEllipse(center_x, center_y, radius_h, radiusV, color)
}

fn C.DrawEllipseLines(center_x int, center_y int, radius_h f32, radiusV f32, color Color)                           // Draw ellipse outline
@[inline]
pub fn draw_ellipse_lines(center_x int, center_y int, radius_h f32, radiusV f32, color Color) {
	C.DrawEllipseLines(center_x, center_y, radius_h, radiusV, color)
}

/*********************************************************************
|                           DRAW RING                                |
*********************************************************************/
fn C.DrawRing(center Vector2, inner_radius f32, outer_radius f32, start_angle f32, end_angle f32, segments int, color Color)        // Draw ring
@[inline]
pub fn draw_ring(center Vector2, inner_radius f32, outer_radius f32, start_angle f32, end_angle f32, segments int, color Color) {
	C.DrawRing(center, inner_radius, outer_radius, start_angle, end_angle, segments, color)
}

fn C.DrawRingLines(center Vector2, inner_radius f32, outer_radius f32, start_angle f32, end_angle f32, segments int, color Color)   // Draw ring outline
@[inline]
pub fn draw_ring_lines(center Vector2, inner_radius f32, outer_radius f32, start_angle f32, end_angle f32, segments int, color Color) {
	C.DrawRingLines(center, inner_radius, outer_radius, start_angle, end_angle, segments,
		color)
}

/*********************************************************************
|                         DRAW RECTANGLE                             |
*********************************************************************/
fn C.DrawRectangle(pos_x int, pos_y int, width int, height int, color Color)                    // Draw a color-filled rectangle
@[inline]
pub fn draw_rectangle(pos_x int, pos_y int, width int, height int, color Color) {
	C.DrawRectangle(pos_x, pos_y, width, height, color)
}

fn C.DrawRectangleV(position Vector2, size Vector2, color Color)                                // Draw a color-filled rectangle (Vector version)
@[inline]
pub fn draw_rectangle_v(position Vector2, size Vector2, color Color) {
	C.DrawRectangleV(position, size, color)
}

fn C.DrawRectangleRec(rec Rectangle, color Color)                                               // Draw a color-filled rectangle
@[inline]
pub fn draw_rectangle_rec(rec Rectangle, color Color) {
	C.DrawRectangleRec(rec, color)
}

fn C.DrawRectanglePro(rec Rectangle, origin Vector2, rotation f32, color Color)                 // Draw a color-filled rectangle with pro parameters
@[inline]
pub fn draw_rectangle_pro(rec Rectangle, origin Vector2, rotation f32, color Color) {
	C.DrawRectanglePro(rec, origin, rotation, color)
}

fn C.DrawRectangleGradientV(pos_x int, pos_y int, width int, height int, color1 Color, color2 Color)        // Draw a vertical-gradient-filled rectangle
@[inline]
pub fn draw_rectangle_gradient_v(pos_x int, pos_y int, width int, height int, color1 Color, color2 Color) {
	C.DrawRectangleGradientV(pos_x, pos_y, width, height, color1, color2)
}

fn C.DrawRectangleGradientH(pos_x int, pos_y int, width int, height int, color1 Color, color2 Color)        // Draw a horizontal-gradient-filled rectangle
@[inline]
pub fn draw_rectangle_gradient_h(pos_x int, pos_y int, width int, height int, color1 Color, color2 Color) {
	C.DrawRectangleGradientH(pos_x, pos_y, width, height, color1, color2)
}

fn C.DrawRectangleGradientEx(rec Rectangle, col1 Color, col2 Color, col3 Color, col4 Color)                 // Draw a gradient-filled rectangle with custom vertex colors
@[inline]
pub fn draw_rectangle_gradient_ex(rec Rectangle, col1 Color, col2 Color, col3 Color, col4 Color) {
	C.DrawRectangleGradientEx(rec, col1, col2, col3, col4)
}

fn C.DrawRectangleLines(pos_x int, pos_y int, width int, height int, color Color)                           // Draw rectangle outline
@[inline]
pub fn draw_rectangle_lines(pos_x int, pos_y int, width int, height int, color Color) {
	C.DrawRectangleLines(pos_x, pos_y, width, height, color)
}

fn C.DrawRectangleLinesEx(rec Rectangle, line_thick f32, color Color)                                        // Draw rectangle outline with extended parameters
@[inline]
pub fn draw_rectangle_lines_ex(rec Rectangle, line_thick f32, color Color) {
	C.DrawRectangleLinesEx(rec, line_thick, color)
}

fn C.DrawRectangleRounded(rec Rectangle, roundness f32, segments int, color Color)                          // Draw rectangle with rounded edges
@[inline]
pub fn draw_rectangle_rounded(rec Rectangle, roundness f32, segments int, color Color) {
	C.DrawRectangleRounded(rec, roundness, segments, color)
}

fn C.DrawRectangleRoundedLines(rec Rectangle, roundness f32, segments int, color Color)                     // Draw rectangle lines with rounded edges
@[inline]
pub fn draw_rectangle_rounded_lines(rec Rectangle, roundness f32, segments int, color Color) {
	C.DrawRectangleRoundedLines(rec, roundness, segments, color)
}

fn C.DrawRectangleRoundedLinesEx(rec Rectangle, roundness f32, segments int, line_thick f32, color Color) // Draw rectangle with rounded edges outline
@[inline]
pub fn draw_rectangle_rounded_lines_ex(rec Rectangle, roundness f32, segments int, line_thick f32, color Color) {
    C.DrawRectangleRoundedLinesEx(rec, roundness, segments, line_thick, color)
}

/*********************************************************************
|                         DRAW TRIANGLE                              |
*********************************************************************/
fn C.DrawTriangle(v1 Vector2, v2 Vector2, v3 Vector2, color Color)          // Draw a color-filled triangle (vertex in counter-clockwise order!)
@[inline]
pub fn draw_triangle(v1 Vector2, v2 Vector2, v3 Vector2, color Color) {
	C.DrawTriangle(v1, v2, v3, color)
}

fn C.DrawTriangleLines(v1 Vector2, v2 Vector2, v3 Vector2, color Color)     // Draw triangle outline (vertex in counter-clockwise order!)
@[inline]
pub fn draw_triangle_lines(v1 Vector2, v2 Vector2, v3 Vector2, color Color) {
	C.DrawTriangleLines(v1, v2, v3, color)
}

fn C.DrawTriangleFan(points &Vector2, point_count int, color Color)         // Draw a triangle fan defined by points (first vertex is the center)
@[inline]
pub fn draw_triangle_fan(points &Vector2, point_count int, color Color) {
	C.DrawTriangleFan(points, point_count, color)
}

fn C.DrawTriangleStrip(points &Vector2, point_count int, color Color)       // Draw a triangle strip defined by points
@[inline]
pub fn draw_triangle_strip(points &Vector2, point_count int, color Color) {
	C.DrawTriangleStrip(points, point_count, color)
}

/*********************************************************************
|                             DRAW POLY                              |
*********************************************************************/
fn C.DrawPoly(center Vector2, sides int, radius f32, rotation f32, color Color) // Draw a regular polygon (Vector version)
@[inline]
pub fn draw_poly(center Vector2, sides int, radius f32, rotation f32, color Color) {
	C.DrawPoly(center, sides, radius, rotation, color)
}

fn C.DrawPolyLines(center Vector2, sides int, radius f32, rotation f32, color Color)
@[inline]
pub fn draw_poly_lines(center Vector2, sides int, radius f32, rotation f32, color Color) {
	C.DrawPolyLines(center, sides, radius, rotation, color)
}

fn C.DrawPolyLinesEx(center Vector2, sides int, radius f32, rotation f32, line_thick f32, color Color)
@[inline]
pub fn draw_poly_lines_ex(center Vector2, sides int, radius f32, rotation f32, line_thick f32, color Color) {
	C.DrawPolyLinesEx(center, sides, radius, rotation, line_thick, color)
}

/*********************************************************************
|                           DRAW CAPSULE                             |
*********************************************************************/
fn C.DrawCapsule(start_pos Vector3, end_pos Vector3, radius f32, slices int, rings int, color Color)                // Draw a capsule with the center of its sphere caps at start_pos and end_pos
@[inline]
pub fn draw_capsule(start_pos Vector3, end_pos Vector3, radius f32, slices int, rings int, color Color) {
    C.DrawCapsule(start_pos, end_pos, radius, slices, rings, color)
}

fn C.DrawCapsuleWires(start_pos Vector3, end_pos Vector3, radius f32, slices int, rings int, color Color) // Draw capsule wireframe with the center of its sphere caps at start_pos and end_pos
@[inline]
pub fn draw_capsule_wires(start_pos Vector3, end_pos Vector3, radius f32, slices int, rings int, color Color) {
    C.DrawCapsuleWires(start_pos, end_pos, radius, slices, rings, color)
}

/*********************************************************************
|                           DRAW SPLINE                              |
*********************************************************************/
// Splines drawing functions
fn C.DrawSplineLinear(points &Vector2, point_count int, thick f32, color Color)                  // Draw spline: Linear, minimum 2 points
@[inline]
pub fn draw_spline_linear(points &Vector2, point_count int, thick f32, color Color) {
    C.DrawSplineLinear(points, point_count, thick, color)
}

fn C.DrawSplineBasis(points &Vector2, point_count int, thick f32, color Color)                   // Draw spline: B-Spline, minimum 4 points
@[inline]
pub fn draw_spline_basis(points &Vector2, point_count int, thick f32, color Color) {
    C.DrawSplineBasis(points, point_count, thick, color)
}

fn C.DrawSplineCatmullRom(points &Vector2, point_count int, thick f32, color Color)              // Draw spline: Catmull-Rom, minimum 4 points
@[inline]
pub fn draw_spline_catmull_rom(points &Vector2, point_count int, thick f32, color Color) {
    C.DrawSplineCatmullRom(points, point_count, thick, color)
}

fn C.DrawSplineBezierQuadratic(points &Vector2, point_count int, thick f32, color Color)         // Draw spline: Quadratic Bezier, minimum 3 points (1 control point): [p1, c2, p3, c4...]
@[inline]
pub fn draw_spline_bezier_quadratic(points &Vector2, point_count int, thick f32, color Color) {
    C.DrawSplineBezierQuadratic(points, point_count, thick, color)
}

fn C.DrawSplineBezierCubic(points &Vector2, point_count int, thick f32, color Color)             // Draw spline: Cubic Bezier, minimum 4 points (2 control points): [p1, c2, c3, p4, c5, c6...]
@[inline]
pub fn draw_spline_bezier_cubic(points &Vector2, point_count int, thick f32, color Color) {
    C.DrawSplineBezierCubic(points, point_count, thick, color)
}

fn C.DrawSplineSegmentLinear(p1 Vector2, p2 Vector2, thick f32, color Color)                    // Draw spline segment: Linear, 2 points
@[inline]
pub fn draw_spline_segment_linear(p1 Vector2, p2 Vector2, thick f32, color Color) {
    C.DrawSplineSegmentLinear(p1, p2, thick, color)
}

fn C.DrawSplineSegmentBasis(p1 Vector2, p2 Vector2, p3 Vector2, p4 Vector2, thick f32, color Color) // Draw spline segment: B-Spline, 4 points
@[inline]
pub fn draw_spline_segment_basis(p1 Vector2, p2 Vector2, p3 Vector2, p4 Vector2, thick f32, color Color) {
    C.DrawSplineSegmentBasis(p1, p2, p3, p4, thick, color)
}

fn C.DrawSplineSegmentCatmullRom(p1 Vector2, p2 Vector2, p3 Vector2, p4 Vector2, thick f32, color Color) // Draw spline segment: Catmull-Rom, 4 points
@[inline]
pub fn draw_spline_segment_catmull_rom(p1 Vector2, p2 Vector2, p3 Vector2, p4 Vector2, thick f32, color Color) {
    C.DrawSplineSegmentCatmullRom(p1, p2, p3, p4, thick, color)
}

fn C.DrawSplineSegmentBezierQuadratic(p1 Vector2, c2 Vector2, p3 Vector2, thick f32, color Color) // Draw spline segment: Quadratic Bezier, 2 points, 1 control point
@[inline]
pub fn draw_spline_segment_bezier_quadratic(p1 Vector2, c2 Vector2, p3 Vector2, thick f32, color Color) {
    C.DrawSplineSegmentBezierQuadratic(p1, c2, p3, thick, color)
}

fn C.DrawSplineSegmentBezierCubic(p1 Vector2, c2 Vector2, c3 Vector2, p4 Vector2, thick f32, color Color) // Draw spline segment: Cubic Bezier, 2 points, 2 control points
@[inline]
pub fn draw_spline_segment_bezier_cubic(p1 Vector2, c2 Vector2, c3 Vector2, p4 Vector2, thick f32, color Color) {
    C.DrawSplineSegmentBezierCubic(p1, c2, c3, p4, thick, color)
}

// Spline segment point evaluation functions, for a given t [0.0f .. 1.0f]
fn C.GetSplinePointLinear(start_pos Vector2, end_pos Vector2, t f32) Vector2    // Get (evaluate) spline point: Linear
@[inline]
pub fn get_spline_point_linear(start_pos Vector2, end_pos Vector2, t f32) Vector2 { 
    return C.GetSplinePointLinear(start_pos, end_pos, t)
}

fn C.GetSplinePointBasis(p1 Vector2, p2 Vector2, p3 Vector2, p4 Vector2, t f32) Vector2    // Get (evaluate) spline point: B-Spline
@[inline]
pub fn get_spline_point_basis(p1 Vector2, p2 Vector2, p3 Vector2, p4 Vector2, t f32) Vector2 {
    return C.GetSplinePointBasis(p1, p2, p3, p4, t)
}

fn C.GetSplinePointCatmullRom(p1 Vector2, p2 Vector2, p3 Vector2, p4 Vector2, t f32) Vector2    // Get (evaluate) spline point: Catmull-Rom
@[inline]
pub fn get_spline_point_catmull_rom(p1 Vector2, p2 Vector2, p3 Vector2, p4 Vector2, t f32) Vector2 {
    return C.GetSplinePointCatmullRom(p1, p2, p3, p4, t)
}

fn C.GetSplinePointBezierQuad(p1 Vector2, c2 Vector2, p3 Vector2, t f32) Vector2    // Get (evaluate) spline point: Quadratic Bezier
@[inline]
pub fn get_spline_point_bezier_quad(p1 Vector2, c2 Vector2, p3 Vector2, t f32) Vector2 {
    return C.GetSplinePointBezierQuad(p1, c2, p3, t)
}

fn C.GetSplinePointBezierCubic(p1 Vector2, c2 Vector2, c3 Vector2, p4 Vector2, t f32) Vector2    // Get (evaluate) spline point: Cubic Bezier
@[inline]
pub fn get_spline_point_bezier_cubic(p1 Vector2, c2 Vector2, c3 Vector2, p4 Vector2, t f32) Vector2 {
    return C.GetSplinePointBezierCubic(p1, c2, c3, p4, t)
}




fn C.CheckCollisionRecs(rec1 Rectangle, rec2 Rectangle) bool
@[inline]
pub fn check_collision_recs(rec1 Rectangle, rec2 Rectangle) bool {
	return C.CheckCollisionRecs(rec1, rec2)
}

fn C.CheckCollisionCircles(center1 Vector2, radius1 f32, center2 Vector2, radius2 f32) bool
@[inline]
pub fn check_collision_circles(center1 Vector2, radius1 f32, center2 Vector2, radius2 f32) bool {
	return C.CheckCollisionCircles(center1, radius1, center2, radius2)
}

fn C.CheckCollisionCircleRec(center Vector2, radius f32, rec Rectangle) bool
@[inline]
pub fn check_collision_circle_rec(center Vector2, radius f32, rec Rectangle) bool {
	return C.CheckCollisionCircleRec(center, radius, rec)
}

fn C.CheckCollisionPointRec(point Vector2, rec Rectangle) bool
@[inline]
pub fn check_collision_point_rec(point Vector2, rec Rectangle) bool {
	return C.CheckCollisionPointRec(point, rec)
}

fn C.CheckCollisionPointCircle(point Vector2, center Vector2, radius f32) bool
@[inline]
pub fn check_collision_point_circle(point Vector2, center Vector2, radius f32) bool {
	return C.CheckCollisionPointCircle(point, center, radius)
}

fn C.CheckCollisionPointTriangle(point Vector2, p1 Vector2, p2 Vector2, p3 Vector2) bool
@[inline]
pub fn check_collision_point_triangle(point Vector2, p1 Vector2, p2 Vector2, p3 Vector2) bool {
	return C.CheckCollisionPointTriangle(point, p1, p2, p3)
}

/*fn C.CheckCollisionPointPoly(point Vector2, points voidptr, point_count int) bool
[inline]
pub fn check_collision_point_poly(point Vector2, points []Vector2) bool {
	return C.CheckCollisionPointPoly(point, points.data, points.len)
}*/

fn C.CheckCollisionLines(start_pos_1 Vector2, end_pos_1 Vector2, start_pos_2 Vector2, end_pos_2 Vector2, collision_point &Vector2) bool
@[inline]
pub fn check_collision_lines(start_pos_1 Vector2, end_pos_1 Vector2, start_pos_2 Vector2, end_pos_2 Vector2, collision_point &Vector2) bool {
	return C.CheckCollisionLines(start_pos_1, end_pos_1, start_pos_2, end_pos_2, collision_point)
}

fn C.CheckCollisionPointLine(point Vector2, p1 Vector2, p2 Vector2, threshold int) bool
@[inline]
pub fn check_collision_point_line(point Vector2, p1 Vector2, p2 Vector2, threshold int) bool {
	return C.CheckCollisionPointLine(point, p1, p2, threshold)
}

fn C.GetCollisionRec(rec1 Rectangle, rec2 Rectangle) Rectangle
@[inline]
pub fn get_collision_rec(rec1 Rectangle, rec2 Rectangle) Rectangle {
	return C.GetCollisionRec(rec1, rec2)
}

@[inline]
pub fn is_image_valid(image Image) bool {
    return image.data   != voidptr(0) &&
           image.width  >  0          &&
           image.height >  0
}

fn C.LoadImage(file_name &char) Image
@[inline]
pub fn load_image(file_name string) Image {
	return C.LoadImage(file_name.str)
}

fn C.LoadImageRaw(file_name &char, width int, height int, format int, header_size int) Image
@[inline]
pub fn load_image_raw(file_name string, width int, height int, format int, header_size int) Image {
	return C.LoadImageRaw(file_name.str, width, height, format, header_size)
}

// Is this function is removed ??
// fn C.LoadImageSvg(file_name_or_string &char, width int, height int) Image                            // Load image from SVG file data or string with specified size
// @[inline]
// pub fn load_image_svg(file_name_or_string string, width int, height int) Image {
//     return C.LoadImageSvg(file_name_or_string.str, width, height)
// }

fn C.LoadImageAnim(file_name &char, frames &int) Image
@[inline]
pub fn load_image_anim(file_name string, frames &int) Image {
	return C.LoadImageAnim(file_name.str, frames)
}

fn C.LoadImageFromMemory(file_type &char, file_data &u8, data_size int) Image
@[inline]
pub fn load_image_from_memory(file_type string, file_data &u8, data_size int) Image {
	return C.LoadImageFromMemory(file_type.str, file_data, data_size)
}

fn C.LoadImageFromTexture(texture Texture) Image
@[inline]
pub fn load_image_from_texture(texture Texture) Image {
	return C.LoadImageFromTexture(texture)
}

fn C.LoadImageFromScreen() Image
@[inline]
pub fn load_image_from_screen() Image {
	return C.LoadImageFromScreen()
}

fn C.UnloadImage(image Image)
@[inline]
pub fn unload_image(image Image) {
	C.UnloadImage(image)
}

fn C.ExportImage(image Image, file_name &char) bool
@[inline]
pub fn export_image(image Image, file_name string) bool {
	return C.ExportImage(image, file_name.str)
}

fn C.ExportImageAsCode(image Image, file_name &char) bool
@[inline]
pub fn export_image_as_code(image Image, file_name string) bool {
	return C.ExportImageAsCode(image, file_name.str)
}

// Image generation functions
fn C.GenImageColor(width int, height int, color Color) Image        // Generate image: plain color
@[inline]
pub fn gen_image_color(width int, height int, color Color) Image {
	return C.GenImageColor(width, height, color)
}


fn C.GenImageGradientLinear(width int, height int, direction int, start Color, end Color) Image         // Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
@[inline]
pub fn gen_image_gradient_linear(width int, height int, direction int, start Color, end Color) Image {
    return C.GenImageGradientLinear(width, height, direction, start, end)
}

fn C.GenImageGradientRadial(width int, height int, density f32, inner Color, outer Color) Image         // Generate image: radial gradient
@[inline]
pub fn gen_image_gradient_radial(width int, height int, density f32, inner Color, outer Color) Image {
    return C.GenImageGradientRadial(width, height, density, inner, outer)
}

fn C.GenImageGradientSquare(width int, height int, density f32, inner Color, outer Color) Image     // Generate image: square gradient
@[inline]
pub fn gen_image_gradient_square(width int, height int, density f32, inner Color, outer Color) Image {
    return C.GenImageGradientSquare(width, height, density, inner, outer)
}

fn C.GenImageChecked(width int, height int, checks_x int, checks_y int, col1 Color, col2 Color) Image     // Generate image: checked
@[inline]
pub fn gen_image_checked(width int, height int, checks_x int, checks_y int, col1 Color, col2 Color) Image {
	return C.GenImageChecked(width, height, checks_x, checks_y, col1, col2)
}

fn C.GenImageWhiteNoise(width int, height int, factor f32) Image                                        // Generate image: white noise
@[inline]
pub fn gen_image_white_noise(width int, height int, factor f32) Image {
	return C.GenImageWhiteNoise(width, height, factor)
}

fn C.GenImagePerlinNoise(width int, height int, offset_x int, offset_y int, scale f32) Image            // Generate image: perlin noise
@[inline]
pub fn gen_image_perlin_noise(width int, height int, offset_x int, offset_y int, scale f32) Image {
	return C.GenImagePerlinNoise(width, height, offset_x, offset_y, scale)
}

fn C.GenImageCellular(width int, height int, tile_size int) Image   // Generate image: cellular algorithm, bigger tileSize means bigger cells
@[inline]
pub fn gen_image_cellular(width int, height int, tile_size int) Image {
	return C.GenImageCellular(width, height, tile_size)
}

fn C.GenImageText(width int, height int, text &char) Image                              // Generate image: grayscale image from text data
@[inline]
pub fn gen_image_text(width int, height int, text string) Image {
    return C.GenImageText(width, height, text.str)
}



fn C.ImageCopy(image Image) Image
@[inline]
pub fn image_copy(image Image) Image {
	return C.ImageCopy(image)
}

fn C.ImageFromImage(image Image, rec Rectangle) Image
@[inline]
pub fn image_from_image(image Image, rec Rectangle) Image {
	return C.ImageFromImage(image, rec)
}

fn C.ImageText(text &char, font_size int, color Color) Image
@[inline]
pub fn image_text(text string, font_size int, color Color) Image {
	return C.ImageText(text.str, font_size, color)
}

fn C.ImageTextEx(font Font, text &char, font_size f32, spacing f32, tint Color) Image
@[inline]
pub fn image_text_ex(font Font, text string, font_size f32, spacing f32, tint Color) Image {
	return C.ImageTextEx(font, text.str, font_size, spacing, tint)
}

fn C.ImageFormat(image &Image, new_format int)
@[inline]
pub fn image_format(image &Image, new_format int) {
	C.ImageFormat(image, new_format)
}

fn C.ImageToPOT(image &Image, fill Color)
@[inline]
pub fn image_to_pot(image &Image, fill Color) {
	C.ImageToPOT(image, fill)
}

fn C.ImageCrop(image &Image, crop Rectangle)
@[inline]
pub fn image_crop(image &Image, crop Rectangle) {
	C.ImageCrop(image, crop)
}

fn C.ImageAlphaCrop(image &Image, threshold f32)
@[inline]
pub fn image_alpha_crop(image &Image, threshold f32) {
	C.ImageAlphaCrop(image, threshold)
}

fn C.ImageAlphaClear(image &Image, color Color, threshold f32)
@[inline]
pub fn image_alpha_clear(image &Image, color Color, threshold f32) {
	C.ImageAlphaClear(image, color, threshold)
}

fn C.ImageAlphaMask(image &Image, alphaMask Image)
@[inline]
pub fn image_alpha_mask(image &Image, alphaMask Image) {
	C.ImageAlphaMask(image, alphaMask)
}

fn C.ImageAlphaPremultiply(image &Image)
@[inline]
pub fn image_alpha_premultiply(image &Image) {
	C.ImageAlphaPremultiply(image)
}

fn C.ImageBlurGaussian(image &Image, blur_size int)                                                // Apply Gaussian blur using a box blur approximation
@[inline]
pub fn image_blur_gaussian(image &Image, blur_size int) {
    C.ImageBlurGaussian(image, blur_size)
}

fn C.ImageResize(image &Image, new_width int, new_height int)
@[inline]
pub fn image_resize(image &Image, new_width int, new_height int) {
	C.ImageResize(image, new_width, new_height)
}

fn C.ImageResizeNN(image &Image, new_width int, new_height int)
@[inline]
pub fn image_resize_nn(image &Image, new_width int, new_height int) {
	C.ImageResizeNN(image, new_width, new_height)
}

fn C.ImageResizeCanvas(image &Image, new_width int, new_height int, offset_x int, offset_y int, fill Color)
@[inline]
pub fn image_resize_canvas(image &Image, new_width int, new_height int, offset_x int, offset_y int, fill Color) {
	C.ImageResizeCanvas(image, new_width, new_height, offset_x, offset_y, fill)
}

fn C.ImageMipmaps(image &Image)
@[inline]
pub fn image_mipmaps(image &Image) {
	C.ImageMipmaps(image)
}

fn C.ImageDither(image &Image, r_bpp int, g_bpp int, b_bpp int, a_bpp int)
@[inline]
pub fn image_dither(image &Image, r_bpp int, g_bpp int, b_bpp int, a_bpp int) {
	C.ImageDither(image, r_bpp, g_bpp, b_bpp, a_bpp)
}

fn C.ImageFlipVertical(image &Image)
@[inline]
pub fn image_flip_vertical(image &Image) {
	C.ImageFlipVertical(image)
}

fn C.ImageFlipHorizontal(image &Image)
@[inline]
pub fn image_flip_horizontal(image &Image) {
	C.ImageFlipHorizontal(image)
}

fn C.ImageRotate(image &Image, degrees int)      // Rotate image by input angle in degrees (-359 to 359)
@[inline]
pub fn image_rotate(image &Image, degrees int) {
    C.ImageRotate(image, degrees)
}

fn C.ImageRotateCW(image &Image)
@[inline]
pub fn image_rotate_cw(image &Image) {
	C.ImageRotateCW(image)
}

fn C.ImageRotateCCW(image &Image)
@[inline]
pub fn image_rotate_ccw(image &Image) {
	C.ImageRotateCCW(image)
}

fn C.ImageColorTint(image &Image, color Color)
@[inline]
pub fn image_color_tint(image &Image, color Color) {
	C.ImageColorTint(image, color)
}

fn C.ImageColorInvert(image &Image)
@[inline]
pub fn image_color_invert(image &Image) {
	C.ImageColorInvert(image)
}

fn C.ImageColorGrayscale(image &Image)
@[inline]
pub fn image_color_grayscale(image &Image) {
	C.ImageColorGrayscale(image)
}

fn C.ImageColorContrast(image &Image, contrast f32)
@[inline]
pub fn image_color_contrast(image &Image, contrast f32) {
	C.ImageColorContrast(image, contrast)
}

fn C.ImageColorBrightness(image &Image, brightness int)
@[inline]
pub fn image_color_brightness(image &Image, brightness int) {
	C.ImageColorBrightness(image, brightness)
}

fn C.ImageColorReplace(image &Image, color Color, replace Color)
@[inline]
pub fn image_color_replace(image &Image, color Color, replace Color) {
	C.ImageColorReplace(image, color, replace)
}

fn C.LoadImageColors(image Image) &Color
@[inline]
pub fn load_image_colors(image Image) &Color {
	return C.LoadImageColors(image)
}

fn C.LoadImagePalette(image Image, max_palette_size int, color_count &int) &Color
@[inline]
pub fn load_image_palette(image Image, max_palette_size int, color_count &int) &Color {
	return C.LoadImagePalette(image, max_palette_size, color_count)
}

fn C.UnloadImageColors(colors &Color)
@[inline]
pub fn unload_image_colors(colors &Color) {
	C.UnloadImageColors(colors)
}

fn C.UnloadImagePalette(colors &Color)
@[inline]
pub fn unload_image_palette(colors &Color) {
	C.UnloadImagePalette(colors)
}

fn C.GetImageAlphaBorder(image Image, threshold f32) Rectangle
@[inline]
pub fn get_image_alpha_border(image Image, threshold f32) Rectangle {
	return C.GetImageAlphaBorder(image, threshold)
}


// Image generation functions
fn C.GetImageColor(image Image, x int, y int) Color         // Generate image: plain color
@[inline]
pub fn get_image_color(image Image, x int, y int) Color {
	return C.GetImageColor(image, x, y)
}

// fn C.GenImageGradientLinear(width int, height int, direction int, start Color, end Color) Image     // Generate image: linear gradient, direction in degrees [0..360], 0=Vertical gradient
// @[inline]
// pub fn gen_image_gradient_linear(width int, height int, direction int, start Color, end Color) Image {
//     return C.GenImageGradientLinear(width, height, direction, start, end)
// }

// fn C.GenImageGradientRadial(width int, height int, density f32, inner Color, outer Color) Image   // Generate image: radial gradient
// @[inline]
// pub fn gen_image_gradient_radial(width int, height int, density f32, inner Color, outer Color) Image {
//     return C.GenImageGradientRadial(width, height, density, inner, outer)
// }

// fn C.GenImageGradientSquare(width int, height int, density f32, inner Color, outer Color) Image   // Generate image: square gradient
// @[inline]
// pub fn gen_image_gradient_square(width int, height int, density f32, inner Color, outer Color) Image {
//     return C.GenImageGradientSquare(width, height, density, inner, outer)
// }

// fn C.GenImageChecked(width int, height int, checks_x int, checks_y int, col1 Color, col2 Color) Image // Generate image: checked
// @[inline]
// pub fn C.GenImageChecked(width int, height int, checks_x int, checks_y int, col1 Color, col2 Color) Image {
//     return C.GenImageChecked(width, height, checks_x, checks_y, col1, col2)
// }

// fn C.GenImageWhiteNoise(width int, height int, factor f32) Image                                 // Generate image: white noise
// @[inline]
// pub fn gen_image_white_noise(width int, height int, factor f32) Image {
//     return gen_image_white_noise(width, height, factor)
// }

// fn C.GenImagePerlinNoise(width int, height int, offset_x int, offset_y int, scale f32) Image        // Generate image: perlin noise
// @[inline]
// pub fn gen_image_perlin_noise(width int, height int, offset_x int, offset_y int, scale f32) Image {
//     return C.GenImagePerlinNoise(width, height, offset_x, offset_y, scale)
// }


// fn C.GenImageCellular(int width, int height, int tileSize) Image                                    // Generate image: cellular algorithm, bigger tileSize means bigger cells
// fn C.GenImageText(int width, int height, const char *text) Image                                    // Generate image: grayscale image from text data





fn C.ImageClearBackground(dst &Image, color Color)
@[inline]
pub fn image_clear_background(dst &Image, color Color) {
	C.ImageClearBackground(dst, color)
}

fn C.ImageDrawPixel(dst &Image, pos_x int, pos_y int, color Color)
@[inline]
pub fn image_draw_pixel(dst &Image, pos_x int, pos_y int, color Color) {
	C.ImageDrawPixel(dst, pos_x, pos_y, color)
}

fn C.ImageDrawPixelV(dst &Image, position Vector2, color Color)
@[inline]
pub fn image_draw_pixel_v(dst &Image, position Vector2, color Color) {
	C.ImageDrawPixelV(dst, position, color)
}

fn C.ImageDrawLine(dst &Image, start_pos_x int, start_pos_y int, end_pos_x int, end_pos_y int, color Color)
@[inline]
pub fn image_draw_line(dst &Image, start_pos_x int, start_pos_y int, end_pos_x int, end_pos_y int, color Color) {
	C.ImageDrawLine(dst, start_pos_x, start_pos_y, end_pos_x, end_pos_y, color)
}

fn C.ImageDrawLineV(dst &Image, start Vector2, end Vector2, color Color)
@[inline]
pub fn image_draw_line_v(dst &Image, start Vector2, end Vector2, color Color) {
	C.ImageDrawLineV(dst, start, end, color)
}

fn C.ImageDrawCircle(dst &Image, center_x int, center_y int, radius int, color Color)
@[inline]
pub fn image_draw_circle(dst &Image, center_x int, center_y int, radius int, color Color) {
	C.ImageDrawCircle(dst, center_x, center_y, radius, color)
}

fn C.ImageDrawCircleV(dst &Image, center Vector2, radius int, color Color)
@[inline]
pub fn image_draw_circle_v(dst &Image, center Vector2, radius int, color Color) {
	C.ImageDrawCircleV(dst, center, radius, color)
}

fn C.ImageDrawCircleLines(dst &Image, center_x int, center_y int, radius int, color Color)
@[inline]
pub fn image_draw_circle_lines(dst &Image, center_x int, center_y int, radius int, color Color) {
	C.ImageDrawCircleLines(dst, center_x, center_y, radius, color)
}

fn C.ImageDrawCircleLinesV(dst &Image, center Vector2, radius int, color Color)
@[inline]
pub fn image_draw_circle_lines_v(dst &Image, center Vector2, radius int, color Color) {
	C.ImageDrawCircleLinesV(dst, center, radius, color)
}

fn C.ImageDrawRectangle(dst &Image, pos_x int, pos_y int, width int, height int, color Color)
@[inline]
pub fn image_draw_rectangle(dst &Image, pos_x int, pos_y int, width int, height int, color Color) {
	C.ImageDrawRectangle(dst, pos_x, pos_y, width, height, color)
}

fn C.ImageDrawRectangleV(dst &Image, position Vector2, size Vector2, color Color)
@[inline]
pub fn image_draw_rectangle_v(dst &Image, position Vector2, size Vector2, color Color) {
	C.ImageDrawRectangleV(dst, position, size, color)
}

fn C.ImageDrawRectangleRec(dst &Image, rec Rectangle, color Color)
@[inline]
pub fn image_draw_rectangle_rec(dst &Image, rec Rectangle, color Color) {
	C.ImageDrawRectangleRec(dst, rec, color)
}

fn C.ImageDrawRectangleLines(dst &Image, rec Rectangle, thick int, color Color)
@[inline]
pub fn image_draw_rectangle_lines(dst &Image, rec Rectangle, thick int, color Color) {
	C.ImageDrawRectangleLines(dst, rec, thick, color)
}

fn C.ImageDrawTriangle(dst &Image, v1 Vector2, v2 Vector2, v3 Vector2, color Color)                    // Draw triangle within an image
@[inline]
pub fn image_draw_triangle(dst &Image, v1 Vector2, v2 Vector2, v3 Vector2, color Color) {
    C.ImageDrawTriangle(dst, v1, v2, v3, color)
}
    
fn C.ImageDrawTriangleEx(dst &Image, v1 Vector2, v2 Vector2, v3 Vector2, c1 Color, c2 Color, c3 Color) // Draw triangle with interpolated colors within an image
@[inline]
pub fn image_draw_triangle_ex(dst &Image, v1 Vector2, v2 Vector2, v3 Vector2, c1 Color, c2 Color, c3 Color) {
    C.ImageDrawTriangleEx(dst, v1, v2, v3, c1, c2, c3)
}

fn C.ImageDrawTriangleLines(dst &Image, v1 Vector2, v2 Vector2, v3 Vector2, color Color) // Draw triangle outline within an image
@[inline]
pub fn image_draw_triangle_lines(dst &Image, v1 Vector2, v2 Vector2, v3 Vector2, color Color) {
    C.ImageDrawTriangleLines(dst, v1, v2, v3, color)
}

fn C.ImageDrawTriangleFan(dst &Image, points &Vector2, point_count int, color Color)     // Draw a triangle fan defined by points within an image (first vertex is the center)
@[inline]
pub fn image_draw_triangle_fan(dst &Image, points []Vector2, color Color) {
    C.ImageDrawTriangleFan(dst, points.data, points.len, color)
}

fn C.ImageDrawTriangleStrip(dst &Image, points &Vector2, point_count int, color Color)   // Draw a triangle strip defined by points within an image
@[inline]
pub fn image_draw_triangle_strip(dst &Image, points []Vector2, color Color) {
    C.ImageDrawTriangleStrip(dst, points.data, points.len, color)
}

fn C.ImageDraw(dst &Image, src Image, src_rec Rectangle, dst_rec Rectangle, tint Color)
@[inline]
pub fn image_draw(dst &Image, src Image, src_rec Rectangle, dst_rec Rectangle, tint Color) {
	C.ImageDraw(dst, src, src_rec, dst_rec, tint)
}

fn C.ImageDrawText(dst &Image, text &char, pos_x int, pos_y int, font_size int, color Color)
@[inline]
pub fn image_draw_text(dst &Image, text string, pos_x int, pos_y int, font_size int, color Color) {
	C.ImageDrawText(dst, text.str, pos_x, pos_y, font_size, color)
}

fn C.ImageDrawTextEx(dst &Image, font Font, text &char, position Vector2, font_size f32, spacing f32, tint Color)
@[inline]
pub fn image_draw_text_ex(dst &Image, font Font, text string, position Vector2, font_size f32, spacing f32, tint Color) {
	C.ImageDrawTextEx(dst, font, text.str, position, font_size, spacing, tint)
}

fn C.LoadTexture(file_name &char) Texture
@[inline]
pub fn load_texture(file_name string) Texture {
	return C.LoadTexture(file_name.str)
}

fn C.LoadTextureFromImage(image Image) Texture
@[inline]
pub fn load_texture_from_image(image Image) Texture {
	return C.LoadTextureFromImage(image)
}

fn C.LoadTextureCubemap(image Image, layout int) TextureCubemap
@[inline]
pub fn load_texture_cubemap(image Image, layout int) TextureCubemap {
	return C.LoadTextureCubemap(image, layout)
}

fn C.LoadRenderTexture(width int, height int) RenderTexture
@[inline]
pub fn load_render_texture(width int, height int) RenderTexture {
	return C.LoadRenderTexture(width, height)
}

fn C.IsTextureValid(texture Texture) bool
@[inline]                                                    
pub fn is_texture_valid(texture Texture) bool {
    return C.IsTextureValid(texture)
}
                                                    
fn C.UnloadTexture(texture Texture)
@[inline]
pub fn unload_texture(texture Texture) {
	C.UnloadTexture(texture)
}

fn C.UnloadRenderTexture(target RenderTexture)
@[inline]
pub fn unload_render_texture(target RenderTexture) {
	C.UnloadRenderTexture(target)
}

fn C.UpdateTexture(texture Texture, pixels voidptr)
@[inline]
pub fn update_texture(texture Texture, pixels voidptr) {
	C.UpdateTexture(texture, pixels)
}

fn C.UpdateTextureRec(texture Texture, rec Rectangle, pixels voidptr)
@[inline]
pub fn update_texture_rec(texture Texture, rec Rectangle, pixels voidptr) {
	C.UpdateTextureRec(texture, rec, pixels)
}

fn C.GenTextureMipmaps(texture &Texture)
@[inline]
pub fn gen_texture_mipmaps(texture &Texture) {
	C.GenTextureMipmaps(texture)
}

fn C.SetTextureFilter(texture Texture, filter int)
@[inline]
pub fn set_texture_filter(texture Texture, filter int) {
	C.SetTextureFilter(texture, filter)
}

fn C.SetTextureWrap(texture Texture, wrap int)
@[inline]
pub fn set_texture_wrap(texture Texture, wrap int) {
	C.SetTextureWrap(texture, wrap)
}

fn C.DrawTexture(texture Texture, pos_x int, pos_y int, tint Color)
@[inline]
pub fn draw_texture(texture Texture, pos_x int, pos_y int, tint Color) {
	C.DrawTexture(texture, pos_x, pos_y, tint)
}

fn C.DrawTextureV(texture Texture, position Vector2, tint Color)
@[inline]
pub fn draw_texture_v(texture Texture, position Vector2, tint Color) {
	C.DrawTextureV(texture, position, tint)
}

fn C.DrawTextureEx(texture Texture, position Vector2, rotation f32, scale f32, tint Color)
@[inline]
pub fn draw_texture_ex(texture Texture, position Vector2, rotation f32, scale f32, tint Color) {
	C.DrawTextureEx(texture, position, rotation, scale, tint)
}

fn C.DrawTextureRec(texture Texture, source Rectangle, position Vector2, tint Color)
@[inline]
pub fn draw_texture_rec(texture Texture, source Rectangle, position Vector2, tint Color) {
	C.DrawTextureRec(texture, source, position, tint)
}

// fn C.DrawTextureQuad(texture Texture, tiling Vector2, offset Vector2, quad Rectangle, tint Color)
// @[inline]
// pub fn draw_texture_quad(texture Texture, tiling Vector2, offset Vector2, quad Rectangle, tint Color) {
// 	C.DrawTextureQuad(texture, tiling, offset, quad, tint)
// }

// fn C.DrawTextureTiled(texture Texture, source Rectangle, dest Rectangle, origin Vector2, rotation f32, scale f32, tint Color)
// @[inline]
// pub fn draw_texture_tiled(texture Texture, source Rectangle, dest Rectangle, origin Vector2, rotation f32, scale f32, tint Color) {
// 	C.DrawTextureTiled(texture, source, dest, origin, rotation, scale, tint)
// }

fn C.DrawTexturePro(texture Texture, source Rectangle, dest Rectangle, origin Vector2, rotation f32, tint Color)
@[inline]
pub fn draw_texture_pro(texture Texture, source Rectangle, dest Rectangle, origin Vector2, rotation f32, tint Color) {
	C.DrawTexturePro(texture, source, dest, origin, rotation, tint)
}

fn C.DrawTextureNPatch(texture Texture, n_patch_info NPatchInfo, dest Rectangle, origin Vector2, rotation f32, tint Color)
@[inline]
pub fn draw_texture_npatch(texture Texture, n_patch_info NPatchInfo, dest Rectangle, origin Vector2, rotation f32, tint Color) {
	C.DrawTextureNPatch(texture, n_patch_info, dest, origin, rotation, tint)
}

// fn C.DrawTexturePoly(texture Texture, center Vector2, points &Vector2, texcoords &Vector2, point_count int, tint Color)
// @[inline]
// pub fn draw_texture_poly(texture Texture, center Vector2, points &Vector2, texcoords &Vector2, point_count int, tint Color) {
// 	C.DrawTexturePoly(texture, center, points, texcoords, point_count, tint)
// }


fn C.GetPixelColor(src_ptr voidptr, format int) Color
@[inline]
pub fn get_pixel_color(src_ptr voidptr, format int) Color {
	return C.GetPixelColor(src_ptr, format)
}

fn C.SetPixelColor(dst_ptr voidptr, color Color, format int)
@[inline]
pub fn set_pixel_color(dst_ptr voidptr, color Color, format int) {
	C.SetPixelColor(dst_ptr, color, format)
}

fn C.GetPixelDataSize(width int, height int, format int) int
@[inline]
pub fn get_pixel_data_size(width int, height int, format int) int {
	return C.GetPixelDataSize(width, height, format)
}

fn C.GetFontDefault() Font
@[inline]
pub fn get_font_default() Font {
	return C.GetFontDefault()
}

fn C.LoadFont(file_name &char) Font
@[inline]
pub fn load_font(file_name string) Font {
	return C.LoadFont(file_name.str)
}

fn C.LoadFontEx(file_name &char, font_size int, font_chars &int, glyph_count int) Font
@[inline]
pub fn load_font_ex(file_name string, font_size int, font_chars &int, glyph_count int) Font {
	return C.LoadFontEx(file_name.str, font_size, font_chars, glyph_count)
}

fn C.LoadFontFromImage(image Image, key Color, first_char int) Font
@[inline]
pub fn load_font_from_image(image Image, key Color, first_char int) Font {
	return C.LoadFontFromImage(image, key, first_char)
}

fn C.LoadFontFromMemory(file_type &i8, file_data &u8, data_size int, font_size int, font_chars &int, glyph_count int) Font
@[inline]
pub fn load_font_from_memory(file_type &i8, file_data &u8, data_size int, font_size int, font_chars &int, glyph_count int) Font {
	return C.LoadFontFromMemory(file_type, file_data, data_size, font_size, font_chars, glyph_count)
}

fn C.LoadFontData(file_data &u8, data_size int, font_size int, font_chars &int, glyph_count int, @type int) &GlyphInfo
@[inline]
pub fn load_font_data(file_data &u8, data_size int, font_size int, font_chars &int, glyph_count int, @type int) &GlyphInfo {
	return C.LoadFontData(file_data, data_size, font_size, font_chars, glyph_count, @type)
}

fn C.GenImageFontAtlas(chars &GlyphInfo, recs &&Rectangle, glyph_count int, font_size int, padding int, pack_method int) Image
@[inline]
pub fn gen_image_font_atlas(chars &GlyphInfo, recs &&Rectangle, glyph_count int, font_size int, padding int, pack_method int) Image {
	return C.GenImageFontAtlas(chars, recs, glyph_count, font_size, padding, pack_method)
}

fn C.UnloadFontData(chars &GlyphInfo, glyph_count int)
@[inline]
pub fn unload_font_data(chars &GlyphInfo, glyph_count int) {
	C.UnloadFontData(chars, glyph_count)
}

fn C.UnloadFont(font Font)
@[inline]
pub fn unload_font(font Font) {
	C.UnloadFont(font)
}

fn C.ExportFontAsCode(font Font, file_name &char) bool
@[inline]
pub fn export_font_as_code(font Font, file_name string) bool {
	return C.ExportFontAsCode(font, file_name.str)
}

fn C.DrawFPS(pos_x int, pos_y int)
@[inline]
pub fn draw_fps(pos_x int, pos_y int) {
	C.DrawFPS(pos_x, pos_y)
}

fn C.DrawText(text &i8, pos_x int, pos_y int, font_size int, color Color)
@[inline]
pub fn draw_text(text string, pos_x int, pos_y int, font_size int, color Color) {
	C.DrawText(text.str, pos_x, pos_y, font_size, color)
}

@[inline]
pub fn draw_text_v(text string, pos Vector2, font_size int, color Color) {
	C.DrawText(text.str, pos.x, pos.y, font_size, color)
}

fn C.DrawTextEx(font Font, text &char, position Vector2, font_size f32, spacing f32, tint Color)
@[inline]
pub fn draw_text_ex(font Font, text string, position Vector2, font_size f32, spacing f32, tint Color) {
	C.DrawTextEx(font, text.str, position, font_size, spacing, tint)
}

fn C.DrawTextPro(font Font, text &i8, position Vector2, origin Vector2, rotation f32, font_size f32, spacing f32, tint Color)
@[inline]
pub fn draw_text_pro(font Font, text &i8, position Vector2, origin Vector2, rotation f32, font_size f32, spacing f32, tint Color) {
	C.DrawTextPro(font, text, position, origin, rotation, font_size, spacing, tint)
}

fn C.DrawTextCodepoint(font Font, codepoint int, position Vector2, font_size f32, tint Color)
@[inline]
pub fn draw_text_codepoint(font Font, codepoint int, position Vector2, font_size f32, tint Color) {
	C.DrawTextCodepoint(font, codepoint, position, font_size, tint)
}

fn C.DrawTextCodepoints(font Font, codepoints &int, count int, position Vector2, font_size f32, spacing f32, tint Color)
@[inline]
pub fn draw_text_codepoints(font Font, codepoints &int, count int, position Vector2, font_size f32, spacing f32, tint Color) {
	C.DrawTextCodepoints(font, codepoints, count, position, font_size, spacing, tint)
}



// Text font info functions
fn C.SetTextLineSpacing(spacing int)                                                 // Set vertical line spacing when drawing with line-breaks
@[inline]
pub fn set_text_line_spacing(spacing int) {
    C.SetTextLineSpacing(spacing)
}

fn C.MeasureText(text &char, font_size int) int
@[inline]
pub fn measure_text(text &char, font_size int) int {
	return C.MeasureText(text, font_size)
}

fn C.MeasureTextEx(font Font, text &char, font_size f32, spacing f32) Vector2
@[inline]
pub fn measure_text_ex(font Font, text string, font_size f32, spacing f32) Vector2 {
	return C.MeasureTextEx(font, text.str, font_size, spacing)
}

fn C.GetGlyphIndex(font Font, codepoint int) int
@[inline]
pub fn get_glyph_index(font Font, codepoint int) int {
	return C.GetGlyphIndex(font, codepoint)
}

fn C.GetGlyphInfo(font Font, codepoint int) GlyphInfo
@[inline]
pub fn get_glyph_info(font Font, codepoint int) GlyphInfo {
	return C.GetGlyphInfo(font, codepoint)
}

fn C.GetGlyphAtlasRec(font Font, codepoint int) Rectangle
@[inline]
pub fn get_glyph_atlas_rec(font Font, codepoint int) Rectangle {
	return C.GetGlyphAtlasRec(font, codepoint)
}

fn C.LoadUTF8(codepoints &int, length int) &char
@[inline]
pub fn load_utf8(codepoints &int, length int) string {
	return unsafe { cstring_to_vstring(C.LoadUTF8(codepoints, length)) }
}

fn C.UnloadUTF8(text &char)
@[inline]
pub fn unload_utf8(text string) {
    C.UnloadUTF8(text.str)
}

// todo
fn C.LoadCodepoints(text &char, count &int) &int
@[inline]
pub fn load_codepoints(text string, count &int) &int {
	return C.LoadCodepoints(text.str, count)
}

fn C.UnloadCodepoints(codepoints &int)
@[inline]
pub fn unload_codepoints(codepoints &int) {
	C.UnloadCodepoints(codepoints)
}

fn C.GetCodepointCount(text &char) int
@[inline]
pub fn get_codepoint_count(text &char) int {
	return C.GetCodepointCount(text)
}

fn C.GetCodepoint(text &char, codepoint_size &int) int
@[inline]
pub fn get_codepoint(text &char, codepoint_size &int) int {
	return C.GetCodepoint(text, codepoint_size)
}

fn C.GetCodepointNext(text &char, codepoint_size &int) int
@[inline]
pub fn get_codepoint_next(text &char, codepoint_size &int) int {
    return C.GetCodepointNext(text, codepoint_size)
}

fn C.GetCodepointPrevious(text &char, codepoint_size &int) int
@[inline]
pub fn get_codepoint_previous(text &char, codepoint_size &int) int {
    return C.GetCodepointPrevious(text, codepoint_size)
}

fn C.CodepointToUTF8(codepoint int, utf8_size &int) &i8
@[inline]
pub fn codepoint_to_utf_8(codepoint int, utf8_size &int) &i8 {
	return C.CodepointToUTF8(codepoint, utf8_size)
}

fn C.TextCopy(dst &char, src &char) int
@[inline]
pub fn text_copy(dst &char, src &char) int {
	return C.TextCopy(dst, src)
}

fn C.TextIsEqual(text1 &char, text2 &char) bool
@[inline]
pub fn text_is_equal(text1 string, text2 string) bool {
	return C.TextIsEqual(text1.str, text2.str)
}
// Text formatting with variables (sprintf() style)
// Dont know how to franslate this to VLANG.
fn C.TextFormat(text &char, args ...C.va_list) &char
@[inline]
pub fn text_format(text string, args ...C.va_list) &char {
    return C.TextFormat(text.str, ...args)
}

fn C.TextLength(text &char) u32
@[inline]
pub fn text_length(text &char) u32 {
	return C.TextLength(text)
}

fn C.TextSubtext(text &char, position int, length int) &char
@[inline]
pub fn text_subtext(text string, position int, length int) string {
	return unsafe { cstring_to_vstring(C.TextSubtext(text.str, position, length)) }
}

fn C.TextReplace(text &char, replace &char, by &char) &char
@[inline]
pub fn text_replace(text string, replace string, by string) string {
	return unsafe { cstring_to_vstring(C.TextReplace(text.str, replace.str, by.str)) }
}

fn C.TextInsert(text &char, insert &char, position int) &char
@[inline]
pub fn text_insert(text string, insert string, position int) string {
	return unsafe { cstring_to_vstring(C.TextInsert(text.str, insert.str, position)) }
}

fn C.TextJoin(text_list &&char, count int, delimiter &char) &char
@[inline]
pub fn text_join(text_list &&char, count int, delimiter &char) &char {
	return C.TextJoin(text_list, count, delimiter)
}

fn C.TextSplit(text &i8, delimiter i8, count &int) &&i8
@[inline]
pub fn text_split(text &i8, delimiter i8, count &int) &&i8 {
	return C.TextSplit(text, delimiter, count)
}

fn C.TextAppend(text &i8, append &i8, position &int)
@[inline]
pub fn text_append(text &i8, append &i8, position &int) {
	C.TextAppend(text, append, position)
}

fn C.TextFindIndex(text &i8, find &i8) int
@[inline]
pub fn text_find_index(text &i8, find &i8) int {
	return C.TextFindIndex(text, find)
}

fn C.TextToUpper(text &i8) &i8
@[inline]
pub fn text_to_upper(text &i8) &i8 {
	return C.TextToUpper(text)
}

fn C.TextToLower(text &i8) &i8
@[inline]
pub fn text_to_lower(text &i8) &i8 {
	return C.TextToLower(text)
}

fn C.TextToPascal(text &i8) &i8
@[inline]
pub fn text_to_pascal(text &i8) &i8 {
	return C.TextToPascal(text)
}

fn C.TextToInteger(text &i8) int
@[inline]
pub fn text_to_integer(text &i8) int {
	return C.TextToInteger(text)
}


/******************************************
*                                         *
*             DRAW SHAPES                 *
*                                         *
******************************************/

// Basic shapes drawing functions
fn C.DrawLine3D(start_pos Vector3, end_pos Vector3, color Color)
@[inline]
pub fn draw_line_3d(start_pos Vector3, end_pos Vector3, color Color) {
	C.DrawLine3D(start_pos, end_pos, color)
}

fn C.DrawPoint3D(position Vector3, color Color)
@[inline]
pub fn draw_point_3d(position Vector3, color Color) {
	C.DrawPoint3D(position, color)
}

fn C.DrawCircle3D(center Vector3, radius f32, rotation_axis Vector3, rotation_angle f32, color Color)
@[inline]
pub fn draw_circle_3d(center Vector3, radius f32, rotation_axis Vector3, rotation_angle f32, color Color) {
	C.DrawCircle3D(center, radius, rotation_axis, rotation_angle, color)
}

fn C.DrawTriangle3D(v1 Vector3, v2 Vector3, v3 Vector3, color Color)
@[inline]
pub fn draw_triangle_3d(v1 Vector3, v2 Vector3, v3 Vector3, color Color) {
	C.DrawTriangle3D(v1, v2, v3, color)
}

fn C.DrawTriangleStrip3D(points &Vector3, point_count int, color Color)
@[inline]
pub fn draw_triangle_strip_3d(points &Vector3, point_count int, color Color) {
	C.DrawTriangleStrip3D(points, point_count, color)
}

fn C.DrawCube(position Vector3, width f32, height f32, length f32, color Color)
@[inline]
pub fn draw_cube(position Vector3, width f32, height f32, length f32, color Color) {
	C.DrawCube(position, width, height, length, color)
}

fn C.DrawCubeV(position Vector3, size Vector3, color Color)
@[inline]
pub fn draw_cube_v(position Vector3, size Vector3, color Color) {
	C.DrawCubeV(position, size, color)
}

fn C.DrawCubeWires(position Vector3, width f32, height f32, length f32, color Color)
@[inline]
pub fn draw_cube_wires(position Vector3, width f32, height f32, length f32, color Color) {
	C.DrawCubeWires(position, width, height, length, color)
}

fn C.DrawCubeWiresV(position Vector3, size Vector3, color Color)
@[inline]
pub fn draw_cube_wires_v(position Vector3, size Vector3, color Color) {
	C.DrawCubeWiresV(position, size, color)
}

fn C.DrawSphere(center_pos Vector3, radius f32, color Color)
@[inline]
pub fn draw_sphere(center_pos Vector3, radius f32, color Color) {
	C.DrawSphere(center_pos, radius, color)
}

fn C.DrawSphereEx(center_pos Vector3, radius f32, rings int, slices int, color Color)
@[inline]
pub fn draw_sphere_ex(center_pos Vector3, radius f32, rings int, slices int, color Color) {
	C.DrawSphereEx(center_pos, radius, rings, slices, color)
}

fn C.DrawSphereWires(center_pos Vector3, radius f32, rings int, slices int, color Color)
@[inline]
pub fn draw_sphere_wires(center_pos Vector3, radius f32, rings int, slices int, color Color) {
	C.DrawSphereWires(center_pos, radius, rings, slices, color)
}

fn C.DrawCylinder(position Vector3, radius_top f32, radius_bottom f32, height f32, slices int, color Color)
@[inline]
pub fn draw_cylinder(position Vector3, radius_top f32, radius_bottom f32, height f32, slices int, color Color) {
	C.DrawCylinder(position, radius_top, radius_bottom, height, slices, color)
}

fn C.DrawCylinderEx(start_pos Vector3, end_pos Vector3, start_radius f32, end_radius f32, sides int, color Color)
@[inline]
pub fn draw_cylinder_ex(start_pos Vector3, end_pos Vector3, start_radius f32, end_radius f32, sides int, color Color) {
	C.DrawCylinderEx(start_pos, end_pos, start_radius, end_radius, sides, color)
}

fn C.DrawCylinderWires(position Vector3, radius_top f32, radius_bottom f32, height f32, slices int, color Color)
@[inline]
pub fn draw_cylinder_wires(position Vector3, radius_top f32, radius_bottom f32, height f32, slices int, color Color) {
	C.DrawCylinderWires(position, radius_top, radius_bottom, height, slices, color)
}

fn C.DrawCylinderWiresEx(start_pos Vector3, end_pos Vector3, start_radius f32, end_radius f32, sides int, color Color)
@[inline]
pub fn draw_cylinder_wires_ex(start_pos Vector3, end_pos Vector3, start_radius f32, end_radius f32, sides int, color Color) {
	C.DrawCylinderWiresEx(start_pos, end_pos, start_radius, end_radius, sides, color)
}

fn C.DrawPlane(center_pos Vector3, size Vector2, color Color)
@[inline]
pub fn draw_plane(center_pos Vector3, size Vector2, color Color) {
	C.DrawPlane(center_pos, size, color)
}

fn C.DrawRay(ray Ray, color Color)
@[inline]
pub fn draw_ray(ray Ray, color Color) {
	C.DrawRay(ray, color)
}

fn C.DrawGrid(slices int, spacing f32)
@[inline]
pub fn draw_grid(slices int, spacing f32) {
	C.DrawGrid(slices, spacing)
}








fn C.LoadModel(file_name &char) Model
@[inline]
pub fn load_model(file_name string) Model {
	return C.LoadModel(file_name.str)
}

fn C.LoadModelFromMesh(mesh Mesh) Model
@[inline]
pub fn load_model_from_mesh(mesh Mesh) Model {
	return C.LoadModelFromMesh(mesh)
}

fn C.UnloadModel(model Model)
@[inline]
pub fn unload_model(model Model) {
	C.UnloadModel(model)
}

// fn C.UnloadModelKeepMeshes(model Model)
// @[inline]
// pub fn unload_model_keep_meshes(model Model) {
// 	C.UnloadModelKeepMeshes(model)
// }

fn C.GetModelBoundingBox(model Model) BoundingBox
@[inline]
pub fn get_model_bounding_box(model Model) BoundingBox {
	return C.GetModelBoundingBox(model)
}

fn C.DrawModel(model Model, position Vector3, scale f32, tint Color)
@[inline]
pub fn draw_model(model Model, position Vector3, scale f32, tint Color) {
	C.DrawModel(model, position, scale, tint)
}

fn C.DrawModelEx(model Model, position Vector3, rotation_axis Vector3, rotation_angle f32, scale Vector3, tint Color)
@[inline]
pub fn draw_model_ex(model Model, position Vector3, rotation_axis Vector3, rotation_angle f32, scale Vector3, tint Color) {
	C.DrawModelEx(model, position, rotation_axis, rotation_angle, scale, tint)
}

fn C.DrawModelWires(model Model, position Vector3, scale f32, tint Color)
@[inline]
pub fn draw_model_wires(model Model, position Vector3, scale f32, tint Color) {
	C.DrawModelWires(model, position, scale, tint)
}

fn C.DrawModelWiresEx(model Model, position Vector3, rotation_axis Vector3, rotation_angle f32, scale Vector3, tint Color)
@[inline]
pub fn draw_model_wires_ex(model Model, position Vector3, rotation_axis Vector3, rotation_angle f32, scale Vector3, tint Color) {
	C.DrawModelWiresEx(model, position, rotation_axis, rotation_angle, scale, tint)
}

fn C.DrawBoundingBox(box BoundingBox, color Color)
@[inline]
pub fn draw_bounding_box(box BoundingBox, color Color) {
	C.DrawBoundingBox(box, color)
}

fn C.DrawBillboard(camera Camera, texture Texture, position Vector3, size f32, tint Color)
@[inline]
pub fn draw_billboard(camera Camera, texture Texture, position Vector3, size f32, tint Color) {
	C.DrawBillboard(camera, texture, position, size, tint)
}

fn C.DrawBillboardRec(camera Camera, texture Texture, source Rectangle, position Vector3, size Vector2, tint Color)
@[inline]
pub fn draw_billboard_rec(camera Camera, texture Texture, source Rectangle, position Vector3, size Vector2, tint Color) {
	C.DrawBillboardRec(camera, texture, source, position, size, tint)
}

fn C.DrawBillboardPro(camera Camera, texture Texture, source Rectangle, position Vector3, up Vector3, size Vector2, origin Vector2, rotation f32, tint Color)
@[inline]
pub fn draw_billboard_pro(camera Camera, texture Texture, source Rectangle, position Vector3, up Vector3, size Vector2, origin Vector2, rotation f32, tint Color) {
	C.DrawBillboardPro(camera, texture, source, position, up, size, origin, rotation,
		tint)
}

fn C.UploadMesh(mesh &Mesh, dynamic bool)
@[inline]
pub fn upload_mesh(mesh &Mesh, dynamic bool) {
	C.UploadMesh(mesh, dynamic)
}

fn C.UpdateMeshBuffer(mesh Mesh, index int, data voidptr, data_size int, offset int)
@[inline]
pub fn update_mesh_buffer(mesh Mesh, index int, data voidptr, data_size int, offset int) {
	C.UpdateMeshBuffer(mesh, index, data, data_size, offset)
}

fn C.UnloadMesh(mesh Mesh)
@[inline]
pub fn unload_mesh(mesh Mesh) {
	C.UnloadMesh(mesh)
}

fn C.DrawMesh(mesh Mesh, material Material, transform Matrix)
@[inline]
pub fn draw_mesh(mesh Mesh, material Material, transform Matrix) {
	C.DrawMesh(mesh, material, transform)
}

fn C.DrawMeshInstanced(mesh Mesh, material Material, transforms &Matrix, instances int)
@[inline]
pub fn draw_mesh_instanced(mesh Mesh, material Material, transforms &Matrix, instances int) {
	C.DrawMeshInstanced(mesh, material, transforms, instances)
}

fn C.ExportMesh(mesh Mesh, file_name &char) bool
@[inline]
pub fn export_mesh(mesh Mesh, file_name string) bool {
	return C.ExportMesh(mesh, file_name.str)
}

fn C.GetMeshBoundingBox(mesh Mesh) BoundingBox
@[inline]
pub fn get_mesh_bounding_box(mesh Mesh) BoundingBox {
	return C.GetMeshBoundingBox(mesh)
}

fn C.GenMeshTangents(mesh &Mesh)
@[inline]
pub fn gen_mesh_tangents(mesh &Mesh) {
	C.GenMeshTangents(mesh)
}

fn C.GenMeshPoly(sides int, radius f32) Mesh
@[inline]
pub fn gen_mesh_poly(sides int, radius f32) Mesh {
	return C.GenMeshPoly(sides, radius)
}

fn C.GenMeshPlane(width f32, length f32, resX int, resZ int) Mesh
@[inline]
pub fn gen_mesh_plane(width f32, length f32, resX int, resZ int) Mesh {
	return C.GenMeshPlane(width, length, resX, resZ)
}

fn C.GenMeshCube(width f32, height f32, length f32) Mesh
@[inline]
pub fn gen_mesh_cube(width f32, height f32, length f32) Mesh {
	return C.GenMeshCube(width, height, length)
}

fn C.GenMeshSphere(radius f32, rings int, slices int) Mesh
@[inline]
pub fn gen_mesh_sphere(radius f32, rings int, slices int) Mesh {
	return C.GenMeshSphere(radius, rings, slices)
}

fn C.GenMeshHemiSphere(radius f32, rings int, slices int) Mesh
@[inline]
pub fn gen_mesh_hemi_sphere(radius f32, rings int, slices int) Mesh {
	return C.GenMeshHemiSphere(radius, rings, slices)
}

fn C.GenMeshCylinder(radius f32, height f32, slices int) Mesh
@[inline]
pub fn gen_mesh_cylinder(radius f32, height f32, slices int) Mesh {
	return C.GenMeshCylinder(radius, height, slices)
}

fn C.GenMeshCone(radius f32, height f32, slices int) Mesh
@[inline]
pub fn gen_mesh_cone(radius f32, height f32, slices int) Mesh {
	return C.GenMeshCone(radius, height, slices)
}

fn C.GenMeshTorus(radius f32, size f32, rad_seg int, sides int) Mesh
@[inline]
pub fn gen_mesh_torus(radius f32, size f32, rad_seg int, sides int) Mesh {
	return C.GenMeshTorus(radius, size, rad_seg, sides)
}

fn C.GenMeshKnot(radius f32, size f32, rad_seg int, sides int) Mesh
@[inline]
pub fn gen_mesh_knot(radius f32, size f32, rad_seg int, sides int) Mesh {
	return C.GenMeshKnot(radius, size, rad_seg, sides)
}

fn C.GenMeshHeightmap(heightmap Image, size Vector3) Mesh
@[inline]
pub fn gen_mesh_heightmap(heightmap Image, size Vector3) Mesh {
	return C.GenMeshHeightmap(heightmap, size)
}

fn C.GenMeshCubicmap(cubicmap Image, cube_size Vector3) Mesh
@[inline]
pub fn gen_mesh_cubicmap(cubicmap Image, cube_size Vector3) Mesh {
	return C.GenMeshCubicmap(cubicmap, cube_size)
}

fn C.LoadMaterials(file_name &char, material_count &int) &Material
@[inline]
pub fn load_materials(file_name string, material_count &int) &Material {
	return C.LoadMaterials(file_name.str, material_count)
}

fn C.LoadMaterialDefault() Material
@[inline]
pub fn load_material_default() Material {
	return C.LoadMaterialDefault()
}

fn C.UnloadMaterial(material Material)
@[inline]
pub fn unload_material(material Material) {
	C.UnloadMaterial(material)
}

fn C.SetMaterialTexture(material &Material, map_type int, texture Texture)
@[inline]
pub fn set_material_texture(material &Material, map_type int, texture Texture) {
	C.SetMaterialTexture(material, map_type, texture)
}

fn C.SetModelMeshMaterial(model &Model, meshId int, materialId int)
@[inline]
pub fn set_model_mesh_material(model &Model, meshId int, materialId int) {
	C.SetModelMeshMaterial(model, meshId, materialId)
}

fn C.LoadModelAnimations(file_name &char, anim_count &u32) &ModelAnimation
@[inline]
// pub fn load_model_animations(file_name string, anim_count &u32) &ModelAnimation {
pub fn load_model_animations(file_name string) (&ModelAnimation, u32) {
    anim_count := u32(0)
    model_anims := C.LoadModelAnimations(file_name.str, &anim_count)
    return model_anims, anim_count
}

fn C.UpdateModelAnimation(model Model, anim ModelAnimation, frame int)
@[inline]
pub fn update_model_animation(model Model, anim ModelAnimation, frame int) {
	C.UpdateModelAnimation(model, anim, frame)
}

fn C.UnloadModelAnimation(anim ModelAnimation)
@[inline]
pub fn unload_model_animation(anim ModelAnimation) {
	C.UnloadModelAnimation(anim)
}

fn C.UnloadModelAnimations(animations &ModelAnimation, count u32)
@[inline]
pub fn unload_model_animations(animations &ModelAnimation, count u32) {
	C.UnloadModelAnimations(animations, count)
}

fn C.IsModelAnimationValid(model Model, anim ModelAnimation) bool
@[inline]
pub fn is_model_animation_valid(model Model, anim ModelAnimation) bool {
	return C.IsModelAnimationValid(model, anim)
}

fn C.CheckCollisionSpheres(center1 Vector3, radius1 f32, center2 Vector3, radius2 f32) bool
@[inline]
pub fn check_collision_spheres(center1 Vector3, radius1 f32, center2 Vector3, radius2 f32) bool {
	return C.CheckCollisionSpheres(center1, radius1, center2, radius2)
}

fn C.CheckCollisionBoxes(box1 BoundingBox, box2 BoundingBox) bool
@[inline]
pub fn check_collision_boxes(box1 BoundingBox, box2 BoundingBox) bool {
	return C.CheckCollisionBoxes(box1, box2)
}

fn C.CheckCollisionBoxSphere(box BoundingBox, center Vector3, radius f32) bool
@[inline]
pub fn check_collision_box_sphere(box BoundingBox, center Vector3, radius f32) bool {
	return C.CheckCollisionBoxSphere(box, center, radius)
}

fn C.GetRayCollisionSphere(ray Ray, center Vector3, radius f32) RayCollision
@[inline]
pub fn get_ray_collision_sphere(ray Ray, center Vector3, radius f32) RayCollision {
	return C.GetRayCollisionSphere(ray, center, radius)
}

fn C.GetRayCollisionBox(ray Ray, box BoundingBox) RayCollision
@[inline]
pub fn get_ray_collision_box(ray Ray, box BoundingBox) RayCollision {
	return C.GetRayCollisionBox(ray, box)
}

fn C.GetRayCollisionMesh(ray Ray, mesh Mesh, transform Matrix) RayCollision
@[inline]
pub fn get_ray_collision_mesh(ray Ray, mesh Mesh, transform Matrix) RayCollision {
	return C.GetRayCollisionMesh(ray, mesh, transform)
}

fn C.GetRayCollisionTriangle(ray Ray, p1 Vector3, p2 Vector3, p3 Vector3) RayCollision
@[inline]
pub fn get_ray_collision_triangle(ray Ray, p1 Vector3, p2 Vector3, p3 Vector3) RayCollision {
	return C.GetRayCollisionTriangle(ray, p1, p2, p3)
}

fn C.GetRayCollisionQuad(ray Ray, p1 Vector3, p2 Vector3, p3 Vector3, p4 Vector3) RayCollision
@[inline]
pub fn get_ray_collision_quad(ray Ray, p1 Vector3, p2 Vector3, p3 Vector3, p4 Vector3) RayCollision {
	return C.GetRayCollisionQuad(ray, p1, p2, p3, p4)
}

//----------------------------------------------------------------------------------
// Audio Definition
//----------------------------------------------------------------------------------
fn C.InitAudioDevice()
@[inline]
pub fn init_audio_device() {
	C.InitAudioDevice()
}

fn C.CloseAudioDevice()
@[inline]
pub fn close_audio_device() {
	C.CloseAudioDevice()
}

fn C.IsAudioDeviceReady() bool
@[inline]
pub fn is_audio_device_ready() bool {
	return C.IsAudioDeviceReady()
}

fn C.SetMasterVolume(volume f32)
@[inline]
pub fn set_master_volume(volume f32) {
	C.SetMasterVolume(volume)
}

//------------------------------------------------------------------------------------
// Audio Loading and Playing Functions (Module: audio)
//------------------------------------------------------------------------------------

// Wave/Sound loading/unloading functions
fn C.LoadWave(file_name &char) Wave
@[inline]
pub fn load_wave(file_name string) Wave {
	return C.LoadWave(file_name.str)
}

fn C.LoadWaveFromMemory(file_type &i8, file_data &i8, data_size int) Wave
@[inline]
pub fn load_wave_from_memory(file_type &i8, file_data &i8, data_size int) Wave {
	return C.LoadWaveFromMemory(file_type, file_data, data_size)
}

fn C.LoadSound(file_name &char) Sound
@[inline]
pub fn load_sound(file_name string) Sound {
	return C.LoadSound(file_name.str)
}

fn C.LoadSoundFromWave(wave Wave) Sound
@[inline]
pub fn load_sound_from_wave(wave Wave) Sound {
	return C.LoadSoundFromWave(wave)
}

fn C.LoadSoundAlias(source Sound) Sound // Create a new sound that shares the same sample data as the source sound, does not own the sound data
@[inline]
pub fn load_sound_alias(source Sound) Sound {
    return C.LoadSoundAlias(source)
}

fn C.UnloadSoundAlias(alias Sound)      // Unload a sound alias (does not deallocate sample data)
@[inline]
pub fn unload_sound_alias(alias Sound) {
    C.UnloadSoundAlias(alias)
}

                                                    
fn C.UpdateSound(sound Sound, data voidptr, sample_count int)
@[inline]
pub fn update_sound(sound Sound, data voidptr, sample_count int) {
	C.UpdateSound(sound, data, sample_count)
}

fn C.UnloadWave(wave Wave)
@[inline]
pub fn unload_wave(wave Wave) {
	C.UnloadWave(wave)
}

fn C.UnloadSound(sound Sound)
@[inline]
pub fn unload_sound(sound Sound) {
	C.UnloadSound(sound)
}

fn C.ExportWave(wave Wave, file_name &char) bool
@[inline]
pub fn export_wave(wave Wave, file_name string) bool {
	return C.ExportWave(wave, file_name.str)
}

fn C.ExportWaveAsCode(wave Wave, file_name &char) bool
@[inline]
pub fn export_wave_as_code(wave Wave, file_name string) bool {
	return C.ExportWaveAsCode(wave, file_name.str)
}

fn C.PlaySound(sound Sound)
@[inline]
pub fn play_sound(sound Sound) {
	C.PlaySound(sound)
}

fn C.StopSound(sound Sound)
@[inline]
pub fn stop_sound(sound Sound) {
	C.StopSound(sound)
}

fn C.PauseSound(sound Sound)
@[inline]
pub fn pause_sound(sound Sound) {
	C.PauseSound(sound)
}

fn C.ResumeSound(sound Sound)
@[inline]
pub fn resume_sound(sound Sound) {
	C.ResumeSound(sound)
}

// fn C.PlaySoundMulti(sound Sound)
// @[inline]
// pub fn play_sound_multi(sound Sound) {
// 	C.PlaySoundMulti(sound)

// fn C.StopSoundMulti()
// @[inline]
// pub fn stop_sound_multi() {
// 	C.StopSoundMulti()
// }

// fn C.GetSoundsPlaying() int
// @[inline]
// pub fn get_sounds_playing() int {
// 	return C.GetSoundsPlaying()
// }

fn C.IsSoundPlaying(sound Sound) bool
@[inline]
pub fn is_sound_playing(sound Sound) bool {
	return C.IsSoundPlaying(sound)
}

fn C.SetSoundVolume(sound Sound, volume f32)
@[inline]
pub fn set_sound_volume(sound Sound, volume f32) {
	C.SetSoundVolume(sound, volume)
}

fn C.SetSoundPitch(sound Sound, pitch f32)
@[inline]
pub fn set_sound_pitch(sound Sound, pitch f32) {
	C.SetSoundPitch(sound, pitch)
}

fn C.SetSoundPan(sound Sound, pan f32)
@[inline]
pub fn set_sound_pan(sound Sound, pan f32) {
	C.SetSoundPan(sound, pan)
}

fn C.WaveCopy(wave Wave) Wave
@[inline]
pub fn wave_copy(wave Wave) Wave {
	return C.WaveCopy(wave)
}

fn C.WaveCrop(wave &Wave, init_sample int, final_sample int)
@[inline]
pub fn wave_crop(wave &Wave, init_sample int, final_sample int) {
	C.WaveCrop(wave, init_sample, final_sample)
}

fn C.WaveFormat(wave &Wave, sample_rate int, sample_size int, channels int)
@[inline]
pub fn wave_format(wave &Wave, sample_rate int, sample_size int, channels int) {
	C.WaveFormat(wave, sample_rate, sample_size, channels)
}

fn C.LoadWaveSamples(wave Wave) &f32
@[inline]
pub fn load_wave_samples(wave Wave) &f32 {
	return C.LoadWaveSamples(wave)
}

fn C.UnloadWaveSamples(samples &f32)
@[inline]
pub fn unload_wave_samples(samples &f32) {
	C.UnloadWaveSamples(samples)
}

fn C.LoadMusicStream(file_name &char) Music
@[inline]
pub fn load_music_stream(file_name string) Music {
	return C.LoadMusicStream(file_name.str)
}

fn C.LoadMusicStreamFromMemory(file_type &i8, data &u8, data_size int) Music
@[inline]
pub fn load_music_stream_from_memory(file_type &i8, data &u8, data_size int) Music {
	return C.LoadMusicStreamFromMemory(file_type, data, data_size)
}

fn C.UnloadMusicStream(music Music)
@[inline]
pub fn unload_music_stream(music Music) {
	C.UnloadMusicStream(music)
}

fn C.PlayMusicStream(music Music)
@[inline]
pub fn play_music_stream(music Music) {
	C.PlayMusicStream(music)
}

fn C.IsMusicStreamPlaying(music Music) bool
@[inline]
pub fn is_music_stream_playing(music Music) bool {
	return C.IsMusicStreamPlaying(music)
}

fn C.UpdateMusicStream(music Music)
@[inline]
pub fn update_music_stream(music Music) {
	C.UpdateMusicStream(music)
}

fn C.StopMusicStream(music Music)
@[inline]
pub fn stop_music_stream(music Music) {
	C.StopMusicStream(music)
}

fn C.PauseMusicStream(music Music)
@[inline]
pub fn pause_music_stream(music Music) {
	C.PauseMusicStream(music)
}

fn C.ResumeMusicStream(music Music)
@[inline]
pub fn resume_music_stream(music Music) {
	C.ResumeMusicStream(music)
}

fn C.SeekMusicStream(music Music, position f32)
@[inline]
pub fn seek_music_stream(music Music, position f32) {
	C.SeekMusicStream(music, position)
}

fn C.SetMusicVolume(music Music, volume f32)
@[inline]
pub fn set_music_volume(music Music, volume f32) {
	C.SetMusicVolume(music, volume)
}

fn C.SetMusicPitch(music Music, pitch f32)
@[inline]
pub fn set_music_pitch(music Music, pitch f32) {
	C.SetMusicPitch(music, pitch)
}

fn C.SetMusicPan(music Music, pan f32)
@[inline]
pub fn set_music_pan(music Music, pan f32) {
	C.SetMusicPan(music, pan)
}

fn C.GetMusicTimeLength(music Music) f32
@[inline]
pub fn get_music_time_length(music Music) f32 {
	return C.GetMusicTimeLength(music)
}

fn C.GetMusicTimePlayed(music Music) f32
@[inline]
pub fn get_music_time_played(music Music) f32 {
	return C.GetMusicTimePlayed(music)
}

fn C.LoadAudioStream(sample_rate u32, sample_size u32, channels u32) AudioStream
@[inline]
pub fn load_audio_stream(sample_rate u32, sample_size u32, channels u32) AudioStream {
	return C.LoadAudioStream(sample_rate, sample_size, channels)
}

fn C.UnloadAudioStream(stream AudioStream)
@[inline]
pub fn unload_audio_stream(stream AudioStream) {
	C.UnloadAudioStream(stream)
}

fn C.UpdateAudioStream(stream AudioStream, data voidptr, frame_count int)
@[inline]
pub fn update_audio_stream(stream AudioStream, data voidptr, frame_count int) {
	C.UpdateAudioStream(stream, data, frame_count)
}

fn C.IsAudioStreamProcessed(stream AudioStream) bool
@[inline]
pub fn is_audio_stream_processed(stream AudioStream) bool {
	return C.IsAudioStreamProcessed(stream)
}

fn C.PlayAudioStream(stream AudioStream)
@[inline]
pub fn play_audio_stream(stream AudioStream) {
	C.PlayAudioStream(stream)
}

fn C.PauseAudioStream(stream AudioStream)
@[inline]
pub fn pause_audio_stream(stream AudioStream) {
	C.PauseAudioStream(stream)
}

fn C.ResumeAudioStream(stream AudioStream)
@[inline]
pub fn resume_audio_stream(stream AudioStream) {
	C.ResumeAudioStream(stream)
}

fn C.IsAudioStreamPlaying(stream AudioStream) bool
@[inline]
pub fn is_audio_stream_playing(stream AudioStream) bool {
	return C.IsAudioStreamPlaying(stream)
}

fn C.StopAudioStream(stream AudioStream)
@[inline]
pub fn stop_audio_stream(stream AudioStream) {
	C.StopAudioStream(stream)
}

fn C.SetAudioStreamVolume(stream AudioStream, volume f32)
@[inline]
pub fn set_audio_stream_volume(stream AudioStream, volume f32) {
	C.SetAudioStreamVolume(stream, volume)
}

fn C.SetAudioStreamPitch(stream AudioStream, pitch f32)
@[inline]
pub fn set_audio_stream_pitch(stream AudioStream, pitch f32) {
	C.SetAudioStreamPitch(stream, pitch)
}

fn C.SetAudioStreamPan(stream AudioStream, pan f32)
@[inline]
pub fn set_audio_stream_pan(stream AudioStream, pan f32) {
	C.SetAudioStreamPan(stream, pan)
}

fn C.SetAudioStreamBufferSizeDefault(size int)
@[inline]
pub fn set_audio_stream_buffer_size_default(size int) {
	C.SetAudioStreamBufferSizeDefault(size)
}

fn C.SetAudioStreamCallback(stream AudioStream, callback voidptr)
@[inline]
pub fn set_audio_stream_callback(stream AudioStream, callback voidptr) {
	C.SetAudioStreamCallback(stream, callback)
}

pub type AudioCallback = fn (buffer voidptr, frames u32)
// typedef void (*AudioCallback)(void *bufferData, unsigned int frames);

fn C.AttachAudioStreamProcessor(stream AudioStream, processor AudioCallback) // Attach audio stream processor to stream, receives the samples as 'float'
pub fn attach_audio_stream_processor(stream AudioStream, processor AudioCallback) {
    C.AttachAudioStreamProcessor(stream, processor)
}
                                                    
fn C.DetachAudioStreamProcessor(stream AudioStream, processor AudioCallback) // Detach audio stream processor from stream
pub fn detach_audio_stream_processor(stream AudioStream, processor AudioCallback) {
    C.DetachAudioStreamProcessor(stream, processor)
}

fn C.AttachAudioMixedProcessor(processor AudioCallback)                      // Attach audio stream processor to the entire audio pipeline, receives the samples as 'float'
pub fn attach_audio_mixed_processor(processor AudioCallback) {
    C.AttachAudioMixedProcessor(processor)
}
                                                    
fn C.DetachAudioMixedProcessor(processor AudioCallback)                      // Detach audio stream processor from the entire audio pipeline
pub fn detach_audio_mixed_processor(processor AudioCallback) {
    C.DetachAudioMixedProcessor(processor)
}
                                                    

// end functions




// // Automation events functionality
fn C.LoadAutomationEventList(file_name &char) C.AutomationEventList               // Load automation events list from file, NULL for empty list, capacity = MAX_AUTOMATION_EVENTS
@[inline]
pub fn load_automation_event_list(file_name string) C.AutomationEventList {
    return C.LoadAutomationEventList(file_name.str)
}
    
fn C.UnloadAutomationEventList(list C.AutomationEventList)                        // Unload automation events list from file
@[inline]
pub fn unload_automation_event_list(list C.AutomationEventList) {
    C.UnloadAutomationEventList(list)
}

fn C.ExportAutomationEventList(list C.AutomationEventList, file_name &char) bool    // Export automation events list as text file
@[inline]
pub fn export_automation_event_list(list C.AutomationEventList, file_name string) bool {
    return C.ExportAutomationEventList(list, file_name.str)
}

fn C.SetAutomationEventList(list &C.AutomationEventList)                           // Set automation event list to record to
@[inline]
pub fn set_automation_event_list(list &C.AutomationEventList) {
    C.SetAutomationEventList(list)
}

fn C.SetAutomationEventBaseFrame(frame int)                                      // Set automation event internal base frame to start recording
@[inline]
pub fn set_automation_event_base_frame(frame int) {
    C.SetAutomationEventBaseFrame(frame)
}

fn C.StartAutomationEventRecording()                                         // Start recording automation events (AutomationEventList must be set)
@[inline]
pub fn start_automation_event_recording() {
    C.StartAutomationEventRecording()
}

fn C.StopAutomationEventRecording()                                          // Stop recording automation events
@[inline]
pub fn stop_automation_event_recording() {
    C.StopAutomationEventRecording()
}

fn C.PlayAutomationEvent(event C.AutomationEvent)                                  // Play a recorded automation event
@[inline]
pub fn play_automation_event(event C.AutomationEvent) {
    C.PlayAutomationEvent(event)
}



// fn C.LoadVrStereoConfig(device VrDeviceInfo) VrStereoConfig
// @[inline]
// pub fn load_vr_stereo_config(device VrDeviceInfo) VrStereoConfig {
// 	return C.LoadVrStereoConfig(device)
// }

// fn C.UnloadVrStereoConfig(config VrStereoConfig)
// @[inline]
// pub fn unload_vr_stereo_config(config VrStereoConfig) {
// 	C.UnloadVrStereoConfig(config)
// }
