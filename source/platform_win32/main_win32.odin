package platform_win32

import windows "core:sys/windows"
import "core:mem"
import "core:fmt"
import game "../game"
import "core:c"

State :: struct {
    running: bool,
    width, height: i32,
    hdc: windows.HDC,
    hwnd: windows.HWND,
    backbuffer: []u32,
    bitmap_info: windows.BITMAPINFO,
}

state: State

process_input :: proc() -> (up, down, left, right, start: bool) {
    msg: windows.MSG
    for windows.PeekMessageW(&msg, nil, 0, 0, windows.PM_REMOVE) {
        if msg.message == windows.WM_QUIT {
            state.running = false
        }
        windows.TranslateMessage(&msg)
        windows.DispatchMessageW(&msg)
    }

    up = u16(windows.GetAsyncKeyState(windows.VK_UP)) & u16(0x8000) != 0
    down = u16(windows.GetAsyncKeyState(windows.VK_DOWN)) & u16(0x8000) != 0
    left = u16(windows.GetAsyncKeyState(windows.VK_LEFT)) & u16(0x8000) != 0
    right = u16(windows.GetAsyncKeyState(windows.VK_RIGHT)) & u16(0x8000) != 0
    start = u16(windows.GetAsyncKeyState(windows.VK_RETURN)) & u16(0x8000) != 0
    return
}

render_frame :: proc() {
    state.bitmap_info.bmiHeader.biSize = size_of(windows.BITMAPINFOHEADER)
    state.bitmap_info.bmiHeader.biWidth = state.width
    state.bitmap_info.bmiHeader.biHeight = -state.height // top-down
    state.bitmap_info.bmiHeader.biPlanes = 1
    state.bitmap_info.bmiHeader.biBitCount = 32
    state.bitmap_info.bmiHeader.biCompression = windows.BI_RGB

    windows.StretchDIBits(
        state.hdc,
        0, 0, state.width, state.height,
        0, 0, state.width, state.height,
        raw_data(state.backbuffer),
        &state.bitmap_info,
        windows.DIB_RGB_COLORS,
        windows.SRCCOPY,
    )
}

main :: proc() {
    state.width = game.WINDOW_SIZE
    state.height = game.WINDOW_SIZE

    class_name := windows.utf8_to_utf16("Snake Win32")
    title_utf16 := windows.utf8_to_utf16("Snake Win32")

    wc: windows.WNDCLASSW
    wc.style = windows.CS_OWNDC
    wc.lpfnWndProc = proc "std" (hwnd: windows.HWND, msg: u32, wparam: windows.WPARAM, lparam: windows.LPARAM) -> windows.LRESULT {
        switch msg {
        case windows.WM_DESTROY:
            state.running = false
            return 0
        case windows.WM_CLOSE:
            state.running = false
            return 0
        }
        return windows.DefWindowProcW(hwnd, msg, wparam, lparam)
    }
    wc.hInstance = windows.HANDLE(windows.GetModuleHandleA(nil))
    // wc.lpszClassName = windows.LPCWSTR(class_name)
    windows.RegisterClassW(&wc)


    state.hwnd = windows.CreateWindowExW(
        0,
        windows.LPCWSTR(&class_name[0]),
        windows.LPCWSTR(&title_utf16[0]),
        windows.WS_OVERLAPPEDWINDOW | windows.WS_VISIBLE,
        windows.CW_USEDEFAULT, windows.CW_USEDEFAULT,
        state.width, state.height,
        nil, nil, wc.hInstance, nil,
    )


    state.hdc = windows.GetDC(state.hwnd)

    state.running = true

    // allocate 32-bit BGRA buffer
    state.backbuffer = make([]u32, state.width * state.height)

    game.set_view_size(f32(state.width), f32(state.height))
    game.initialize()

    target_frame_time := 1.0 / 60.0

    freq: windows.LARGE_INTEGER
    windows.QueryPerformanceFrequency(&freq)

    last_time: windows.LARGE_INTEGER
    windows.QueryPerformanceCounter(&last_time)

    for state.running {
        start_time: windows.LARGE_INTEGER
        windows.QueryPerformanceCounter(&start_time)

        up, down, left, right, start := process_input()
        if start // just do something to close
        {
            state.running = false
        }
        game.set_inputs(up, down, left, right, start)

        draw_commands, still_running := game.update()
        if !still_running {
            break
        }

        // Clear frame
        for i in 0 ..< len(state.backbuffer){
            state.backbuffer[i] = 0x000000 // black
        }

        // Render game draw commands to the backbuffer
        for cmd in draw_commands {
            switch dc in cmd {
                case game.Draw_Command_Clear:
                {
                    color := dc.color
                    fill_color := (u32(color.a)<<24) | (u32(color.r)<<16) | (u32(color.g)<<8) | u32(color.b)
                    for i in 0 ..< len(state.backbuffer) {
                        state.backbuffer[i] = fill_color
                    }                
                }

                case game.Draw_Command_Rectangle:
                {
                    rect := dc.rectangle
                    color := (u32(dc.color.a)<<24) | (u32(dc.color.r)<<16) | (u32(dc.color.g)<<8) | u32(dc.color.b)
                    x0 := i32(rect.x)
                    y0 := i32(rect.y)
                    x1 := x0 + i32(rect.w)
                    y1 := y0 + i32(rect.h)
                    for y in y0 ..< y1 {
                        if y < 0 || y >= state.height do continue
                        for x in x0 ..< x1 {
                            if x < 0 || x >= state.width do continue
                            state.backbuffer[y*state.width + x] = color
                        }
                    }                    
                }
                case game.Draw_Command_Line: {}
            }
        }

        render_frame()

        // frame timing
        end_time: windows.LARGE_INTEGER
        windows.QueryPerformanceCounter(&end_time)
        elapsed := f64(end_time - start_time) / f64(freq)

        // sleep if we’re faster than target
        if elapsed < target_frame_time {
            sleep_ms := cast(u32)((target_frame_time - elapsed) * 1000.0)
            windows.Sleep(sleep_ms)
        }

        // update last_time
        last_time = start_time
    }

    windows.ReleaseDC(state.hwnd, state.hdc)
    windows.DestroyWindow(state.hwnd)
}