
package dayN

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

import rl "vendor:raylib"

foreign {
    sscanf :: proc "c" (s, format: cstring, #c_vararg args: ..any) -> int ---
}

main :: proc() {
    data, ok := os.read_entire_file("input.txt")
    assert(ok)
    input := strings.trim_space(string(data))
    part1(input)
    part2(input)
}

iv2 :: [2]int

DIMS :: iv2{101,103}

part1 :: proc(input: string) {
    it := input
    safety_factor: [4]int
    for line in strings.split_lines_iterator(&it) {
        free_all(context.temp_allocator)
        cline := strings.clone_to_cstring(line, context.temp_allocator)
        p, v: iv2
        sscanf(cline, "p=%lld,%lld v=%lld,%lld", &p.x, &p.y, &v.x, &v.y)

        // not this time, eric
        p += 100*v %% DIMS
        p %%= DIMS
        if p.x != DIMS.x/2 && p.y != DIMS.y/2 {
            quad_index := ( p.x / (DIMS.x / 2 + 1) ) * 2 + p.y / (DIMS.y / 2 + 1)
            safety_factor[quad_index] += 1
        }
    }

    prod := 1
    for n in safety_factor {
        prod *= n
    }
    fmt.println(prod)
}

WINDOW_SCALE :: 8

part2 :: proc(input: string) {
    Robot :: struct {
        p,v: iv2
    }
    robots: [dynamic]Robot

    it := input
    for line in strings.split_lines_iterator(&it) {
        cline := strings.clone_to_cstring(line, context.temp_allocator)
        robot: Robot
        sscanf(cline, "p=%lld,%lld v=%lld,%lld", &robot.p.x, &robot.p.y, &robot.v.x, &robot.v.y)
        append(&robots, robot)
    }

    w := i32(DIMS.x)
    h := i32(DIMS.y)

    rl.InitWindow(w*WINDOW_SCALE, h*WINDOW_SCALE, "AoC 2024 Day 14 Part 2")

    rendtex := rl.LoadRenderTexture(w, h)

    step := 0

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        free_all(context.temp_allocator)

        if rl.IsKeyPressed(.SPACE) {
            for {
                step += 1
                drew_to_top := false
                grid: [DIMS.y][DIMS.x]b8
                adj_count := 0
                for &r in robots {
                    r.p += r.v
                    r.p %%= DIMS
                    grid[r.p.y][r.p.x]=true
                    adj := false
                    for dy in -1..=1 {
                        for dx in -1..=1 {
                            p := r.p + iv2{dx, dy}
                            if dx==0 && dy==0 do continue
                            if p.x >= 0 && p.x < DIMS.x && p.y >= 0 && p.y < DIMS.y {
                                adj ||= grid[p.y][p.x]
                            }
                        }
                    }
                    adj_count += int(adj)
                }
                if adj_count >= 200 do break
            }
            rl.BeginTextureMode(rendtex)
            rl.ClearBackground(rl.BLACK)
            for r in robots {
                rl.DrawPixel(auto_cast r.p.x, auto_cast r.p.y, rl.GREEN)
            }
            rl.EndTextureMode()
        }

        rl.BeginDrawing()
        rl.DrawTexturePro(rendtex.texture, 
            {0, 0, f32(w), f32(h)}, 
            {0, 0, f32(w*WINDOW_SCALE), f32(h*WINDOW_SCALE)}, 
            {}, 0, rl.WHITE)
        rl.DrawText(fmt.ctprintf("{}", step), 5, 5, 36, rl.WHITE)
        rl.EndDrawing()
    }
}