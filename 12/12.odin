
package day12

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
    data, ok := os.read_entire_file("input.txt")
    assert(ok)
    input := strings.trim_space(string(data))
    part1(input)
    part2(input)
}

part1 :: proc(input: string) {
    lines := transmute([][]u8) strings.split_lines(input)
    w := len(lines[0]); h := len(lines)
    grid := make([]u8, w*h)
    for line, y in lines {
        for c, x in line {
            grid[x + y*w] = u8(c)
        }
    }

    total: int
    for y in 0..<h {
        for x in 0..<w {
            c := grid[x+y*w]
            if (c & 0x80) == 0 {
                count, border_count, b := flood_fill(grid, w, h, x, y, c)
                total += count * border_count
            }
        }
    }

    fmt.println(total)

    in_bounds :: proc(w, h, x, y: int) -> bool {
        if x < 0 || x >= w do return false
        if y < 0 || y >= h do return false
        return true
    }

    flood_fill :: proc(grid: []u8, w, h, x, y: int, c: u8) -> (int, int, bool) {
        if !in_bounds(w,h,x,y) do return 0,0,false
        if grid[x + y*w] != c do return 0, 0, false
        grid[x+y*w] |= 0x80

        neighbors := [4][2]int {
            {0, 1},{0,-1},
            {-1,0},{ 1,0},
        }
        count := 1
        border_count := 4
        for d in neighbors {
            x := x+d.x
            y := y+d.y
            if in_bounds(w,h,x,y) && grid[x+y*w] & 0x7f == c {
                border_count -= 1
            }
            n, m, b := flood_fill(grid, w, h, x, y, c)
            count += n
            border_count += m
        }
        return count, border_count, true
    }
}

part2 :: proc(input: string) {
    
}