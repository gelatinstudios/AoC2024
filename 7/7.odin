
package day7

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
    get_num :: proc(it: ^string) -> (result: int, ok: bool) {
        return strconv.parse_int(strings.fields_iterator(it) or_return)
    }
    eval :: proc(target, n: int, s: string, mul: bool) -> bool {
        s:=s
        b, ok := get_num(&s)
        if !ok do return n==target
        m: int
        if mul {
            m = n*b
        } else {
            m = n+b
        }
        if m > target do return false
        ra := eval(target, m, s, true)
        if ra do return true
        return eval(target, m, s, false)
    }
    it := input
    sum := 0
    for line in strings.split_lines_iterator(&it) {
        target_str, _, eq_str := strings.partition(line, ":")
        target, _ := strconv.parse_int(target_str)

        n, _ := get_num(&eq_str)
        if eval(target, n, eq_str, true) || eval(target, n, eq_str, false) {
            sum += target
        }
    }
    fmt.println(sum)
}

part2 :: proc(input: string) {
    get_num :: proc(it: ^string) -> (result: int, ok: bool) {
        return strconv.parse_int(strings.fields_iterator(it) or_return)
    }
    concat :: proc(a, b: int) -> int {
        mul := 1
        for n := b; n >= 1; n /= 10 {
            mul *= 10
        }
        result := a*mul + b
        return result
    }
    Op :: enum { Add, Mul, Concat }
    eval :: proc(target, n: int, s: string, op: Op) -> bool {
        s:=s
        b, ok := get_num(&s)
        if !ok do return n==target
        m: int
        switch op {
            case .Add: m = n + b
            case .Mul: m = n * b
            case .Concat: m = concat(n, b)
        }
        if m > target do return false
        return try_all(target, m, s)
    }
    try_all :: proc(target, n: int, s: string) -> bool {
        for op in Op {
            if eval(target, n, s, op) do return true
        }
        return false
    }
    it := input
    sum := 0
    for line in strings.split_lines_iterator(&it) {
        target_str, _, eq_str := strings.partition(line, ":")
        target, _ := strconv.parse_int(target_str)

        n, _ := get_num(&eq_str)
        if try_all(target, n, eq_str) {
            sum += target
        }
    }
    fmt.println(sum)
}