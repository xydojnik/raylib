module raylib


// Some Basic Colors;
// NOTE: Custom raylib color palette for amazing visuals on WHITE background
pub const lightgray  = Color { 200, 200, 200, 255 }    // Light Gray
pub const gray       = Color { 130, 130, 130, 255 }    // Gray;
pub const darkgray   = Color { 80,  80,  80,  255 }    // Dark Gray
pub const yellow     = Color { 253, 249, 0,   255 }    // Yellow
pub const gold       = Color { 255, 203, 0,   255 }    // Gold
pub const orange     = Color { 255, 161, 0,   255 }    // Orange
pub const pink       = Color { 255, 109, 194, 255 }    // Pink
pub const red        = Color { 230, 41,  55,  255 }    // Red
pub const maroon     = Color { 190, 33,  55,  255 }    // Maroon
pub const green      = Color { 0,   228, 48,  255 }    // Green
pub const lime       = Color { 0,   158, 47,  255 }    // Lime
pub const darkgreen  = Color { 0,   117, 44,  255 }    // Dark Green
pub const skyblue    = Color { 102, 191, 255, 255 }    // Sky Blue
pub const blue       = Color { 0,   121, 241, 255 }    // Blue
pub const darkblue   = Color { 0,   82,  172, 255 }    // Dark Blue
pub const purple     = Color { 200, 122, 255, 255 }    // Purple
pub const violet     = Color { 135, 60,  190, 255 }    // Violet
pub const darkpurple = Color { 112, 31,  126, 255 }    // Dark Purpl
pub const beige      = Color { 211, 176, 131, 255 }    // Beige
pub const brown      = Color { 127, 106, 79,  255 }    // Brown
pub const darkbrown  = Color { 76 , 63 , 47,  255 }    // Dark Brown
pub const white      = Color { 255, 255, 255, 255 }    // White
pub const black      = Color { 0,   0,   0,   255 }    // Black
pub const blank      = Color { 0,   0,   0,   0   }    // Blank (Transparent)
pub const magenta    = Color { 255, 0,   255, 255 }    // Magenta
pub const raywhite   = Color { 245, 245, 245, 255 }    // My own White (raylib logo)
                                                    


// Color, 4 components, R8G8B8A8 (32bit)
@[typedef]
struct C.Color {
pub mut:
	r u8        // Color red   value
	g u8        // Color green value
	b u8        // Color blue  value
	a u8        // Color alpha value
}
pub type Color = C.Color


pub fn (color Color) to_vec4() Vector4 {
    vec := Vector4 {
        f32(color.r),
        f32(color.g), 
        f32(color.b),
        f32(color.a)
    }
    return vec
}

fn C.Fade(color Color, alpha f32) Color
@[inline]
pub fn Color.fade(color Color, alpha f32) Color {
	return C.Fade(color, alpha)
}

fn C.ColorLerp(c1 Color,  c2 Color, lerp f32) Color
@[inline]
pub fn Color.lerp(c1 Color,  c2 Color, lerp f32) Color {
	return C.ColorLerp(c1, c2, lerp)
}

fn C.ColorToInt(color Color) int
@[inline]
pub fn Color.to_int(color Color) int {
	return C.ColorToInt(color)
}

fn C.ColorNormalize(color Color) Vector4
@[inline]
pub fn Color.normalize(color Color) Vector4 {
	return C.ColorNormalize(color)
}

fn C.ColorFromNormalized(normalized Vector4) Color
@[inline]
pub fn Color.from_normalized(normalized Vector4) Color {
	return C.ColorFromNormalized(normalized)
}

fn C.ColorToHSV(color Color) Vector3
@[inline]
pub fn Color.to_hsv(color Color) Vector3 {
	return C.ColorToHSV(color)
}

fn C.ColorFromHSV(hue f32, saturation f32, value f32) Color
@[inline]
pub fn Color.from_hsv(hue f32, saturation f32, value f32) Color {
	return C.ColorFromHSV(hue, saturation, value)
}

fn C.ColorAlpha(color Color, alpha f32) Color
@[inline]
pub fn Color.alpha(color Color, alpha f32) Color {
	return C.ColorAlpha(color, alpha)
}

fn C.ColorAlphaBlend(dst Color, src Color, tint Color) Color
@[inline]
pub fn Color.alpha_blend(dst Color, src Color, tint Color) Color {
	return C.ColorAlphaBlend(dst, src, tint)
}

fn C.GetColor(hex_value u32) Color
@[inline]
pub fn Color.get(hex_value u32) Color {
	return C.GetColor(hex_value)
}



// Using v like methods.
@[inline]
pub fn (c Color) fade(alpha f32) Color {
    return C.Fade(c, alpha)
}

@[inline]
pub fn (c Color) lerp(c1 Color, lerp f32) Color {
    return C.ColorLerp(c, c1, lerp)
}

@[inline]
pub fn (c Color) to_int() int {
	return C.ColorToInt(c)
}

@[inline]
pub fn (c Color) normalize() Vector4 {
	return C.ColorNormalize(c)
}

@[inline]
pub fn (c Color) to_hsv() Vector3 {
	return C.ColorToHSV(c)
}

@[inline]
pub fn (c Color) alpha(alpha f32) Color {
	return C.ColorAlpha(c, alpha)
}

// @[inline]
// pub fn Color.alpha_blend(dst Color, src Color, tint Color) Color {
// 	return C.ColorAlphaBlend(dst, src, tint)
// }

// Using v like methods.
