#

namespace eval ::srec {
}

proc srec::parse_record { record addrVar } {
    upvar $addrVar addr

    set type [ string range $record 0 1 ]

    # header record
    if { $type == "S0" } {
        return
    }

    # count record
    if { $type == "S5" } {
        return
    }

    # termination records
    if { $type == "S7" || $type == "S8" || $type == "S9" } {
        return
    }

    set n [ string range $record 2 3 ]
    set n [ expr 0x$n ]

    # data records
    if { $type == "S1" } {
        set addr [ string range $record 4 7 ]
        set n [ expr $n - 2 ]
    }
    if { $type == "S2" } {
        set addr [ string range $record 4 9 ]
        set n [ expr $n - 3 ]
    }
    if { $type == "S3" } {
        set addr [ string range $record 4 11 ]
        set n [ expr $n - 4 ]
    }
    set addr [ expr 0x$addr ]

    if { $n < 1 } {
        error "error: "
    }

    set bytes [ list ]
    while { $n > 1 } {
        set p [ expr [ string length $record ] - 2 * $n ]
        set b [ string range $record $p [ expr $p + 1 ] ]
        set n [ expr $n - 1 ]
        lappend bytes $b
    }

    # checksum
#    set cs [ string range $record ... ]

    return $bytes
}
