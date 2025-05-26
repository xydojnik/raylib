module raylib


// Texture parameters: filter mode
// NOTE 1: Filtering considers mipmaps if available in the texture
// NOTE 2: Filter is accordingly set for minification and magnification
pub const texture_filter_point           = C.TEXTURE_FILTER_POINT           // No filter, just pixel approximation
pub const texture_filter_bilinear        = C.TEXTURE_FILTER_BILINEAR        // Linear filtering
pub const texture_filter_trilinear       = C.TEXTURE_FILTER_TRILINEAR       // Trilinear filtering (linear with mipmaps)
pub const texture_filter_anisotropic_4x  = C.TEXTURE_FILTER_ANISOTROPIC_4X  // Anisotropic filtering 4x
pub const texture_filter_anisotropic_8x  = C.TEXTURE_FILTER_ANISOTROPIC_8X  // Anisotropic filtering 8x
pub const texture_filter_anisotropic_16x = C.TEXTURE_FILTER_ANISOTROPIC_16X // Anisotropic filtering 16x


// Texture parameters: wrap mode
pub const texture_wrap_repeat        = C.TEXTURE_WRAP_REPEAT        // Repeats texture in tiled mode
pub const texture_wrap_clamp         = C.TEXTURE_WRAP_CLAMP         // Clamps texture to edge pixel in tiled mode
pub const texture_wrap_mirror_repeat = C.TEXTURE_WRAP_MIRROR_REPEAT // Mirrors and repeats the texture in tiled mode
pub const texture_wrap_mirror_clamp  = C.TEXTURE_WRAP_MIRROR_CLAMP  // Mirrors and clamps to border the texture in tiled mode

// Cubemap layouts
pub const cubemap_layout_auto_detect         = C.CUBEMAP_LAYOUT_AUTO_DETECT         // Automatically detect layout type
pub const cubemap_layout_line_vertical       = C.CUBEMAP_LAYOUT_LINE_VERTICAL       // Layout is defined by a vertical line with faces
pub const cubemap_layout_line_horizontal     = C.CUBEMAP_LAYOUT_LINE_HORIZONTAL     // Layout is defined by a horizontal line with faces
pub const cubemap_layout_cross_three_by_four = C.CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR // Layout is defined by a 3x4 cross with cubemap faces
pub const cubemap_layout_cross_four_by_three = C.CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE // Layout is defined by a 4x3 cross with cubemap faces




// Texture, tex data stored in GPU memory (VRAM)
@[typedef]
struct C.Texture {
pub mut:
	id      u32     // OpenGL texture id
	width   int     // Texture base width
	height  int     // Texture base height
	mipmaps int     // Mipmap levels, 1 by default
	format  int     // Data format (PixelFormat type)
}

pub type Texture   = C.Texture
pub type Texture2D = C.Texture // What is a point of Texture2D?



// Texture functions
@[inline]
pub fn Texture.load(file_name string) Texture {
	return C.LoadTexture(file_name.str)
}

@[inline]
pub fn Texture.load_from_image(img Image) Texture {
	return C.LoadTextureFromImage(img)
}

@[inline]
pub fn Texture.to_image(t Texture) Image {
	return C.LoadImageFromTexture(t)
}

@[inline]
pub fn Texture.get_default() Texture {
    return Texture {
        id:      rl_get_texture_id_default()
        width:   1
        height:  1
        mipmaps: 1
    }
}

@[inline]                                                    
pub fn Texture.is_valid(t Texture, ) bool {
    return C.IsTextureValid(t)
}

@[inline]
pub fn Texture.update(t Texture, pixels voidptr) {
	C.UpdateTexture(t, pixels)
}

@[inline]
pub fn Texture.update_rec(t Texture, rec Rectangle, pixels voidptr) {
	C.UpdateTextureRec(t, rec, pixels)
}

@[inline]
pub fn Texture.gen_mipmaps(t &Texture) {
	C.GenTextureMipmaps(t)
}

@[inline]
pub fn Texture.set_filter(t Texture, filter int) {
	C.SetTextureFilter(t, filter)
}

@[inline]
pub fn Texture.set_wrap(t Texture, wrap int) {
	C.SetTextureWrap(t, wrap)
}

@[inline]
pub fn Texture.draw(t Texture, pos_x int, pos_y int, tint Color) {
	C.DrawTexture(t, pos_x, pos_y, tint)
}

@[inline]
pub fn Texture.draw_v(t Texture, position Vector2, tint Color) {
	C.DrawTextureV(t, position, tint)
}

@[inline]
pub fn Texture.draw_ex(t Texture, position Vector2, rotation f32, scale f32, tint Color) {
	C.DrawTextureEx(t, position, rotation, scale, tint)
}

@[inline]
pub fn Texture.draw_rec(t Texture, source Rectangle, position Vector2, tint Color) {
	C.DrawTextureRec(t, source, position, tint)
}

@[inline]
pub fn Texture.draw_pro(t Texture, source Rectangle, dest Rectangle, origin Vector2, rotation f32, tint Color) {
	C.DrawTexturePro(t, source, dest, origin, rotation, tint)
}

@[inline]
pub fn Texture.draw_npatch(t Texture,npatch_info NPatchInfo, dest Rectangle, origin Vector2, rotation f32, tint Color) {
	C.DrawTextureNPatch(t, npatch_info, dest, origin, rotation, tint)
}

@[inline]
pub fn Texture.unload(t Texture) {
	C.UnloadTexture(t)
}




// Struct methods
pub fn (t Texture) set_slot(slot int) {
    rl_active_texture_slot(slot)
    rl_enable_texture(t.id)
}

@[inline]
pub fn (t Texture) to_image() Image {
	return C.LoadImageFromTexture(t)
}

@[inline]                                                    
pub fn (t Texture) is_valid() bool {
    return C.IsTextureValid(t)
}

@[inline]
pub fn (t Texture) update(pixels voidptr) {
	C.UpdateTexture(t, pixels)
}

@[inline]
pub fn (t Texture) update_rec(rec Rectangle, pixels voidptr) {
	C.UpdateTextureRec(t, rec, pixels)
}

@[inline]
pub fn (t &Texture) gen_mipmaps() {
	C.GenTextureMipmaps(t)
}

@[inline]
pub fn (t Texture) set_filter(filter int) {
	C.SetTextureFilter(t, filter)
}

@[inline]
pub fn (t Texture) set_wrap(wrap int) {
	C.SetTextureWrap(t, wrap)
}

@[inline]
pub fn (t Texture) draw(pos_x int, pos_y int, tint Color) {
	C.DrawTexture(t, pos_x, pos_y, tint)
}

@[inline]
pub fn (t Texture) draw_v(position Vector2, tint Color) {
	C.DrawTextureV(t, position, tint)
}

@[inline]
pub fn (t Texture) draw_ex(position Vector2, rotation f32, scale f32, tint Color) {
	C.DrawTextureEx(t, position, rotation, scale, tint)
}

@[inline]
pub fn (t Texture) draw_rec(source Rectangle, position Vector2, tint Color) {
	C.DrawTextureRec(t, source, position, tint)
}

@[inline]
pub fn (t Texture) draw_pro(source Rectangle, dest Rectangle, origin Vector2, rotation f32, tint Color) {
	C.DrawTexturePro(t, source, dest, origin, rotation, tint)
}

@[inline]
pub fn (t Texture) draw_npatch(npatch_info NPatchInfo, dest Rectangle, origin Vector2, rotation f32, tint Color) {
	C.DrawTextureNPatch(t, npatch_info, dest, origin, rotation, tint)
}

@[inline]
pub fn (t Texture) unload() { C.UnloadTexture(t) }
// Texture functions



// TextureCubemap functions

pub type TextureCubemap  = C.Texture

@[inline]
pub fn TextureCubemap.load(image Image, layout int) TextureCubemap {
	return C.LoadTextureCubemap(image, layout)
}


@[typedef]
struct C.RenderTexture {
pub mut:
	id      u32         // OpenGL framebuffer object id
	texture Texture     // Color buffer attachment texture
	depth   Texture     // Depth buffer attachment texture
}

pub type RenderTexture   = C.RenderTexture
pub type RenderTexture2D = C.RenderTexture

@[inline]
pub fn RenderTexture.load(width int, height int) RenderTexture {
	return C.LoadRenderTexture(width, height)
}

@[inline]
pub fn (rt RenderTexture) unload() {
	C.UnloadRenderTexture(rt)
}

@[inline]
pub fn (rt RenderTexture) begin() {
	C.BeginTextureMode(rt)
}

@[inline] pub fn RenderTexture.end()      { C.EndTextureMode() }
@[inline] pub fn (rt RenderTexture) end() { C.EndTextureMode() }
