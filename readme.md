<div align="center" style="display:grid;place-items:center;">
<p>
     <a href="https://vlang.io/"   target="_blank"><img width="80" src="https://raw.githubusercontent.com/vlang/v-logo/master/dist/v-logo.svg?sanitize=true" alt="V logo"></a>
     <a href="https://raylib.com/" target="_blank"><img width="80" src="https://github.com/raysan5/raylib/blob/master/logo/raylib_128x128.png?sanitize=true" alt="Raylib logo"></a>
</p>
     <h1>Raylib 5.+ for V programming language.</h1>
</div>

> This project was created for learning purpose... at least for now.

## Installation
1. Make sure you have [**_vlang_**](https://vlang.io/) and [**_GCC_**](https://www.mingw-w64.org/) installed.
2. Download [xydojnik/raylib](https://github.com/xydojnik/raylib) or `git clone` it to `.vmodules`. Make sure [submodules](https://github.com/raysan5/raylib) is downloaded.
3. Compile RAYLIB (thirdparty/raylib/src) with make.

Download raylib module.
```bash
v install xydojnik/raylib
```
Compile raylib with __make__.
```bash
cd thirdparty/raylib/src
make PLATFORM=PLATFORM_DESKTOP
```

## Basic example:
This is a basic raylib example, it creates a window and draws the text "Congrats! You created your first window!" in the middle of the screen. Check this example running live on web here.

```vlang
module main

import raylib as rl

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
fn main() {
    // Initialization
    //--------------------------------------------------------------------------------------
    screen_width  := 800
    screen_height := 450

    rl.init_window(screen_width, screen_height, 'raylib [core] example - basic window')
    // De-Initialization
    //--------------------------------------------------------------------------------------
    defer { rl.close_window() }        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    rl.set_target_fps(60)               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    for !rl.window_should_close() {    // Detect window close button or ESC key
        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.begin_drawing()

            rl.clear_background(rl.raywhite)

            rl.draw_text('Congrats! You created your first window!', 190, 200, 20, rl.black)

        rl.end_drawing()
    }
}

```
Build v file:
```bash
v -cc gcc build basic_window.v
```
Run v file:
```bash
v -cc gcc run basic_window.v
```
Run v file with **Debug** information **_-cg_** flag:
```bash
v -cc gcc -cg run basic_window.v
```
Differences:
- Functions and parameters are renamed from `PascalCase` to `camel_case`
- Colours are V constants, not as macros
- Some function that uses or returns a C-string instead uses a V-string
- Some function that returns C like array now returns v slices

> First three lines in a list was taken from: [raylib](https://github.com/vlang/raylib/blob/main/readme.md)

## Screenshots:
> examples/shaders/shaders_basic_pbr.v
![](https://github.com/xydojnik/raylib/blob/main/examples/shaders/shaders_basic_pbr.png)

## Useg
To make games faster with vlang

## License
[MIT](https://choosealicense.com/licenses/mit/)
