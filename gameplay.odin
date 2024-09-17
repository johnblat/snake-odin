package snake

import "core:fmt"
import rl "vendor:raylib"


gameplay :: proc() {
    frames_num_remaining_before_move -= 1
    if frames_num_remaining_before_move > 0 {
        return
    }
    if gameplay_will_snake_eat_food_on_next_move() {
        gameplay_snake_move_to_eat_food()
    } else {
        gameplay_snake_move()
    }
    if gameplay_did_snake_die() {
        fmt.println("You died!")
        gameplay_reset()
    }
    
    frames_num_remaining_before_move = frames_total_before_move
    
}

gameplay_snake_move :: proc() {
    for i in 0..<snake_head_index {
        snake_cells[i] = snake_cells[i + 1]
    }
    switch snake_movement_direction {
        case Direction.UP: snake_cells[snake_head_index].y -= 1
        case Direction.DOWN: snake_cells[snake_head_index].y += 1
        case Direction.LEFT: snake_cells[snake_head_index].x -= 1
        case Direction.RIGHT: snake_cells[snake_head_index].x += 1
    }
}

gameplay_will_snake_eat_food_on_next_move :: proc() -> bool {
    next_cell : Cell
    switch snake_movement_direction {
        case Direction.UP: next_cell = Cell{snake_cells[snake_head_index].x, snake_cells[snake_head_index].y - 1}
        case Direction.DOWN: next_cell = Cell{snake_cells[snake_head_index].x, snake_cells[snake_head_index].y + 1}
        case Direction.LEFT: next_cell = Cell{snake_cells[snake_head_index].x - 1, snake_cells[snake_head_index].y}
        case Direction.RIGHT: next_cell = Cell{snake_cells[snake_head_index].x + 1, snake_cells[snake_head_index].y}
    }
    return next_cell == food_cell
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

gameplay_next_cell_wrap :: proc(cell: Cell) -> Cell {
    // get the next cell in the grid not on border and wrap to Cell{BORDER_CELL_PADDING, BORDER_CELL_PADDING} if it reaches the end
    next_cell := Cell{cell.x + 1, cell.y}
    if next_cell.x >= GRID_SIZE - BORDER_CELL_PADDING {
        next_cell = Cell{BORDER_CELL_PADDING, next_cell.y}
    }
    if next_cell.y >= GRID_SIZE - BORDER_CELL_PADDING {
        next_cell = Cell{next_cell.x, BORDER_CELL_PADDING}
    }
    return next_cell    
}

gameplay_snake_move_to_eat_food :: proc() {
    snake_head_index += 1
    snake_cells[snake_head_index] = food_cell

    food_cell = Cell{
        rl.GetRandomValue(BORDER_CELL_PADDING, GRID_SIZE - 1 - BORDER_CELL_PADDING ),
        rl.GetRandomValue(BORDER_CELL_PADDING, GRID_SIZE - 1 - BORDER_CELL_PADDING )
    }
    for gameplay_food_on_invalid_cell() {
        food_cell = gameplay_next_cell_wrap(food_cell)
    }
}

gameplay_did_snake_die :: proc() -> bool {
    // check if snake head is out of bounds
    if snake_cells[snake_head_index].x < BORDER_CELL_PADDING ||
    snake_cells[snake_head_index].x >= GRID_SIZE - BORDER_CELL_PADDING ||
    snake_cells[snake_head_index].y < BORDER_CELL_PADDING ||
    snake_cells[snake_head_index].y >= GRID_SIZE - BORDER_CELL_PADDING {
        return true
    }

    // check if snake head is colliding with tail
    for i in 0..<snake_head_index {
        if snake_cells[i] == snake_cells[snake_head_index] {
            return true
        }
    }
    return false
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