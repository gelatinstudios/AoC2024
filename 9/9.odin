
package day9

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
    add_to_checksum :: proc(checksum: ^int, id: int, n: u8) {
        @static pos: int
        for _ in 0..<n {
            checksum^ += id * pos
            pos += 1
            //fmt.print(id)
        }
    }
    disk_map := transmute([]u8)input
    for &n in disk_map {
        n -= '0'
    }
    checksum: int
    in_free_space := false
    j := len(disk_map) - 1
    for n, i in disk_map {
        if in_free_space {
            for _ in 0 ..< n {
                if disk_map[j] == 0 {
                    j -= 2
                }
                if j <= i do break
                add_to_checksum(&checksum, j/2, 1)
                disk_map[j]-=1
            }
        } else {
            id := i / 2
            add_to_checksum(&checksum, id, n)
        }

        in_free_space = !in_free_space
    }
    fmt.println(checksum)
}

part2 :: proc(input: string) {

}