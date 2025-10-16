package platform_raylib

import game "../game"
import rl "vendor:raylib"

State :: struct
{
	req_close : bool,
}

state : State

main :: proc()
{
	rl.SetConfigFlags({.VSYNC_HINT })
    rl.InitWindow(game.WINDOW_SIZE, game.WINDOW_SIZE, "snake")
    rl.SetTargetFPS(60)

    game.set_view_size(f32(game.WINDOW_SIZE), f32(game.WINDOW_SIZE))

    game.initialize()

	for !state.req_close
	{
		if rl.WindowShouldClose()
		{
			return
		}

		up_state := rl.IsKeyDown(.UP)
		down_state := rl.IsKeyDown(.DOWN)
		left_state := rl.IsKeyDown(.LEFT)
		right_state := rl.IsKeyDown(.RIGHT)
		start_state := rl.IsKeyDown(.ENTER)

		game.set_inputs(up_state, down_state, left_state, right_state, start_state)

		draw_commands, still_running := game.update()
		if !still_running
		{
			return
		}

	 	rl.BeginDrawing()

		for draw_command in draw_commands
		{
			switch dc in draw_command
			{
				case game.Draw_Command_Clear:
				{
					color := transmute(rl.Color)dc.color
					rl.ClearBackground(color)
				}
				case game.Draw_Command_Line:
				{
					color := transmute(rl.Color)dc.color
					rl.DrawLineEx([2]f32{dc.x1, dc.x2}, [2]f32{dc.y1, dc.y2}, dc.thick, color)
				}
				case game.Draw_Command_Rectangle:
				{
					color := transmute(rl.Color)dc.color
					rectangle := transmute(rl.Rectangle)dc.rectangle
					rl.DrawRectangleRec(rectangle, color)
				}
			}
		}

		rl.EndDrawing()
	}
}