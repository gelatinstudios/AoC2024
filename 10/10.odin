
package day10

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

in_bounds :: proc(grid: [][]u8, x, y: int) -> bool {
    return x >= 0 && x < len(grid[0]) &&
           y >= 0 && y < len(grid)
}

iv2 :: [2]int
iv2_set :: map[iv2]struct{}

part1 :: proc(input: string) {
    get_trails :: proc(nines: ^iv2_set, grid: [][]u8, x, y: int, n: u8) {
        if !in_bounds(grid, x, y) do return
        if grid[y][x] != n do return
        if n == 9 {
            nines[iv2{x, y}]={}
            return
        }
        get_trails(nines, grid, x+0, y+1, n+1)
        get_trails(nines, grid, x+0, y-1, n+1)
        get_trails(nines, grid, x+1, y+0, n+1)
        get_trails(nines, grid, x-1, y+0, n+1)
    }
    grid := transmute([][]u8) strings.split_lines(input)
    for &line in grid {
        for &n in line {
            n -= '0'
        }
    }
    sum := 0
    for line, y in grid {
        for cell, x in line {
            if cell == 0 {
                nines: iv2_set
                get_trails(&nines, grid, x, y, 0)
                sum += len(nines)
            }
        }
    }
    fmt.println(sum)
}

part2 :: proc(input: string) {
    
}