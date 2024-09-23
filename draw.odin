package snake

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"


debug_draw_input_keydowns :: proc( x_offset, y_offset: i32) -> (x_end, y_end: i32) {
    x_start_text_draw : i32 = x_offset
    y_start_text_draw : i32 = y_offset
    padding : i32 : 20
    
    x : i32 = x_start_text_draw
    y : i32 = y_start_text_draw

    keyboard_up_str    : string = "rl.KeyboardKey.UP"
    keyboard_down_str  : string = "rl.KeyboardKey.DOWN"
    keyboard_left_str  : string = "rl.KeyboardKey.LEFT"
    keyboard_right_str : string = "rl.KeyboardKey.RIGHT"

    key_down_str : string = "down"
    key_up_str   : string = "up"

    // draw current state of each key
    if rl.IsKeyDown(rl.KeyboardKey.UP) {
        str := strings.concatenate([]string{keyboard_up_str, ": ", key_down_str})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    
    } else {
        str := strings.concatenate([]string{keyboard_up_str, ": ",  key_up_str})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    }

    y += padding

    if rl.IsKeyDown(rl.KeyboardKey.DOWN) {
        str := strings.concatenate([]string{keyboard_down_str, ": ", key_down_str})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    
    } else {
        str := strings.concatenate([]string{keyboard_down_str, ": ",  key_up_str})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    }

    y += padding

    if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
        str := strings.concatenate([]string{keyboard_left_str, ": ", key_down_str})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    
    } else {
        str := strings.concatenate([]string{keyboard_left_str, ": ",  key_up_str})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    }

    y += padding

    if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
        str := strings.concatenate([]string{keyboard_right_str, ": ", key_down_str})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    
    } else {
        str := strings.concatenate([]string{keyboard_right_str, ": ",  key_up_str})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
    }

    x_end = x
    y_end = y + padding 

    return
}

debug_draw_input_keys_pressed_array :: proc(x_offset, y_offset: i32) -> (x_end, y_end: i32) {
    x_start_text_draw : i32 = x_offset
    y_start_text_draw : i32 = y_offset
    padding : i32 : 20
    
    x : i32 = x_start_text_draw
    y : i32 = y_start_text_draw

    keyboard_up_str    : string = "rl.KeyboardKey.UP"
    keyboard_down_str  : string = "rl.KeyboardKey.DOWN"
    keyboard_left_str  : string = "rl.KeyboardKey.LEFT"
    keyboard_right_str : string = "rl.KeyboardKey.RIGHT"

    // draw keys pressed down in array
    for i in 0..<input_num_keys_pressed_down {
        key := input_keys_pressed_down[i]
        key_str : string
        if key == rl.KeyboardKey.UP {
            key_str = keyboard_up_str
        } else if key == rl.KeyboardKey.DOWN {
            key_str = keyboard_down_str
        } else if key == rl.KeyboardKey.LEFT {
            key_str = keyboard_left_str
        } else if key == rl.KeyboardKey.RIGHT {
            key_str = keyboard_right_str
        }

        str := strings.concatenate([]string{"[", key_str, "]"})
        cstr := strings.clone_to_cstring(str)
        rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})
        y += padding
    }

    // increment y for padding for elements not present
    for _ in input_num_keys_pressed_down..<len(input_keys_pressed_down) {
        y += padding
    }

    x_end = x
    y_end = y + padding

    return
}

debug_draw_snake_movement_direction :: proc(x_offset, y_offset: i32) -> (x_end, y_end: i32) {
    x_start_text_draw : i32 = x_offset
    y_start_text_draw : i32 = y_offset
    padding : i32 : 20
    
    x : i32 = x_start_text_draw
    y : i32 = y_start_text_draw

    snake_movement_direction_label_str := "snake_movement_direction: "
    snake_movement_direction_up_str    := "Direction.UP"
    snake_movement_direction_down_str  := "Direction.DOWN"
    snake_movement_direction_left_str  := "Direction.LEFT"
    snake_movement_direction_right_str := "Direction.RIGHT"

    text: string
    if snake_movement_direction == Direction.UP {
        text = strings.concatenate([]string{snake_movement_direction_label_str, snake_movement_direction_up_str})
    } else if snake_movement_direction == Direction.DOWN {
        text = strings.concatenate([]string{snake_movement_direction_label_str, snake_movement_direction_down_str})
    } else if snake_movement_direction == Direction.LEFT {
        text = strings.concatenate([]string{snake_movement_direction_label_str, snake_movement_direction_left_str})
    } else if snake_movement_direction == Direction.RIGHT {
        text = strings.concatenate([]string{snake_movement_direction_label_str, snake_movement_direction_right_str})
    } else {
        text = strings.concatenate([]string{snake_movement_direction_label_str, "unknown"})
    }

    cstr := strings.clone_to_cstring(text)
    rl.DrawText(cstr, x, y, 20, rl.Color{255, 255, 255, 255})

    x_end = x
    y_end = y + padding

    return
}


// draw procedures

draw :: proc() {
    rl.BeginDrawing()

    // draw background color
    rl.ClearBackground(COLOR_BG)

    // draw food
    rl.DrawRectangle(
        food_cell.x * CELL_RENDER_SIZE, 
        food_cell.y * CELL_RENDER_SIZE, 
        CELL_RENDER_SIZE, 
        CELL_RENDER_SIZE, 
        color_food
    )

    //  draw snake

    // head
    rl.DrawRectangle(
        snake_cells[snake_head_index].x * CELL_RENDER_SIZE, 
        snake_cells[snake_head_index].y * CELL_RENDER_SIZE, 
        CELL_RENDER_SIZE, 
        CELL_RENDER_SIZE, 
        COLOR_SNAKE_HEAD
    )

    //tail
    tail_cells : []Cell
    if snake_head_index > 0 do tail_cells = snake_cells[0 : snake_head_index ]
    for cell in tail_cells {
        rl.DrawRectangle(
            cell.x * CELL_RENDER_SIZE, 
            cell.y * CELL_RENDER_SIZE, 
            CELL_RENDER_SIZE, 
            CELL_RENDER_SIZE, 
            COLOR_SNAKE_TAIL
        )
    }

    // draw border 

    // top border
    rl.DrawRectangle(0, 0, WINDOW_SIZE, CELL_RENDER_SIZE * BORDER_CELL_PADDING, COLOR_BORDER)
    // bottom border
    rl.DrawRectangle(0, WINDOW_SIZE - CELL_RENDER_SIZE * BORDER_CELL_PADDING, WINDOW_SIZE, CELL_RENDER_SIZE * BORDER_CELL_PADDING, COLOR_BORDER)
    // left border
    rl.DrawRectangle(0, 0, CELL_RENDER_SIZE * BORDER_CELL_PADDING, WINDOW_SIZE, COLOR_BORDER)
    // right border
    rl.DrawRectangle(WINDOW_SIZE - CELL_RENDER_SIZE * BORDER_CELL_PADDING, 0, CELL_RENDER_SIZE * BORDER_CELL_PADDING, WINDOW_SIZE, COLOR_BORDER)

    // draw grid
    for x in 0..=GRID_SIZE {
        rl.DrawLine(x * CELL_RENDER_SIZE, 0, x * CELL_RENDER_SIZE, WINDOW_SIZE, COLOR_GRID)
    }
    for y in 0..=GRID_SIZE {
        rl.DrawLine(0, y * CELL_RENDER_SIZE, WINDOW_SIZE, y * CELL_RENDER_SIZE, COLOR_GRID)
    }

    // draw debug ui
    // x :i32 = 10
    // y :i32 = 10
    // y_padding_between_elements : i32 = 20
    
    // x, y = debug_draw_snake_movement_direction(x, y)
    // y += y_padding_between_elements
    // x, y = debug_draw_input_keydowns(x, y)
    // y += y_padding_between_elements
    // debug_draw_input_keys_pressed_array(x, y)

    // end
    rl.EndDrawing()
}
