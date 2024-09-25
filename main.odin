package snake

import "core:fmt"
import "core:strings"

import rl "vendor:raylib"
import imgui_rl "imgui_impl_raylib"
import imgui "odin-imgui"

main :: proc() {
    // raylib setup

    rl.SetConfigFlags({.VSYNC_HINT })
    rl.InitWindow(WINDOW_SIZE, WINDOW_SIZE, "snake")
    rl.SetTargetFPS(60)
    defer rl.CloseWindow()

    // imgui setup

    imgui.CreateContext()
    defer imgui.DestroyContext()
    
    imgui_rl.init()
    defer imgui_rl.shutdown()

    imgui_rl.build_font_atlas()
    

    // gameplay setup

    gameplay_reset()

    // game loop

    for !rl.WindowShouldClose() {
        imgui_rl.process_events()
        imgui_rl.new_frame()
        imgui.NewFrame()

        input()
        gameplay()
        draw()
        
        free_all(context.temp_allocator)
    }

}