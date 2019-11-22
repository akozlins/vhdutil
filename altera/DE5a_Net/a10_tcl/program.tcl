#
# author : Alexandr Kozlinskiy
# date : 2017-11-08
#

source [ file join [ file dirname [ info script ] ] "cfi1616.tcl" ]
source [ file join [ file dirname [ info script ] ] "quartus.tcl" ]

package require fileutil

set BLOCK_SIZE 0x40000

set CTRL_ADDR 0x1003FF00
set DATA_ADDR 0x10040000

proc program_file_256k { mm addr fname } {
    set fsize [ file size $fname ]
    if { $fsize == 0 } {
        error "'$fname' : size == 0"
    }
    if { $fsize > $::BLOCK_SIZE } {
        error "'$fname' : size > $::BLOCK_SIZE"
    }

    puts "INFO: $addr # read block"

    set tmp [ ::fileutil::tempfile ]
    try {
        ::master_read_to_file $mm $tmp $addr $fsize
        set err [ catch { ::util::exec diff -q -s $tmp $fname } ]
        if { $err == 0 } return
    } \
    finally {
        file delete $tmp
    }

    puts "INFO: $addr # erase"

    set err [ ::cfi1616::unlock $mm $addr ]
    if { $err != 0 } { error "failed to unlock block $addr" }
    ::cfi1616::erase $mm $addr

    # 1: write 256k buffer to nios data region
    ::master_write_from_file $mm $fname $::DATA_ADDR

    set err [ ::cfi1616::sync $mm $addr ]
    if { $err != 0 } { error "failed to sync block $addr" }

    puts "INFO: $addr # program"

    # 2: write addr != 0 to ctrl region
    ::master_write_32 $mm $::CTRL_ADDR [ list $addr $fsize ]

    # 3: wait addr == 0
    set timeout 4000
    while { true } {
        set ctrl [ ::master_read_32 $mm $::CTRL_ADDR 2 ]
        if { [ lindex $ctrl 0 ] == 0 && [ lindex $ctrl 1 ] == 0 } break
        if { [ incr timeout -10 ] <= 0 } { error "timeout" }
        after 10
    }

    puts "INFO: $addr # verify"

    set tmp [ ::fileutil::tempfile ]
    try {
        ::master_read_to_file $mm $tmp $addr $fsize
        set err [ catch { ::util::exec diff -q -s $tmp $fname } ]
        if { $err != 0 } { error "failed verify of block $addr" }
    } \
    finally {
        file delete $tmp
    }

    return
}

# program_file --
#
# Arguments:
# mm
# base
# fname
#
proc program_file { args } {
    array set opts [ list ]
    for { set i 0 } { $i < [ llength $args ] } { incr i } {
        switch [ lindex $args $i ] {
            -callback {
                incr i
                set callback [ lindex $args $i ]
            }
            -- {
                incr i
                break
            }
            default break
        }
    }
    lassign [ lrange $args $i end ] mm base fname

    set fsize [ file size $fname ]
    set n [ expr { ( $fsize + $::BLOCK_SIZE - 1 ) / $::BLOCK_SIZE } ]

    set fin [ open $fname r ]
    fconfigure $fin -translation binary

    set tmp [ ::fileutil::tempfile ]

    try { for { set i 0 } 1 { incr i } {
        puts "INFO: \[ $i / $n \]"
        if { [ info exist callback ] } {
            if { [ $callback $n $i ] != 0 } break
        }
        if { $i >= $n } break

        set fout [ open $tmp w ]
        fconfigure $fout -translation binary
        try {
            ::util::fcopy $fin $fout -size $::BLOCK_SIZE
        } \
        finally {
            close $fout
        }

        set addr [ format "0x%08X" [ expr { $base + $i * $::BLOCK_SIZE } ] ]
        program_file_256k $mm $addr $tmp
    } } \
    finally {
        file delete $tmp
        close $fin
    }

    return
}

set test_addr 0x05E80000
set sof_addr 0x02B40000
set sof "output_files/top.sof"
set elf_addr 0x05E40000
set elf "software/app/main.elf"

set proc_paths [ get_service_paths processor ]
set mm_paths [ get_service_paths master ]
set mm_index -1

proc mm_claim { { index -1 } } {
    if { $index == $::mm_index } {
        return
    }
    if { [ info exists ::mm ] } {
        ::close_service master $::mm
        unset ::mm
    }
    if { $index >= 0 } {
        set path [ lindex $::mm_paths $index ]
        puts "INFO: claim master '$path'"
        set ::mm [ ::claim_service master $path "" ]
    }
    set ::mm_index $index
}

proc program_test { addr } {
    set tmp [ ::fileutil::tempfile ]
    try {
        ::util::exec dd if=/dev/urandom of=$tmp bs=[ expr { $::BLOCK_SIZE } ] count=1 status=none
        ?t program_file $::mm $addr $tmp
    } \
    finally {
        file delete $tmp
    }

#    ::cfi1616::read_array $mm
#    puts "INFO: $addr # unlock"
#    ::cfi1616::unlock $mm $addr
#    puts "INFO: $addr # erase"
#    ::cfi1616::erase $mm $addr
#    ::cfi1616::sync $mm $addr
#    puts "INFO: $addr # lock"
#    ::cfi1616::lock $mm $addr
}

#set nios_path [ lindex $proc_paths 0 ]
#puts "INFO: claim processor '$nios_path'"
#set nios [ claim_service processor $nios_path "" ]
#puts "INFO: stop processor"
#processor_stop $nios

mm_claim 0

#?t ?c program_file $mm $elf_addr $elf
#?t ?c program_file $mm $sof_addr $sof

#mm_claim

#puts "INFO: start processor"
#processor_run $nios
#close_service processor $nios
