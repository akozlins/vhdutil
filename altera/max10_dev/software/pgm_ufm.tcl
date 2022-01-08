#
# author : Alexandr Kozlinskiy
# date : 2019-08-26
#

set dir0 [ file dirname [ info script ] ]
source [ file join $dir0 "../util/quartus/tcl/mm.tcl" ]
source [ file join $dir0 "../util/quartus/tcl/srec.tcl" ]
source [ file join $dir0 "../util/quartus/tcl/ufm.tcl" ]



set device_pattern /devices/10M*/nios*

set proc_paths [ get_service_paths processor ]
set proc_path [ lindex $proc_paths [ lsearch $proc_paths $device_pattern ] ]
processor_stop $proc_path
processor_reset $proc_path

mm_claim $device_pattern

proc pgm {} {
    pgm_srec $::mm [ file join $::dir0 "app/main.srec" ]
    processor_run $::proc_path
}



proc lequal { l1 l2 } {
    if { [ llength $l1 ] != [ llength $l2 ] } {
        return false
    }

    set n [ llength $l1 ]
    for { set i 0 } { $i < $n } { incr i } {
        if { [ lindex $l1 $i ] != [ lindex $l2 $i ] } {
            return false
        }
    }

    return true
}

proc pgm_srec { mm fname } {
    set f [ open $fname r ]

    set bytes [ lrepeat 0x8000 FF ]

    while { true } {
        set record [ gets $f ]
        if { [ eof $f ] } {
            break
        }

        set addr 0
        foreach a [ srec::parse_record $record addr ] {
            lset bytes $addr $a
            set addr [ expr $addr + 1 ]
        }
    }

    close $f

    set words [ list ]
    foreach { a b c d } $bytes {
        lappend words 0x$d$c$b$a
    }

    puts -nonewline "erase sector 1 ... "
    ::ufm::erase $mm 1
    puts DONE

    puts -nonewline "erase sector 2 ... "
    ::ufm::erase $mm 2
    puts DONE

    # sector 1
    puts -nonewline "write sector 1 ... "
    ::ufm::disable_wp $mm 1
    master_write_32 $mm 0x0000 [ lrange $words 0x0000 0x0FFF ]
    ::ufm::enable_wp $mm 1
    puts DONE

    # sector 2
    puts -nonewline "write sector 2 ... "
    ::ufm::disable_wp $mm 2
    master_write_32 $mm 0x4000 [ lrange $words 0x1000 0x1FFF ]
    ::ufm::enable_wp $mm 2
    puts DONE

    puts -nonewline "check sector 1 ... "
    if { [ lequal [ lrange $words 0x0000 0x0FFF ] [ master_read_32 $mm 0x0000 0x1000 ] ] } {
        puts OK
    } \
    else {
        puts FAIL
    }
    puts -nonewline "check sector 2 ... "
    if { [ lequal [ lrange $words 0x1000 0x1FFF ] [ master_read_32 $mm 0x4000 0x1000 ] ] } {
        puts OK
    } \
    else {
        puts FAIL
    }
}

proc test { mm } {
    set data1 [ list ]
    for { set i 0x0000 } { $i < 0x1000 } { incr i } {
        lappend data1 $i
    }
    set data2 [ list ]
    for { set i 0x1000 } { $i < 0x2000 } { incr i } {
        lappend data2 $i
    }

    ::ufm::erase $mm 1
    ::ufm::erase $mm 2

    ::ufm::disable_wp $mm 1
    master_write_32 $mm 0x0000 $data1
    ::ufm::enable_wp $mm 1

    ::ufm::disable_wp $mm 2
    master_write_32 $mm 0x4000 $data2
    ::ufm::enable_wp $mm 2

    puts [ master_read_32 $mm 0x0000 1024 ]
    puts [ master_read_32 $mm 0x4000 1024 ]
}
