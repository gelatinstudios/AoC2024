
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
                count, border_count := flood_fill(grid, w, h, x, y, c)
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

    flood_fill :: proc(grid: []u8, w, h, x, y: int, c: u8) -> (int, int) {
        if !in_bounds(w,h,x,y) do return 0,0
        if grid[x + y*w] != c do return 0, 0
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
            n, m := flood_fill(grid, w, h, x, y, c)
            count += n
            border_count += m
        }
        return count, border_count
    }
}

part2 :: proc(input: string) {
    Cell :: struct {
        mark0: bool,
        side_marks: [4]b8,
        symbol: u8,
    }

    lines := transmute([][]u8) strings.split_lines(input)
    w := len(lines[0]); h := len(lines)
    grid := make([]Cell, w*h)
    for line, y in lines {
        for c, x in line {
            cell := &grid[x+y*w]
            cell.symbol = u8(c)
        }
    }

    total: int
    for y in 0..<h {
        for x in 0..<w {
            c := grid[x+y*w]
            if c.mark0 do continue
            count, side_count := flood_fill(grid, w, h, x, y, c.symbol)
            total += count * side_count
        }
    }

    fmt.println(total)

    in_bounds :: proc(w, h, x, y: int) -> bool {
        if x < 0 || x >= w do return false
        if y < 0 || y >= h do return false
        return true
    }

    flood_fill :: proc(grid: []Cell, w, h, x, y: int, symbol: u8) -> (int, int) {
        if !in_bounds(w,h,x,y) do return 0, 0
        c := &grid[x+y*w]
        if c.mark0 do return 0, 0
        if c.symbol != symbol do return 0, 0

        c.mark0 = true

        neighbors := [4][2]int {
            {0, 1},{0,-1},
            {-1,0},{ 1,0},
        }
        count := 1
        side_count := 0
        for d in neighbors {
            x := x+d.x
            y := y+d.y
            n, m := flood_fill(grid, w, h, x, y, symbol)
            count += n
            side_count += m
        }
        {
            p := [2]int{x,y}
            for d, i in neighbors {
                if c.side_marks[i] do continue
                n := p + d
                if !in_bounds(w,h,n.x,n.y) || grid[n.x+n.y*w].symbol != symbol {
                    side_count += 1
                    c.side_marks[i] = true
                    dd := n - p
                    dd.x, dd.y = dd.y, -dd.x
                    for bp := p + dd; in_bounds(w,h,bp.x,bp.y) && grid[bp.x+bp.y*w].symbol == symbol; bp += dd {
                        bn := bp + d
                        if in_bounds(w,h,bn.x,bn.y) && grid[bn.x+bn.y*w].symbol == symbol {
                            break
                        }
                        grid[bp.x+bp.y*w].side_marks[i] = true
                    }
                    dd.x = -dd.x
                    dd.y = -dd.y
                    for bp := p + dd; in_bounds(w,h,bp.x,bp.y) && grid[bp.x+bp.y*w].symbol == symbol; bp += dd {
                        bn := bp + d
                        if in_bounds(w,h,bn.x,bn.y) && grid[bn.x+bn.y*w].symbol == symbol {
                            break
                        }
                        grid[bp.x+bp.y*w].side_marks[i] = true
                    }
                }
            }
        }
        return count, side_count
    }
}
