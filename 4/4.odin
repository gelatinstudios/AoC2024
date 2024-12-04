
package day4

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

part1 :: proc(input: string) {
    test :: proc(grid: []string, x, y, dx, dy: int) -> bool {
        x := x
        y := y
        w := len(grid[0])
        h := len(grid)

        letters: [4]u8
        for i in 0..<4 {
            if x < 0 || x >= w do return false
            if y < 0 || y >= h do return false
            letters[i] = grid[y][x]
            x += dx
            y += dy
        }
        word := string(letters[:])
        return word == "XMAS" || word == "SAMX"
    }
    grid := strings.split_lines(input)
    if grid[len(grid)-1] == "" {
        grid = grid[:len(grid)-1]
    }
    count := 0
    for line, y in grid {
        for _, x in line {
            for dy in -1..=1 {
                for dx in -1..=1 {
                    count += int(test(grid, x, y, dx, dy))
                }
            }
        }
    }
    count /= 2
    fmt.println(count)
}

part2 :: proc(input: string) {
    test :: proc(grid: []string, x, y, dx, dy: int) -> bool {
        x := x
        y := y
        w := len(grid[0])
        h := len(grid)

        letters: [3]u8
        for _, i in letters {
            if x < 0 || x >= w do return false
            if y < 0 || y >= h do return false
            letters[i] = grid[y][x]
            x += dx
            y += dy
        }
        word := string(letters[:])
        return word == "MAS" || word == "SAM"
    }
    grid := strings.split_lines(input)
    if grid[len(grid)-1] == "" {
        grid = grid[:len(grid)-1]
    }
    count := 0
    for line, y in grid {
        for _, x in line {
            count += int(test(grid, x, y,   1,  1) &&
                         test(grid, x+2, y, -1, 1))
        }
    }
    fmt.println(count)
}