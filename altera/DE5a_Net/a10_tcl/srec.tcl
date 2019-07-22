#
# author : Alexandr Kozlinskiy
# date : 2017-11-11
#

proc read_srec { f } {
    set words [ list ]

    for { set l 0 } { $l < 64 } { incr l } {
        set type [ read $f 2 ]
        if { $type != "S3" } {
            error "error: unknown record type $type"
        }
        set n [ read $f 2 ]
        set n [ expr 0x$n - 5 ]
        if { $n != 32 } {
            error "error: n != 32"
        }
        set addr [ read $f 8 ]

        for { set i 0 } { $i < 32 } { incr i } {
            set b [ read $f 2 ]
            if { [ eof $f ] } break
            lappend words "0x$b"
        }

        set c [ read $f 2 ]
        if { [ read $f 1 ] != "\n" } {
            error "error: expect line feed"
        }
    }

    return $words
}

proc read_file_8 { fname } {
    set n [ file size $fname ]
    set f [ open $fname r ]
    fconfigure $f -translation binary

    set bytes [ list ]
    for {set i 0} {$i < $n} {incr i} {
        binary scan [ read $f 1 ] H* hex
        lappend bytes "0x$hex"
    }

    close $f
    return $bytes
}

if { [ catch {
    set f [ open "output_files/top.sof.flash" ]
    puts [ time { read_srec $f } 128 ]
} ] } {
    puts $::errorInfo
}
