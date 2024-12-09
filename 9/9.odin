
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
    part1(strings.clone(input))
    part2(strings.clone(input))
}

part1 :: proc(input: string) {
    add_to_checksum :: proc(checksum: ^int, id: int, n: u8) {
        @static pos: int
        for _ in 0..<n {
            checksum^ += id * pos
            pos += 1
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
    print_sections :: proc(sections: []Section) {
        for index : i16 = 0; index >= 0; index = sections[index].next {
            section := sections[index]
            for _ in 0..<section.block_count {
                if section.is_free {
                    fmt.print('.')
                } else {
                    fmt.print(section.id)
                }
            }
        }
        fmt.println()
    }
    disk_map := transmute([]u8)input
    for &n in disk_map {
        n -= '0'
    }
    Section :: struct {
        prev, next: i16,
        is_free: b8,
        block_count: u8,
        id: i16,
    }
    sections: [dynamic]Section
    for n, i in disk_map {
        section: Section
        section.prev = i16(i-1)
        section.next = i16(i+1)
        section.block_count = n
        if i % 2 == 0 {
            section.id = i16(i/2)
        } else {
            section.is_free = true
        }
        append(&sections, section)
    }
    sections[len(disk_map)-1].next = -1

    index := i16(len(sections)-1)
    for index >= 0 {
        section := &sections[index]
        next_index := section.prev

        if !section.is_free {
            cand_index: i16
            for cand_index >= 0 {
                if cand_index == index do break
                candidate := &sections[cand_index]
                next_cand_index := candidate.next

                if candidate.is_free {
                    if candidate.block_count >= section.block_count {
                        absorbed := false
                        if section.prev >= 0 {
                            prev := &sections[section.prev]
                            prev.next = section.next
                            if prev.is_free {
                                prev.block_count += section.block_count
                                absorbed = true
                            }
                        }
                        if section.next >= 0 {
                            next := &sections[section.next]
                            next.prev = section.prev
                            if !absorbed && next.is_free {
                                next.block_count += section.block_count
                                absorbed = true
                            }
                        }
                        if !absorbed {
                            b: Section
                            b.is_free = true
                            b.block_count = section.block_count
                            if section.prev >= 0 {
                                sections[section.prev].next = auto_cast len(sections)
                            }
                            if section.next >= 0 {
                                sections[section.next].prev = auto_cast len(sections)
                            }
                            b.prev = section.prev
                            b.next = section.next
                            append(&sections, b)
                        }

                        sections[candidate.prev].next = index
                        section.prev = candidate.prev
                        if candidate.block_count == section.block_count {
                            section.next = candidate.next
                            sections[candidate.next].prev = index
                        } else {
                            section.next = cand_index
                            candidate.prev = index
                            candidate.block_count -= section.block_count
                        }

                        break
                    }
                }

                cand_index = next_cand_index
            }
        }

        index = next_index
    }
    checksum: int
    pos: int
    for index : i16 = 0; index >= 0; index = sections[index].next {
        section := sections[index]
        for _ in 0..< section.block_count {
            if !section.is_free {
                checksum += pos * int(section.id)
            }
            pos += 1
        }
    }
    fmt.println(checksum)
}