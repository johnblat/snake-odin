package snake

import "core:testing"
import rl "vendor:raylib"

@(test)
test_input_keys_pressed_down_as_active:: proc(t: ^testing.T) {
    // validate initial value is as expected
    testing.expect(t, input_num_keys_pressed_down == 0)

    // validate size and positions of keys pressed down

    // add keys
    err_input_arr_valf := "input_keys_pressed_down[%v] = %v"
    err_input_arr_len_valf := "input_num_keys_pressed_down = %v"

    input_keys_pressed_down_add_as_active(rl.KeyboardKey.UP)
    testing.expectf(t, input_num_keys_pressed_down == 1, err_input_arr_len_valf, 0, input_num_keys_pressed_down)
    testing.expectf(t, input_keys_pressed_down[0] == rl.KeyboardKey.UP, err_input_arr_valf, 0, input_keys_pressed_down[0])

    input_keys_pressed_down_add_as_active(rl.KeyboardKey.DOWN)
    testing.expectf(t, input_num_keys_pressed_down == 2, err_input_arr_len_valf, 0, input_num_keys_pressed_down)


    testing.expectf(t, input_keys_pressed_down[0] == rl.KeyboardKey.DOWN, err_input_arr_valf, 0, input_keys_pressed_down[0])
    testing.expectf(t, input_keys_pressed_down[1] == rl.KeyboardKey.UP,   err_input_arr_valf, 1, input_keys_pressed_down[1])

    input_keys_pressed_down_add_as_active(rl.KeyboardKey.LEFT)
    testing.expect(t, input_num_keys_pressed_down == 3)
    testing.expectf(t, input_keys_pressed_down[0] == rl.KeyboardKey.LEFT, err_input_arr_valf, 0, input_keys_pressed_down[0])
    testing.expectf(t, input_keys_pressed_down[1] == rl.KeyboardKey.DOWN, err_input_arr_valf, 1, input_keys_pressed_down[1])
    testing.expectf(t, input_keys_pressed_down[2] == rl.KeyboardKey.UP,   err_input_arr_valf, 2, input_keys_pressed_down[2])
}