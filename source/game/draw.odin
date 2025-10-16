package game

import "core:fmt"
import "core:strings"
// import rl "vendor:raylib"


// debug_draw_input_keydowns :: proc( x_offset, y_offset: i32) -> (x_end, y_end: i32) {
//     x_start_text_draw : i32 = x_offset
//     y_start_text_draw : i32 = y_offset
//     padding : i32 : 20
    
//     x : i32 = x_start_text_draw
//     y : i32 = y_start_text_draw

//     keyboard_up_str    : string = "rl.KeyboardKey.UP"
//     keyboard_down_str  : string = "rl.KeyboardKey.DOWN"
//     keyboard_left_str  : string = "rl.KeyboardKey.LEFT"
//     keyboard_right_str : string = "rl.KeyboardKey.RIGHT"

//     key_down_str : string = "down"
//     key_up_str   : string = "up"

//     // draw current state of each key
//     if rl.IsKeyDown(rl.KeyboardKey.UP) {
//         str := strings.concatenate([]string{keyboard_up_str, ": ", key_down_str})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    
//     } else {
//         str := strings.concatenate([]string{keyboard_up_str, ": ",  key_up_str})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
//     }

//     y += padding

//     if rl.IsKeyDown(rl.KeyboardKey.DOWN) {
//         str := strings.concatenate([]string{keyboard_down_str, ": ", key_down_str})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    
//     } else {
//         str := strings.concatenate([]string{keyboard_down_str, ": ",  key_up_str})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
//     }

//     y += padding

//     if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
//         str := strings.concatenate([]string{keyboard_left_str, ": ", key_down_str})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    
//     } else {
//         str := strings.concatenate([]string{keyboard_left_str, ": ",  key_up_str})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
//     }

//     y += padding

//     if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
//         str := strings.concatenate([]string{keyboard_right_str, ": ", key_down_str})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    
//     } else {
//         str := strings.concatenate([]string{keyboard_right_str, ": ",  key_up_str})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
//     }

//     x_end = x
//     y_end = y + padding 

//     return
// }

// debug_draw_input_keys_pressed_array :: proc(x_offset, y_offset: i32) -> (x_end, y_end: i32) {
//     x_start_text_draw : i32 = x_offset
//     y_start_text_draw : i32 = y_offset
//     padding : i32 : 20
    
//     x : i32 = x_start_text_draw
//     y : i32 = y_start_text_draw

//     keyboard_up_str    : string = "rl.KeyboardKey.UP"
//     keyboard_down_str  : string = "rl.KeyboardKey.DOWN"
//     keyboard_left_str  : string = "rl.KeyboardKey.LEFT"
//     keyboard_right_str : string = "rl.KeyboardKey.RIGHT"

//     // draw keys pressed down in array
//     for i in 0..<input_num_keys_pressed_down {
//         key := input_keys_pressed_down[i]
//         key_str : string
//         if key == rl.KeyboardKey.UP {
//             key_str = keyboard_up_str
//         } else if key == rl.KeyboardKey.DOWN {
//             key_str = keyboard_down_str
//         } else if key == rl.KeyboardKey.LEFT {
//             key_str = keyboard_left_str
//         } else if key == rl.KeyboardKey.RIGHT {
//             key_str = keyboard_right_str
//         }

//         str := strings.concatenate([]string{"[", key_str, "]"})
//         cstr := strings.clone_to_cstring(str)
//         rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
//         y += padding
//     }

//     // increment y for padding for elements not present
//     for _ in input_num_keys_pressed_down..<len(input_keys_pressed_down) {
//         y += padding
//     }

//     x_end = x
//     y_end = y + padding

//     return
// }

// debug_draw_snake_movement_direction :: proc(x_offset, y_offset: i32) -> (x_end, y_end: i32) {
//     x_start_text_draw : i32 = x_offset
//     y_start_text_draw : i32 = y_offset
//     padding : i32 : 20
    
//     x : i32 = x_start_text_draw
//     y : i32 = y_start_text_draw

//     snake_movement_direction_label_str := "snake_movement_direction: "
//     snake_movement_direction_up_str    := "Direction.UP"
//     snake_movement_direction_down_str  := "Direction.DOWN"
//     snake_movement_direction_left_str  := "Direction.LEFT"
//     snake_movement_direction_right_str := "Direction.RIGHT"

//     text: string
//     if snake_movement_direction == Direction.UP {
//         text = strings.concatenate([]string{snake_movement_direction_label_str, snake_movement_direction_up_str})
//     } else if snake_movement_direction == Direction.DOWN {
//         text = strings.concatenate([]string{snake_movement_direction_label_str, snake_movement_direction_down_str})
//     } else if snake_movement_direction == Direction.LEFT {
//         text = strings.concatenate([]string{snake_movement_direction_label_str, snake_movement_direction_left_str})
//     } else if snake_movement_direction == Direction.RIGHT {
//         text = strings.concatenate([]string{snake_movement_direction_label_str, snake_movement_direction_right_str})
//     } else {
//         text = strings.concatenate([]string{snake_movement_direction_label_str, "unknown"})
//     }

//     cstr := strings.clone_to_cstring(text)
//     rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})

//     x_end = x
//     y_end = y + padding

//     return
// }


Draw_Command_Rectangle :: struct
{
    rectangle : Rectangle,
    color : [4]u8,
}


Draw_Command_Line :: struct
{
    x1,y1, x2,y2 : f32,
    thick : f32,
    color : [4]u8,
}


Draw_Command_Clear :: struct
{
    color : [4]u8,
}


Draw_Command :: union
{
    Draw_Command_Rectangle,
    Draw_Command_Line,
    Draw_Command_Clear,
}


draw_clear :: proc(r, g, b, a : u8)
{
    dc_clear := Draw_Command_Clear { color = [4]u8{ r, g, b, a } }
    append_elem(&state.draw_commands, dc_clear)
}


draw_rectangle :: proc(x, y, w, h : f32, r, g, b, a : u8)
{
    draw_command_rectangle := Draw_Command_Rectangle {
        rectangle = Rectangle {x, y, w, h},
        color = [4]u8{r, g, b, a},
    }
    append_elem(&state.draw_commands, draw_command_rectangle)
}


draw_line :: proc(x1, y1, x2, y2, thick : f32, r, g, b, a : u8)
{
    draw_command_line := Draw_Command_Line {
        x1 = x1, y1 = y1, x2 = x2, y2 = y2, thick = thick, color = { r, g, b, a }, 
    }
    append_elem(&state.draw_commands, draw_command_line)
}


draw :: proc() {

    // draw background color
    // rl.ClearBackground(COLOR_BG)
    draw_clear(COLOR_BG.r, COLOR_BG.g, COLOR_BG.b, COLOR_BG.a)
    // draw checkered background
    color1 := [4]u8 {209/2, 113/2, 52/2, 255}
    color2 := [4]u8 {97/2, 40/2, 21/2, 255}

    for x in 0..=GRID_SIZE 
    {
        for y in 0..=GRID_SIZE 
        {
            color : [4]u8
            if (x + y) % 2 == 0 
            {
                color = color1
            } 
            else 
            {
                color = color2
            }
            draw_rectangle(
                f32(x * CELL_RENDER_SIZE), 
                f32(y * CELL_RENDER_SIZE), 
                f32(CELL_RENDER_SIZE), 
                f32(CELL_RENDER_SIZE), 
                color.r,
                color.g,
                color.b,
                color.a,
            )
        }
    }

    // draw food
    draw_rectangle(
        f32(food_cell.x * CELL_RENDER_SIZE), 
        f32(food_cell.y * CELL_RENDER_SIZE), 
        f32(CELL_RENDER_SIZE), 
        f32(CELL_RENDER_SIZE),
        color_food.r,
        color_food.g,
        color_food.b,
        color_food.a,
    )

    // head
    draw_rectangle(
        f32(snake_cells[snake_head_index].x * CELL_RENDER_SIZE), 
        f32(snake_cells[snake_head_index].y * CELL_RENDER_SIZE), 
        f32(CELL_RENDER_SIZE), 
        f32(CELL_RENDER_SIZE), 
        COLOR_SNAKE_HEAD.r,
        COLOR_SNAKE_HEAD.g,
        COLOR_SNAKE_HEAD.b,
        COLOR_SNAKE_HEAD.a,
    )

    //tail
    tail_cells : []Cell
    if snake_head_index > 0 do tail_cells = snake_cells[0 : snake_head_index ]
    for cell in tail_cells {
        draw_rectangle(
            f32(cell.x * CELL_RENDER_SIZE), 
            f32(cell.y * CELL_RENDER_SIZE), 
            f32(CELL_RENDER_SIZE), 
            f32(CELL_RENDER_SIZE), 
            COLOR_SNAKE_TAIL.r,
            COLOR_SNAKE_TAIL.g,
            COLOR_SNAKE_TAIL.b,
            COLOR_SNAKE_TAIL.a,
        )
    }

    // draw border 

    // top border
    draw_rectangle(0, 0, f32(WINDOW_SIZE), f32(CELL_RENDER_SIZE * BORDER_CELL_PADDING), COLOR_BORDER.r,COLOR_BORDER.g,COLOR_BORDER.b,COLOR_BORDER.a)
    // bottom border
    draw_rectangle(0, f32(WINDOW_SIZE - CELL_RENDER_SIZE * BORDER_CELL_PADDING), f32(WINDOW_SIZE), f32(CELL_RENDER_SIZE * BORDER_CELL_PADDING),  COLOR_BORDER.r,COLOR_BORDER.g,COLOR_BORDER.b,COLOR_BORDER.a)
    // left border
    draw_rectangle(0, 0, f32(CELL_RENDER_SIZE * BORDER_CELL_PADDING), f32(WINDOW_SIZE),  COLOR_BORDER.r,COLOR_BORDER.g,COLOR_BORDER.b,COLOR_BORDER.a)
    // right border
    draw_rectangle(f32(WINDOW_SIZE - CELL_RENDER_SIZE * BORDER_CELL_PADDING), 0, f32(CELL_RENDER_SIZE * BORDER_CELL_PADDING), f32(WINDOW_SIZE),  COLOR_BORDER.r,COLOR_BORDER.g,COLOR_BORDER.b,COLOR_BORDER.a)

    // draw grid
    // for x in 0..=GRID_SIZE {
    //     rl.DrawLine(x * CELL_RENDER_SIZE, 0, x * CELL_RENDER_SIZE, WINDOW_SIZE, COLOR_GRID)
    // }
    // for y in 0..=GRID_SIZE {
    //     rl.DrawLine(0, y * CELL_RENDER_SIZE, WINDOW_SIZE, y * CELL_RENDER_SIZE, COLOR_GRID)
    // }

    // draw debug ui
    // x :i32 = 10
    // y :i32 = 10
    // y_padding_between_elements : i32 = 20
    
    // x, y = debug_draw_snake_movement_direction(x, y)
    // y += y_padding_between_elements
    // x, y = debug_draw_input_keydowns(x, y)
    // y += y_padding_between_elements
    // debug_draw_input_keys_pressed_array(x, y)

}
