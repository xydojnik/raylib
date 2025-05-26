module gui

import raylib_v as rl


// Global gui state control functions
fn C.GuiEnable()            // Enable gui controls (global state)
fn C.GuiDisable()           // Disable gui controls (global state)
fn C.GuiLock()              // Lock gui controls (global state)
fn C.GuiUnlock()            // Unlock gui controls (global state)
fn C.GuiIsLocked() bool     // Check if gui is locked (global state)
fn C.GuiSetAlpha(alpha f32) // Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
fn C.GuiSetState(state int) // Set gui state (global state)
fn C.GuiGetState() int      // Get gui state (global state)

// Font set/get functions
fn C.GuiSetFont(font rl.Font)                          // Set gui custom font (global state)
fn C.GuiGetFont() rl.Font                              // Get gui custom font (global state)

// Style set/get functions
fn C.GuiSetStyle(control int, property int, value int) // Set one style property
fn C.GuiGetStyle(control int, property int) int        // Get one style property

// Styles loading functions
fn C.GuiLoadStyle(file_name &char)                     // Load style file over global style variable (.rgs)
fn C.GuiLoadStyleDefault()                             // Load style default over global style

// Tooltips management functions
fn C.GuiEnableTooltip()                                // Enable gui tooltips (global state)
fn C.GuiDisableTooltip()                               // Disable gui tooltips (global state)
fn C.GuiSetTooltip(tooltip &char)                      // Set tooltip string

// Icons functionality
fn C.GuiIconText(icon_id int, text &char) &char        // Get text with icon id prepended (if supported)


// #if !defined(RAYGUI_NO_ICONS)
//     fn C.GuiSetIconScale(int scale) // Set default icon drawing size
//     u32 *GuiGetIcons()              // Get raygui icons data pointer

//     &char *GuiLoadIcons(&char file_name, bool load_icons_name) // Load raygui icons file (.rgi) into internal icons data
//     fn C.GuiDrawIcon(int icon_id, int posX, int posY, int pixelSize, Color color) // Draw icon using pixel size at specified position
// #endif


// Controls
//----------------------------------------------------------------------------------------------------------
// Container/separator controls, useful for controls organization
fn C.GuiWindowBox(bounds rl.Rectangle, title &char) int                                                                                           // Window Box control, shows a window that can be closed
fn C.GuiGroupBox(bounds rl.Rectangle, text &char) int                                                                                             // Group Box control with text name
fn C.GuiLine(bounds rl.Rectangle, text &char) int                                                                                                 // Line separator control, could contain text
fn C.GuiPanel(bounds rl.Rectangle, text &char) int                                                                                                // Panel control, useful to group controls
fn C.GuiTabBar(bounds rl.Rectangle, text &&char, count int, active &int) int                                                                      // Tab Bar control, returns TAB to be closed or -1
fn C.GuiScrollPanel(bounds rl.Rectangle, text &char, content rl.Rectangle, scroll &rl.Vector2, view &rl.Rectangle) int                            // Scroll Panel control

                                                                                                                                                  // Basic controls set
fn C.GuiLabel(bounds rl.Rectangle, text &char) int                                                                                                // Label control, shows text
fn C.GuiButton(bounds rl.Rectangle, text &char) int                                                                                               // Button control, returns true when clicked
fn C.GuiLabelButton(bounds rl.Rectangle, text &char) int                                                                                          // Label button control, show true when clicked
fn C.GuiToggle(bounds rl.Rectangle, text &char, active &bool) int                                                                                 // Toggle Button control, returns true when active
fn C.GuiToggleGroup(bounds rl.Rectangle, text &char, active &int) int                                                                             // Toggle Group control, returns active toggle index
fn C.GuiToggleSlider(bounds rl.Rectangle, text &char, active &int) int                                                                            // Toggle Slider control, returns true when clicked
fn C.GuiCheckBox(bounds rl.Rectangle, text &char, checked &bool) int                                                                              // Check Box control, returns true when active
fn C.GuiComboBox(bounds rl.Rectangle, text &char, active &int) int                                                                                // Combo Box control, returns selected item index


fn C.GuiDropdownBox(bounds rl.Rectangle, text &char, active &int, edit_mode bool) int                                                             // Dropdown Box control, returns selected item
fn C.GuiSpinner(bounds rl.Rectangle, text &char, value &int, min_value int, max_value int, edit_mode bool) int                                    // Spinner control, returns selected value
fn C.GuiValueBox(bounds rl.Rectangle, text &char, value &int, min_value int, max_value int, edit_mode bool) int                                   // Value Box control, updates input text with numbers
fn C.GuiTextBox(bounds rl.Rectangle, text &char, text_size int, edit_mode bool) int                                                               // Text Box control, updates input text


fn C.GuiSlider(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int                              // Slider control, returns selected value
fn C.GuiSliderBar(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int                           // Slider Bar control, returns selected value
fn C.GuiProgressBar(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int                         // Progress Bar control, shows current progress value
fn C.GuiStatusBar(bounds rl.Rectangle, text &char) int                                                                                            // Status Bar control, shows info text
fn C.GuiDummyRec(bounds rl.Rectangle, text &char) int                                                                                             // Dummy control for placeholders
fn C.GuiGrid(bounds rl.Rectangle, text &char, spacing f32, subdivs int, mouse_cell &rl.Vector2) int                                               // Grid control, returns mouse cell position

                                                                                                                                                  // Advance controls set
fn C.GuiListView(bounds rl.Rectangle, text &char, scroll_index &int, active &int) int                                                             // List View control, returns selected list item index
fn C.GuiListViewEx(bounds rl.Rectangle, text &&char, count int, scroll_index &int, active &int, focus &int) int                                   // List View with extended parameters
fn C.GuiMessageBox(bounds rl.Rectangle, title &char, message &char, buttons &char) int                                                            // Message Box control, displays a message
fn C.GuiTextInputBox(bounds rl.Rectangle, title &char, message &char, buttons &char, text &char, text_max_size int, secret_view_active &bool) int // Text Input Box control, ask for text, supports secret
fn C.GuiColorPicker(bounds rl.Rectangle, text &char, color &rl.Color) int                                                                         // Color Picker control (multiple color controls)
fn C.GuiColorPanel(bounds rl.Rectangle, text &char, color &rl.Color) int                                                                          // Color Panel control
fn C.GuiColorBarAlpha(bounds rl.Rectangle, text &char, alpha &f32) int                                                                            // Color Bar Alpha control
fn C.GuiColorBarHue(bounds rl.Rectangle, text &char, value &f32) int                                                                              // Color Bar Hue control
fn C.GuiColorPickerHSV(bounds rl.Rectangle, text &char,  color_hsv &rl.Vector3) int                                                               // Color Picker control that avoids conversion to RGB on each call (multiple color controls)
fn C.GuiColorPanelHSV(bounds rl.Rectangle, text &char, color_hsv &rl.Vector3 ) int                                                                // Color Panel control that returns HSV color value, used by fn C.GuiColorPickerHSV()
