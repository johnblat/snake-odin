package platform_sdl

import game "../game"
import sdl "vendor:sdl3"

State :: struct
{
	window : ^sdl.Window,
	renderer : ^sdl.Renderer,
	req_close : bool,
}

state : State

main :: proc()
{
	if ok := sdl.Init({.VIDEO, .AUDIO}); !ok 
	{
		sdl.Log("could not init sdl")
		return
	}

	sdl.CreateWindowAndRenderer("Snake SDL", game.WINDOW_SIZE, game.WINDOW_SIZE, {}, &state.window, &state.renderer)
	sdl.SetRenderVSync(state.renderer, 1)

    game.set_view_size(f32(game.WINDOW_SIZE), f32(game.WINDOW_SIZE))

    game.initialize()

    frame_time_ms : u64 = (1000/60)

	for !state.req_close
	{
		frame_start_ticks_ms := sdl.GetTicks()

		event : sdl.Event
		for sdl.PollEvent(&event)
		{
			#partial switch event.type
			{
				case .WINDOW_CLOSE_REQUESTED:
				{
					state.req_close = true
					return
				}
				case .KEY_DOWN:
				{
					if event.key.repeat != true
					{
						if event.key.scancode == .ESCAPE
						{
							state.req_close = true
							return
						}
					}
				}
			}
		}

		key_state := sdl.GetKeyboardState(nil)

		up_state := key_state[sdl.Scancode.UP]
		down_state := key_state[sdl.Scancode.DOWN]
		left_state := key_state[sdl.Scancode.LEFT]
		right_state := key_state[sdl.Scancode.RIGHT]
		start_state := key_state[sdl.Scancode.RETURN]

		game.set_inputs(up_state, down_state, left_state, right_state, start_state)

		draw_commands, still_running := game.update()
		if !still_running
		{
			return
		}

		for draw_command in draw_commands
		{
			switch dc in draw_command
			{
				case game.Draw_Command_Clear:
				{
					sdl.SetRenderDrawColor(state.renderer, dc.color.r, dc.color.g, dc.color.b, dc.color.a)
					sdl.RenderClear(state.renderer)
				}
				case game.Draw_Command_Line:
				{
					sdl.SetRenderDrawColor(state.renderer, dc.color.r, dc.color.g, dc.color.b, dc.color.a)
					sdl.RenderLine(state.renderer, dc.x1, dc.x2, dc.y1, dc.y2)
				}
				case game.Draw_Command_Rectangle:
				{
					sdl.SetRenderDrawColor(state.renderer, dc.color.r, dc.color.g, dc.color.b, dc.color.a)

					sdl.RenderRect(state.renderer, &sdl.FRect{dc.rectangle.x, dc.rectangle.y, dc.rectangle.w, dc.rectangle.h })
				}
			}
		}

		sdl.RenderPresent(state.renderer)

		frame_end_ticks_ms := sdl.GetTicks()
		total_frame_ticks_ms := frame_end_ticks_ms - frame_start_ticks_ms
		delay_ms := frame_time_ms - total_frame_ticks_ms
		sdl.Delay(u32(delay_ms))
	}
}