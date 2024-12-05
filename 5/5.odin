
package day5

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
    rules: map[int][dynamic]int
    updates: [dynamic][]int
    it := input
    for line in strings.split_lines_iterator(&it) {
        s := line
        if line == "" do break
        nums: [2]int
        for &n in nums {
            ss, _ := strings.split_iterator(&s, "|")
            n, _ = strconv.parse_int(ss)
        }
        k := nums[0]; v := nums[1]
        if k in rules {
            append(&rules[k], v)
        } else {
            rules[k] = make([dynamic]int)
            append(&rules[k], v)
        }
    } 
    for line in strings.split_lines_iterator(&it) {
        s := line
        if line == "" do break
        update: [dynamic]int
        for ss in strings.split_iterator(&s, ",") {
            n, _ := strconv.parse_int(ss)
            append(&update, n)
        }
        append(&updates, update[:])
    }
    sum := 0
    for update in updates {
        good := true
        seen: map[int]struct{}
        update_loop: for n in update {
            after_list := rules[n]
            for n in after_list {
                if n in seen {
                    good = false
                    break update_loop
                }
            }
            seen[n]={}
        }
        if good {
            sum += update[len(update)/2]
        }
    }
    fmt.println(sum)
}

part2 :: proc(input: string) {
    
}