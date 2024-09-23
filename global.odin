package snake

import rl "vendor:raylib"

/*************
* CONSTANTS
**************/
GRID_SIZE             : i32 : 10
NUM_CELLS             : i32 : GRID_SIZE * GRID_SIZE // 400
CELL_RENDER_SIZE      : i32 :  32
GRID_LINE_RENDER_SIZE : i32 : 2
BORDER_CELL_PADDING   : i32 : 1 // how many cells to pad the border of the window by 
WINDOW_SIZE           : i32 : (GRID_SIZE) * CELL_RENDER_SIZE // 640 

// colors
COLOR_SNAKE_HEAD : rl.Color : rl.Color{0, 120, 255, 255}
COLOR_SNAKE_TAIL : rl.Color : rl.Color{0, 46, 255, 255} 
color_food       : rl.Color : rl.Color{216, 122, 27, 255}
COLOR_GRID       : rl.Color : rl.Color{60, 60, 60, 255}
COLOR_BG         : rl.Color : rl.Color{0, 0, 0, 255}
COLOR_BORDER     : rl.Color : COLOR_SNAKE_TAIL

/*************
* GLOBAL VARIABLES
**************/
snake_cells             : [NUM_CELLS]Cell
snake_head_index        : i32 = 0
snake_movement_direction: Direction = Direction.RIGHT

food_cell : Cell = Cell{5, 5}

frames_total_before_move         : i32 = 12
frames_num_remaining_before_move : i32 = frames_total_before_move
