
package dayN

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:math/big"

main :: proc() {
    data, ok := os.read_entire_file("input.txt")
    assert(ok)
    input := strings.trim_space(string(data))
    //part1(input)
    part2(input)
}

iv2 :: [2]int
vmin :: proc(v: iv2) -> int {
    return min(v.x, v.y)
}

part1 :: proc(input: string) {
    total_token_count := 0
    it := input
    for line in strings.split_lines_iterator(&it) {
        a_line := line
        b_line     := strings.split_lines_iterator(&it) or_break
        prize_line := strings.split_lines_iterator(&it) or_break
        _           = strings.split_lines_iterator(&it) or_break

        a := parse_line(a_line)
        b := parse_line(b_line)
        prize := parse_line(prize_line)

        max_a_presses := vmin(prize / a + {1,1})
        max_b_presses := vmin(prize / b + {1,1})
        max_presses := iv2{max_a_presses, max_b_presses}

        start := max_presses

        dists: map[iv2]int
        defer delete(dists)
        dists[start]=0

        open_set: [dynamic]iv2
        defer delete(open_set)
        append(&open_set, start)

        for len(open_set) > 0 {
            current: iv2
            index: int
            min_dist := max(int)
            for n, i in open_set {
                n_dist := dist(dists, n)
                if n_dist < min_dist {
                    min_dist = n_dist
                    current = n
                    index = i
                }
            }

            if pos(a,b,current) == prize {
                total_token_count += token_cost(current)
                break
            }

            unordered_remove(&open_set, index)

            deltas: [3]iv2 = {{0,-1},{-1,0},{-1,-1}}
            for d in deltas {
                neighbor := current + d
                p := pos(a,b,neighbor)
                if p.x < prize.x do continue
                if p.y < prize.y do continue
                tent_dist := dist(dists, current) + token_cost_dist(current, neighbor)
                if tent_dist < dist(dists, neighbor) {
                    dists[neighbor] = tent_dist
                    if !slice.contains(open_set[:], neighbor) {
                        append(&open_set, neighbor)
                    }
                }
            }
        }
    }

    fmt.println(total_token_count)

    dist :: proc(dists: map[iv2]int, n: iv2) -> int {
        return dists[n] or_else max(int)
    }

    token_cost :: proc(a: iv2) -> int {
        return a.x*3 + a.y
    }

    token_cost_dist :: proc(a, b: iv2) -> int {
        return abs(a.x - b.x)*3 + abs(a.y - b.y)
    }

    pos :: proc(a, b, presses: iv2) -> iv2 {
        return a*presses.x + b*presses.y
    }
}

parse_line :: proc(s: string) -> iv2 {
    it := s
    result: iv2
    for &r, i in result {
        field := strings.split_iterator(&it, ",") or_break
        j := len(field)-1
        for '0' <= field[j] && field[j] <= '9' {
            j -= 1
        }
        result[i] = strconv.parse_int(field[j+1:]) or_break
    }
    return result
}

// why yes, i did implement Dijkstra's algorithm ito solve part 1
// why yes, it is in fact very slow (but fast enough to get me the answer)
// why yes, i did find out that it was too slow for part 2
// why yes, i did realize that it was just a system of equations
// gg eric

part2 :: proc(input: string) {
    total_token_count := 0
    it := input
    for line in strings.split_lines_iterator(&it) {
        a_line := line
        b_line     := strings.split_lines_iterator(&it) or_break
        prize_line := strings.split_lines_iterator(&it) or_break
        strings.split_lines_iterator(&it)

        a := parse_line(a_line)
        b := parse_line(b_line)
        prize := parse_line(prize_line)

        prize += 10000000000000

        // Cramer's rule
        a1 := i128(a.x)
        a2 := i128(a.y)
        b1 := i128(b.x)
        b2 := i128(b.y)
        c1 := i128(prize.x)
        c2 := i128(prize.y)

        m1 := f64(-a1)/f64(b1)
        m2 := f64(-a2)/f64(b2)

        if m1 != m2 {
            denom := a1*b2 - b1*a2
            if denom != 0 {
                a_num := (c1*b2 - b1*c2)
                if a_num % denom != 0 do continue
                b_num := (a1*c2 - c1*a2)
                if b_num % denom != 0 do continue
                a_presses := int(a_num / denom)
                b_presses := int(b_num / denom)

                if a_presses * a + b_presses * b == prize {
                    total_token_count += a_presses*3 + b_presses
                }
            }
        } else if b1 == b2 {
            fmt.println("Overlap")
            // overlap
        } else {
            // no solution
            fmt.println("No Solution")
        }
    }

    fmt.println(total_token_count)
}

