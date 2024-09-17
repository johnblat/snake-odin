package snake

import "core:fmt"
import "core:strings"

import rl "vendor:raylib"


// input procedures
input :: proc() {
    new_direction := snake_movement_direction

    if rl.IsKeyDown(rl.KeyboardKey.UP) && snake_movement_direction != Direction.DOWN && snake_movement_direction != Direction.UP {
        snake_movement_direction = Direction.UP
    } 
    else if rl.IsKeyDown(rl.KeyboardKey.DOWN) && snake_movement_direction != Direction.UP && snake_movement_direction != Direction.DOWN {
        snake_movement_direction = Direction.DOWN
    } 
    else if rl.IsKeyDown(rl.KeyboardKey.LEFT) && snake_movement_direction != Direction.RIGHT && snake_movement_direction != Direction.LEFT {
        snake_movement_direction = Direction.LEFT
    } 
    else if rl.IsKeyDown(rl.KeyboardKey.RIGHT) && snake_movement_direction != Direction.LEFT && snake_movement_direction != Direction.RIGHT {
        snake_movement_direction = Direction.RIGHT
    }
}


// main procedure

main :: proc() {
    // raylib setup
    rl.SetConfigFlags({.VSYNC_HINT })
    rl.InitWindow(WINDOW_SIZE, WINDOW_SIZE, "snake")
    rl.SetTargetFPS(60)

    // gameplay setup
    gameplay_reset()

    // game loop
    for !rl.WindowShouldClose() {
        input()
        gameplay()
        draw()
        free_all(context.temp_allocator)

    }

    rl.CloseWindow()

}