
package day8

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

iv2 :: [2]int

Antinodes :: map[iv2]struct{}

part1 :: proc(input: string) {
    maybe_add_antinode :: proc(antinodes: ^Antinodes, grid: [][]u8, v: iv2) {
        if v.x < 0 || v.x >= len(grid[0]) do return
        if v.y < 0 || v.y >= len(grid   ) do return
        antinodes[v]={}
    }
    grid := transmute([][]u8)strings.split_lines(input)
    antennas: map[u8][dynamic]iv2
    for line, y in grid {
        for c, x in line {
            if c == '.' do continue
            if c not_in antennas {
                antennas[c] = make([dynamic]iv2)
            }
            append(&antennas[c], iv2{x, y})
        }
    }
    antinodes: Antinodes
    for freq, positions in antennas {
        for a in positions {
            for b in positions {
                if a==b do continue
                maybe_add_antinode(&antinodes, grid, b + b-a)
            }
        }
    }
    fmt.println(len(antinodes))
}

part2 :: proc(input: string) {
    in_bounds :: proc(grid: [][]u8, v: iv2) -> bool {
        if v.x < 0 || v.x >= len(grid[0]) do return false
        if v.y < 0 || v.y >= len(grid   ) do return false
        return true
    }
    grid := transmute([][]u8)strings.split_lines(input)
    antennas: map[u8][dynamic]iv2
    for line, y in grid {
        for c, x in line {
            if c == '.' do continue
            if c not_in antennas {
                antennas[c] = make([dynamic]iv2)
            }
            append(&antennas[c], iv2{x, y})
        }
    }
    antinodes: Antinodes
    for freq, positions in antennas {
        for a in positions {
            for b in positions {
                if a==b do continue
                for p := b; in_bounds(grid, p); p += b-a {
                    antinodes[p]={}
                }
            }
        }
    }
    fmt.println(len(antinodes))
}