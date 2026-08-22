package window

import "lib:wgpu"
import "core:log"

Window :: struct {
	state: rawptr,

	get_framebuffer_size: proc(window: ^Window) -> (width, height: u32),
	get_surface: proc(window: ^Window, instance: wgpu.Instance) -> wgpu.Surface,
	on_resize: proc "c" (),

	destroy: proc(window: ^Window),
	poll_events: proc(window: ^Window),
	present_screen: proc(window: ^Window),
	should_quit: proc(window: ^Window) -> bool
}

create_window :: proc(width: int, height: int, title: string) -> (window: Window, ok: bool) {
	log.info("Creating SDL3 window"); window, ok = sdl3_create_window(width, height, title); if ok do return window, true
	log.warn("SDL3 window failed, creating GLFW window")
	log.warn("GLFW window failed")
	return {}, false
}