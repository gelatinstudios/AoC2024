
package dayN

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:c/libc"

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
        libc.sscanf(cline, "p=%lld,%lld v=%lld,%lld", &p.x, &p.y, &v.x, &v.y)

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

part2 :: proc(input: string) {
    
}