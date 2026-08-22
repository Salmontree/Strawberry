#+private
package window

import "core:strings"
import "core:log"
import "lib:wgpu"
import "lib:wgpu/sdl3glue"
import SDL "vendor:sdl3"

@(private="file")
State :: struct {
	window: ^SDL.Window,
	should_quit: bool,
}

sdl3_create_window :: proc(width: int, height: int, title: string) -> (window: Window, ok: bool) {
	if !SDL.Init({.VIDEO}) do return {}, false
	state := new(State); if state == nil do return {}, false

	if state.window = SDL.CreateWindow(strings.clone_to_cstring(title, context.temp_allocator), i32(width), i32(height), { .RESIZABLE }); state.window == nil do return {}, false
	SDL.SetWindowMinimumSize(state.window, 720, 480)
	state.should_quit = false

	return {
		state=state,

		get_framebuffer_size = proc(window: ^Window) -> (width, height: u32) {
			state := (^State)(window.state)
			w, h: i32; SDL.GetWindowSizeInPixels(state.window, &w, &h)
			return u32(w), u32(h)
		},
		get_surface = proc(window: ^Window, instance: wgpu.Instance) -> wgpu.Surface {
			state := (^State)(window.state)
			return sdl3glue.GetSurface(instance, state.window)
		},

		destroy = proc(window: ^Window) {
			log.info("Destroying window")
			state := (^State)(window.state)
			SDL.DestroyWindow(state.window)
			SDL.Quit()
			free(state)
		},

		poll_events = proc(window: ^Window) {
			state := (^State)(window.state)
			event: SDL.Event
			for SDL.PollEvent(&event) {
				#partial switch event.type {
					case .QUIT: state.should_quit = true
					case .WINDOW_RESIZED, .WINDOW_PIXEL_SIZE_CHANGED:
						if window.on_resize != nil do window.on_resize()
						else do log.warn("No resize callback")
				}
			}
		},

		present_screen = proc(window: ^Window) {
			state := (^State)(window.state)
			SDL.GL_SwapWindow(state.window)
		},

		should_quit = proc(window: ^Window) -> bool {
			state := (^State)(window.state)
			return state.should_quit
		},
	}, true
}