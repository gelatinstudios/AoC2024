
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
    // unfortunately this match lib is based off of lua's which 
    // afaict doesn't have any kind of logical OR 
    // and i don't feel like learning to use odin's regex library
    // which i already wasted a lot of time to trying to figure out
    // soooooooooo i did some dumb logic to combine 2 matches
    
    // i hate regex

    // if i just wrote a normal parser i would have been done a lot faster

    // here's my slop

    Mul :: struct {
        a, b: i32
    }
    Do :: struct{}
    Dont :: struct {}
    Opcode :: union {
        Mul, Do, Dont
    }
    Instr :: struct {
        op: Opcode,
        pos: int,
    }
    instrs: [dynamic]Instr
    it := input
    n := 0
    matcher := match.matcher_init(input, `mul%(%d+%,%d+%)`)
    for match, index in match.matcher_gmatch(&matcher) {
        s := strings.clone_to_cstring(match)
        a, b: i32
        libc.sscanf(s, "mul(%d,%d)", &a, &b)
        if a < 1000 && b < 1000 {
            append(&instrs, Instr {
                op = Mul{a,b},
                pos = n + matcher.captures[0].byte_start
            })
        }
        n += matcher.captures[0].byte_end
    }
    it = input
    n = 0
    matcher = match.matcher_init(input, `do.?.?.?%(%)`)
    for match, index in match.matcher_gmatch(&matcher) {
        op: Opcode
        if match == "do()" {
            op = Do{}
        } else if match == "don't()" {
            op = Dont{}
        } else {
            continue
        }
        append(&instrs, Instr {
            op = op,
            pos = n + matcher.captures[0].byte_start
        })
        n += matcher.captures[0].byte_end
    }
    slice.sort_by_key(instrs[:], proc(instr: Instr) -> int { return instr.pos })
    enabled := true
    result := 0
    for instr in instrs {
        switch mul in instr.op {
            case Do:   enabled = true
            case Dont: enabled = false
            case Mul: 
                if enabled {
                    result += int(mul.a*mul.b)
                }
        }
    }
    fmt.println(result)
}