package snake

import rl "vendor:raylib"

input_keys_pressed_down : [4]rl.KeyboardKey
input_num_keys_pressed_down : i32 = 0
input_key_active_index : i32 : 0

input_keys_pressed_down_add_as_active :: proc(key: rl.KeyboardKey) {
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

input_keys_pressed_down_remove_if_exists :: proc(key: rl.KeyboardKey) {
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
    if rl.IsKeyPressed(rl.KeyboardKey.UP) && snake_movement_direction != Direction.DOWN && snake_movement_direction != Direction.UP
    {
        input_keys_pressed_down_add_as_active(rl.KeyboardKey.UP)
    }
    else if rl.IsKeyReleased(rl.KeyboardKey.UP) {
        input_keys_pressed_down_remove_if_exists(rl.KeyboardKey.UP)
    }
    
    if rl.IsKeyPressed(rl.KeyboardKey.DOWN) && snake_movement_direction != Direction.UP && snake_movement_direction != Direction.DOWN
    {
        input_keys_pressed_down_add_as_active(rl.KeyboardKey.DOWN)
    }
    else if rl.IsKeyReleased(rl.KeyboardKey.DOWN) {
        input_keys_pressed_down_remove_if_exists(rl.KeyboardKey.DOWN)
    }

    if rl.IsKeyPressed(rl.KeyboardKey.LEFT) && snake_movement_direction != Direction.RIGHT && snake_movement_direction != Direction.LEFT
    {
        input_keys_pressed_down_add_as_active(rl.KeyboardKey.LEFT)
    }
    else if rl.IsKeyReleased(rl.KeyboardKey.LEFT) {
        input_keys_pressed_down_remove_if_exists(rl.KeyboardKey.LEFT)
    }

    if rl.IsKeyPressed(rl.KeyboardKey.RIGHT) && snake_movement_direction != Direction.LEFT && snake_movement_direction != Direction.RIGHT
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