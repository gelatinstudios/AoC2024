
package day2

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

parse :: proc(input: string) -> [][]int {
    input := input

    result: [dynamic][]int
    for line in strings.split_lines_iterator(&input) {
        nums: [dynamic]int
        it := line
        for s in strings.fields_iterator(&it) {
            n, _ := strconv.parse_int(s)
            append(&nums, n)
        }
        append(&result, nums[:])
    }

    return result[:]
}

part1 :: proc(input: string) {
    reports := parse(input)

    safe_count := 0
    for report in reports {
        all_increasing := true
        all_descreasing := true
        differ_correctly := true

        for b, i in report[1:] {
            a := report[i]
            
            diff := abs(a-b)

            all_increasing  = all_increasing  && a < b
            all_descreasing = all_descreasing && a > b
            differ_correctly = differ_correctly && 1 <= diff && diff <= 3
        }

        safe_count += int((all_increasing || all_descreasing) && differ_correctly)
    }

    fmt.println(safe_count)
}

part2 :: proc(input: string) {
    is_safe :: proc(raw_report: []int, ignore: int) -> bool {
        report := slice.clone_to_dynamic(raw_report)
        if ignore >= 0 {
            ordered_remove(&report, ignore)
        }
        all_increasing := true
        all_descreasing := true
        differ_correctly := true
        for b, i in report[1:] {
            a := report[i]
            diff := abs(a-b)
            all_increasing  = all_increasing  && a < b
            all_descreasing = all_descreasing && a > b
            differ_correctly = differ_correctly && 1 <= diff && diff <= 3
        }

        return ((all_increasing || all_descreasing) && differ_correctly)
    }

    reports := parse(input)

    safe_count := 0
    for report in reports {
        for i in -1..<len(report) {
            if is_safe(report, i) {
                safe_count += 1
                break
            }
        }
    }

    fmt.println(safe_count)
}