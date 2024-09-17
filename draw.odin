package snake

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"


debug_draw_input_keydowns :: proc() {
    x_start_text_draw : i32 = 10
    y_start_text_draw : i32 = 10
    
    x : i32 = x_start_text_draw
    y : i32 = y_start_text_draw

    keyboard_up_str    : string = "rl.KeyboardKey.UP"
    keyboard_down_str  : string = "rl.KeyboardKey.DOWN"
    keyboard_left_str  : string = "rl.KeyboardKey.LEFT"
    keyboard_right_str : string = "rl.KeyboardKey.RIGHT"

    key_down_str : string = "down"
    key_up_str   : string = "up"

    padding : i32 : 20

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

    debug_draw_input_keydowns()
    
    rl.EndDrawing()
}
