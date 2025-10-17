package platform_x11_opengl_linux

import "base:runtime"
import "vendor:egl"
import "vendor:x11/xlib"
import gl "vendor:OpenGL"
import "core:fmt"
import "core:time"
import "../game"

shared_context : runtime.Context

main :: proc()
{
    shared_context = context
    dpy := xlib.OpenDisplay(nil)
    assert(dpy != nil, "Cannot open X display")

    window := xlib.CreateWindow(
        display = dpy,
        parent = xlib.DefaultRootWindow(dpy),
        x = 0,
        y = 0,
        width = u32(game.WINDOW_SIZE),
        height = u32(game.WINDOW_SIZE),
        bordersz = 0,
        depth = 0,
        class = .InputOutput,
        visual = nil,
        attr_mask = {
            .CWEventMask
        },
        attr = &{
            event_mask = { .StructureNotify }
        },
    )
    assert(window != 0, "Failed to create window")

    // make the window fixed size
    {
        hints := xlib.AllocSizeHints()
        assert(hints != nil)
        defer xlib.Free(hints)

        hints.flags += { .PMinSize, .PMaxSize }
        hints.min_width = i32(game.WINDOW_SIZE)
        hints.max_width = i32(game.WINDOW_SIZE)
        hints.min_height = i32(game.WINDOW_SIZE)
        hints.max_height = i32(game.WINDOW_SIZE)
        xlib.SetWMNormalHints(dpy, window, hints)
    }

    xlib.SelectInput(dpy, window, { .KeyPress })
    xlib.StoreName(dpy, window, "Snake X11 OpenGL Linux")
    xlib.MapWindow(dpy, window)

    display : egl.Display
    {
        display = egl.GetPlatformDisplay(.X11_KHR, dpy, nil)
        assert(display != egl.NO_DISPLAY, "Cannot create EGL display")

        major, minor : i32
        assert(bool(egl.Initialize(display, &major, &minor)), "Cannot initialize EGL display")
        assert(!(major < 1 || (major == 1 && minor < 5)), "EGL version 1.5 or higher required")
    }

    assert(bool(egl.BindAPI(egl.OPENGL_API)), "Failed to select OpenGL API for EGL")

    ctx : egl.Context
    {
        attr : []i32 =
        {
            egl.CONTEXT_MAJOR_VERSION, 4,
            egl.CONTEXT_MINOR_VERSION, 6,
            egl.CONTEXT_OPENGL_PROFILE_MASK, egl.CONTEXT_OPENGL_CORE_PROFILE_BIT,
//            egl.CONTEXT_OPENGL_DEBUG, i32(true),
            egl.NONE,
        }
        NO_CONFIG_KHR :: egl.Config(uintptr(0))

        ctx = egl.CreateContext(display, NO_CONFIG_KHR, egl.NO_CONTEXT, raw_data(attr))
        assert(ctx != egl.NO_CONTEXT, "Cannot create EGL context, OpenGL 4.6 not supported?")
    }

    assert(bool(egl.MakeCurrent(display, egl.NO_SURFACE, egl.NO_SURFACE, ctx)), "Failed to make context current")

    surface : egl.Surface
    {
        configs : [64]egl.Config
        config_count : i32 = size_of(configs)/size_of(configs[0])
        {
            attr : []i32 = {
                egl.SURFACE_TYPE,      egl.WINDOW_BIT,
                egl.CONFORMANT,        egl.OPENGL_BIT,
                egl.RENDERABLE_TYPE,   egl.OPENGL_BIT,
                egl.COLOR_BUFFER_TYPE, egl.RGB_BUFFER,

                egl.RED_SIZE,      8,
                egl.GREEN_SIZE,    8,
                egl.BLUE_SIZE,     8,
                egl.DEPTH_SIZE,   24,
                egl.STENCIL_SIZE,  8,
                egl.NONE,
            }
            assert(
                bool(egl.ChooseConfig(
                    display,
                    raw_data(attr),
                    raw_data(configs[:]),
                    config_count,
                    &config_count
                )) &&
                config_count != 0,
                "Cannot choose EGL configs"
            )
        }

        for i : i32 = 0; i < config_count; i += 1
        {
            attr : []i32 =
            {
                egl.RENDER_BUFFER, egl.BACK_BUFFER,
                egl.NONE,
            }
            surface = egl.CreatePlatformWindowSurface(display, configs[i], &window, raw_data(attr))
            if surface != egl.NO_SURFACE
            {
                break
            }
        }

        assert(surface != egl.NO_SURFACE, "Cannot create EGL surface")
    }

    assert(bool(egl.MakeCurrent(display, surface, surface, ctx)), "Failed to make context current")

    gl.load_up_to(4, 6, egl.gl_set_proc_address)

    gl.DebugMessageCallback(proc "c" (
        source : u32,
        type : u32,
        id : u32,
        severity : u32,
        length : i32,
        message : cstring,
        userParam : rawptr
    )
    {
        context = shared_context
        fmt.printf("%v\n", message)
        if severity == gl.DEBUG_SEVERITY_HIGH || severity == gl.DEBUG_SEVERITY_MEDIUM
        {
            fmt.panicf("OpenGL API usage error! Use debugger to examine call stack!")
        }
    }, nil)
    gl.Enable(gl.DEBUG_OUTPUT_SYNCHRONOUS)

    Vertex :: struct
    {
        position : [3]f32,
        color    : [3]f32,
    }

    vbo_squares : u32
    gl.CreateBuffers(1, &vbo_squares)


    vao : u32
    {
        gl.CreateVertexArrays(1, &vao)

        vbuf_index : u32 = 0
        gl.VertexArrayVertexBuffer(vao, vbuf_index, vbo_squares, 0, size_of(Vertex))

        a_pos : u32 = 0
        gl.VertexArrayAttribFormat(vao, a_pos, 3, gl.FLOAT, false, u32(offset_of(Vertex, position)))
        gl.VertexArrayAttribBinding(vao, a_pos, vbuf_index)
        gl.EnableVertexArrayAttrib(vao, a_pos)

        a_color : u32 = 1
        gl.VertexArrayAttribFormat(vao, a_color, 3, gl.FLOAT, false, u32(offset_of(Vertex, color)))
        gl.VertexArrayAttribBinding(vao, a_color, vbuf_index)
        gl.EnableVertexArrayAttrib(vao, a_color)
    }

    pipeline : u32
    vshader : u32
    fshader : u32
    {
        glsl_vshader : cstring =
            "#version 450 core                             \n" +
            "                                              \n" +
            "layout (location=0) in vec3 a_pos;            \n" +
            "layout (location=1) in vec3 a_color;          \n" +
            "                                              \n" +
            "out gl_PerVertex { vec4 gl_Position; };       \n" +
            "out vec4 color;                               \n" +
            "                                              \n" +
            "void main()                                   \n" +
            "{                                             \n" +
            "    gl_Position = vec4(a_pos, 1);             \n" +
            "    color = vec4(a_color, 1);                 \n" +
            "}                                             \n"

        glsl_fshader : cstring =
            "#version 450 core                             \n" +
            "                                              \n" +
            "in vec4 color;                                \n" +
            "                                              \n" +
            "layout (location=0)                           \n" +
            "out vec4 o_color;                             \n" +
            "                                              \n" +
            "void main()                                   \n" +
            "{                                             \n" +
            "    o_color = color;                          \n" +
            "}                                             \n"

        vshader = gl.CreateShaderProgramv(gl.VERTEX_SHADER, 1, raw_data( []cstring {glsl_vshader}))
        fshader = gl.CreateShaderProgramv(gl.FRAGMENT_SHADER, 1, raw_data( []cstring {glsl_fshader}))

        linked : i32
        gl.GetProgramiv(vshader, gl.LINK_STATUS, &linked)
        if linked == 0
        {
            message_len : i32
            gl.GetProgramiv(vshader, gl.INFO_LOG_LENGTH, &message_len)
            message_buffer := make_slice([]u8, len = message_len)
            gl.GetProgramInfoLog(vshader, i32(len(message_buffer)), nil, raw_data(message_buffer))
            fmt.println(string(message_buffer))
            fmt.panicf("Failed to create vertex shader!\n")
        }

        gl.GetProgramiv(fshader, gl.LINK_STATUS, &linked)
        if linked == 0
        {
            message_len : i32
            gl.GetProgramiv(vshader, gl.INFO_LOG_LENGTH, &message_len)
            message_buffer := make_slice([]u8, len = message_len)
            gl.GetProgramInfoLog(vshader, i32(len(message_buffer)), nil, raw_data(message_buffer))
            fmt.println(string(message_buffer))
            fmt.panicf("Failed to create fragment shader!\n")
        }

        gl.GenProgramPipelines(1, &pipeline)
        gl.UseProgramStages(pipeline, gl.VERTEX_SHADER_BIT, vshader)
        gl.UseProgramStages(pipeline, gl.FRAGMENT_SHADER_BIT, fshader)
    }


    {
        gl.Enable(gl.BLEND)
        gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)
        gl.Disable(gl.DEPTH_TEST)
        gl.Disable(gl.CULL_FACE)
    }



    WM_PROTOCOLS := xlib.InternAtom(dpy, "WM_PROTOCOLS", false)
    WM_DELETE_WINDOW := xlib.InternAtom(dpy , "WM_DELETE_WINDOW", false)
    xlib.SetWMProtocols(dpy, window, &WM_DELETE_WINDOW, 1)


    delta_time := (1000 / 60) * time.Millisecond

    squares_verticies := make([dynamic]Vertex)
    defer delete(squares_verticies)

    for
    {
        free_all(context.temp_allocator)
        clear(&squares_verticies)

        start := time.tick_now()

        up_state := false
        down_state := false
        left_state := false
        right_state := false
        start_state := false

        for xlib.Pending(dpy) != 0\
        {
            event : xlib.XEvent
            xlib.NextEvent(dpy, &event)

            #partial switch event.type
            {
                case .KeyPress:
                    key := xlib.LookupKeysym(&event.xkey, 0)
                    up_state = key == .XK_Up
                    down_state = key == .XK_Down
                    left_state = key == .XK_Left
                    right_state = key == .XK_Right
                    start_state = key == .XK_Return

                    if key == .XK_Escape
                    {
                        return
                    }

                case .ClientMessage:
                    if event.xclient.message_type == WM_PROTOCOLS
                    {
                        protocol := event.xclient.data.l[0]
                        if xlib.Atom(protocol) == WM_DELETE_WINDOW
                        {
                            break
                        }
                    }
            }
            continue
        }

        game.set_inputs(up_state, down_state, left_state, right_state, start_state)

        draw_commands, still_running := game.update()
        if !still_running
        {
            return
        }

        for draw_command in draw_commands
        {
            switch dc in draw_command
            {
                case game.Draw_Command_Clear:
                {
                    color : [3]f32 =
                    {
                        f32(dc.color.r) / 255,
                        f32(dc.color.g) / 255,
                        f32(dc.color.b) / 255,
                    }
                    append(&squares_verticies, Vertex { {  1,  1,  0 }, color })
                    append(&squares_verticies, Vertex { {  1, -1,  0 }, color })
                    append(&squares_verticies, Vertex { { -1,  1,  0 }, color })

                    append(&squares_verticies, Vertex { { -1, -1,  0 }, color })
                    append(&squares_verticies, Vertex { { -1,  1,  0 }, color })
                    append(&squares_verticies, Vertex { {  1, -1,  0 }, color })
                }
                case game.Draw_Command_Line:
                {
                    color : [3]f32 =
                    {
                        f32(dc.color.r) / 255,
                        f32(dc.color.g) / 255,
                        f32(dc.color.b) / 255,
                    }

                    x0 := +((f32(dc.x1) / f32(game.WINDOW_SIZE)) * 2 - 1)
                    y0 := -((f32(dc.y1) / f32(game.WINDOW_SIZE)) * 2 - 1)
                    x1 := +((f32(dc.x2 + dc.thick) / f32(game.WINDOW_SIZE)) * 2 - 1)
                    y1 := -((f32(dc.y2 + dc.thick) / f32(game.WINDOW_SIZE)) * 2 - 1)

                    append(&squares_verticies, Vertex { { x0, y0, 0 }, color })
                    append(&squares_verticies, Vertex { { x1, y0, 0 }, color })
                    append(&squares_verticies, Vertex { { x0, y1, 0 }, color })

                    append(&squares_verticies, Vertex { { x1, y1,  0 }, color })
                    append(&squares_verticies, Vertex { { x1, y0,  0 }, color })
                    append(&squares_verticies, Vertex { { x0, y1,  0 }, color })

                }
                case game.Draw_Command_Rectangle:
                {
                    color : [3]f32 =
                    {
                        f32(dc.color.r) / 255,
                        f32(dc.color.g) / 255,
                        f32(dc.color.b) / 255,
                    }

                    x0 := +((f32(dc.rectangle.x) / f32(game.WINDOW_SIZE)) * 2 - 1)
                    y0 := -((f32(dc.rectangle.y) / f32(game.WINDOW_SIZE)) * 2 - 1)
                    x1 := +((f32(dc.rectangle.x + dc.rectangle.w) / f32(game.WINDOW_SIZE)) * 2 - 1)
                    y1 := -((f32(dc.rectangle.y + dc.rectangle.h) / f32(game.WINDOW_SIZE)) * 2 - 1)

                    append(&squares_verticies, Vertex { { x0, y0, 0 }, color })
                    append(&squares_verticies, Vertex { { x1, y0, 0 }, color })
                    append(&squares_verticies, Vertex { { x0, y1, 0 }, color })

                    append(&squares_verticies, Vertex { { x1, y1,  0 }, color })
                    append(&squares_verticies, Vertex { { x1, y0,  0 }, color })
                    append(&squares_verticies, Vertex { { x0, y1,  0 }, color })
                }
            }
        }

        gl.DrawBuffer(gl.BACK)
        gl.Viewport(0, 0, i32(game.WINDOW_SIZE), i32(game.WINDOW_SIZE))
        gl.Clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT | gl.STENCIL_BUFFER_BIT)

        if len(squares_verticies) > 0
        {
            gl.NamedBufferData(vbo_squares, size_of(Vertex) * cap(squares_verticies), raw_data(squares_verticies), gl.STREAM_DRAW)
            gl.BindProgramPipeline(pipeline)
            gl.BindVertexArray(vao)
            gl.DrawArrays(gl.TRIANGLES, 0, i32(len(squares_verticies)))
        }

        assert(bool(egl.SwapBuffers(display, surface)), "Failed to swap OpenGL buffers!")


        tick_since_start := time.tick_since(start)
        time.sleep(delta_time - tick_since_start)
    }
}
