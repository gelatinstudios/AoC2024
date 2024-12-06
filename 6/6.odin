
package day6

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
    data, ok := os.read_entire_file("input.txt")
    assert(ok)
    input := string(data)
    part1(input)
    part2(input)
}

iv2 :: [2]int

in_bounds :: proc(grid: []string, v: iv2) -> bool {
    w:=len(grid[0])
    h:=len(grid)
    if v.x < 0 do return false
    if v.y < 0 do return false
    if v.x >= w do return false
    if v.y >= h do return false
    return true
}

part1 :: proc(input: string) {
    using strings
    grid := split_lines(trim_space(input))
    guard: iv2
    for &line, y in grid {
        for cell, x in line {
            if cell == '^' {
                guard.x = x
                guard.y = y
            }
        }
    }
    dguard := iv2{0, -1}
    visited: map[iv2]struct{}
    for in_bounds(grid, guard) {
        visited[guard]={}
        for {
            n := guard+dguard
            if !in_bounds(grid, n) || grid[n.y][n.x]!='#' {
                break
            }
            dguard.x, dguard.y = dguard.y, dguard.x
            dguard.x = -dguard.x
        }
        guard += dguard
    }
    fmt.println(len(visited))
}

part2 :: proc(input: string) {
    
}