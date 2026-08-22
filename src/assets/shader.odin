package assets

import "vendor:sdl3"
import "core:log"
import "core:os"
import "core:strings"

Shader :: struct {
	id: u32,

	use: proc(shader: ^Shader)
}

@(private)
shader_init :: proc() -> (ok: bool) {
	return true
}

@(private)
shader_load :: proc(files: ..string) -> (asset: ^Shader, ok: bool) {
	if len(files) != 1 do return nil, false

	prgsrc: string; if tmp, err := os.read_entire_file(files[0], context.temp_allocator); err != nil do return nil, false; else do prgsrc = string(tmp)
	
	shaders, err := strings.split(string(prgsrc), ",", context.temp_allocator)
	if err != nil || len(shaders) != 2 do return nil, false

	return nil, false
}

@(private)
shader_destroy :: proc(asset: ^Shader) {
	free(asset)
}