
package aoc

import "core:os"
import "core:fmt"

main :: proc() {
    data, ok := os.read_entire_file("input.txt")
    assert(ok)
    input := string(data)
    part1(input)
    part2(input)
}


part1 :: proc(input: string) {

}

part2 :: proc(input: string) {
    
}