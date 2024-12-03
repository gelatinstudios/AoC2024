
package day3

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

import "core:text/match"
import "core:c/libc"

main :: proc() {
    data, ok := os.read_entire_file("input.txt")
    assert(ok)
    input := string(data)
    part1(input)
    part2(input)
}

part1 :: proc(input: string) {
    result := 0
    input := input
    captures: [32]match.Match
    for match in match.gfind(&input, `mul%(%d+%,%d+%)`, &captures) {
        s := strings.clone_to_cstring(match)
        a, b: i32
        libc.sscanf(s, "mul(%d,%d)", &a, &b)
        if a < 1000 && b < 1000 {
            result += int(a*b)
        }
    }
    fmt.println(result)
}

part2 :: proc(input: string) {
}