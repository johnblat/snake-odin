package snake

import rl "vendor:raylib"

// input key stack of keyboard keys pressed in the order they were pressed

// input_key_stack : []rl.KeyboardKey
// input_key_stack_len : i32 = 0

// input_key_stack_peek :: proc() -> rl.KeyboardKey {
//     key := input_key_stack[0]
//     return key
// }

// input_key_stack_push :: proc(key: rl.KeyboardKey) {
//     input_key_stack[input_key_stack_len] = key
//     input_key_stack_len += 1
// }

// input_key_stack_pop :: proc() -> rl.KeyboardKey {
//     key := key_stack[0]
//     key_stack_len -= 1
//     for i in 0..<key_stack_len {
//         key_stack[i] = key_stack[i + 1]
//     }
//     return key
// }

input_keys_pressed_down : [4]rl.KeyboardKey
input_num_keys_pressed_down : i32 = 0
input_key_active_index : i32 : 0

input_keys_pressed_down_add_as_active :: proc(key: rl.KeyboardKey) {
    if input_num_keys_pressed_down == 0 {
        input_keys_pressed_down[input_key_active_index] = key
        input_num_keys_pressed_down += 1
    }
    else {
        input_keys_pressed_down_remove_if_exists(key)
        for i in 0..<input_num_keys_pressed_down {
            input_keys_pressed_down[i + 1] = input_keys_pressed_down[i]
        }
        input_keys_pressed_down[0] = key
        input_num_keys_pressed_down += 1
    }
}

input_keys_pressed_down_remove_if_exists :: proc(key: rl.KeyboardKey) {
    for i in 0..<input_num_keys_pressed_down {
        if input_keys_pressed_down[i] == key {
            for j in i..<input_num_keys_pressed_down {
                input_keys_pressed_down[j] = input_keys_pressed_down[j + 1]
            }
        }
        input_num_keys_pressed_down -= 1
    }
}



// input procedures
input :: proc() {
    
    // modify array of keys pressed down based on current keyboard state
    if rl.IsKeyDown(rl.KeyboardKey.UP) && snake_movement_direction != Direction.DOWN && snake_movement_direction != Direction.UP
    {
        input_keys_pressed_down_add_as_active(rl.KeyboardKey.UP)
    }
    else if rl.IsKeyReleased(rl.KeyboardKey.UP) {
        input_keys_pressed_down_remove_if_exists(rl.KeyboardKey.UP)
    }
    
    if rl.IsKeyDown(rl.KeyboardKey.DOWN) && snake_movement_direction != Direction.UP && snake_movement_direction != Direction.DOWN
    {
        input_keys_pressed_down_add_as_active(rl.KeyboardKey.DOWN)
    }
    else if rl.IsKeyReleased(rl.KeyboardKey.DOWN) {
        input_keys_pressed_down_remove_if_exists(rl.KeyboardKey.DOWN)
    }

    if rl.IsKeyDown(rl.KeyboardKey.LEFT) && snake_movement_direction != Direction.RIGHT && snake_movement_direction != Direction.LEFT
    {
        input_keys_pressed_down_add_as_active(rl.KeyboardKey.LEFT)
    }
    else if rl.IsKeyReleased(rl.KeyboardKey.LEFT) {
        input_keys_pressed_down_remove_if_exists(rl.KeyboardKey.LEFT)
    }

    if rl.IsKeyDown(rl.KeyboardKey.RIGHT) && snake_movement_direction != Direction.LEFT && snake_movement_direction != Direction.RIGHT
    {
        input_keys_pressed_down_add_as_active(rl.KeyboardKey.RIGHT)
    }
    else if rl.IsKeyReleased(rl.KeyboardKey.RIGHT) {
        input_keys_pressed_down_remove_if_exists(rl.KeyboardKey.RIGHT)
    }

    // set direction of snake based on most recent key pressed down
    if input_num_keys_pressed_down > 0 {
        if input_keys_pressed_down[input_key_active_index] == rl.KeyboardKey.UP {
            snake_movement_direction = Direction.UP
        }
        else if input_keys_pressed_down[input_key_active_index] == rl.KeyboardKey.DOWN {
            snake_movement_direction = Direction.DOWN
        }
        else if input_keys_pressed_down[input_key_active_index] == rl.KeyboardKey.LEFT {
            snake_movement_direction = Direction.LEFT
        }
        else if input_keys_pressed_down[input_key_active_index] == rl.KeyboardKey.RIGHT {
            snake_movement_direction = Direction.RIGHT
        }
    }
}