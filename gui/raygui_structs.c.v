module gui


// Style property
// NOTE: Used when exporting style as code for convenience
struct C.GuiStyleProp {
    controlId     u16  // Control identifier
    propertyId    u16  // Property identifier
    propertyValue int  // Property value
}
pub type GuiStyleProp = C.GuiStyleProp


/*
// Controls text style -NOT USED-
// NOTE: Text style is defined by control
struct C.GuiTextStyle {
    u32 size
    int charSpacing
    int lineSpacing
    int alignmentH
    int alignmentV
    int padding
}
pub type GuiTextStyle = C.GuiTextStyle
*/


// Gui control state
// enum C.GuiState as u32 {
//     state_normal   = C.STATE_NORMAL
//     state_focused  = C.STATE_FOCUSED
//     state_pressed  = C.STATE_PRESSED
//     state_disabled = C.STATE_DISABLED
// } 
// pub type GuiState = GuiState


// // Gui control text alignment
// enum C.GuiTextAlignment as u32 {
//     text_align_left   = C.TEXT_ALIGN_LEFT
//     text_align_center = C.TEXT_ALIGN_CENTER
//     text_align_right  = C.TEXT_ALIGN_RIGHT
// } 
// pub type GuiTextAlignment = C.GuiTextAlignment


// // Gui control text alignment vertical
// // NOTE: Text vertical position inside the text bounds
// enum C.GuiTextAlignmentVertical as u32 {
//     text_align_top    = C.TEXT_ALIGN_TOP
//     text_align_middle = C.TEXT_ALIGN_MIDDLE
//     text_align_bottom = C.TEXT_ALIGN_BOTTOM
// } 
// pub type GuiTextAlignmentVertical = C.GuiTextAlignmentVertical


// // Gui control text wrap mode
// // NOTE: Useful for multiline text
// enum C.GuiTextWrapMode as u32 {
//     text_wrap_none = C.TEXT_WRAP_NONE
//     text_wrap_char = C.TEXT_WRAP_CHAR
//     text_wrap_word = C.TEXT_WRAP_WORD
// }
// pub type GuiTextWrapMode = C.GuiTextWrapMode


// // Gui controls
// enum C.GuiControl as u32 {
//     // Default -> populates to all controls when set
//    default     = C.DEFAULT

//    // Basic controls
//    label       = C.LABEL          // Used also for: LABELBUTTON
//    button      = C.BUTTON
//    toggle      = C.TOGGLE         // Used also for: TOGGLEGROUP
//    slider      = C.SLIDER         // Used also for: SLIDERBAR TOGGLESLIDER
//    progressbar = C.PROGRESSBAR
//    checkbox    = C.CHECKBOX
//    combobox    = C.COMBOBOX
//    dropdownbox = C.DROPDOWNBOX
//    textbox     = C.TEXTBOX        // Used also for: TEXTBOXMULTI
//    valuebox    = C.VALUEBOX
//    spinner     = C.SPINNER        // Uses: BUTTON VALUEBOX
//    listview    = C.LISTVIEW
//    colorpicker = C.COLORPICKER
//    scrollbar   = C.SCROLLBAR
//    statusbar   = C.STATUSBAR
// }
// pub type GuiControl = C.GuiControl


// // Gui base properties for every control
// // NOTE: RAYGUI_MAX_PROPS_BASE properties (by default 16 properties)
// typedef enum {
//     BORDER_COLOR_NORMAL = 0,    // Control border color in STATE_NORMAL
//     BASE_COLOR_NORMAL,          // Control base color in STATE_NORMAL
//     TEXT_COLOR_NORMAL,          // Control text color in STATE_NORMAL
//     BORDER_COLOR_FOCUSED,       // Control border color in STATE_FOCUSED
//     BASE_COLOR_FOCUSED,         // Control base color in STATE_FOCUSED
//     TEXT_COLOR_FOCUSED,         // Control text color in STATE_FOCUSED
//     BORDER_COLOR_PRESSED,       // Control border color in STATE_PRESSED
//     BASE_COLOR_PRESSED,         // Control base color in STATE_PRESSED
//     TEXT_COLOR_PRESSED,         // Control text color in STATE_PRESSED
//     BORDER_COLOR_DISABLED,      // Control border color in STATE_DISABLED
//     BASE_COLOR_DISABLED,        // Control base color in STATE_DISABLED
//     TEXT_COLOR_DISABLED,        // Control text color in STATE_DISABLED
//     BORDER_WIDTH,               // Control border size, 0 for no border
//     //TEXT_SIZE,                  // Control text size (glyphs max height) -> GLOBAL for all controls
//     //TEXT_SPACING,               // Control text spacing between glyphs -> GLOBAL for all controls
//     //TEXT_LINE_SPACING           // Control text spacing between lines -> GLOBAL for all controls
//     TEXT_PADDING,               // Control text padding, not considering border
//     TEXT_ALIGNMENT,             // Control text horizontal alignment inside control text bound (after border and padding)
//     //TEXT_WRAP_MODE              // Control text wrap-mode inside text bounds -> GLOBAL for all controls
// } GuiControlProperty

// // TODO: Which text styling properties should be global or per-control?
// // At this moment TEXT_PADDING and TEXT_ALIGNMENT is configured and saved per control while
// // TEXT_SIZE, TEXT_SPACING, TEXT_LINE_SPACING, TEXT_ALIGNMENT_VERTICAL, TEXT_WRAP_MODE are global and
// // should be configured by user as needed while defining the UI layout


// // Gui extended properties depend on control
// // NOTE: RAYGUI_MAX_PROPS_EXTENDED properties (by default, max 8 properties)
// //----------------------------------------------------------------------------------
// // DEFAULT extended properties
// // NOTE: Those properties are common to all controls or global
// // WARNING: We only have 8 slots for those properties by default!!! -> New global control: TEXT?
// typedef enum {
//     TEXT_SIZE = 16,             // Text size (glyphs max height)
//     TEXT_SPACING,               // Text spacing between glyphs
//     LINE_COLOR,                 // Line control color
//     BACKGROUND_COLOR,           // Background color
//     TEXT_LINE_SPACING,          // Text spacing between lines
//     TEXT_ALIGNMENT_VERTICAL,    // Text vertical alignment inside text bounds (after border and padding)
//     TEXT_WRAP_MODE              // Text wrap-mode inside text bounds
//     //TEXT_DECORATION             // Text decoration: 0-None, 1-Underline, 2-Line-through, 3-Overline
//     //TEXT_DECORATION_THICK       // Text decoration line thikness
// } GuiDefaultProperty

// // Other possible text properties:
// // TEXT_WEIGHT                  // Normal, Italic, Bold -> Requires specific font change
// // TEXT_INDENT	                // Text indentation -> Now using TEXT_PADDING...

// // Label
// //typedef enum { } GuiLabelProperty

// // Button/Spinner
// //typedef enum { } GuiButtonProperty

// // Toggle/ToggleGroup
// typedef enum {
//     GROUP_PADDING = 16,         // ToggleGroup separation between toggles
// } GuiToggleProperty

// // Slider/SliderBar
// typedef enum {
//     SLIDER_WIDTH = 16,          // Slider size of internal bar
//     SLIDER_PADDING              // Slider/SliderBar internal bar padding
// } GuiSliderProperty

// // ProgressBar
// typedef enum {
//     PROGRESS_PADDING = 16,      // ProgressBar internal padding
// } GuiProgressBarProperty

// // ScrollBar
// typedef enum {
//     ARROWS_SIZE = 16,           // ScrollBar arrows size
//     ARROWS_VISIBLE,             // ScrollBar arrows visible
//     SCROLL_SLIDER_PADDING,      // ScrollBar slider internal padding
//     SCROLL_SLIDER_SIZE,         // ScrollBar slider size
//     SCROLL_PADDING,             // ScrollBar scroll padding from arrows
//     SCROLL_SPEED,               // ScrollBar scrolling speed
// } GuiScrollBarProperty

// // CheckBox
// typedef enum {
//     CHECK_PADDING = 16          // CheckBox internal check padding
// } GuiCheckBoxProperty

// // ComboBox
// typedef enum {
//     COMBO_BUTTON_WIDTH = 16,    // ComboBox right button width
//     COMBO_BUTTON_SPACING        // ComboBox button separation
// } GuiComboBoxProperty

// // DropdownBox
// typedef enum {
//     ARROW_PADDING = 16,         // DropdownBox arrow separation from border and items
//     DROPDOWN_ITEMS_SPACING      // DropdownBox items separation
// } GuiDropdownBoxProperty

// // TextBox/TextBoxMulti/ValueBox/Spinner
// typedef enum {
//     TEXT_READONLY = 16,         // TextBox in read-only mode: 0-text editable, 1-text no-editable
// } GuiTextBoxProperty

// // Spinner
// typedef enum {
//     SPIN_BUTTON_WIDTH = 16,     // Spinner left/right buttons width
//     SPIN_BUTTON_SPACING,        // Spinner buttons separation
// } GuiSpinnerProperty

// // ListView
// typedef enum {
//     LIST_ITEMS_HEIGHT = 16,     // ListView items height
//     LIST_ITEMS_SPACING,         // ListView items separation
//     SCROLLBAR_WIDTH,            // ListView scrollbar size (usually width)
//     SCROLLBAR_SIDE,             // ListView scrollbar side (0-SCROLLBAR_LEFT_SIDE, 1-SCROLLBAR_RIGHT_SIDE)
// } GuiListViewProperty

// // ColorPicker
// typedef enum {
//     COLOR_SELECTOR_SIZE = 16,
//     HUEBAR_WIDTH,               // ColorPicker right hue bar width
//     HUEBAR_PADDING,             // ColorPicker right hue bar separation from panel
//     HUEBAR_SELECTOR_HEIGHT,     // ColorPicker right hue bar selector height
//     HUEBAR_SELECTOR_OVERFLOW    // ColorPicker right hue bar selector overflow
// } GuiColorPickerProperty


