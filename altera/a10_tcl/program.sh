#!/bin/sh
# \
exec system-console -cli -disable_readline --script=$0 "$(dirname -- "$(readlink -f -- "$0")")" "$@"

set dir [ lindex $argv 0 ]
set argv [ lreplace $argv 0 0 ]
incr argc -1

source [ file join $dir "program.tcl" ]

if { [ llength $mm_paths ] == 0 } {
    puts "E \[...\] no master services found"
    return
}

proc pgm { addr fname } {
    if { [ file extension $fname ] == ".elf" } {
        set flash [ file rootname $fname ].[ clock format [ file mtime $fname ] -format %Y%m%d_%H%M%S ].flash
        if { [ file exists $flash ] == 0 } {
            file rename [ ?t ::quartus::elf2flash $fname ] $flash
        }
        set fname $flash
    }
    if { [ file extension $fname ] == ".sof" } {
        set flash [ file rootname $fname ].[ clock format [ file mtime $fname ] -format %Y%m%d_%H%M%S ].flash
        if { [ file exists $flash ] == 0 } {
            file rename [ ?t ::quartus::sof2flash $fname ] $flash
        }
        set fname $flash
    }
    if { [ file extension $fname ] == ".flash" } {
        set fname [ ?t ::quartus::flash2bin $fname ]
    }
    if { [ file extension $fname ] != ".bin" } {
        error "invalid file type: '$fname', require '.bin'"
    }

    ?t program_file $::mm $addr $fname
}

if { [ file exists $::elf ] } {
} elseif { [ file exists "generated/$::elf" ] } {
    set elf "generated/$::elf"
} elseif { [ file exists ".cache/$::elf" ] } {
    set elf ".cache/$::elf"
}

while 1 {
    puts "  \[sof\] => pgm $::sof_addr '$sof'"
    puts "  \[elf\] => pgm $::elf_addr '$elf'"
    puts "  \[test\] => program_test $::test_addr"
    puts "  \[o\] => print option bits"
    puts "  \[q\] => exit"

    puts -nonewline "Select entry : "
    if { [ gets stdin line ] == 0 } break

    switch -exact -- $line {
        mm {
            refresh_connections
            mm_claim /devices/10A*/phy*/master
        }
        sof { ?c pgm $::sof_addr $::sof }
        elf { ?c pgm $::elf_addr $::elf }
        test { program_test $::test_addr }
        o {
            foreach x [ ::master_read_32 $mm 0x00030000 0x20 ] {
                puts [ format "0x%08X" $x ]
            }
        }
        q { break }
    }
}

foreach service [ ::get_claimed_services "" ] {
    puts "I \[...\] close service '$service'"
    ::close_service master [ lindex $service 0 ]
}
