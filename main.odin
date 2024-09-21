package snake

import "core:fmt"
import "core:strings"

import rl "vendor:raylib"

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