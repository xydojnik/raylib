module c

#preinclude "@VMODROOT/src/c/pre.h"

#flag -I@VMODROOT/thirdparty/raylib/src/
#flag -L@VMODROOT/thirdparty/raylib/src/

#flag @VMODROOT/thirdparty/raylib/src/rcore.o

#include "raylib.h"


$if windows {
    #flag -lraylib -lgdi32 -lopengl32 -lwinmm
} $else $if linux {
	#flag -lGL -lm -lpthread -ldl -lrt
} $else $if macos {
	#flag -DGL_SILENCE_DEPRECATION
	#flag -ObjC
	#flag -framework OpenGL
	#flag -framework Cocoa
	#flag -framework IOKit
} $else {
	$compile_error('Unsupported OS')
}
