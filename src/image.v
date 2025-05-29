module raylib


// Image, pixel data stored in CPU memory (RAM)
@[typedef]
struct C.Image {
pub mut:
	data    voidptr // &u8 // Image raw data
	width   int     // Image base width
	height  int     // Image base height
	mipmaps int     // Mipmap levels, 1 by default
	format  int     // Data format (PixelFormat type)
}
pub type Image = C.Image


// Load
@[inline]
pub fn Image.load(file_name string) Image {
	img := C.LoadImage(file_name.str)
    // if !img.is_valid() {
    //     return error('IMAGE: ERROR Could not load Image: [ ${file_name} ]')
    // }
    return img
}

@[inline]
pub fn Image.load_raw(file_name string, width int, height int, format int, header_size int) Image {
	return C.LoadImageRaw(file_name.str, width, height, format, header_size)
}

pub fn Image.load_anim(file_name string) (Image, int) {
    mut frames := int(0)
	img := C.LoadImageAnim(file_name.str, &frames)
    return img, frames
}

@[inline]
pub fn Image.from_texture(texture Texture) Image {
	return C.LoadImageFromTexture(texture)
}


@[inline]
pub fn Image.load_from_memory(file_type string, file_data []u8) Image {
	return C.LoadImageFromMemory(file_type.str, file_data.data, file_data.len)
}

@[inline]
pub fn Image.load_from_screen() Image {
	return C.LoadImageFromScreen()
}
// Load


@[inline]
pub fn (img Image) unload() {
	C.UnloadImage(img)
}


// Generate Image
@[inline]
pub fn Image.gen_color(width int, height int, color Color) Image {
	return C.GenImageColor(width, height, color)
}

@[inline]
pub fn Image.gen_gradient_linear(width int, height int, direction int, start Color, end Color) Image {
    return C.GenImageGradientLinear(width, height, direction, start, end)
}

@[inline]
pub fn Image.gen_gradient_radial(width int, height int, density f32, inner Color, outer Color) Image {
    return C.GenImageGradientRadial(width, height, density, inner, outer)
}

@[inline]
pub fn Image.gen_gradient_square(width int, height int, density f32, inner Color, outer Color) Image {
    return C.GenImageGradientSquare(width, height, density, inner, outer)
}

@[inline]
pub fn Image.gen_checked(width int, height int, checks_x int, checks_y int, col1 Color, col2 Color) Image {
	return C.GenImageChecked(width, height, checks_x, checks_y, col1, col2)
}

@[inline]
pub fn Image.gen_white_noise(width int, height int, factor f32) Image {
	return C.GenImageWhiteNoise(width, height, factor)
}

@[inline]
pub fn Image.gen_perlin_noise(width int, height int, offset_x int, offset_y int, scale f32) Image {
	return C.GenImagePerlinNoise(width, height, offset_x, offset_y, scale)
}

@[inline]
pub fn Image.gen_cellular(width int, height int, tile_size int) Image {
	return C.GenImageCellular(width, height, tile_size)
}

@[inline]
pub fn Image.gen_text(width int, height int, text string) Image {
    return C.GenImageText(width, height, text.str)
}
// Generate Image


// V like methods.
@[inline]
pub fn (img Image) copy() Image {
	return C.ImageCopy(img)
}

@[inline]
pub fn (img Image) from_image(rec Rectangle) Image {
	return C.ImageFromImage(img, rec)
}

@[inline]
pub fn Image.text(text string, font_size int, color Color) Image {
	return C.ImageText(text.str, font_size, color)
}

@[inline]
pub fn Image.text_ex(font Font, text string, font_size f32, spacing f32, tint Color) Image {
	return C.ImageTextEx(font, text.str, font_size, spacing, tint)
}

@[inline]
pub fn (mut img Image) format(new_format int) {
	C.ImageFormat(img, new_format)
}

@[inline]
pub fn (mut img Image) to_pot(fill Color) {
	C.ImageToPOT(img, fill)
}

@[inline]
pub fn (mut img Image) crop(crop Rectangle) {
	C.ImageCrop(img, crop)
}

@[inline]
pub fn (mut img Image) alpha_crop(threshold f32) {
	C.ImageAlphaCrop(img, threshold)
}

@[inline]
pub fn (mut img Image) alpha_clear(color Color, threshold f32) {
	C.ImageAlphaClear(img, color, threshold)
}

@[inline]
pub fn (mut img Image) alpha_mask(alpha_mask Image) {
	C.ImageAlphaMask(img, alpha_mask)
}

@[inline]
pub fn (mut img Image) alpha_premultiply() {
	C.ImageAlphaPremultiply(img)
}

@[inline]
pub fn (mut img Image) blur_gaussian(blur_size int) {
    C.ImageBlurGaussian(img, blur_size)
}

@[inline]
pub fn (mut img Image) resize(new_width int, new_height int) {
	C.ImageResize(img, new_width, new_height)
}

@[inline]
pub fn (mut img Image) resize_nn(new_width int, new_height int) {
	C.ImageResizeNN(img, new_width, new_height)
}

@[inline]
pub fn (mut img Image) resize_canvas(new_width int, new_height int, offset_x int, offset_y int, fill Color) {
	C.ImageResizeCanvas(img, new_width, new_height, offset_x, offset_y, fill)
}

@[inline]
pub fn (mut img Image) mipmaps() {
	C.ImageMipmaps(img)
}

@[inline]
pub fn (mut img Image) dither(r_bpp int, g_bpp int, b_bpp int, a_bpp int) {
	C.ImageDither(img, r_bpp, g_bpp, b_bpp, a_bpp)
}

@[inline]
pub fn (mut img Image) flip_vertical() {
	C.ImageFlipVertical(img)
}

@[inline]
pub fn (mut img Image) flip_horizontal() {
	C.ImageFlipHorizontal(img)
}

@[inline]
pub fn (mut img Image) rotate(degrees int) {
    C.ImageRotate(img, degrees)
}

@[inline]
pub fn (mut img Image) rotate_cw() {
	C.ImageRotateCW(img)
}

@[inline]
pub fn (mut img Image) rotate_ccw() {
	C.ImageRotateCCW(img)
}

@[inline]
pub fn (mut img Image) color_tint(color Color) {
	C.ImageColorTint(img, color)
}

@[inline]
pub fn (mut img Image) color_invert() {
	C.ImageColorInvert(img)
}

@[inline]
pub fn (mut img Image) color_grayscale() {
	C.ImageColorGrayscale(img)
}

@[inline]
pub fn (mut img Image) color_contrast(contrast f32) {
	C.ImageColorContrast(img, contrast)
}

@[inline]
pub fn (mut img Image) color_brightness(brightness int) {
	C.ImageColorBrightness(img, brightness)
}

@[inline]
pub fn (mut img Image) color_replace(color Color, replace Color) {
	C.ImageColorReplace(img, color, replace)
}

@[inline]
pub fn (img Image) load_colors() &Color {
	return C.LoadImageColors(img)
}

@[inline]
pub fn (img Image) to_texture() Texture {
	return C.LoadTextureFromImage(img) // Load texture from image data
}


// pub fn (img Image) load_palette(max_palette_size int, color_count &int) &Color {
// 	return C.LoadImagePalette(img, max_palette_size, color_count)
// }
@[inline]
pub fn (img Image) load_palette(max_palette_size int) []Color {
    color_count := int(0)
	carr        := C.LoadImagePalette(img, max_palette_size, &color_count)
    return ptr_arr_to_varr[Color](carr, color_count)
}


@[inline]
pub fn (colors []Color) unload_palette() {
	C.UnloadImagePalette(colors.data)
}



@[inline]
pub fn (img Image) get_alpha_border(threshold f32) Rectangle {
	return C.GetImageAlphaBorder(img, threshold)
}

@[inline]
pub fn (img Image) get_color(x int, y int) Color {
	return C.GetImageColor(img, x, y)
}


// Draw Image
@[inline]
pub fn (mut img Image) draw_pixel(pos_x int, pos_y int, color Color) {
	C.ImageDrawPixel(img, pos_x, pos_y, color)
}

@[inline]
pub fn (mut img Image) draw_pixel_v(position Vector2, color Color) {
	C.ImageDrawPixelV(img, position, color)
}

@[inline]
pub fn (mut img Image) draw_line(start_pos_x int, start_pos_y int, end_pos_x int, end_pos_y int, color Color) {
	C.ImageDrawLine(img, start_pos_x, start_pos_y, end_pos_x, end_pos_y, color)
}

@[inline]
pub fn (mut img Image) draw_line_v(start Vector2, end Vector2, color Color) {
	C.ImageDrawLineV(img, start, end, color)
}

@[inline]
pub fn (mut img Image) draw_circle(center_x int, center_y int, radius int, color Color) {
	C.ImageDrawCircle(img, center_x, center_y, radius, color)
}

@[inline]
pub fn (mut img Image) draw_circle_v(center Vector2, radius int, color Color) {
	C.ImageDrawCircleV(img, center, radius, color)
}

@[inline]
pub fn (mut img Image) draw_circle_lines(center_x int, center_y int, radius int, color Color) {
	C.ImageDrawCircleLines(img, center_x, center_y, radius, color)
}

@[inline]
pub fn (mut img Image) draw_circle_lines_v(center Vector2, radius int, color Color) {
	C.ImageDrawCircleLinesV(img, center, radius, color)
}

@[inline]
pub fn (mut img Image) draw_rectangle(pos_x int, pos_y int, width int, height int, color Color) {
	C.ImageDrawRectangle(img, pos_x, pos_y, width, height, color)
}

@[inline]
pub fn (mut img Image) draw_rectangle_v(position Vector2, size Vector2, color Color) {
	C.ImageDrawRectangleV(img, position, size, color)
}

@[inline]
pub fn (mut img Image) draw_rectangle_rec(rec Rectangle, color Color) {
	C.ImageDrawRectangleRec(img, rec, color)
}

@[inline]
pub fn (mut img Image) draw_rectangle_lines(rec Rectangle, thick int, color Color) {
	C.ImageDrawRectangleLines(img, rec, thick, color)
}

@[inline]
pub fn (mut img Image) idraw_triangle(v1 Vector2, v2 Vector2, v3 Vector2, color Color) {
    C.ImageDrawTriangle(img, v1, v2, v3, color)
}
    
@[inline]
pub fn (mut img Image) draw_triangle_ex(v1 Vector2, v2 Vector2, v3 Vector2, c1 Color, c2 Color, c3 Color) {
    C.ImageDrawTriangleEx(img, v1, v2, v3, c1, c2, c3)
}

@[inline]
pub fn (mut img Image) draw_triangle_lines(v1 Vector2, v2 Vector2, v3 Vector2, color Color) {
    C.ImageDrawTriangleLines(img, v1, v2, v3, color)
}

@[inline]
pub fn (mut img Image) draw_triangle_fan(points []Vector2, color Color) {
    C.ImageDrawTriangleFan(img, points.data, points.len, color)
}

@[inline]
pub fn (mut img Image) draw_triangle_strip(points []Vector2, color Color) {
    C.ImageDrawTriangleStrip(img, points.data, points.len, color)
}

@[inline]
pub fn (mut img Image) draw(src Image, src_rec Rectangle, dst_rec Rectangle, tint Color) {
	C.ImageDraw(img, src, src_rec, dst_rec, tint)
}

@[inline]
pub fn (mut img Image) draw_text(text string, pos_x int, pos_y int, font_size int, color Color) {
	C.ImageDrawText(img, text.str, pos_x, pos_y, font_size, color)
}

@[inline]
pub fn (mut img Image) draw_text_ex(font Font, text string, position Vector2, font_size f32, spacing f32, tint Color) {
	C.ImageDrawTextEx(img, font, text.str, position, font_size, spacing, tint)
}

// Draw Image



// Export
@[inline]
pub fn (img Image) export(file_name string) bool {
	return C.ExportImage(img, file_name.str)
}

@[inline]
pub fn (img Image) export_as_code(file_name string) bool {
	return C.ExportImageAsCode(img, file_name.str)
}
// Export

@[inline]
pub fn (img Image) is_valid() bool {
    // return C.IsImageValid(img) // NOT WORKING
    return img.data   != voidptr(0) &&
           img.width  >  0          &&
           img.height >  0
}
