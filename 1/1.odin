
package aoc

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
    input := input

    lists: [2][dynamic]int
    list_index := 0
    for s in strings.fields_iterator(&input) {
        n, ok := strconv.parse_int(s)
        assert(ok)

        append(&lists[list_index], n)

        list_index = int(!bool(list_index))
    }

    assert(len(lists[0]) == len(lists[1]))

    slice.sort(lists[0][:])
    slice.sort(lists[1][:])

    total_distance := 0

    for a, i in lists[0] {
        b := lists[1][i]
        total_distance += abs(a-b)
    }

    fmt.println(total_distance)
}

part2 :: proc(input: string) {
    input := input

    lists: [2][dynamic]int
    list_index := 0
    for s in strings.fields_iterator(&input) {
        n, ok := strconv.parse_int(s)
        assert(ok)

        append(&lists[list_index], n)

        list_index = int(!bool(list_index))
    }

    similarity_score := 0

    for a in lists[0] {
        b := slice.count(lists[1][:], a)
        similarity_score += a*b
    }

    fmt.println(similarity_score)
}