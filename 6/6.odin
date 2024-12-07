
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
    // Probably the dumbest possible way to check for a loop and i don't really care
    sim :: proc(grid: []string, guard: iv2, max_obs := max(int), fake_obs: Maybe(iv2) = nil) -> (int, bool) {
        guard := guard
        dguard := iv2{0, -1}
        obstacles_visited := 0
        for in_bounds(grid, guard) {
            if obstacles_visited >= max_obs {
                return 0, true
            }
            for {
                n := guard+dguard
                if !in_bounds(grid, n) do break
                o,b := fake_obs.?
                if b {
                    if grid[n.y][n.x]!='#' && o != n {
                        break
                    }
                } else {
                    if grid[n.y][n.x]!='#' {
                        break
                    }
                }

                dguard.x, dguard.y = dguard.y, dguard.x
                dguard.x = -dguard.x
                obstacles_visited += 1
            }
            guard += dguard
        }
        return obstacles_visited, false
    }
    max_obs, _ := sim(grid, guard)
    max_obs *= 2
    n := 0
    for line, y in grid {
        for _, x in line {
            obs := iv2{x,y}
            if obs == guard do continue
            if grid[obs.y][obs.x] == '#' do continue
            _, looped := sim(grid, guard, max_obs, obs)
            n += int(looped)
        }
    }
    fmt.println(n)
}