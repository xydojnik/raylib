module gui

import raylib_v as rl


// Global gui state control functions
pub fn enable()             { C.GuiEnable()           } // Enable gui controls (global state)
pub fn disable()            { C.GuiDisable()          } // Disable gui controls (global state)
pub fn lock()               { C.GuiLock()             } // Lock gui controls (global state)
pub fn unlock()             { C.GuiUnlock()           } // Unlock gui controls (global state)
pub fn is_locked() bool     { return C.GuiIsLocked()  } // Check if gui is locked (global state)
pub fn set_alpha(alpha f32) { C.GuiSetAlpha(alpha)    } // Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
pub fn set_state(state int) { C.GuiSetState(state)    } // Set gui state (global state)
pub fn get_state() int      { return C.GuiGetState()  } // Get gui state (global state)

// Font set/get functions
pub fn set_font(font rl.Font) { C.GuiSetFont(font)    } // Set gui custom font (global state)
pub fn get_font() rl.Font     { return C.GuiGetFont() } // Get gui custom font (global state)

// Style set/get functions
pub fn set_style(control int, property int, value int)     { C.GuiSetStyle(control, property, value) } // Set one style property
pub fn get_style(control int, property int, value int) int { return C.GuiGetStyle(control, property) } // Get one style property

// Styles loading functions
pub fn load_style(file_name &char){ C.GuiLoadStyle(file_name) } // Load style file over global style variable (.rgs)
pub fn load_style_default()       { C.GuiLoadStyleDefault()   } // Load style default over global style

// Tooltips management functions
pub fn enable_tooltip()          { C.GuiEnableTooltip()     } // Enable gui tooltips (global state)
pub fn disable_tooltip()         { C.GuiDisableTooltip()    } // Disable gui tooltips (global state)
pub fn set_tooltip(tooltip &char){ C.GuiSetTooltip(tooltip) } // Set tooltip string

// Icons functionality
pub fn icon_text(icon_id int, text &char) &char { return C.GuiIconText(icon_id, text) } // Get text with icon id prepended (if supported)

// #if !defined(RAYGUI_NO_ICONS)
//     pub fn (){ C.GuiSetIconScale(int scale) // Set default icon drawing size
//     u32 *GuiGetIcons()              // Get raygui icons data pointer

//     &char *GuiLoadIcons(&char file_name, bool load_icons_name) // Load raygui icons file (.rgi) into internal icons data
//     pub fn (){ C.GuiDrawIcon(int icon_id, int posX, int posY, int pixelSize, Color color) // Draw icon using pixel size at specified position
// #endif


// Controls
//----------------------------------------------------------------------------------------------------------
// Container/separator controls, useful for controls organization
pub fn window_box(bounds rl.Rectangle, title &char) int {
    return C.GuiWindowBox(bounds, title)                         // Window Box control, shows a window that can be closed
}
pub fn group_box(bounds rl.Rectangle, text &char) int {
    return C.GuiGroupBox(bounds, text)                           // Group Box control with text name
}
pub fn line(bounds rl.Rectangle, text &char) int {
    return C.GuiLine(bounds, text)                               // Line separator control, could contain text
}
pub fn panel(bounds rl.Rectangle, text &char) int {
    return C.GuiPanel(bounds, text)                              // Panel control, useful to group controls
}
pub fn tab_bar(bounds rl.Rectangle, text &&char, count int, active &int) int {
    return C.GuiTabBar(bounds, text, count, active)              // Tab Bar control, returns TAB to be closed or -1
}
pub fn scroll_panel(bounds rl.Rectangle, text &char, content rl.Rectangle, scroll &rl.Vector2, view &rl.Rectangle) int {
    return C.GuiScrollPanel(bounds, text, content, scroll, view) // Scroll Panel control
}

// Basic controls set
pub fn label(bounds rl.Rectangle, text &char) int {
    return C.GuiLabel(bounds, text)                // Label control, shows text
}
pub fn button(bounds rl.Rectangle, text &char) int {
    return C.GuiButton(bounds, text)               // Button control, returns true when clicked
}
pub fn label_button(bounds rl.Rectangle, text &char) int {
    return C.GuiLabelButton(bounds, text)          // Label button control, show true when clicked
}
pub fn toggle(bounds rl.Rectangle, text &char, active &bool) int {
    return C.GuiToggle(bounds, text, active)       // Toggle Button control, returns true when active
}
pub fn toggle_group(bounds rl.Rectangle, text &char, active &int) int {
    return C.GuiToggleGroup(bounds, text, active)  // Toggle Group control, returns active toggle index
}
pub fn toggle_slider(bounds rl.Rectangle, text &char, active &int) int {
    return C.GuiToggleSlider(bounds, text, active) // Toggle Slider control, returns true when clicked
}
pub fn check_box(bounds rl.Rectangle, text &char, checked &bool) int {
    return C.GuiCheckBox(bounds, text, checked)    // Check Box control, returns true when active
}
pub fn combo_box(bounds rl.Rectangle, text &char, active &int) int {
    return C.GuiComboBox(bounds, text, active)     // Combo Box control, returns selected item index
}

pub fn dropdown_box(bounds rl.Rectangle, text &char, active &int, edit_mode bool) int {
    return C.GuiDropdownBox(bounds, text, active, edit_mode)                   // Dropdown Box control, returns selected item
}
pub fn spinner(bounds rl.Rectangle, text &char, value &int, min_value int, max_value int, edit_mode bool) int {
    return C.GuiSpinner(bounds, text, value, min_value, max_value, edit_mode)  // Spinner control, returns selected value
}
pub fn value_box(bounds rl.Rectangle, text &char, value &int, min_value int, max_value int, edit_mode bool) int {
    return C.GuiValueBox(bounds, text, value, min_value, max_value, edit_mode) // Value Box control, updates input text with numbers
}
pub fn text_box(bounds rl.Rectangle, text &char, text_size int, edit_mode bool) int {
    return C.GuiTextBox(bounds, text, text_size, edit_mode)                    // Text Box control, updates input text
}

pub fn slider(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int {
    return C.GuiSlider(bounds, text_left, text_right, value, min_value, max_value)      // Slider control, returns selected value
}
pub fn slider_bar(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int {
    return C.GuiSliderBar(bounds, text_left, text_right, value, min_value, max_value)   // Slider Bar control, returns selected value
}
pub fn progress_bar(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int {
    return C.GuiProgressBar(bounds, text_left, text_right, value, min_value, max_value) // Progress Bar control, shows current progress value
}
pub fn status_bar(bounds rl.Rectangle, text &char) int {
    return C.GuiStatusBar(bounds, text)                                                 // Status Bar control, shows info text
}
pub fn dummy_rec(bounds rl.Rectangle, text &char) int {
    return C.GuiDummyRec(bounds, text)                                                  // Dummy control for placeholders
}
pub fn grid(bounds rl.Rectangle, text &char, spacing f32, subdivs int, mouse_cell &rl.Vector2) int {
    return C.GuiGrid(bounds, text, spacing, subdivs, mouse_cell)                        // Grid control, returns mouse cell position
}

// // Advance controls set
pub fn list_view(bounds rl.Rectangle, text &char, scroll_index &int, active &int) int {
    return C.GuiListView(bounds, text, scroll_index, active) // List View control, returns selected list item index
}
pub fn list_view_ex(bounds rl.Rectangle, text &&char, count int, scroll_index &int, active &int, focus &int) int {
    return C.GuiListViewEx(bounds, text, count, scroll_index, active, focus) // List View with extended parameters
}
pub fn message_box(bounds rl.Rectangle, title &char, message &char, buttons &char) int {
    return C.GuiMessageBox(bounds, title, message, buttons) // Message Box control, displays a message
}
pub fn text_input_box(bounds rl.Rectangle, title &char, message &char, buttons &char, text &char, text_max_size int, secret_view_active &bool) int {
    return C.GuiTextInputBox(bounds, title, message, buttons, text, text_max_size, secret_view_active) // Text Input Box control, ask for text, supports secret
}

pub fn color_picker(bounds rl.Rectangle, text &char, color &rl.Color) int {
    return C.GuiColorPicker(bounds, text, color)        // Color Picker control (multiple color controls)
}
pub fn color_panel(bounds rl.Rectangle, text &char, color &rl.Color) int {
    return C.GuiColorPanel(bounds, text, color)         // Color Panel control
}
pub fn color_bar_alpha(bounds rl.Rectangle, text &char, alpha &f32) int {
    return C.GuiColorBarAlpha(bounds, text, alpha)      // Color Bar Alpha control
}
pub fn color_bar_hue(bounds rl.Rectangle, text &char, value &f32) int {
    return C.GuiColorBarHue(bounds, text, value)        // Color Bar Hue control
}
pub fn color_picker_hsv(bounds rl.Rectangle, text &char,  color_hsv &rl.Vector3) int {
    return C.GuiColorPickerHSV(bounds, text, color_hsv) // Color Picker control that avoids conversion to RGB on each call (multiple color controls)
}
pub fn color_panel_hsv(bounds rl.Rectangle, text &char, color_hsv &rl.Vector3) int {
    return C.GuiColorPanelHSV(bounds, text, color_hsv)  // Color Panel control that returns HSV color value, used by pub fn (){ C.GuiColorPickerHSV()
}




















// // Global gui state control functions
// pub fn gui_enable()             { C.GuiEnable()           } // Enable gui controls (global state)
// pub fn gui_disable()            { C.GuiDisable()          } // Disable gui controls (global state)
// pub fn gui_lock()               { C.GuiLock()             } // Lock gui controls (global state)
// pub fn gui_unlock()             { C.GuiUnlock()           } // Unlock gui controls (global state)
// pub fn gui_is_locked() bool     { return C.GuiIsLocked()  } // Check if gui is locked (global state)
// pub fn gui_set_alpha(alpha f32) { C.GuiSetAlpha(alpha)    } // Set gui controls alpha (global state), alpha goes from 0.0f to 1.0f
// pub fn gui_set_state(state int) { C.GuiSetState(state)    } // Set gui state (global state)
// pub fn gui_get_state() int      { return C.GuiGetState()  } // Get gui state (global state)

// // Font set/get functions
// pub fn gui_set_font(font rl.Font) { C.GuiSetFont(font)    } // Set gui custom font (global state)
// pub fn gui_get_font() rl.Font     { return C.GuiGetFont() } // Get gui custom font (global state)

// // Style set/get functions
// pub fn gui_set_style(control int, property int, value int)     { C.GuiSetStyle(control, property, value) } // Set one style property
// pub fn gui_get_style(control int, property int, value int) int { return C.GuiGetStyle(control, property) } // Get one style property

// // Styles loading functions
// pub fn gui_load_style(file_name &char){ C.GuiLoadStyle(file_name) } // Load style file over global style variable (.rgs)
// pub fn gui_load_style_default()       { C.GuiLoadStyleDefault()   } // Load style default over global style

// // Tooltips management functions
// pub fn gui_enable_tooltip()          { C.GuiEnableTooltip()     } // Enable gui tooltips (global state)
// pub fn gui_disable_tooltip()         { C.GuiDisableTooltip()    } // Disable gui tooltips (global state)
// pub fn gui_set_tooltip(tooltip &char){ C.GuiSetTooltip(tooltip) } // Set tooltip string

// // Icons functionality
// pub fn gui_icon_text(icon_id int, text &char) &char { return C.GuiIconText(icon_id, text) } // Get text with icon id prepended (if supported)

// // #if !defined(RAYGUI_NO_ICONS)
// //     pub fn gui_(){ C.GuiSetIconScale(int scale) // Set default icon drawing size
// //     u32 *GuiGetIcons()              // Get raygui icons data pointer

// //     &char *GuiLoadIcons(&char file_name, bool load_icons_name) // Load raygui icons file (.rgi) into internal icons data
// //     pub fn gui_(){ C.GuiDrawIcon(int icon_id, int posX, int posY, int pixelSize, Color color) // Draw icon using pixel size at specified position
// // #endif


// // Controls
// //----------------------------------------------------------------------------------------------------------
// // Container/separator controls, useful for controls organization
// pub fn gui_window_box(bounds rl.Rectangle, title &char) int {
//     return C.GuiWindowBox(bounds, title)                         // Window Box control, shows a window that can be closed
// }
// pub fn gui_group_box(bounds rl.Rectangle, text &char) int {
//     return C.GuiGroupBox(bounds, text)                           // Group Box control with text name
// }
// pub fn gui_line(bounds rl.Rectangle, text &char) int {
//     return C.GuiLine(bounds, text)                               // Line separator control, could contain text
// }
// pub fn gui_panel(bounds rl.Rectangle, text &char) int {
//     return C.GuiPanel(bounds, text)                              // Panel control, useful to group controls
// }
// pub fn gui_tab_bar(bounds rl.Rectangle, text &&char, count int, active &int) int {
//     return C.GuiTabBar(bounds, text, count, active)              // Tab Bar control, returns TAB to be closed or -1
// }
// pub fn gui_scroll_panel(bounds rl.Rectangle, text &char, content rl.Rectangle, scroll &rl.Vector2, view &rl.Rectangle) int {
//     return C.GuiScrollPanel(bounds, text, content, scroll, view) // Scroll Panel control
// }

// // Basic controls set
// pub fn gui_label(bounds rl.Rectangle, text &char) int {
//     return C.GuiLabel(bounds, text)                // Label control, shows text
// }
// pub fn gui_button(bounds rl.Rectangle, text &char) int {
//     return C.GuiButton(bounds, text)               // Button control, returns true when clicked
// }
// pub fn gui_label_button(bounds rl.Rectangle, text &char) int {
//     return C.GuiLabelButton(bounds, text)          // Label button control, show true when clicked
// }
// pub fn gui_toggle(bounds rl.Rectangle, text &char, active &bool) int {
//     return C.GuiToggle(bounds, text, active)       // Toggle Button control, returns true when active
// }
// pub fn gui_toggle_group(bounds rl.Rectangle, text &char, active &int) int {
//     return C.GuiToggleGroup(bounds, text, active)  // Toggle Group control, returns active toggle index
// }
// pub fn gui_toggle_slider(bounds rl.Rectangle, text &char, active &int) int {
//     return C.GuiToggleSlider(bounds, text, active) // Toggle Slider control, returns true when clicked
// }
// pub fn gui_check_box(bounds rl.Rectangle, text &char, checked &bool) int {
//     return C.GuiCheckBox(bounds, text, checked)    // Check Box control, returns true when active
// }
// pub fn gui_combo_box(bounds rl.Rectangle, text &char, active &int) int {
//     return C.GuiComboBox(bounds, text, active)     // Combo Box control, returns selected item index
// }

// pub fn gui_gropdown_box(bounds rl.Rectangle, text &char, active &int, edit_mode bool) int {
//     return C.GuiDropdownBox(bounds, text, active, edit_mode)                   // Dropdown Box control, returns selected item
// }
// pub fn gui_spinner(bounds rl.Rectangle, text &char, value &int, min_value int, max_value int, edit_mode bool) int {
//     return C.GuiSpinner(bounds, text, value, min_value, max_value, edit_mode)  // Spinner control, returns selected value
// }
// pub fn gui_value_box(bounds rl.Rectangle, text &char, value &int, min_value int, max_value int, edit_mode bool) int {
//     return C.GuiValueBox(bounds, text, value, min_value, max_value, edit_mode) // Value Box control, updates input text with numbers
// }
// pub fn gui_text_box(bounds rl.Rectangle, text &char, text_size int, edit_mode bool) int {
//     return C.GuiTextBox(bounds, text, text_size, edit_mode)                    // Text Box control, updates input text
// }

// pub fn gui_slider(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int {
//     return C.GuiSlider(bounds, text_left, text_right, value, min_value, max_value)      // Slider control, returns selected value
// }
// pub fn gui_slider_bar(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int {
//     return C.GuiSliderBar(bounds, text_left, text_right, value, min_value, max_value)   // Slider Bar control, returns selected value
// }
// pub fn gui_progress_bar(bounds rl.Rectangle, text_left &char, text_right &char, value &f32, min_value f32, max_value f32) int {
//     return C.GuiProgressBar(bounds, text_left, text_right, value, min_value, max_value) // Progress Bar control, shows current progress value
// }
// pub fn gui_status_bar(bounds rl.Rectangle, text &char) int {
//     return C.GuiStatusBar(bounds, text)                                                 // Status Bar control, shows info text
// }
// pub fn gui_dummy_rec(bounds rl.Rectangle, text &char) int {
//     return C.GuiDummyRec(bounds, text)                                                  // Dummy control for placeholders
// }
// pub fn gui_grid(bounds rl.Rectangle, text &char, spacing f32, subdivs int, mouse_cell &rl.Vector2) int {
//     return C.GuiGrid(bounds, text, spacing, subdivs, mouse_cell)                        // Grid control, returns mouse cell position
// }

// // // Advance controls set
// pub fn gui_list_view(bounds rl.Rectangle, text &char, scroll_index &int, active &int) int {
//     return C.GuiListView(bounds, text, scroll_index, active) // List View control, returns selected list item index
// }
// pub fn gui_list_view_ex(bounds rl.Rectangle, text &&char, count int, scroll_index &int, active &int, focus &int) int {
//     return C.GuiListViewEx(bounds, text, count, scroll_index, active, focus) // List View with extended parameters
// }
// pub fn gui_message_box(bounds rl.Rectangle, title &char, message &char, buttons &char) int {
//     return C.GuiMessageBox(bounds, title, message, buttons) // Message Box control, displays a message
// }
// pub fn gui_text_input_box(bounds rl.Rectangle, title &char, message &char, buttons &char, text &char, text_max_size int, secret_view_active &bool) int {
//     return C.GuiTextInputBox(bounds, title, message, buttons, text, text_max_size, secret_view_active) // Text Input Box control, ask for text, supports secret
// }

// pub fn gui_color_picker(bounds rl.Rectangle, text &char, color &rl.Color) int {
//     return C.GuiColorPicker(bounds, text, color)        // Color Picker control (multiple color controls)
// }
// pub fn gui_color_panel(bounds rl.Rectangle, text &char, color &rl.Color) int {
//     return C.GuiColorPanel(bounds, text, color)         // Color Panel control
// }
// pub fn gui_color_bar_alpha(bounds rl.Rectangle, text &char, alpha &f32) int {
//     return C.GuiColorBarAlpha(bounds, text, alpha)      // Color Bar Alpha control
// }
// pub fn gui_color_bar_hue(bounds rl.Rectangle, text &char, value &f32) int {
//     return C.GuiColorBarHue(bounds, text, value)        // Color Bar Hue control
// }
// pub fn gui_color_picker_hsv(bounds rl.Rectangle, text &char,  color_hsv &rl.Vector3) int {
//     return C.GuiColorPickerHSV(bounds, text, color_hsv) // Color Picker control that avoids conversion to RGB on each call (multiple color controls)
// }
// pub fn gui_color_panel_hsv(bounds rl.Rectangle, text &char, color_hsv &rl.Vector3) int {
//     return C.GuiColorPanelHSV(bounds, text, color_hsv)  // Color Panel control that returns HSV color value, used by pub fn gui_(){ C.GuiColorPickerHSV()
// }
