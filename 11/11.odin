
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


part1 :: proc(input: string) {
    Stone :: struct {
        n, next: int,
    }
    stones: [dynamic]Stone
    it := input
    i := 0
    for s in strings.fields_iterator(&it) {
        n, ok := strconv.parse_int(s)
        assert(ok)
        append(&stones, Stone {
            n = n,
            next = i+1,
        })
        i += 1
    }
    stones[len(stones)-1].next = -1

    for _ in 0 ..< 25 {
        for i := 0; i != -1; {
            s := &stones[i]
            next := s.next
            if s.n == 0 {
                s.n = 1
            } else if a, b, ok := split_digits(s.n); ok {
                left := s
                right: Stone
                right.next = left.next
                left.next = len(stones)
                left.n = a
                right.n = b
                append(&stones, right)
            } else {
                s.n *= 2024
            }
            i = next
        }
    }

    fmt.println(len(stones))

    print_stones :: proc(stones: []Stone) {
        for i := 0; i != -1; i = stones[i].next {
            fmt.print(stones[i].n, "")
        }
        fmt.println()
    }
}

split_digits :: proc(n: int) -> (int, int, bool) {
    m := n
    digit_count := n == 0 ? 1 : 0
    for m > 0 {
        m /= 10
        digit_count += 1
    }

    if digit_count % 2 != 0 {
        return 0, 0, false
    }

    div := 1
    for _ in 0..<digit_count/2 {
        div *= 10
    }

    return n/div, n%div, true
}

part2 :: proc(input: string) {
    Stones :: map[int]int

    stones_a, stones_b: Stones

    stones := &stones_a
    it := input
    for s in strings.fields_iterator(&it) {
        n, ok := strconv.parse_int(s)
        assert(ok)
        add_stones(stones, n, 1)
    }

    new_stones := &stones_b

    for _ in 0 ..< 75 {
        clear(new_stones)
        for n, count in stones {
            if n == 0 {
                add_stones(new_stones, 1, count)
            } else if a, b, ok := split_digits(n); ok {
                add_stones(new_stones, a, count)
                add_stones(new_stones, b, count)
            } else {
                add_stones(new_stones, n*2024, count)
            }
        }
        stones, new_stones = new_stones, stones
    }

    total := 0
    for _, count in stones {
        total += count
    }
    fmt.println(total)

    add_stones :: proc(stones: ^Stones, n, count: int) {
        if n in stones {
            stones[n] += count
        } else {
            stones[n] = count
        }
    }
}