package game

import "core:strings"

import "core:fmt"
import "core:slice"
import "core:math/rand"

/*************
* STRUCTS
**************/
Cell :: struct {
    x: i32,
    y: i32,
}

Direction :: enum{
    UP,
    DOWN,
    LEFT,
    RIGHT,
}



/*************
* CONSTANTS
**************/
GRID_SIZE             : i32 : 20
NUM_CELLS             : i32 : GRID_SIZE * GRID_SIZE // 400
CELL_RENDER_SIZE      : i32 :  32
GRID_LINE_RENDER_SIZE : i32 : 2
BORDER_CELL_PADDING   : i32 : 1 // how many cells to pad the border of the window by 
WINDOW_SIZE           : i32 : (GRID_SIZE) * CELL_RENDER_SIZE // 640 

// colors
COLOR_SNAKE_HEAD := [4]u8{126, 121, 245, 255}
COLOR_SNAKE_TAIL := [4]u8{105, 87, 243, 255} 
color_food       := [4]u8 {59, 178, 78, 255}
COLOR_GRID       := [4]u8{60, 60, 60, 255}
COLOR_BG         := [4]u8{0, 0, 0, 255}
COLOR_BORDER     := [4]u8{19, 113, 53, 255}

/*************
* GLOBAL VARIABLES
**************/
snake_cells             : [NUM_CELLS]Cell
snake_head_index        : i32 = 0
snake_movement_direction: Direction = Direction.RIGHT

food_cell : Cell = Cell{5, 5}

frames_total_before_move         : i32 = 12
frames_num_remaining_before_move : i32 = frames_total_before_move

input_keys_pressed_down : [4]Keyboard_Key
input_num_keys_pressed_down : i32 = 0
input_key_active_index : i32 : 0




input_keys_pressed_down_add_as_active :: proc(key: Keyboard_Key) {
    if input_num_keys_pressed_down == 0 {
        input_keys_pressed_down[input_key_active_index] = key
        input_num_keys_pressed_down += 1
    }
    else {
        // if key is first element, do nothing
        if input_keys_pressed_down[0] == key {
            return
        }
        input_keys_pressed_down_remove_if_exists(key)

        // shift all elements in array to right
        for i := input_num_keys_pressed_down - 1; i >= 0; i -= 1 {
            input_keys_pressed_down[i + 1] = input_keys_pressed_down[i]
        }

        // place key
        input_keys_pressed_down[0] = key
        input_num_keys_pressed_down += 1
    }
}

input_keys_pressed_down_remove_if_exists :: proc(key: Keyboard_Key) {
    for i in 0..<input_num_keys_pressed_down {
        if input_keys_pressed_down[i] == key {
            for j in i..<input_num_keys_pressed_down {
                input_keys_pressed_down[j] = input_keys_pressed_down[j + 1]
            }
            input_num_keys_pressed_down -= 1
        }
        
    }
}


// input procedures
input :: proc() {
    
    // modify array of keys pressed down based on current keyboard state
    if keyboard_key_is_just_pressed(.UP) && snake_movement_direction != Direction.DOWN && snake_movement_direction != Direction.UP
    {
        input_keys_pressed_down_add_as_active(.UP)
    }
    else if keyboard_key_is_just_released(.UP) {
        input_keys_pressed_down_remove_if_exists(.UP)
    }
    
    if keyboard_key_is_just_pressed(.DOWN) && snake_movement_direction != Direction.UP && snake_movement_direction != Direction.DOWN
    {
        input_keys_pressed_down_add_as_active(.DOWN)
    }
    else if keyboard_key_is_just_released(.DOWN) {
        input_keys_pressed_down_remove_if_exists(.DOWN)
    }

    if keyboard_key_is_just_pressed(.LEFT) && snake_movement_direction != Direction.RIGHT && snake_movement_direction != Direction.LEFT
    {
        input_keys_pressed_down_add_as_active(.LEFT)
    }
    else if keyboard_key_is_just_released(.LEFT) {
        input_keys_pressed_down_remove_if_exists(.LEFT)
    }

    if keyboard_key_is_just_pressed(.RIGHT) && snake_movement_direction != Direction.LEFT && snake_movement_direction != Direction.RIGHT
    {
        input_keys_pressed_down_add_as_active(.RIGHT)
    }
    else if keyboard_key_is_just_released(.RIGHT) {
        input_keys_pressed_down_remove_if_exists(.RIGHT)
    }

    // set direction of snake based on most recent key pressed down
    if input_num_keys_pressed_down > 0 {
        if input_keys_pressed_down[input_key_active_index] == .UP {
            snake_movement_direction = Direction.UP
        }
        else if input_keys_pressed_down[input_key_active_index] == .DOWN {
            snake_movement_direction = Direction.DOWN
        }
        else if input_keys_pressed_down[input_key_active_index] == .LEFT {
            snake_movement_direction = Direction.LEFT
        }
        else if input_keys_pressed_down[input_key_active_index] == .RIGHT {
            snake_movement_direction = Direction.RIGHT
        }
    }
}


gameplay_reset :: proc() {
    frames_num_remaining_before_move = frames_total_before_move
    snake_cells[0] = Cell{GRID_SIZE / 2, GRID_SIZE / 2}
    snake_cells[1] = Cell{GRID_SIZE / 2 + 1, GRID_SIZE / 2}
    snake_cells[2] = Cell{GRID_SIZE / 2 + 2, GRID_SIZE / 2}
    snake_head_index = 2
    snake_movement_direction = Direction.RIGHT
    food_cell = Cell{5, 5}
}


gameplay_food_on_invalid_cell :: proc() -> bool {
    // check if food is on a cell that is occupied by snake
    for i in 0..=snake_head_index {
        if snake_cells[i] == food_cell {
            return true
        }
    }

    return false
}

Rectangle :: struct
{
    x, y, w, h : f32
}




State :: struct
{
    view_w, view_h : f32,
    keyboard_state_current : #sparse[Keyboard_Key]bool,
    keyboard_state_previous : #sparse[Keyboard_Key]bool,
    draw_commands : [dynamic]Draw_Command,
}


state : State


set_inputs :: proc(up, down, left, right, start : bool)
{
    state.keyboard_state_current[.UP] = up
    state.keyboard_state_current[.DOWN] = down
    state.keyboard_state_current[.LEFT] = left
    state.keyboard_state_current[.RIGHT] = right
    state.keyboard_state_current[.RETURN] = start

}

update :: proc() -> (draw_commands : []Draw_Command, still_running : bool)
{
    clear(&state.draw_commands)

    frames_num_remaining_before_move -= 1

    should_process_gameplay := frames_num_remaining_before_move <= 0

    input()

    if should_process_gameplay 
    {
        snake_next_cell := Cell{}

        switch snake_movement_direction 
        {
            case Direction.UP: snake_next_cell = Cell{snake_cells[snake_head_index].x, snake_cells[snake_head_index].y - 1}
            case Direction.DOWN: snake_next_cell = Cell{snake_cells[snake_head_index].x, snake_cells[snake_head_index].y + 1}
            case Direction.LEFT: snake_next_cell = Cell{snake_cells[snake_head_index].x - 1, snake_cells[snake_head_index].y}
            case Direction.RIGHT: snake_next_cell = Cell{snake_cells[snake_head_index].x + 1, snake_cells[snake_head_index].y}
        }

        will_snake_eat_food_on_next_move := snake_next_cell == food_cell

        if will_snake_eat_food_on_next_move 
        {
            snake_head_index += 1
            snake_cells[snake_head_index] = food_cell

            // // FIX THIS
            // food_cell = Cell{
            //     BORDER_CELL_PADDING + (rand.int31() % GRID_SIZE - 1 - BORDER_CELL_PADDING),
            //     BORDER_CELL_PADDING + (rand.int31() % GRID_SIZE - 1 - BORDER_CELL_PADDING)
            // }

            min := BORDER_CELL_PADDING
            max := GRID_SIZE - 1 - BORDER_CELL_PADDING
            food_cell = Cell{
                min + (rand.int31() % (max - min + 1)),
                min + (rand.int31() % (max - min + 1)),
            }

            for gameplay_food_on_invalid_cell() 
            {
                next_cell_for_attempt_food_placement := Cell{food_cell.x + 1, food_cell.y}
                if next_cell_for_attempt_food_placement.x >= GRID_SIZE - BORDER_CELL_PADDING 
                {
                    next_cell_for_attempt_food_placement = Cell{BORDER_CELL_PADDING, next_cell_for_attempt_food_placement.y}
                }
                if next_cell_for_attempt_food_placement.y >= GRID_SIZE - BORDER_CELL_PADDING 
                {
                    next_cell_for_attempt_food_placement = Cell{next_cell_for_attempt_food_placement.x, BORDER_CELL_PADDING}
                }
                food_cell = next_cell_for_attempt_food_placement
            }
        } 
        else 
        {
            for i in 0..<snake_head_index 
            {
                snake_cells[i] = snake_cells[i + 1]
            }
            switch snake_movement_direction 
            {
                case Direction.UP: snake_cells[snake_head_index].y -= 1
                case Direction.DOWN: snake_cells[snake_head_index].y += 1
                case Direction.LEFT: snake_cells[snake_head_index].x -= 1
                case Direction.RIGHT: snake_cells[snake_head_index].x += 1
            }
        }

        did_snake_go_out_of_bounds := snake_cells[snake_head_index].x < BORDER_CELL_PADDING ||
            snake_cells[snake_head_index].x >= GRID_SIZE - BORDER_CELL_PADDING ||
            snake_cells[snake_head_index].y < BORDER_CELL_PADDING ||
            snake_cells[snake_head_index].y >= GRID_SIZE - BORDER_CELL_PADDING

        did_snake_head_collide_with_tail := false

        for i in 0..<snake_head_index 
        {
            head_cell := snake_cells[snake_head_index]
            this_tail_cell := snake_cells[i]

            did_snake_head_collide_with_tail |= head_cell == this_tail_cell         
        }

        did_snake_die_this_frame := did_snake_go_out_of_bounds || did_snake_head_collide_with_tail

        if did_snake_die_this_frame
        {
            fmt.println("You died!")
            gameplay_reset()
        }

        frames_num_remaining_before_move = frames_total_before_move

    }

    draw()
    
    free_all(context.temp_allocator)

    for key_state, i in state.keyboard_state_current
    {
        state.keyboard_state_previous[i] = key_state
    }

    draw_commands = state.draw_commands[:len(state.draw_commands)]
    still_running = true
    return 
}


set_view_size :: proc(w, h : f32)
{
    state.view_w = w
    state.view_h = h
}


initialize :: proc()
{
    gameplay_reset()
}
